/**CFile****************************************************************

  FileName    [gia.c]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Scalable AIG package.]

  Synopsis    []

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: gia.c,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/

#include "gia.h"

////////////////////////////////////////////////////////////////////////
///                        DECLARATIONS                              ///
////////////////////////////////////////////////////////////////////////

// combinational simulation manager
typedef struct Hcd_Man_t_ Hcd_Man_t;
struct Hcd_Man_t_
{
    // parameters
    Gia_Man_t *      pGia;           // the AIG to be used for simulation
    int              nBTLimit;       // internal backtrack limit 
    int              fVerbose;       // internal verbose flag 
    // internal variables
    unsigned *       pSimInfo;       // simulation info for each object
    Vec_Ptr_t *      vSimInfo;       // pointers to the CI simulation info
    Vec_Ptr_t *      vSimPres;       // pointers to the presense of simulation info
    // temporaries
    Vec_Int_t *      vClassOld;      // old class numbers
    Vec_Int_t *      vClassNew;      // new class numbers
    Vec_Int_t *      vClassTemp;     // temporary storage
    Vec_Int_t *      vRefinedC;      // refined const reprs
};

static inline unsigned   Hcd_ObjSim( Hcd_Man_t * p, int Id )                  { return p->pSimInfo[Id];      }
static inline unsigned * Hcd_ObjSimP( Hcd_Man_t * p, int Id )                 { return p->pSimInfo + Id;     }
static inline unsigned   Hcd_ObjSetSim( Hcd_Man_t * p, int Id, unsigned n )   { return p->pSimInfo[Id] = n;  }

////////////////////////////////////////////////////////////////////////
///                     FUNCTION DEFINITIONS                         ///
////////////////////////////////////////////////////////////////////////

/**Function*************************************************************

  Synopsis    [Starts the fraiging manager.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Hcd_Man_t * Gia_ManEquivStart( Gia_Man_t * pGia, int nBTLimit, int fVerbose )
{
    Hcd_Man_t * p;
    Gia_Obj_t * pObj;
    int i;
    p = ABC_CALLOC( Hcd_Man_t, 1 );
    p->pGia       = pGia;
    p->nBTLimit   = nBTLimit;
    p->fVerbose   = fVerbose;
    p->pSimInfo   = ABC_ALLOC( unsigned, Gia_ManObjNum(pGia) );
    p->vClassOld  = Vec_IntAlloc( 100 );
    p->vClassNew  = Vec_IntAlloc( 100 );
    p->vClassTemp = Vec_IntAlloc( 100 );
    p->vRefinedC  = Vec_IntAlloc( 100 );
    // collect simulation info
    p->vSimInfo = Vec_PtrAlloc( 1000 );
    Gia_ManForEachCi( pGia, pObj, i )
        Vec_PtrPush( p->vSimInfo, Hcd_ObjSimP(p, Gia_ObjId(pGia,pObj)) );
    p->vSimPres = Vec_PtrAllocSimInfo( Gia_ManCiNum(pGia), 1 );
    return p;
}

/**Function*************************************************************

  Synopsis    [Starts the fraiging manager.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ManEquivStop( Hcd_Man_t * p )
{
    Vec_PtrFree( p->vSimInfo );
    Vec_PtrFree( p->vSimPres );
    Vec_IntFree( p->vClassOld );
    Vec_IntFree( p->vClassNew );
    Vec_IntFree( p->vClassTemp );
    Vec_IntFree( p->vRefinedC );
    ABC_FREE( p->pSimInfo );
    ABC_FREE( p );
}


/**Function*************************************************************

  Synopsis    [Compared two simulation infos.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
static inline int Hcd_ManCompareEqual( unsigned s0, unsigned s1 )
{
    if ( (s0 & 1) == (s1 & 1) )
        return s0 == s1;
    else
        return s0 ==~s1;
}

/**Function*************************************************************

  Synopsis    [Compares one simulation info.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
static inline int Hcd_ManCompareConst( unsigned s )
{
    if ( s & 1 )
        return s ==~0;
    else
        return s == 0;
}

/**Function*************************************************************

  Synopsis    [Creates one equivalence class.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Hcd_ManClassCreate( Gia_Man_t * pGia, Vec_Int_t * vClass )
{
    int Repr = -1, EntPrev = -1, Ent, i;
    assert( Vec_IntSize(vClass) > 0 );
    Vec_IntForEachEntry( vClass, Ent, i )
    {
        if ( i == 0 )
        {
            Repr = Ent;
            Gia_ObjSetRepr( pGia, Ent, -1 );
            EntPrev = Ent;
        }
        else
        {
            Gia_ObjSetRepr( pGia, Ent, Repr );
            Gia_ObjSetNext( pGia, EntPrev, Ent );
            EntPrev = Ent;
        }
    }
    Gia_ObjSetNext( pGia, EntPrev, 0 );
}

/**Function*************************************************************

  Synopsis    [Refines one equivalence class.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Hcd_ManClassRefineOne( Hcd_Man_t * p, int i )
{
    unsigned Sim0, Sim1;
    int Ent;
    Vec_IntClear( p->vClassOld );
    Vec_IntClear( p->vClassNew );
    Vec_IntPush( p->vClassOld, i );
    Sim0 = Hcd_ObjSim(p, i);
    Gia_ClassForEachObj1( p->pGia, i, Ent )
    {
        Sim1 = Hcd_ObjSim(p, Ent);
        if ( Hcd_ManCompareEqual( Sim0, Sim1 ) )
            Vec_IntPush( p->vClassOld, Ent );
        else
            Vec_IntPush( p->vClassNew, Ent );
    }
    if ( Vec_IntSize( p->vClassNew ) == 0 )
        return 0;
    Hcd_ManClassCreate( p->pGia, p->vClassOld );
    Hcd_ManClassCreate( p->pGia, p->vClassNew );
    if ( Vec_IntSize(p->vClassNew) > 1 )
        return 1 + Hcd_ManClassRefineOne( p, Vec_IntEntry(p->vClassNew,0) );
    return 1;
}

/**Function*************************************************************

  Synopsis    [Computes hash key of the simulation info.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Hcd_ManHashKey( unsigned * pSim, int nWords, int nTableSize )
{
    static int s_Primes[16] = { 
        1291, 1699, 1999, 2357, 2953, 3313, 3907, 4177, 
        4831, 5147, 5647, 6343, 6899, 7103, 7873, 8147 };
    unsigned uHash = 0;
    int i;
    if ( pSim[0] & 1 )
        for ( i = 0; i < nWords; i++ )
            uHash ^= ~pSim[i] * s_Primes[i & 0xf];
    else
        for ( i = 0; i < nWords; i++ )
            uHash ^=  pSim[i] * s_Primes[i & 0xf];
    return (int)(uHash % nTableSize);

}

/**Function*************************************************************

  Synopsis    [Rehashes the refined classes.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Hcd_ManClassesRehash( Hcd_Man_t * p, Vec_Int_t * vRefined )
{
    int * pTable, nTableSize, Key, i, k;
    nTableSize = Gia_PrimeCudd( 100 + Vec_IntSize(vRefined) / 5 );
    pTable = ABC_CALLOC( int, nTableSize );
    Vec_IntForEachEntry( vRefined, i, k )
    {
        assert( !Hcd_ManCompareConst( Hcd_ObjSim(p, i) ) );
        Key = Hcd_ManHashKey( Hcd_ObjSimP(p, i), 1, nTableSize );
        if ( pTable[Key] == 0 )
            Gia_ObjSetRepr( p->pGia, i, GIA_VOID );
        else
        {
            Gia_ObjSetNext( p->pGia, pTable[Key], i );
            Gia_ObjSetRepr( p->pGia, i, Gia_ObjRepr(p->pGia, pTable[Key]) );
            if ( Gia_ObjRepr(p->pGia, i) == GIA_VOID )
                Gia_ObjSetRepr( p->pGia, i, pTable[Key] );
        }
        pTable[Key] = i;
    }
    ABC_FREE( pTable );
//    Gia_ManEquivPrintClasses( p->pGia, 0, 0.0 );
    // refine classes in the table
    Vec_IntForEachEntry( vRefined, i, k )
    {
        if ( Gia_ObjIsHead( p->pGia, i ) )
            Hcd_ManClassRefineOne( p, i );
    }
    Gia_ManEquivPrintClasses( p->pGia, 0, 0.0 );
}

/**Function*************************************************************

  Synopsis    [Refines equivalence classes after simulation.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Hcd_ManClassesRefine( Hcd_Man_t * p )
{
    Gia_Obj_t * pObj;
    int i;
    Vec_IntClear( p->vRefinedC );
    Gia_ManForEachAnd( p->pGia, pObj, i )
    {
        if ( Gia_ObjIsTail(p->pGia, i) ) // add check for the class level
        {
            Hcd_ManClassRefineOne( p, Gia_ObjRepr(p->pGia, i) );
        }
        else if ( Gia_ObjIsConst(p->pGia, i) )
        {
            if ( !Hcd_ManCompareConst( Hcd_ObjSim(p, i) ) )
                Vec_IntPush( p->vRefinedC, i );
        }
    }
    Hcd_ManClassesRehash( p, p->vRefinedC );
}

/**Function*************************************************************

  Synopsis    [Creates equivalence classes for the first time.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Hcd_ManClassesCreate( Hcd_Man_t * p )
{
    Gia_Obj_t * pObj;
    int i;
    assert( p->pGia->pReprs == NULL );
    p->pGia->pReprs = ABC_CALLOC( Gia_Rpr_t, Gia_ManObjNum(p->pGia) );
    p->pGia->pNexts = ABC_CALLOC( int, Gia_ManObjNum(p->pGia) );
    Gia_ManForEachObj( p->pGia, pObj, i )
        Gia_ObjSetRepr( p->pGia, i, Gia_ObjIsAnd(pObj) ? 0 : GIA_VOID );
}

/**Function*************************************************************

  Synopsis    [Initializes simulation info.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Hcd_ManSimulationInit( Hcd_Man_t * p )
{
    Gia_Obj_t * pObj;
    int i;
    Gia_ManForEachCi( p->pGia, pObj, i )
        Hcd_ObjSetSim( p, i, (Gia_ManRandom(0) << 1) );
}

/**Function*************************************************************

  Synopsis    [Performs one round of simple combinational simulation.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Hcd_ManSimulateSimple( Hcd_Man_t * p )
{
    Gia_Obj_t * pObj;
    unsigned Res0, Res1;
    int i;
    Gia_ManForEachAnd( p->pGia, pObj, i )
    {
        Res0 = Hcd_ObjSim( p, Gia_ObjFaninId0(pObj, i) );
        Res1 = Hcd_ObjSim( p, Gia_ObjFaninId1(pObj, i) );
        Hcd_ObjSetSim( p, i, (Gia_ObjFaninC0(pObj)? ~Res0: Res0) &
                             (Gia_ObjFaninC1(pObj)? ~Res1: Res1) );
    }
}


/**Function*************************************************************

  Synopsis    [Resimulate and refine one equivalence class.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
unsigned Gia_Resimulate_rec( Hcd_Man_t * p, int iObj )
{
    Gia_Obj_t * pObj;
    unsigned Res0, Res1;
    if ( Gia_ObjIsTravIdCurrentArrayId( p->pGia, iObj ) )
        return Hcd_ObjSim( p, iObj );
    Gia_ObjSetTravIdCurrentArrayId( p->pGia, iObj );
    pObj = Gia_ManObj(p->pGia, iObj);
    if ( Gia_ObjIsCi(pObj) )
        return Hcd_ObjSetSim( p, iObj, (Gia_ManRandom(0) << 1) );
    assert( Gia_ObjIsAnd(pObj) );
    Res0 = Gia_Resimulate_rec( p, Gia_ObjFaninId0(pObj, iObj) );
    Res1 = Gia_Resimulate_rec( p, Gia_ObjFaninId1(pObj, iObj) );
    return Hcd_ObjSetSim( p, iObj, (Gia_ObjFaninC0(pObj)? ~Res0: Res0) &
                                   (Gia_ObjFaninC1(pObj)? ~Res1: Res1) );
}

/**Function*************************************************************

  Synopsis    [Resimulate and refine one equivalence class.]

  Description [Assumes that the counter-example is assigned at the PIs.
  The counter-example should have the first bit set to 0 at each PI.]
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ResimulateAndRefine( Hcd_Man_t * p, int i )
{
    int RetValue, iObj;
    Gia_ManIncrementTravIdArray( p->pGia );
    Gia_ClassForEachObj( p->pGia, i, iObj )
        Gia_Resimulate_rec( p, iObj );
    RetValue = Hcd_ManClassRefineOne( p, i );
    assert( RetValue );
}


/**Function*************************************************************

  Synopsis    [Reduces the AIG to only contain important nodes.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Gia_Man_t * Gia_GenerateReducedConst( Gia_Man_t * p, Vec_Ptr_t ** pvRoots )
{
    Vec_Ptr_t * vRoots;
    Gia_Man_t * pNew, * pTemp;
    Gia_Obj_t * pObj, * pRepr;
    int i, k;
    Gia_ManCleanMark0( p );
    vRoots = Vec_PtrAlloc( 100 );
    Gia_ManForEachAnd( p, pObj, i )
    {
        pObj->fMark0 = Gia_ObjFanin0(pObj)->fMark0 || Gia_ObjFanin1(pObj)->fMark0;
        if ( pObj->fMark0 || !Gia_ObjIsConst(p, i) || Gia_ObjProved(p, i) )
            continue;
        // const marked for the first time
        pObj->fMark0 = 1;
        Vec_PtrPush( vRoots, pObj );
    }
    // clean the roots
    Vec_PtrForEachEntry( vRoots, pObj, i )
        pObj->fMark0 = 0;
    // copy unmarked nodes
    pNew = Gia_ManStart( Gia_ManObjNum(p) );
    pNew->pName = Gia_UtilStrsav( p->pName );
    Gia_ManConst0(p)->Value = 0;
    Gia_ManForEachCi( p, pObj, i )
        pObj->Value = Gia_ManAppendCi(pNew);
    Gia_ManHashAlloc( pNew );
    Gia_ManForEachAnd( p, pObj, i )
    {
        if ( pObj->fMark0 )
            continue;
        pObj->Value = Gia_ManHashAnd( pNew, Gia_ObjFanin0Copy(pObj), Gia_ObjFanin1Copy(pObj) );
        if ( !Gia_ObjProved(p, i) )
            continue;
        pRepr = Gia_ObjReprObj(p, i);
        assert( pRepr < pObj );
        if ( pRepr->fMark0 )
            continue;
        pObj->Value  = Gia_LitNotCond( pRepr->Value, Gia_ObjPhase(pRepr) ^ Gia_ObjPhase(pObj) );
    }
    // add PO nodes
    printf( "Total roots = %d. ", Vec_PtrSize(vRoots) );
    k = 0;
    Vec_PtrForEachEntry( vRoots, pObj, i )
    {
        if ( pObj->Value == 0 || pObj->Value == 1 )
            continue;
        Gia_ManAppendCo( pNew, Gia_LitNotCond(pObj->Value, pObj->fPhase) );
        Vec_PtrWriteEntry( vRoots, k++, pObj );
    }
    Vec_PtrShrink( vRoots, k );
    printf( "Total outputs = %d.\n", Gia_ManCoNum(pNew) );

//    Vec_PtrFree( vRoots );
    *pvRoots = vRoots;

printf( "Before sweeping = %d\n", Gia_ManAndNum(pNew) );
    pNew = Gia_ManCleanup( pTemp = pNew );
    Gia_ManStop( pTemp );
printf( "After sweeping = %d\n", Gia_ManAndNum(pNew) );
    return pNew;
}


/**Function*************************************************************

  Synopsis    [Count the number of unproved constants.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Gia_CountConstants( Gia_Man_t * p )
{
    Gia_Obj_t * pObj;
    int i, Count = 0;
    Gia_ManForEachAnd( p, pObj, i )
        if ( Gia_ObjIsConst(p, i) && !Gia_ObjProved(p, i) )
            Count++;
    return Count;
}

/**Function*************************************************************

  Synopsis    [Performs refinement of constant-nodes.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_PerformsConstRefinement( Hcd_Man_t * p )
{
    extern void Tas_ManSolveMiterNc2( Gia_Man_t * pAig, int nConfs, Gia_Man_t * pAigOld, Vec_Ptr_t * vOldRoots, Vec_Ptr_t * vSimInfo );
    Vec_Ptr_t * vSimInfo;
    Gia_Man_t * pGiaC;
    Gia_Obj_t * pObj;
    Vec_Ptr_t * vRoots;
    int i, clk, nCount, nSmallRuns = 1000; // fixed number of runs
    // collect outputs of simulation info
    vSimInfo = Vec_PtrAlloc( 1000 );
    Gia_ManForEachCi( p->pGia, pObj, i )
        Vec_PtrPush( vSimInfo, Hcd_ObjSimP(p, Gia_ObjId(p->pGia,pObj)) );
    while ( (nCount = Gia_CountConstants(p->pGia)) )
    {
        clk = clock();
        pGiaC = Gia_GenerateReducedConst( p->pGia, &vRoots );
        ABC_PRT( "Reduced AIG", clock() - clk );

        printf( "Counter = %5d.\n", nCount );
        Tas_ManSolveMiterNc2( pGiaC, 100, p->pGia, vRoots, vSimInfo );
        Gia_ManStop( pGiaC );

        clk = clock();
        Hcd_ManSimulateSimple( p );
        Hcd_ManClassesRefine( p );
        ABC_PRT( "Simulate/refine", clock() - clk );
    }
    Vec_PtrFree( vSimInfo );
}

/**Function*************************************************************

  Synopsis    [Keeps only unsolved members belonging to representatives.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ShrinkEquivCands( Gia_Man_t * pGia, Vec_Ptr_t * vLev )
{
    Gia_Obj_t * pObj;
    int i, k = 0;
    Vec_PtrForEachEntry( vLev, pObj, i )
        if ( Gia_ObjIsUsed(pGia, Gia_ObjId(pGia, pObj)) && !Gia_ObjProved(pGia, Gia_ObjId(pGia, pObj)) )
            Vec_PtrWriteEntry( vLev, k++, pObj );
    Vec_PtrShrink( vLev, k );
}

/**Function*************************************************************

  Synopsis    [Returns temporary representative of the node.]

  Description [The temp repr is the first node among the nodes in the class that
  (a) precedes the given node, and (b) whose level is lower than the given node.]
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
static inline Gia_Obj_t * Gia_ObjTempRepr( Gia_Man_t * p, int i, int Level )
{
    int iRepr, iMember;
    iRepr = Gia_ObjRepr( p, i ); 
    if ( iRepr == GIA_VOID )
        return NULL;
    if ( iRepr == 0 )
        return Gia_ManConst0( p );
    Gia_ClassForEachObj( p, iRepr, iMember )
    {
        if ( iMember >= i )
            return NULL;
        if ( p->pLevels[iMember] < Level )
            return Gia_ManObj( p, iMember );
    }
    assert( 0 );
    return NULL;
}

/**Function*************************************************************

  Synopsis    [Generates reduced AIG for the given level.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Gia_Man_t * Gia_GenerateReducedLevel( Gia_Man_t * p, int Level, Vec_Ptr_t ** pvRoots )
{
    Gia_Man_t * pNew;
    Gia_Obj_t * pObj, * pRepr;
    Vec_Ptr_t * vRoots;
    int i;
    vRoots = Vec_PtrAlloc( 100 );
    // copy unmarked nodes
    pNew = Gia_ManStart( Gia_ManObjNum(p) );
    pNew->pName = Gia_UtilStrsav( p->pName );
    Gia_ManConst0(p)->Value = 0;
    Gia_ManForEachCi( p, pObj, i )
        pObj->Value = Gia_ManAppendCi(pNew);
    Gia_ManHashAlloc( pNew );
    Gia_ManForEachAnd( p, pObj, i )
    {
        if ( p->pLevels[i] > Level )
            continue;
        if ( p->pLevels[i] == Level )
            Vec_PtrPush( vRoots, pObj );
        if ( p->pLevels[i] < Level && (pRepr = Gia_ObjTempRepr(p, i, Level)) )
        {
            assert( pRepr < pObj );
            pObj->Value  = Gia_LitNotCond( pRepr->Value, Gia_ObjPhase(pRepr) ^ Gia_ObjPhase(pObj) );
            continue;
        }
        pObj->Value = Gia_ManHashAnd( pNew, Gia_ObjFanin0Copy(pObj), Gia_ObjFanin1Copy(pObj) );
    }
    *pvRoots = vRoots;
    // required by SAT solving
    Gia_ManCreateRefs( pNew );
    Gia_ManFillValue( pNew );
    return pNew;
}

/**Function*************************************************************

  Synopsis    [Collects relevant classes.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Vec_Ptr_t * Gia_CollectRelatedClasses( Gia_Man_t * pGia, Vec_Ptr_t * vRoots )
{
    Vec_Ptr_t * vClasses;
    Gia_Obj_t * pRoot, * pRepr;
    int i;
    vClasses = Vec_PtrAlloc( 100 );
    Gia_ManConst0( pGia )->fMark0 = 1;
    Vec_PtrForEachEntry( vRoots, pRoot, i )
    {
        pRepr = Gia_ObjReprObj( pGia, Gia_ObjId(pGia, pRoot) );
        if ( pRepr == NULL || pRepr->fMark0 )
            continue;
        Vec_PtrPush( vClasses, pRepr );
    }
    Gia_ManConst0( pGia )->fMark0 = 0;
    Vec_PtrForEachEntry( vClasses, pRepr, i )
        pRepr->fMark0 = 0;
    return vClasses;
}

/**Function*************************************************************

  Synopsis    [Collects class members.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
Gia_Obj_t * Gia_CollectClassMembers( Gia_Man_t * p, Gia_Obj_t * pRepr, Vec_Ptr_t * vMembers, int Level )
{
    Gia_Obj_t * pTempRepr = NULL;
    int iRepr, iMember;
    iRepr = Gia_ObjId( p, pRepr );
    Vec_PtrClear( vMembers );
    Gia_ClassForEachObj( p, iRepr, iMember )
    {
        if ( p->pLevels[iMember] == Level )
            Vec_PtrPush( vMembers, Gia_ManObj( p, iMember ) );
        if ( pTempRepr == NULL && p->pLevels[iMember] < Level )
            pTempRepr = Gia_ManObj( p, iMember );
    }
    assert( Vec_PtrSize(vMembers) > 0 );
    return pTempRepr;
}


/**Function*************************************************************

  Synopsis    [Packs patterns into array of simulation info.]

  Description []
               
  SideEffects []

  SeeAlso     []

*************************************`**********************************/
int Gia_GiarfStorePatternTry( Vec_Ptr_t * vInfo, Vec_Ptr_t * vPres, int iBit, int * pLits, int nLits )
{
    unsigned * pInfo, * pPres;
    int i;
    for ( i = 0; i < nLits; i++ )
    {
        pInfo = Vec_PtrEntry(vInfo, Gia_Lit2Var(pLits[i]));
        pPres = Vec_PtrEntry(vPres, Gia_Lit2Var(pLits[i]));
        if ( Gia_InfoHasBit( pPres, iBit ) && 
             Gia_InfoHasBit( pInfo, iBit ) == Gia_LitIsCompl(pLits[i]) )
             return 0;
    }
    for ( i = 0; i < nLits; i++ )
    {
        pInfo = Vec_PtrEntry(vInfo, Gia_Lit2Var(pLits[i]));
        pPres = Vec_PtrEntry(vPres, Gia_Lit2Var(pLits[i]));
        Gia_InfoSetBit( pPres, iBit );
        if ( Gia_InfoHasBit( pInfo, iBit ) == Gia_LitIsCompl(pLits[i]) )
            Gia_InfoXorBit( pInfo, iBit );
    }
    return 1;
}

