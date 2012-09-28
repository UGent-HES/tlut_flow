/**CFile****************************************************************

  FileName    [saigConstr2.c]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Sequential AIG package.]

  Synopsis    [Functional constraint detection.]

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: saigConstr2.c,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/

#include "saig.h"
#include "cnf.h"
#include "satSolver.h"
#include "kit.h"


////////////////////////////////////////////////////////////////////////
///                        DECLARATIONS                              ///
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
///                     FUNCTION DEFINITIONS                         ///
////////////////////////////////////////////////////////////////////////

/**Function*************************************************************

  Synopsis    [Creates COI of the property output.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Aig_Man_t * Saig_ManUnrollCOI( Aig_Man_t * p, int nFrames )
{
    Aig_Man_t * pFrames;
    Aig_Obj_t ** pObjMap;
    int i;
    pFrames = Aig_ManFrames( p, nFrames, 0, 1, 0, 1, &pObjMap );
    for ( i = 0; i < nFrames * Aig_ManObjNumMax(p); i++ )
        if ( pObjMap[i] && Aig_ObjIsNone( Aig_Regular(pObjMap[i]) ) )
            pObjMap[i] = NULL;
    assert( p->pObjCopies == NULL );
    p->pObjCopies = pObjMap;
    return pFrames;
}

/**Function*************************************************************

  Synopsis    [Collects and saves values of the SAT variables.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Saig_CollectSatValues( sat_solver * pSat, Cnf_Dat_t * pCnf, Vec_Ptr_t * vInfo, int * piPat )
{
    Aig_Obj_t * pObj;
    unsigned * pInfo;
    int i;
    Aig_ManForEachNode( pCnf->pMan, pObj, i )
    {
        assert( pCnf->pVarNums[i] > 0 );
        pInfo = Vec_PtrEntry( vInfo, i );
        if ( Aig_InfoHasBit(pInfo, *piPat) != sat_solver_var_value(pSat, pCnf->pVarNums[i]) )
            Aig_InfoXorBit(pInfo, *piPat);
    }
}

/**Function*************************************************************

  Synopsis    [Runs the SAT test for the node in one polarity.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Saig_DetectTryPolarity( sat_solver * pSat, int nConfs, Cnf_Dat_t * pCnf, Aig_Obj_t * pObj, int iPol, Vec_Ptr_t * vInfo, int * piPat )
{
    Aig_Obj_t * pOut = Aig_ManPo( pCnf->pMan, 0 );
    int status, Lits[2];
    Lits[0] = toLitCond( pCnf->pVarNums[Aig_ObjId(pOut)], 0 );
    Lits[1] = toLitCond( pCnf->pVarNums[Aig_ObjId(pObj)], !iPol );
    status = sat_solver_solve( pSat, Lits, Lits + 2, (ABC_INT64_T)nConfs, 0, 0, 0 );
    if ( status == l_False )
        return 1;
    if ( status == l_Undef )
    {
        printf( "Solver returned undecided.\n" );
        return 0;
    }
    assert( status == l_True );
    Saig_CollectSatValues( pSat, pCnf, vInfo, piPat );
    (*piPat)++;
    if ( *piPat == Vec_PtrReadWordsSimInfo(vInfo) * 32 )
    {
        printf( "Warning: Reached the limit on the number of patterns.\n" );
        *piPat = 0;
    }
    return 0;
}




/**Function*************************************************************

  Synopsis    [Creates timeframes for inductive check.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Aig_Man_t * Saig_ManUnrollInd( Aig_Man_t * p )
{
    int nFrames = 2;
    Aig_Man_t * pFrames;
    Aig_Obj_t ** pObjMap;
    int i;
    pFrames = Aig_ManFrames( p, nFrames, 0, 1, 1, 0, &pObjMap );
    for ( i = 0; i < nFrames * Aig_ManObjNumMax(p); i++ )
        if ( pObjMap[i] && Aig_ObjIsNone( Aig_Regular(pObjMap[i]) ) )
            pObjMap[i] = NULL;
    assert( p->pObjCopies == NULL );
    p->pObjCopies = pObjMap;
    return pFrames;
}


/**Function*************************************************************

  Synopsis    [Performs inductive check for one of the constraints.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Saig_ManFilterUsingIndOne( Aig_Man_t * p, sat_solver * pSat, Cnf_Dat_t * pCnf, int nConfs, Aig_Obj_t * pObj )
{
    Aig_Obj_t * pObjR  = Aig_Regular(pObj);
    Aig_Obj_t * pNode0 = p->pObjCopies[2*Aig_ObjId(pObjR)+0];
    Aig_Obj_t * pNode1 = p->pObjCopies[2*Aig_ObjId(pObjR)+1];
    int status, iVar[2], Lits[2];
    if ( pNode0 == NULL || pNode1 == NULL )
        return 0;
    iVar[0] = pCnf->pVarNums[Aig_ObjId(Aig_Regular(pNode0))];
    iVar[1] = pCnf->pVarNums[Aig_ObjId(Aig_Regular(pNode1))];
    Lits[0] = toLitCond( iVar[0], Aig_IsComplement(pObj) ^  Aig_IsComplement(pNode0) );
    Lits[1] = toLitCond( iVar[1], Aig_IsComplement(pObj) ^ !Aig_IsComplement(pNode1) );
    status = sat_solver_solve( pSat, Lits, Lits + 2, (ABC_INT64_T)nConfs, 0, 0, 0 );
    if ( status == l_False )
        return 1;
    if ( status == l_Undef )
    {
        printf( "Solver returned undecided.\n" );
        return 0;
    }
    assert( status == l_True );
    return 0;
}

/**Function*************************************************************

  Synopsis    [Detects constraints functionally.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Saig_ManFilterUsingInd( Aig_Man_t * p, Vec_Vec_t * vCands, int nConfs, int fVerbose )
{
    Vec_Ptr_t * vNodes;
    Aig_Man_t * pFrames;
    sat_solver * pSat;
    Cnf_Dat_t * pCnf;
    Aig_Obj_t * pObj;
    int i, k, k2;
    if ( fVerbose )
        printf( "Filtered cands:  " );
    // create timeframes
    pFrames = Saig_ManUnrollInd( p );
    // start the SAT solver
    pCnf = Cnf_DeriveSimple( pFrames, Aig_ManPoNum(pFrames) );
    pSat = Cnf_DataWriteIntoSolver( pCnf, 1, 0 );
    // check candidates
    Vec_VecForEachLevel( vCands, vNodes, i )
    {
        k2 = 0;
        Vec_PtrForEachEntry( vNodes, pObj, k )
            if ( Saig_ManFilterUsingIndOne( p, pSat, pCnf, nConfs, pObj ) )
            {
                Vec_PtrWriteEntry( vNodes, k2++, pObj );
                if ( fVerbose )
                    printf( "%d:%s%d  ", i, Aig_IsComplement(pObj)? "!":"", Aig_ObjId(Aig_Regular(pObj)) );
            }
        Vec_PtrShrink( vNodes, k2 );
    }
    if ( fVerbose )
        printf( "\n" );
    // clean up
    Cnf_DataFree( pCnf );
    sat_solver_delete( pSat );
    Aig_ManStop( pFrames );
}



/**Function*************************************************************

  Synopsis    [Detects constraints functionally.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Vec_Vec_t * Saig_ManDetectConstrFunc( Aig_Man_t * p, int nFrames, int nConfs, int fVerbose )
{
    int iPat = 0, nWordsAlloc = 32;
    Vec_Vec_t * vCands = NULL;
    Vec_Ptr_t * vInfo;
    Aig_Obj_t * pObj, * pRepr;
    Aig_Man_t * pFrames;
    sat_solver * pSat;
    Cnf_Dat_t * pCnf;
    unsigned * pInfo;
    int i, k, Lit, status, nCands = 0;
    assert( Saig_ManPoNum(p) == 1 );
    // perform unrolling
    pFrames = Saig_ManUnrollCOI( p, nFrames );
    assert( Aig_ManPoNum(pFrames) == 1 );
    assert( Aig_ManRegNum(pFrames) == 0 );
//    Aig_ManShow( pFrames, 0, NULL );

    // start the SAT solver
    pCnf = Cnf_DeriveSimple( pFrames, Aig_ManPoNum(pFrames) );
    pSat = Cnf_DataWriteIntoSolver( pCnf, 1, 0 );

    // solve the original problem
    Lit = toLitCond( pCnf->pVarNums[Aig_ObjId(Aig_ManPo(pFrames,0))], 0 );
    status = sat_solver_solve( pSat, &Lit, &Lit + 1, (ABC_INT64_T)nConfs, 0, 0, 0 );
    if ( status == l_False )
    {
        printf( "The problem is trivially UNSAT (inductive with k=%d).\n", nFrames-1 );
        Cnf_DataFree( pCnf );
        sat_solver_delete( pSat );
        Aig_ManStop( pFrames );
        return NULL;
    }
    if ( status == l_Undef )
    {
        printf( "Solver could not solve the original problem.\n" );
        Cnf_DataFree( pCnf );
        sat_solver_delete( pSat );
        Aig_ManStop( pFrames );
        return NULL;
    }
    assert( status == l_True );

    // create simulation info
    vInfo = Vec_PtrAllocSimInfo( Aig_ManObjNumMax(pFrames), nWordsAlloc );
    Vec_PtrCleanSimInfo( vInfo, 0, nWordsAlloc );
    Saig_CollectSatValues( pSat, pCnf, vInfo, &iPat );
    Aig_ManForEachObj( pFrames, pObj, i )
    {
        pInfo = Vec_PtrEntry( vInfo, i );
        if ( pInfo[0] & 1 )
            memset( (char*)pInfo, 0xff, 4*nWordsAlloc );
    }
//    Aig_ManShow( pFrames, 0, NULL );
//    Aig_ManShow( p, 0, NULL );

    // consider the nodes for ci=>!Out and label when it holds
    Aig_ManCleanMarkAB( pFrames );
    Aig_ManForEachNode( pFrames, pObj, i )
    {
        // check if the node is available in both polarities
        pInfo = Vec_PtrEntry( vInfo, i );
        for ( k = 0; k < nWordsAlloc; k++ )
            if ( pInfo[k] != ~0 )
                break;
        if ( k == nWordsAlloc )
        {
            if ( Saig_DetectTryPolarity(pSat, nConfs, pCnf, pObj, 0, vInfo, &iPat) ) // !pObj is a constr
            {
                pObj->fMarkA = 1, nCands++;
//                printf( "!%d  ", Aig_ObjId(pObj) );
            }
            continue;
        }
        for ( k = 0; k < nWordsAlloc; k++ )
            if ( pInfo[k] != 0 )
                break;
        if ( k == nWordsAlloc )
        {
            if ( Saig_DetectTryPolarity(pSat, nConfs, pCnf, pObj, 1, vInfo, &iPat) ) //  pObj is a constr
            {
                pObj->fMarkB = 1, nCands++;
//                printf( "%d  ", Aig_ObjId(pObj) );
            }
            continue;
        }
    }
    if ( nCands )
    {
//        printf( "\n" );
        printf( "Found %3d classes of candidates.\n", nCands );
        vCands = Vec_VecAlloc( nFrames );
        for ( k = 0; k < nFrames; k++ )
        {
            Aig_ManForEachNode( p, pObj, i ) // if 'Aig_ManForEachObj', then register outputs are included...
            {
                pRepr = p->pObjCopies[nFrames*i + k];
                if ( pRepr == NULL )
                    continue;
                if ( Aig_Regular(pRepr)->fMarkA ) // !pObj is a constr
                {
                    Vec_VecPush( vCands, k, Aig_NotCond(pObj, !Aig_IsComplement(pRepr)) );
//                    printf( "%d->!%d ", Aig_ObjId(Aig_Regular(pRepr)), Aig_ObjId(pObj) );
                }
                else if ( Aig_Regular(pRepr)->fMarkB ) //  pObj is a constr
                {
                    Vec_VecPush( vCands, k, Aig_NotCond(pObj,  Aig_IsComplement(pRepr)) );
//                    printf( "%d->%d ", Aig_ObjId(Aig_Regular(pRepr)), Aig_ObjId(pObj) );
                }
            }
        }
//        printf( "\n" );
        printf( "Found %3d candidates.\n", Vec_VecSizeSize(vCands) );
        ABC_FREE( p->pObjCopies );
        Saig_ManFilterUsingInd( p, vCands, nConfs, fVerbose );
        printf( "Found %3d candidates after filtering.\n", Vec_VecSizeSize(vCands) );
    }
    Vec_PtrFree( vInfo );
    Cnf_DataFree( pCnf );
    sat_solver_delete( pSat );
    Aig_ManCleanMarkAB( pFrames );
    Aig_ManStop( pFrames );
    return vCands;
}

/**Function*************************************************************

  Synopsis    [Experimental procedure.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Saig_ManDetectConstrFuncTest( Aig_Man_t * p, int nFrames, int nConfs, int fVerbose )
{
    Vec_Vec_t * vCands;
    vCands = Saig_ManDetectConstrFunc( p, nFrames, nConfs, fVerbose );
    Vec_VecFreeP( &vCands );
}

////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////


