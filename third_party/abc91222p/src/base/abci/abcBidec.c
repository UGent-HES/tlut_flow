/**CFile****************************************************************

  FileName    [abcBidec.c]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Network and node package.]

  Synopsis    [Interface to bi-decomposition.]

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: abcBidec.c,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/

#include "abc.h"
#include "bdc.h"
#include "kit.h"

////////////////////////////////////////////////////////////////////////
///                        DECLARATIONS                              ///
////////////////////////////////////////////////////////////////////////

static inline Hop_Obj_t * Bdc_FunCopyHop( Bdc_Fun_t * pObj )  { return Hop_NotCond( Bdc_FuncCopy(Bdc_Regular(pObj)), Bdc_IsComplement(pObj) );  }

////////////////////////////////////////////////////////////////////////
///                     FUNCTION DEFINITIONS                         ///
////////////////////////////////////////////////////////////////////////

/**Function*************************************************************

  Synopsis    [Resynthesizes nodes using bi-decomposition.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Hop_Obj_t * Abc_NodeIfNodeResyn( Bdc_Man_t * p, Hop_Man_t * pHop, Hop_Obj_t * pRoot, int nVars, Vec_Int_t * vTruth, unsigned * puCare, float dProb )
{
    unsigned * pTruth;
    Bdc_Fun_t * pFunc;
    int nNodes, i;
    assert( nVars <= 16 );
    // derive truth table
    pTruth = Hop_ManConvertAigToTruth( pHop, Hop_Regular(pRoot), nVars, vTruth, 0 );
    if ( Hop_IsComplement(pRoot) )
        Extra_TruthNot( pTruth, pTruth, nVars );
    // perform power-aware decomposition
    if ( dProb >= 0.0 )
    {
        float Prob = (float)2.0 * dProb * (1.0 - dProb);
        assert( Prob >= 0.0 && Prob <= 0.5 );
        if ( Prob >= 0.4 )
        {
            Extra_TruthNot( puCare, puCare, nVars );
            if ( dProb > 0.5 ) // more 1s than 0s
                Extra_TruthOr( pTruth, pTruth, puCare, nVars );
            else
                Extra_TruthSharp( pTruth, pTruth, puCare, nVars );
            Extra_TruthNot( puCare, puCare, nVars );
            // decompose truth table
            Bdc_ManDecompose( p, pTruth, NULL, nVars, NULL, 1000 );
        }
        else
        {
            // decompose truth table
            Bdc_ManDecompose( p, pTruth, puCare, nVars, NULL, 1000 );
        }
    }
    else
    {
        // decompose truth table
        Bdc_ManDecompose( p, pTruth, puCare, nVars, NULL, 1000 );
/*
        if ( nVars == 6 && puCare != NULL )
        {
            typedef ABC_UINT64_T word;
            extern int Bat_ManSolveTruth( word Func, word Care );
            word Func, Care;
            int Counter = 64-Kit_TruthCountOnes(puCare, 6);
            if ( Counter > 0 )
            {
            printf( "Don't-cares = %2d.  ", Counter );
            Extra_PrintHex( stdout, pTruth, 6 );
            printf( "   " );
            Extra_PrintHex( stdout, puCare, 6 );
            printf( "\n" );
            Func = ((word)pTruth[0]) | (((word)pTruth[1]) << 32);
            Care = ((word)puCare[0]) | (((word)puCare[1]) << 32);
            Bat_ManSolveTruth( Func, ~((word)0) );
            Bat_ManSolveTruth( Func, Care );
            printf( "\n" );
            }
        }
*/
    }
    // convert back into HOP
    Bdc_FuncSetCopy( Bdc_ManFunc( p, 0 ), Hop_ManConst1( pHop ) );
    for ( i = 0; i < nVars; i++ )
        Bdc_FuncSetCopy( Bdc_ManFunc( p, i+1 ), Hop_ManPi( pHop, i ) );
    nNodes = Bdc_ManNodeNum(p);
    for ( i = nVars + 1; i < nNodes; i++ )
    {
        pFunc = Bdc_ManFunc( p, i );
        Bdc_FuncSetCopy( pFunc, Hop_And( pHop, Bdc_FunCopyHop(Bdc_FuncFanin0(pFunc)), Bdc_FunCopyHop(Bdc_FuncFanin1(pFunc)) ) );
    }
    return Bdc_FunCopyHop( Bdc_ManRoot(p) );
}

/**Function*************************************************************

  Synopsis    [Resynthesizes nodes using bi-decomposition.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_NtkBidecResyn( Abc_Ntk_t * pNtk, int fVerbose )
{
    Bdc_Par_t Pars = {0}, * pPars = &Pars;
    Bdc_Man_t * p;
    Abc_Obj_t * pObj;
    Vec_Int_t * vTruth;
    int i, nGainTotal = 0, nNodes1, nNodes2;
    int clk = clock();
    assert( Abc_NtkIsLogic(pNtk) );
    if ( !Abc_NtkToAig(pNtk) )
        return;
    pPars->nVarsMax = Abc_NtkGetFaninMax( pNtk );
    pPars->fVerbose = fVerbose;
    if ( pPars->nVarsMax > 15 )
    {
        if ( fVerbose )
        printf( "Resynthesis is not performed for nodes with more than 15 inputs.\n" );
        pPars->nVarsMax = 15;
    }
    vTruth = Vec_IntAlloc( 0 );
    p = Bdc_ManAlloc( pPars );
    Abc_NtkForEachNode( pNtk, pObj, i )
    {
        if ( Abc_ObjFaninNum(pObj) > 15 )
            continue;
        nNodes1 = Hop_DagSize(pObj->pData);
        pObj->pData = Abc_NodeIfNodeResyn( p, pNtk->pManFunc, pObj->pData, Abc_ObjFaninNum(pObj), vTruth, NULL, -1.0 );
        nNodes2 = Hop_DagSize(pObj->pData);
        nGainTotal += nNodes1 - nNodes2;
    }
    Bdc_ManFree( p );
    Vec_IntFree( vTruth );
    if ( fVerbose )
    {
    printf( "Total gain in AIG nodes = %d.  ", nGainTotal );
    ABC_PRT( "Total runtime", clock() - clk );
    }
}


////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////


