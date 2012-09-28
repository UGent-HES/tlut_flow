/**CFile****************************************************************

  FileName    [giaAbs.c]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Scalable AIG package.]

  Synopsis    [Counter-example-guided abstraction refinement.]

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: giaAbs.c,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/
 
#include "gia.h"
#include "giaAig.h"
#include "giaAbs.h"

////////////////////////////////////////////////////////////////////////
///                        DECLARATIONS                              ///
////////////////////////////////////////////////////////////////////////

extern Aig_Man_t * Saig_ManDeriveAbstraction( Aig_Man_t * p, Vec_Int_t * vFlops );
extern Vec_Int_t * Saig_ManProofAbstractionFlops( Aig_Man_t * p, Gia_ParAbs_t * pPars );
extern Vec_Int_t * Saig_ManCexAbstractionFlops( Aig_Man_t * p, Gia_ParAbs_t * pPars );
extern int         Saig_ManCexRefineStep( Aig_Man_t * p, Vec_Int_t * vFlops, Gia_Cex_t * pCex, int fVerbose );

////////////////////////////////////////////////////////////////////////
///                     FUNCTION DEFINITIONS                         ///
////////////////////////////////////////////////////////////////////////

/**Function*************************************************************

  Synopsis    [This procedure sets default parameters.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ManAbsSetDefaultParams( Gia_ParAbs_t * p )
{
    memset( p, 0, sizeof(Gia_ParAbs_t) );
    p->nFramesMax  =    10;    // timeframes for PBA
    p->nConfMax    = 10000;    // conflicts for PBA
    p->fDynamic    =     1;    // dynamic unfolding for PBA
    p->fConstr     =     0;    // use constraints
    p->nFramesBmc  =   250;    // timeframes for BMC
    p->nConfMaxBmc =  5000;    // conflicts for BMC
    p->nRatio      =    10;    // ratio of flops to quit
    p->fUseBdds    =     0;    // use BDDs to refine abstraction
    p->fUseDprove  =     0;    // use 'dprove' to refine abstraction
    p->fUseStart   =     1;    // use starting frame
    p->fVerbose    =     0;    // verbose output
}


/**Function*************************************************************

  Synopsis    [Transform flop list into flop map.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Vec_Int_t * Gia_ManFlops2Classes( Gia_Man_t * pGia, Vec_Int_t * vFlops )
{
    Vec_Int_t * vFlopClasses;
    int i, Entry;
    vFlopClasses = Vec_IntStart( Gia_ManRegNum(pGia) );
    Vec_IntForEachEntry( vFlops, Entry, i )
        Vec_IntWriteEntry( vFlopClasses, Entry, 1 );
    return vFlopClasses;
}

/**Function*************************************************************

  Synopsis    [Transform flop map into flop list.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Vec_Int_t * Gia_ManClasses2Flops( Vec_Int_t * vFlopClasses )
{
    Vec_Int_t * vFlops;
    int i, Entry;
    vFlops = Vec_IntAlloc( 100 );
    Vec_IntForEachEntry( vFlopClasses, Entry, i )
        if ( Entry )
            Vec_IntPush( vFlops, i );
    return vFlops;
}


/**Function*************************************************************

  Synopsis    [Performs abstraction on the AIG manager.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Gia_Man_t * Gia_ManCexAbstraction( Gia_Man_t * p, Vec_Int_t * vFlops )
{
    Gia_Man_t * pGia;
    Aig_Man_t * pNew, * pTemp;
    pNew = Gia_ManToAig( p, 0 );
    pNew = Saig_ManDeriveAbstraction( pTemp = pNew, vFlops );
    Aig_ManStop( pTemp );
    pGia = Gia_ManFromAig( pNew );
    pGia->vCiNumsOrig = pNew->vCiNumsOrig; 
    pNew->vCiNumsOrig = NULL;
    Aig_ManStop( pNew );
    return pGia;

}

/**Function*************************************************************

  Synopsis    [Computes abstracted flops for the manager.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Vec_Int_t * Gia_ManCexAbstractionFlops( Gia_Man_t * p, Gia_ParAbs_t * pPars )
{
    Vec_Int_t * vFlops;
    Aig_Man_t * pNew;
    pNew = Gia_ManToAig( p, 0 );
    vFlops = Saig_ManCexAbstractionFlops( pNew, pPars );
    Aig_ManStop( pNew );
    return vFlops;
}

/**Function*************************************************************

  Synopsis    [Computes abstracted flops for the manager.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Vec_Int_t * Gia_ManProofAbstractionFlops( Gia_Man_t * p, Gia_ParAbs_t * pPars )
{
    Vec_Int_t * vFlops;
    Aig_Man_t * pNew;
    pNew = Gia_ManToAig( p, 0 );
    vFlops = Saig_ManProofAbstractionFlops( pNew, pPars );
    Aig_ManStop( pNew );
    return vFlops;
}

/**Function*************************************************************

  Synopsis    [Starts abstraction by computing latch map.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ManCexAbstractionStart( Gia_Man_t * pGia, Gia_ParAbs_t * pPars )
{
    Vec_Int_t * vFlops;
    if ( pGia->vFlopClasses != NULL )
    {
        printf( "Gia_ManCexAbstractionStart(): Abstraction latch map is present but will be rederived.\n" );
        Vec_IntFreeP( &pGia->vFlopClasses );
    }
    vFlops = Gia_ManCexAbstractionFlops( pGia, pPars );
    if ( vFlops )
    {
        pGia->vFlopClasses = Gia_ManFlops2Classes( pGia, vFlops );
        Vec_IntFree( vFlops );
    }
}

/**Function*************************************************************

  Synopsis    [Derives abstraction using the latch map.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Gia_Man_t * Gia_ManCexAbstractionDerive( Gia_Man_t * pGia )
{
    Vec_Int_t * vFlops;
    Gia_Man_t * pAbs = NULL;
    if ( pGia->vFlopClasses == NULL )
    {
        printf( "Gia_ManCexAbstractionDerive(): Abstraction latch map is missing.\n" );
        return NULL;
    }
    vFlops = Gia_ManClasses2Flops( pGia->vFlopClasses );
    pAbs = Gia_ManCexAbstraction( pGia, vFlops );
    Vec_IntFree( vFlops );
    return pAbs;
}

/**Function*************************************************************

  Synopsis    [Refines abstraction using the latch map.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ManCexAbstractionRefine( Gia_Man_t * pGia, Gia_Cex_t * pCex, int fVerbose )
{
    Aig_Man_t * pNew;
    Vec_Int_t * vFlops;
    if ( pGia->vFlopClasses == NULL )
    {
        printf( "Gia_ManCexAbstractionRefine(): Abstraction latch map is missing.\n" );
        return;
    }
    pNew = Gia_ManToAig( pGia, 0 );
    vFlops = Gia_ManClasses2Flops( pGia->vFlopClasses );
    if ( !Saig_ManCexRefineStep( pNew, vFlops, pCex, fVerbose ) )
        printf( "Refinement did not happen.\n" );
    Vec_IntFree( pGia->vFlopClasses );
    pGia->vFlopClasses = Gia_ManFlops2Classes( pGia, vFlops );
    Vec_IntFree( vFlops );
    Aig_ManStop( pNew );
}

/**Function*************************************************************

  Synopsis    [Starts abstraction by computing latch map.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ManProofAbstractionStart( Gia_Man_t * pGia, Gia_ParAbs_t * pPars )
{
    Vec_Int_t * vFlops;
    if ( pGia->vFlopClasses != NULL )
    {
        printf( "Gia_ManProofAbstractionStart(): Abstraction latch map is present but will be rederived.\n" );
        Vec_IntFreeP( &pGia->vFlopClasses );
    }
    vFlops = Gia_ManProofAbstractionFlops( pGia, pPars );
    if ( vFlops )
    {
        pGia->vFlopClasses = Gia_ManFlops2Classes( pGia, vFlops );
        Vec_IntFree( vFlops );
    }
}

////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////


