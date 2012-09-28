/**CFile****************************************************************

  FileName    [skyAbc.c]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Universal netlist with boxes.]

  Synopsis    [Replacement procedures for the Sky package.]

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: skyAbc.c,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/

#include "gia.h"
#include "sky.h"

////////////////////////////////////////////////////////////////////////
///                        DECLARATIONS                              ///
////////////////////////////////////////////////////////////////////////

#define ATTR
//#define ATTR static

////////////////////////////////////////////////////////////////////////
///                     FUNCTION DEFINITIONS                         ///
////////////////////////////////////////////////////////////////////////

/*=== sky.c ======================================================================*/
/*=== skyBest.c ======================================================================*/
ATTR int             Sky_ManCompareWithBest( Sky_Man_t * p )                                            { return 0;    }
/*=== skyCheck.c =================================================================*/
/*=== skyCore.c ==================================================================*/
ATTR Sky_Man_t *     Sky_ManPerformBalance( Sky_Man_t * p, int fExor, int fUpdateLevel, int fVerbose )  { return NULL; }
ATTR Sky_Man_t *     Sky_ManPerformDc2( Sky_Man_t * p, int fBalance, int fUpdateLevel, int fVerbose )   { return NULL; }
ATTR Sky_Man_t *     Sky_ManPerformDch( Sky_Man_t * p, void * pPars )                                   { return NULL; }
ATTR Sky_Man_t *     Sky_ManPerformBidec( Sky_Man_t * p, int fVerbose )                                 { return NULL; }
ATTR Sky_Man_t *     Sky_ManPerformMapShrink( Sky_Man_t * p, int fKeepLevel, int fVerbose )             { return NULL; }
ATTR float           Sky_ManTrace( Sky_Man_t * p, void * pLutLib, int fVerbose )                        { return 0.0;  }
ATTR Sky_Man_t *     Sky_ManSpeedup( Sky_Man_t * p, void * pLL, int Per, int Degree, int fV, int fVV )  { return NULL; }
/*=== skyDfs.c ===================================================================*/
/*=== skyDress.c =================================================================*/
ATTR Sky_Man_t *     Sky_ManDress( Sky_Man_t * p0, Sky_Man_t * p1, int nBTL, int fPol, int fV, int fVV) { return NULL; }
/*=== skyExtract.c ===============================================================*/
ATTR Gia_Man_t *     Sky_ManExtract( Sky_Man_t * p )                                                    { return NULL; }
ATTR Gia_Man_t *     Sky_ManCollapseComb( Sky_Man_t * p )                                               { return NULL; }
ATTR Gia_Man_t *     Sky_ManCollapseSeq( Sky_Man_t * p )                                                { return NULL; }
/*=== skyIf.c ====================================================================*/
ATTR void            Sky_ManSetIfParsDefault( void * pPars )                                            {}
ATTR Sky_Man_t *     Sky_ManMappingIf( Sky_Man_t * p, void * pPars )                                    { return NULL; }
ATTR Sky_Man_t *     Sky_ManMappingIfLogic( Sky_Man_t * p, void * pPars )                               { return NULL; }
/*=== skyLog.c =================================================================*/
ATTR void            Sky_ManLogDump( Sky_Man_t * p, char * pFileName )                                  {}
/*=== skyLogic.c =================================================================*/
ATTR Sky_Man_t *     Sky_ManLogic( Sky_Man_t * p, int fOldAlgo, int fTrueFanins, int nSlackMin )        { return NULL; }
ATTR Sky_Man_t *     Sky_ManLogicAig( Sky_Man_t * p )                                                   { return NULL; }
ATTR Sky_Man_t *     Sky_ManUnmap( Sky_Man_t * p )                                                      { return NULL; }
ATTR Sky_Man_t *     Sky_ManShortNames( Sky_Man_t * p )                                                 { return NULL; }
/*=== skyMan.c ===================================================================*/
ATTR void            Sky_ManFree( Sky_Man_t * p )                                                       {}
ATTR void            Sky_ManFreeP( void ** p )                                                          {}
ATTR Sky_Man_t *     Sky_ManDup( Sky_Man_t * p, Sky_Mod_t*(*pFuncModDup)(Sky_Man_t*,Sky_Mod_t*,int) )   { return NULL; }
ATTR Sky_Mod_t *     Sky_ManReadRoot( Sky_Man_t * p )                                                   { return NULL; }
/*=== skyName.c ==================================================================*/
/*=== skyObj.c ===================================================================*/
/*=== skyPrint.c =================================================================*/
ATTR void            Sky_ManPrintStats( Sky_Man_t * p, int fReportInstances, int fReportDangling, int fReportFlops, int fReportFanio, int fReportMemory, int fReportNpn, int fReportMffc, int fReportTiming ) {}
/*=== skyReadBlif.c ==============================================================*/
ATTR Sky_Man_t *     Sky_ManReadBlif( Sky_Man_t * pOld, char * pFileName, int fCheck )                  { return NULL; }
ATTR Sky_Man_t *     Sky_ManPrepareOne( char * pFileName, int fSaveNodeNames )                          { return NULL; }
/*=== skySeq.c ===================================================================*/
ATTR Sky_Man_t *     Sky_ManSeqSynthesis( Sky_Man_t * p, void * pSynPars, int fIgnoreAsync )            { return NULL; }
ATTR Sky_Man_t *     Sky_ManFraig( Sky_Man_t * p, void * pDchPars )                                     { return NULL; }
/*=== skyStats.c =================================================================*/
ATTR char *          Sky_ManName( Sky_Man_t * p )                                                       { return NULL; }
ATTR char *          Sky_ManSpec( Sky_Man_t * p )                                                       { return NULL; }
ATTR void            Sky_ManSetName( Sky_Man_t * p, char * pName )                                      {}
ATTR void            Sky_ManSetSpec( Sky_Man_t * p, char * pSpec )                                      {}
ATTR int             Sky_ManHasCboices( Sky_Man_t * p )                                                 { return 0;    }
ATTR int             Sky_ManIsStrashed( Sky_Man_t * p )                                                 { return 0;    }
ATTR int             Sky_ManIsMapped( Sky_Man_t * p )                                                   { return 0;    }
ATTR int             Sky_ManPiNum( Sky_Man_t * p )                                                      { return 0;    }
ATTR int             Sky_ManPoNum( Sky_Man_t * p )                                                      { return 0;    }
ATTR int             Sky_ManFfNum( Sky_Man_t * p )                                                      { return 0;    }
ATTR int             Sky_ManBoxNum( Sky_Man_t * p )                                                     { return 0;    }
ATTR int             Sky_ManSeqBoxNum( Sky_Man_t * p )                                                  { return 0;    }
ATTR int             Sky_ManSeqWhiteBoxNum( Sky_Man_t * p )                                             { return 0;    }
ATTR int             Sky_ManSeqBlackBoxNum( Sky_Man_t * p )                                             { return 0;    }
ATTR int             Sky_ManCombBoxNum( Sky_Man_t * p )                                                 { return 0;    }
ATTR int             Sky_ManCombWhiteBoxNum( Sky_Man_t * p )                                            { return 0;    }
ATTR int             Sky_ManCombBlackBoxNum( Sky_Man_t * p )                                            { return 0;    }
ATTR int             Sky_ManNodeNum( Sky_Man_t * p )                                                    { return 0;    }
ATTR int             Sky_ManNode0Num( Sky_Man_t * p )                                                   { return 0;    }
ATTR int             Sky_ManNode1Num( Sky_Man_t * p )                                                   { return 0;    }
ATTR int             Sky_ManNode2pNum( Sky_Man_t * p )                                                  { return 0;    }
ATTR int             Sky_ManAigLevelNum( Sky_Man_t * p )                                                { return 0;    }
ATTR int             Sky_ManMappedLevelNum( Sky_Man_t * p )                                             { return 0;    }
ATTR int             Sky_ManAndNum( Sky_Man_t * p )                                                     { return 0;    }
ATTR int             Sky_ManObjNum( Sky_Man_t * p )                                                     { return 0;    }
ATTR int             Sky_ManEdgeNum( Sky_Man_t * p )                                                    { return 0;    }
ATTR float           Sky_ManDelay( Sky_Man_t * p, void * pLutLib )                                      { return 0.0;  } 
/*=== skyStrash.c ================================================================*/
ATTR Sky_Man_t *     Sky_ManStrash( Sky_Man_t * p )                                                     { return NULL; }
/*=== skySweep.c =================================================================*/
ATTR Sky_Man_t *     Sky_ManStructSweepSeq( Sky_Man_t * p, int fVerbose )                               { return NULL; }
/*=== skyUtil.c ==================================================================*/
/*=== skyVerify.c ================================================================*/
ATTR int             Sky_ManPrepareVerification( Sky_Man_t * pMan, char ** argv, int argc, 
                        Sky_Man_t ** ppMan1, Sky_Man_t ** ppMan2, int * pfDelete1, int * pfDelete2 )    { return 1;    }
