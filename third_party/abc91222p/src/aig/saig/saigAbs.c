/**CFile****************************************************************

  FileName    [saigAbs.c]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Sequential AIG package.]

  Synopsis    [Counter-example-based abstraction.]

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: saigAbs.c,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/

#include "saig.h"
#include "ssw.h"
#include "fra.h"

////////////////////////////////////////////////////////////////////////
///                        DECLARATIONS                              ///
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
///                     FUNCTION DEFINITIONS                         ///
////////////////////////////////////////////////////////////////////////

/**Function*************************************************************

  Synopsis    [Collects internal nodes in the DFS order.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Saig_ManFindFirstFlop_rec( Aig_Man_t * p, Aig_Obj_t * pObj )
{
    int RetValue;
    if ( Aig_ObjIsTravIdCurrent(p, pObj) )
        return -1;
    Aig_ObjSetTravIdCurrent(p, pObj);
    if ( Saig_ObjIsPi(p, pObj) )
        return -1;
    if ( Saig_ObjIsLo(p, pObj) )
    {
        assert( Aig_ObjPioNum(pObj) >= Saig_ManPiNum(p) );
        return Aig_ObjPioNum(pObj)-Saig_ManPiNum(p);
    }
    assert( Aig_ObjIsNode(pObj) );
    RetValue = Saig_ManFindFirstFlop_rec( p, Aig_ObjFanin0(pObj) );
    if ( RetValue >= 0 )
        return RetValue;
    return Saig_ManFindFirstFlop_rec( p, Aig_ObjFanin1(pObj) );
}

/**Function*************************************************************

  Synopsis    [Returns the index of the flop that appears in the support.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Saig_ManFindFirstFlop( Aig_Man_t * p )
{
    Aig_ManIncrementTravId( p );
    Aig_ObjSetTravIdCurrent( p, Aig_ManConst1(p) );
    return Saig_ManFindFirstFlop_rec( p, Aig_ObjFanin0(Aig_ManPo(p, 0)) );

}

/**Function*************************************************************

  Synopsis    [Derive a new counter-example.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Ssw_Cex_t * Saig_ManCexRemap( Aig_Man_t * p, Aig_Man_t * pAbs, Ssw_Cex_t * pCexAbs )
{
    Ssw_Cex_t * pCex;
    Aig_Obj_t * pObj;
    int i, f;
    // start the counter-example
    pCex = Ssw_SmlAllocCounterExample( Aig_ManRegNum(p), Saig_ManPiNum(p), pCexAbs->iFrame+1 );
    pCex->iFrame = pCexAbs->iFrame;
    pCex->iPo    = pCexAbs->iPo;
    // copy the bit data
    for ( f = 0; f <= pCexAbs->iFrame; f++ )
    {
        Saig_ManForEachPi( pAbs, pObj, i )
        {
            if ( i == Saig_ManPiNum(p) )
                break;
            if ( Aig_InfoHasBit( pCexAbs->pData, pCexAbs->nRegs + pCexAbs->nPis * f + i ) )
                Aig_InfoSetBit( pCex->pData, pCex->nRegs + pCex->nPis * f + i );
        }
    }
    // verify the counter example
    if ( !Ssw_SmlRunCounterExample( p, pCex ) )
    {
        printf( "Saig_ManCexRemap(): Counter-example is invalid.\n" );
        Ssw_SmlFreeCounterExample( pCex );
        pCex = NULL;
    }
    else
    {
        printf( "Counter-example verification is successful.\n" );
        printf( "Output %d was asserted in frame %d (use \"write_counter\" to dump a witness). \n", pCex->iPo, pCex->iFrame );
    }
    return pCex;
}
 
/**Function*************************************************************

  Synopsis    [Find the first PI corresponding to the flop.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Saig_ManCexFirstFlopPi( Aig_Man_t * p, Aig_Man_t * pAbs )
{ 
    Aig_Obj_t * pObj;
    int i;
    assert( pAbs->vCiNumsOrig != NULL );
    Aig_ManForEachPi( p, pObj, i )
    {
        if ( Vec_IntEntry(pAbs->vCiNumsOrig, i) >= Saig_ManPiNum(p) )
            return i;
    }
    return -1;
}
 
/**Function*************************************************************

  Synopsis    [Refines abstraction using one step.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Aig_Man_t * Saig_ManCexRefine( Aig_Man_t * p, Aig_Man_t * pAbs, Vec_Int_t * vFlops, int nFrames, int nConfMaxOne, int fUseBdds, int fUseDprove, int fVerbose, int * pnUseStart )
{ 
    extern int Saig_BmcPerform( Aig_Man_t * pAig, int nStart, int nFramesMax, int nNodesMax, int nTimeOut, int nConfMaxOne, int nConfMaxAll, int fVerbose, int fVerbOverwrite );
    extern Vec_Int_t * Saig_ManExtendCounterExampleTest( Aig_Man_t * p, int iFirstPi, void * pCex, int fVerbose );
    extern int Aig_ManVerifyUsingBdds( Aig_Man_t * p, int nBddMax, int nIterMax, int fPartition, int fReorder, int fReorderImage, int fVerbose, int fSilent );
    Vec_Int_t * vFlopsNew;
    int i, Entry;
    if ( fUseDprove && Aig_ManRegNum(pAbs) > 0 )
    {
        Fra_Sec_t SecPar, * pSecPar = &SecPar;
        int RetValue;
        Fra_SecSetDefaultParams( pSecPar );
        pSecPar->fVerbose       = fVerbose;
        RetValue = Fra_FraigSec( pAbs, pSecPar, NULL );
    }
    else if ( fUseBdds && (Aig_ManRegNum(pAbs) > 0 && Aig_ManRegNum(pAbs) <= 80) )
    {
        int nBddMax       = 1000000;
        int nIterMax      = nFrames;
        int fPartition    = 1;
        int fReorder      = 1;
        int fReorderImage = 1;
        Aig_ManVerifyUsingBdds( pAbs, nBddMax, nIterMax, fPartition, fReorder, fReorderImage, fVerbose, 0 );
    }
    else 
        Saig_BmcPerform( pAbs, pnUseStart? *pnUseStart: 0, nFrames, 2000, 20, nConfMaxOne, 1000000, fVerbose, 0 );
    if ( pAbs->pSeqModel == NULL )
        return NULL;
    if ( pnUseStart )
        *pnUseStart = ((Fra_Cex_t *)pAbs->pSeqModel)->iFrame;
    vFlopsNew = Saig_ManExtendCounterExampleTest( pAbs, Saig_ManCexFirstFlopPi(p, pAbs), pAbs->pSeqModel, fVerbose );
    if ( vFlopsNew == NULL )
        return NULL;
    if ( Vec_IntSize(vFlopsNew) == 0 )
    {
        printf( "Discovered a true counter-example!\n" );
        p->pSeqModel = Saig_ManCexRemap( p, pAbs, pAbs->pSeqModel );
        Vec_IntFree( vFlopsNew );
        return NULL;
    }
    // vFlopsNew contains PI numbers that should be kept in pAbs
    if ( fVerbose )
        printf( "Adding %d registers to the abstraction.\n", Vec_IntSize(vFlopsNew) );
    // add to the abstraction
    Vec_IntForEachEntry( vFlopsNew, Entry, i )
    {
        Entry = Vec_IntEntry(pAbs->vCiNumsOrig, Entry);
        assert( Entry >= Saig_ManPiNum(p) );
        assert( Entry < Aig_ManPiNum(p) );
        Vec_IntPush( vFlops, Entry-Saig_ManPiNum(p) );
    }
    Vec_IntFree( vFlopsNew );

    Vec_IntSort( vFlops, 0 );
    Vec_IntForEachEntryStart( vFlops, Entry, i, 1 )
        assert( Vec_IntEntry(vFlops, i-1) != Entry );

    return Saig_ManDeriveAbstraction( p, vFlops );
}
 
/**Function*************************************************************

  Synopsis    [Refines abstraction using one step.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Saig_ManCexRefineStep( Aig_Man_t * p, Vec_Int_t * vFlops, Fra_Cex_t * pCex, int fVerbose )
{
    extern Vec_Int_t * Saig_ManExtendCounterExampleTest( Aig_Man_t * p, int iFirstPi, void * pCex, int fVerbose );
    Aig_Man_t * pAbs;
    Vec_Int_t * vFlopsNew;
    int i, Entry;
    pAbs = Saig_ManDeriveAbstraction( p, vFlops );
    vFlopsNew = Saig_ManExtendCounterExampleTest( pAbs, Saig_ManCexFirstFlopPi(p, pAbs), pCex, fVerbose );
    if ( vFlopsNew == NULL )
    {
        Aig_ManStop( pAbs );
        return 0;
    }
    if ( Vec_IntSize(vFlopsNew) == 0 )
    {
        printf( "Discovered a true counter-example!\n" );
//        p->pSeqModel = Saig_ManCexRemap( p, pAbs, pAbs->pSeqModel );
        Vec_IntFree( vFlopsNew );
        Aig_ManStop( pAbs );
        return 0;
    }
    if ( fVerbose )
        printf( "Adding %d registers to the abstraction.\n", Vec_IntSize(vFlopsNew) );
    // vFlopsNew contains PI number that should be kept in pAbs
    // add to the abstraction
    Vec_IntForEachEntry( vFlopsNew, Entry, i )
    {
        Entry = Vec_IntEntry(pAbs->vCiNumsOrig, Entry);
        assert( Entry >= Saig_ManPiNum(p) );
        assert( Entry < Aig_ManPiNum(p) );
        Vec_IntPush( vFlops, Entry-Saig_ManPiNum(p) );
    }
    Vec_IntFree( vFlopsNew );
    Aig_ManStop( pAbs );
    return 1;
}

/**Function*************************************************************

  Synopsis    [Computes the flops to remain after abstraction.]

  Description []
               
  SideEffects []

  SeeAlso     []
 
***********************************************************************/
Vec_Int_t * Saig_ManCexAbstractionFlops( Aig_Man_t * p, Gia_ParAbs_t * pPars )
{
    int nUseStart = 0;
    Aig_Man_t * pAbs, * pTemp;
    Vec_Int_t * vFlops;
    int Iter, clk = clock(), clk2 = clock();//, iFlop;
    assert( Aig_ManRegNum(p) > 0 );
    if ( pPars->fVerbose )
        printf( "Performing counter-example-based refinement.\n" );
    Aig_ManSetPioNumbers( p );
    vFlops = Vec_IntStartNatural( 1 );
/*
    iFlop = Saig_ManFindFirstFlop( p );
    assert( iFlop >= 0 );
    vFlops = Vec_IntAlloc( 1 );
    Vec_IntPush( vFlops, iFlop );
*/
    // create the resulting AIG
    pAbs = Saig_ManDeriveAbstraction( p, vFlops );
    if ( !pPars->fVerbose )
    {
        printf( "Init : " );
        Aig_ManPrintStats( pAbs );
    }
    printf( "Refining abstraction...\n" );
    for ( Iter = 0; ; Iter++ )
    {
        pTemp = Saig_ManCexRefine( p, pAbs, vFlops, pPars->nFramesBmc, pPars->nConfMaxBmc, pPars->fUseBdds, pPars->fUseDprove, pPars->fVerbose, pPars->fUseStart?&nUseStart:NULL );
        Aig_ManStop( pAbs );
        if ( pTemp == NULL )
            break;
        pAbs = pTemp;
        printf( "ITER %4d : ", Iter );
        if ( !pPars->fVerbose )
            Aig_ManPrintStats( pAbs );
        // output the intermediate result of abstraction
        Ioa_WriteAiger( pAbs, "gabs.aig", 0, 0 );
//            printf( "Intermediate abstracted model was written into file \"%s\".\n", "gabs.aig" );
        // check if the ratio is reached
        if ( 100.0*(Aig_ManRegNum(p)-Aig_ManRegNum(pAbs))/Aig_ManRegNum(p) < 1.0*pPars->nRatio )
        {
            printf( "Refinements is stopped because flop reduction is less than %d%%\n", pPars->nRatio );
            Aig_ManStop( pAbs );
            pAbs = NULL;
            Vec_IntFree( vFlops );
            vFlops = NULL;
            break;
        }
    }
    return vFlops;
}

/**Function*************************************************************

  Synopsis    [Performs counter-example-based abstraction.]

  Description []
               
  SideEffects []

  SeeAlso     []
 
***********************************************************************/
Aig_Man_t * Saig_ManCexAbstraction( Aig_Man_t * p, Gia_ParAbs_t * pPars )
{
    Vec_Int_t * vFlops;
    Aig_Man_t * pAbs = NULL;
    vFlops = Saig_ManCexAbstractionFlops( p, pPars );
    // write the final result
    if ( vFlops )
    {
        pAbs = Saig_ManDeriveAbstraction( p, vFlops );
        Ioa_WriteAiger( pAbs, "gabs.aig", 0, 0 );
        printf( "Final abstracted model was written into file \"%s\".\n", "gabs.aig" );
        Vec_IntFree( vFlops );
    }
    return pAbs;
}

////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////


