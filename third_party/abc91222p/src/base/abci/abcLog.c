/**CFile****************************************************************

  FileName    [abcLog.c]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Network and node package.]

  Synopsis    [Log file printing.]

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: abcLog.c,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/

#include "abc.h"
#include "gia.h"

////////////////////////////////////////////////////////////////////////
///                        DECLARATIONS                              ///
////////////////////////////////////////////////////////////////////////

/*
    Log file format (Jiang, Mon, 28 Sep 2009)

    <result> <cyc> <engine_name>
    <TRACE> : default is "NULL"
    <INIT_STATE> : default is "NULL"
   
    <retult> is the following:
    snl_SAT
    snl_UNSAT
    snl_UNK
    snl_ABORT
   
    <cyc> : # of cycles
   
    <INIT_STATE>  : initial state
    <TRACE> : input vector
   
    <INIT_STATE>and <TRACE> are strings of 0/1/- ( - means don't care). The length is equivalent to #input*#<cyc>.
*/

////////////////////////////////////////////////////////////////////////
///                     FUNCTION DEFINITIONS                         ///
////////////////////////////////////////////////////////////////////////

/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_NtkWriteLogFile( char * pFileName, void * pSeqCex, int Status, char * pCommand )
{
    Gia_Cex_t * pCex = pSeqCex;
    FILE * pFile;
    int i;
    pFile = fopen( pFileName, "w" );
    if ( pFile == NULL )
    {
        printf( "Cannot open log file \"%s\".\n" , pFileName );
        return;
    }
    // write <result>
    if ( Status == 1 )
        fprintf( pFile, "snl_UNSAT" );
    else if ( Status == 0 )
        fprintf( pFile, "snl_SAT" );
    else if ( Status == -1 )
        fprintf( pFile, "snl_UNK" );
    else 
        printf( "Abc_NtkWriteLogFile(): Cannot recognize solving status.\n" );
    fprintf( pFile, " " );
    // write <cyc>
    fprintf( pFile, "%d", pCex ? pCex->iFrame + 1 : -1 );
    fprintf( pFile, " " );
    // write <engine_name>
    fprintf( pFile, "%s", pCommand ? pCommand : "unknown" );
    fprintf( pFile, "\n" );
    // write <INIT_STATE>
    if ( pCex == NULL )
        fprintf( pFile, "NULL" );
    else
    {
        for ( i = 0; i < pCex->nRegs; i++ )
            fprintf( pFile, "%d", Gia_InfoHasBit(pCex->pData,i) );
    }
    fprintf( pFile, "\n" );
    // write <TRACE>
    if ( pCex == NULL )
        fprintf( pFile, "NULL" );
    else
    {
        assert( pCex->nBits - pCex->nRegs == pCex->nPis * (pCex->iFrame + 1) );
        for ( i = pCex->nRegs; i < pCex->nBits; i++ )
            fprintf( pFile, "%d", Gia_InfoHasBit(pCex->pData,i) );
    }
    fprintf( pFile, "\n" );
    fclose( pFile );
}

////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////