ATTR int             Sky_ManVerifyCec( Sky_Man_t * p1, Sky_Man_t * p2, int fClp, int fDumpM, int fVer ) { return 1;    }
ATTR int             Sky_ManVerifySec( Sky_Man_t * p1, Sky_Man_t * p2, void * pSecPars, int fDumpM, int fIgnoreAsync )    { return 1;    }
ATTR int             Sky_ManVerifySim( Sky_Man_t * p1, Sky_Man_t * p2, Gia_ParSim_t * pSimPars, int fD, int fIgnoreAsync ){ return 1;    }
/*=== skyWriteBlif.c =============================================================*/
ATTR void            Sky_ManWriteBlif( Sky_Man_t * p, char * pFileName )                                {}

/*=== rtmCore.c ===================================================================*/
ATTR int             Rti_ManPeriod( Sky_Man_t * p, int fUnitDelay, int nItersMax, int fReverse, int fOneDir, int fVerbose ) { return 0;    } 
ATTR Sky_Man_t *     Rti_ManMapSeqMinDelay( Sky_Man_t * p, int nItersMax, int fReverse, int fOneDir, int fVerbose )         { return NULL; } 
ATTR Sky_Man_t *     Rti_ManRetime( Sky_Man_t * p, Sky_RetPar_t * pPars )                                                   { return NULL; } 
ATTR Sky_Man_t *     Rti_ManElaborate( Sky_Man_t * p, int fReset, int fEnable, int fVerbose )                               { return NULL; } 

////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////