/**Function*************************************************************

  Synopsis    [Procedure to test the new SAT solver.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
int Gia_GiarfStorePattern( Vec_Ptr_t * vSimInfo, Vec_Ptr_t * vPres, Vec_Int_t * vCex )
{
    int k;
    for ( k = 1; k < 32; k++ )
        if ( Gia_GiarfStorePatternTry( vSimInfo, vPres, k, (int *)Vec_IntArray(vCex), Vec_IntSize(vCex) ) )
            break;
    return (int)(k < 32);
}

/**Function*************************************************************

  Synopsis    [Performs computation of AIGs with choices.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ComputeEquivalencesLevel( Hcd_Man_t * p, Gia_Man_t * pGiaLev, Vec_Ptr_t * vOldRoots, int Level )
{
    Tas_Man_t * pTas;
    Vec_Int_t * vCex;
    Vec_Ptr_t * vClasses, * vMembers;
    Gia_Obj_t * pRoot, * pMember, * pMemberPrev, * pRepr, * pTempRepr;
    int i, k, iRoot, iRootNew, iMember, iMemberPrev, status, fOneFailed;
    int nSaved = 0, nRecords = 0, nUndec = 0;

    pTas = Tas_ManAlloc( pGiaLev, 1000 );
    vCex = Tas_ReadModel( pTas );
    vMembers = Vec_PtrAlloc( 100 );
    Vec_PtrCleanSimInfo( p->vSimPres, 0, 1 );
    // resolve constants
    Vec_PtrForEachEntry( vOldRoots, pRoot, i )
    {
        iRoot = Gia_ObjId( p->pGia, pRoot );
        if ( !Gia_ObjIsConst( p->pGia, iRoot ) )
            continue;
        iRootNew = Gia_LitNotCond( pRoot->Value, pRoot->fPhase );
        status = Tas_ManSolve( pTas, Gia_ObjFromLit(pGiaLev, iRootNew), NULL );
        if ( status == -1 ) // undec
        {
//            Gia_ObjSetFailed( p->pGia, iRoot );
            nUndec++;
        }
        else if ( status == 1 ) // unsat
        {
            Gia_ObjSetProved( p->pGia, iRoot );
        }
        else  // sat
        {
//            Gia_ObjUnsetRepr( p->pGia, iRoot ); // do we need this?
            nRecords++;
            nSaved += Gia_GiarfStorePattern( p->vSimInfo, p->vSimPres, vCex );
        }
    }

    while ( Vec_PtrSize(vOldRoots) > 0 )
    {
        // resolve equivalences 
        vClasses = Gia_CollectRelatedClasses( p->pGia, vOldRoots );
        Vec_PtrClear( vOldRoots );
        Vec_PtrForEachEntry( vClasses, pRepr, i )
        {
            // derive temp repr and members on this level
            pTempRepr = Gia_CollectClassMembers( p->pGia, pRepr, vMembers, Level );
            Vec_PtrPush( vMembers, pTempRepr );
            assert( Vec_PtrSize(vMembers) >= 1 );
            if ( Vec_PtrSize(vMembers) == 1 )
                continue;
            // try proving the members
            fOneFailed = 0;
            pMemberPrev = Vec_PtrEntryLast( vMembers );
            Vec_PtrForEachEntry( vMembers, pMember, k )
            {
                iMemberPrev = Gia_LitNotCond( pMemberPrev->Value,  pMemberPrev->fPhase ); 
                iMember     = Gia_LitNotCond( pMember->Value,     !pMember->fPhase ); 
                pMemberPrev = pMember;
                status = Tas_ManSolve( pTas, Gia_ObjFromLit(pGiaLev, iMemberPrev), Gia_ObjFromLit(pGiaLev, iMember) );
                if ( status == -1 ) // undec
                {
//                    Gia_ObjSetFailed( p->pGia, iRoot );
                    nUndec++;
                }
                else if ( status == 1 ) // unsat
                {
//                    Gia_ObjSetProved( p->pGia, iRoot );
                }
                else  // sat
                {
                    fOneFailed = 1;
                    nRecords++;
                    nSaved += Gia_GiarfStorePattern( p->vSimInfo, p->vSimPres, vCex );
                }
            }
            // if fail, quit this class
            if ( fOneFailed )
            {
                Vec_PtrForEachEntry( vMembers, pMember, k )
                    Vec_PtrPush( vOldRoots, pMember );
            }
        }
    }

        // resimulate
//        clk = clock();
        Hcd_ManSimulateSimple( p );
        Hcd_ManClassesRefine( p );
//        ABC_PRT( "Simulate/refine", clock() - clk );

        // verify the results

    Vec_PtrFree( vMembers );
    Tas_ManStop( pTas );
}

/**Function*************************************************************

  Synopsis    [Performs computation of AIGs with choices.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Gia_ComputeEquivalences( Gia_Man_t * pGia, int nBTLimit, int fUseMiniSat, int fVerbose )
{
    Hcd_Man_t * p;
    Gia_Man_t * pGiaLev;
    Vec_Ptr_t * vRoots;
    int i, Lev, nLevels;
    int clk;
    Gia_ManRandom( 1 );
    Gia_ManSetPhase( pGia );
    nLevels = Gia_ManLevelNum( pGia );
    // start the manager
    p = Gia_ManEquivStart( pGia, nBTLimit, fVerbose );
    // create trivial classes
    Hcd_ManClassesCreate( p );
    // refine
    for ( i = 0; i < 3; i++ )
    {
        clk = clock();       
        Hcd_ManSimulationInit( p );
        Hcd_ManSimulateSimple( p );
        ABC_PRT( "Sim", clock() - clk );
        clk = clock();
        Hcd_ManClassesRefine( p );
        ABC_PRT( "Ref", clock() - clk );
    }
    // process in the levelized order
    for ( Lev = 1; Lev < nLevels; Lev++ )
    {
        pGiaLev = Gia_GenerateReducedLevel( pGia, Lev, &vRoots );
        Gia_ComputeEquivalencesLevel( p, pGiaLev, vRoots, Lev );
        Gia_ManStop( pGiaLev );
        Vec_PtrFree( vRoots );
    }
    // clean up
    Gia_ManEquivStop( p );
}

////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////


