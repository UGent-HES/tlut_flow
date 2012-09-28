/**CFile****************************************************************

  FileName    [giaAbs.h]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Scalable AIG package.]

  Synopsis    [External declarations.]

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: giaAbs.h,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/
 
#ifndef __GIA_ABS_H__
#define __GIA_ABS_H__

////////////////////////////////////////////////////////////////////////
///                          INCLUDES                                ///
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
///                         PARAMETERS                               ///
////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
extern "C" {
#endif

////////////////////////////////////////////////////////////////////////
///                         BASIC TYPES                              ///
////////////////////////////////////////////////////////////////////////

// abstraction parameters
typedef struct Gia_ParAbs_t_ Gia_ParAbs_t;
struct Gia_ParAbs_t_
{
    int            nFramesMax;   // timeframes for PBA
    int            nConfMax;     // conflicts for PBA
    int            fDynamic;     // dynamic unfolding for PBA
    int            fConstr;      // use constraints
    int            nFramesBmc;   // timeframes for BMC
    int            nConfMaxBmc;  // conflicts for BMC
    int            nRatio;       // ratio of flops to quit
    int            fUseBdds;     // use BDDs to refine abstraction
    int            fUseDprove;   // use 'dprove' to refine abstraction
    int            fUseStart;    // use starting frame
    int            fVerbose;     // verbose output
};

extern void Gia_ManAbsSetDefaultParams( Gia_ParAbs_t * p );

////////////////////////////////////////////////////////////////////////
///                      MACRO DEFINITIONS                           ///
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
///                    FUNCTION DECLARATIONS                         ///
////////////////////////////////////////////////////////////////////////

 
#ifdef __cplusplus
}
#endif

#endif

////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////

