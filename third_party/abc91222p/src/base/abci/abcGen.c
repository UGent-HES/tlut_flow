/**CFile****************************************************************

  FileName    [abcGen.c]

  SystemName  [ABC: Logic synthesis and verification system.]

  PackageName [Network and node package.]

  Synopsis    [Procedures to generate various type of circuits.]

  Author      [Alan Mishchenko]
  
  Affiliation [UC Berkeley]

  Date        [Ver. 1.0. Started - June 20, 2005.]

  Revision    [$Id: abcGen.c,v 1.00 2005/06/20 00:00:00 alanmi Exp $]

***********************************************************************/

#include "abc.h"

////////////////////////////////////////////////////////////////////////
///                        DECLARATIONS                              ///
////////////////////////////////////////////////////////////////////////

void Abc_WriteLayer( FILE * pFile, int nVars, int fSkip1 );
void Abc_WriteComp( FILE * pFile );
void Abc_WriteFullAdder( FILE * pFile );

void Abc_GenAdder( char * pFileName, int nVars );
void Abc_GenSorter( char * pFileName, int nVars );

////////////////////////////////////////////////////////////////////////
///                     FUNCTION DEFINITIONS                         ///
////////////////////////////////////////////////////////////////////////

/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_GenAdder( char * pFileName, int nVars )
{
    FILE * pFile;
    int i;

    assert( nVars > 0 );

    pFile = fopen( pFileName, "w" );
    fprintf( pFile, "# %d-bit ripple-carry adder generated by ABC on %s\n", nVars, Extra_TimeStamp() );
    fprintf( pFile, ".model Adder%02d\n", nVars );

    fprintf( pFile, ".inputs" );
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " a%02d", i );
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " b%02d", i );
    fprintf( pFile, "\n" );

    fprintf( pFile, ".outputs" );
    for ( i = 0; i <= nVars; i++ )
        fprintf( pFile, " y%02d", i );
    fprintf( pFile, "\n" );

    fprintf( pFile, ".names c\n" );
    if ( nVars == 1 )
        fprintf( pFile, ".subckt FA a=a00 b=b00 cin=c s=y00 cout=y01\n" );
    else
    {
        fprintf( pFile, ".subckt FA a=a00 b=b00 cin=c s=y00 cout=%02d\n", 0 );
        for ( i = 1; i < nVars-1; i++ )
            fprintf( pFile, ".subckt FA a=a%02d b=b%02d cin=%02d s=y%02d cout=%02d\n", i, i, i-1, i, i );
        fprintf( pFile, ".subckt FA a=a%02d b=b%02d cin=%02d s=y%02d cout=y%02d\n", i, i, i-1, i, i+1 );
    }
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" );

    Abc_WriteFullAdder( pFile );
    fclose( pFile );
}

/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_GenSorter( char * pFileName, int nVars )
{
    FILE * pFile;
    int i, k, Counter, nDigits;

    assert( nVars > 1 );

    pFile = fopen( pFileName, "w" );
    fprintf( pFile, "# %d-bit sorter generated by ABC on %s\n", nVars, Extra_TimeStamp() );
    fprintf( pFile, ".model Sorter%02d\n", nVars );

    fprintf( pFile, ".inputs" );
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " x%02d", i );
    fprintf( pFile, "\n" );

    fprintf( pFile, ".outputs" );
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " y%02d", i );
    fprintf( pFile, "\n" );

    Counter = 0;
    nDigits = Extra_Base10Log( (nVars-2)*nVars );
    if ( nVars == 2 )
        fprintf( pFile, ".subckt Comp a=x00 b=x01 x=y00 y=y01\n" );
    else
    {
        fprintf( pFile, ".subckt Layer0" );
        for ( k = 0; k < nVars; k++ )
            fprintf( pFile, " x%02d=x%02d", k, k );
        for ( k = 0; k < nVars; k++ )
            fprintf( pFile, " y%02d=%0*d", k, nDigits, Counter++ );
        fprintf( pFile, "\n" );
        Counter -= nVars;
        for ( i = 1; i < 2*nVars-2; i++ )
        {
            fprintf( pFile, ".subckt Layer%d", (i&1) );
            for ( k = 0; k < nVars; k++ )
                fprintf( pFile, " x%02d=%0*d", k, nDigits, Counter++ );
            for ( k = 0; k < nVars; k++ )
                fprintf( pFile, " y%02d=%0*d", k, nDigits, Counter++ );
            fprintf( pFile, "\n" );
            Counter -= nVars;
        }
        fprintf( pFile, ".subckt Layer%d", (i&1) );
        for ( k = 0; k < nVars; k++ )
            fprintf( pFile, " x%02d=%0*d", k, nDigits, Counter++ );
        for ( k = 0; k < nVars; k++ )
            fprintf( pFile, " y%02d=y%02d", k, k );
        fprintf( pFile, "\n" );
    }
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" );

    Abc_WriteLayer( pFile, nVars, 0 );
    Abc_WriteLayer( pFile, nVars, 1 );
    Abc_WriteComp( pFile );
    fclose( pFile );
}

/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_WriteLayer( FILE * pFile, int nVars, int fSkip1 )
{
    int i;
    fprintf( pFile, ".model Layer%d\n", fSkip1 );
    fprintf( pFile, ".inputs" ); 
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " x%02d", i ); 
    fprintf( pFile, "\n" ); 
    fprintf( pFile, ".outputs" ); 
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " y%02d", i ); 
    fprintf( pFile, "\n" ); 
    if ( fSkip1 )
    {
        fprintf( pFile, ".names x00 y00\n" ); 
        fprintf( pFile, "1 1\n" ); 
        i = 1;
    }
    else
        i = 0;
    for ( ; i + 1 < nVars; i += 2 )
        fprintf( pFile, ".subckt Comp a=x%02d b=x%02d x=y%02d y=y%02d\n", i, i+1, i, i+1 );
    if ( i < nVars )
    {
        fprintf( pFile, ".names x%02d y%02d\n", i, i ); 
        fprintf( pFile, "1 1\n" ); 
    }
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 
}

/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_WriteComp( FILE * pFile )
{
    fprintf( pFile, ".model Comp\n" );
    fprintf( pFile, ".inputs a b\n" ); 
    fprintf( pFile, ".outputs x y\n" ); 
    fprintf( pFile, ".names a b x\n" ); 
    fprintf( pFile, "11 1\n" ); 
    fprintf( pFile, ".names a b y\n" ); 
    fprintf( pFile, "1- 1\n" ); 
    fprintf( pFile, "-1 1\n" ); 
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 
}

/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_WriteFullAdder( FILE * pFile )
{
    fprintf( pFile, ".model FA\n" );
    fprintf( pFile, ".inputs a b cin\n" ); 
    fprintf( pFile, ".outputs s cout\n" ); 
    fprintf( pFile, ".names a b k\n" ); 
    fprintf( pFile, "10 1\n" ); 
    fprintf( pFile, "01 1\n" ); 
    fprintf( pFile, ".names k cin s\n" ); 
    fprintf( pFile, "10 1\n" ); 
    fprintf( pFile, "01 1\n" ); 
    fprintf( pFile, ".names a b cin cout\n" ); 
    fprintf( pFile, "11- 1\n" ); 
    fprintf( pFile, "1-1 1\n" ); 
    fprintf( pFile, "-11 1\n" ); 
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 
}


/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_WriteCell( FILE * pFile )
{
    fprintf( pFile, ".model cell\n" );
    fprintf( pFile, ".inputs px1 px2 py1 py2 x y\n" ); 
    fprintf( pFile, ".outputs fx fy\n" ); 
    fprintf( pFile, ".names x y a\n" ); 
    fprintf( pFile, "11 1\n" ); 
    fprintf( pFile, ".names px1 a x nx\n" ); 
    fprintf( pFile, "11- 1\n" ); 
    fprintf( pFile, "0-1 1\n" ); 
    fprintf( pFile, ".names py1 a y ny\n" ); 
    fprintf( pFile, "11- 1\n" ); 
    fprintf( pFile, "0-1 1\n" ); 
    fprintf( pFile, ".names px2 nx fx\n" ); 
    fprintf( pFile, "10 1\n" ); 
    fprintf( pFile, "01 1\n" ); 
    fprintf( pFile, ".names py2 ny fy\n" ); 
    fprintf( pFile, "10 1\n" ); 
    fprintf( pFile, "01 1\n" ); 
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 
}

/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_GenMesh( char * pFileName, int nVars )
{
    FILE * pFile;
    int i, k;

    assert( nVars > 0 );

    pFile = fopen( pFileName, "w" );
    fprintf( pFile, "# %dx%d mesh generated by ABC on %s\n", nVars, nVars, Extra_TimeStamp() );
    fprintf( pFile, ".model mesh%d\n", nVars );

    for ( i = 0; i < nVars; i++ )
        for ( k = 0; k < nVars; k++ )
        {
            fprintf( pFile, ".inputs" );
            fprintf( pFile, " p%d%dx1", i, k );
            fprintf( pFile, " p%d%dx2", i, k );
            fprintf( pFile, " p%d%dy1", i, k );
            fprintf( pFile, " p%d%dy2", i, k );
            fprintf( pFile, "\n" );
        }
    fprintf( pFile, ".inputs" );
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " v%02d v%02d", 2*i, 2*i+1 );
    fprintf( pFile, "\n" );

    fprintf( pFile, ".outputs" );
    fprintf( pFile, " fx00" );
    fprintf( pFile, "\n" );

    for ( i = 0; i < nVars; i++ ) // horizontal
        for ( k = 0; k < nVars; k++ ) // vertical
        {
            fprintf( pFile, ".subckt cell" );
            fprintf( pFile, " px1=p%d%dx1", i, k );
            fprintf( pFile, " px2=p%d%dx2", i, k );
            fprintf( pFile, " py1=p%d%dy1", i, k );
            fprintf( pFile, " py2=p%d%dy2", i, k );
            if ( k == nVars - 1 )
                fprintf( pFile, " x=v%02d", i );
            else
                fprintf( pFile, " x=fx%d%d", i, k+1 );
            if ( i == nVars - 1 )
                fprintf( pFile, " y=v%02d", nVars+k );
            else
                fprintf( pFile, " y=fy%d%d", i+1, k );
            // outputs
            fprintf( pFile, " fx=fx%d%d", i, k );
            fprintf( pFile, " fy=fy%d%d", i, k );
            fprintf( pFile, "\n" );
        }
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" );
    fprintf( pFile, "\n" );

    Abc_WriteCell( pFile );
    fclose( pFile );
}


/**Function*************************************************************

  Synopsis    []

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_WriteKLut( FILE * pFile, int nLutSize )
{
    int i, iVar, iNext, nPars = (1 << nLutSize);
    fprintf( pFile, "\n" ); 
    fprintf( pFile, ".model lut%d\n", nLutSize );
    fprintf( pFile, ".inputs" );
    for ( i = 0; i < nPars; i++ )
        fprintf( pFile, " p%02d", i );
    fprintf( pFile, "\n" );
    fprintf( pFile, ".inputs" );
    for ( i = 0; i < nLutSize; i++ )
        fprintf( pFile, " i%d", i );
    fprintf( pFile, "\n" );
    fprintf( pFile, ".outputs o\n" ); 
    fprintf( pFile, ".names n01 o\n" ); 
    fprintf( pFile, "1 1\n" ); 
    // write internal MUXes
    iVar = 0;
    iNext = 2;
    for ( i = 1; i < nPars; i++ )
    {
        if ( i == iNext )
        {
            iNext *= 2;
            iVar++; 
        }
        if ( iVar == nLutSize - 1 )
            fprintf( pFile, ".names i%d p%02d p%02d n%02d\n", iVar, 2*(i-nPars/2), 2*(i-nPars/2)+1, i ); 
        else
            fprintf( pFile, ".names i%d n%02d n%02d n%02d\n", iVar, 2*i, 2*i+1, i ); 
        fprintf( pFile, "01- 1\n" ); 
        fprintf( pFile, "1-1 1\n" ); 
    }
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 
}

/**Function*************************************************************

  Synopsis    [Generates structure of L K-LUTs implementing an N-var function.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_GenFpga( char * pFileName, int nLutSize, int nLuts, int nVars )
{
    FILE * pFile;
    int nVarsLut = (1 << nLutSize);                     // the number of LUT variables
    int nVarsLog = Extra_Base2Log( nVars + nLuts - 1 ); // the number of encoding vars
    int nVarsDeg = (1 << nVarsLog);                     // the number of LUT variables (total)
    int nParsLut = nLuts * (1 << nLutSize);             // the number of LUT params
    int nParsVar = nLuts * nLutSize * nVarsLog;         // the number of var params
    int i, j, k;

    assert( nVars > 0 );

    pFile = fopen( pFileName, "w" );
    fprintf( pFile, "# Structure with %d %d-LUTs for %d-var function generated by ABC on %s\n", nLuts, nLutSize, nVars, Extra_TimeStamp() );
    fprintf( pFile, ".model struct%dx%d_%d\n", nLuts, nLutSize, nVars );

    fprintf( pFile, ".inputs" );
    for ( i = 0; i < nParsLut; i++ )
        fprintf( pFile, " pl%02d", i );
    fprintf( pFile, "\n" );

    fprintf( pFile, ".inputs" );
    for ( i = 0; i < nParsVar; i++ )
        fprintf( pFile, " pv%02d", i );
    fprintf( pFile, "\n" );

    fprintf( pFile, ".inputs" );
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " v%02d", i );
    fprintf( pFile, "\n" );

    fprintf( pFile, ".outputs" );
    fprintf( pFile, " v%02d", nVars + nLuts - 1 );
    fprintf( pFile, "\n" );
    fprintf( pFile, ".names Gnd\n" ); 
    fprintf( pFile, " 0\n" ); 

    // generate LUTs
    for ( i = 0; i < nLuts; i++ )
    {
        fprintf( pFile, ".subckt lut%d", nLutSize );
        // generate config parameters
        for ( k = 0; k < nVarsLut; k++ )
            fprintf( pFile, " p%02d=pl%02d", k, i * nVarsLut + k );
        // generate the inputs
        for ( k = 0; k < nLutSize; k++ )
            fprintf( pFile, " i%d=s%02d", k, i * nLutSize + k );
        // generate the output
        fprintf( pFile, " o=v%02d", nVars + i );
        fprintf( pFile, "\n" );
    }

    // generate LUT inputs
    for ( i = 0; i < nLuts; i++ )
    {
        for ( j = 0; j < nLutSize; j++ )
        {
            fprintf( pFile, ".subckt lut%d", nVarsLog );
            // generate config parameters
            for ( k = 0; k < nVarsDeg; k++ )
            {
                if ( k < nVars + nLuts - 1 && k < nVars + i )
                    fprintf( pFile, " p%02d=v%02d", k, k );
                else
                    fprintf( pFile, " p%02d=Gnd", k );
            }
            // generate the inputs
            for ( k = 0; k < nVarsLog; k++ )
                fprintf( pFile, " i%d=pv%02d", k, (i * nLutSize + j) * nVarsLog + k );
            // generate the output
            fprintf( pFile, " o=s%02d", i * nLutSize + j );
            fprintf( pFile, "\n" );
        }
    }

    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 

    // generate LUTs
    Abc_WriteKLut( pFile, nLutSize );
    if ( nVarsLog != nLutSize )
        Abc_WriteKLut( pFile, nVarsLog );
    fclose( pFile );
}

/**Function*************************************************************

  Synopsis    [Generates structure of L K-LUTs implementing an N-var function.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_GenOneHot( char * pFileName, int nVars )
{
    FILE * pFile;
    int i, k, Counter, nDigitsIn, nDigitsOut;
    pFile = fopen( pFileName, "w" );
    fprintf( pFile, "# One-hotness condition for %d vars generated by ABC on %s\n", nVars, Extra_TimeStamp() );
    fprintf( pFile, ".model 1hot_%dvars\n", nVars );
    fprintf( pFile, ".inputs" );
    nDigitsIn = Extra_Base10Log( nVars );
    for ( i = 0; i < nVars; i++ )
        fprintf( pFile, " i%0*d", nDigitsIn, i );
    fprintf( pFile, "\n" );
    fprintf( pFile, ".outputs" );
    nDigitsOut = Extra_Base10Log( nVars * (nVars - 1) / 2 );
    for ( i = 0; i < nVars * (nVars - 1) / 2; i++ )
        fprintf( pFile, " o%0*d", nDigitsOut, i );
    fprintf( pFile, "\n" );
    Counter = 0;
    for ( i = 0; i < nVars; i++ )
        for ( k = i+1; k < nVars; k++ )
        {
            fprintf( pFile, ".names i%0*d i%0*d o%0*d\n", nDigitsIn, i, nDigitsIn, k, nDigitsOut, Counter ); 
            fprintf( pFile, "11 0\n" ); 
            Counter++;
        }
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 
    fclose( pFile );
}

/**Function*************************************************************

  Synopsis    [Generates structure of L K-LUTs implementing an N-var function.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_GenOneHotIntervals( char * pFileName, int nPis, int nRegs, Vec_Ptr_t * vOnehots )
{
    Vec_Int_t * vLine;
    FILE * pFile;
    int i, j, k, iReg1, iReg2, Counter, Counter2, nDigitsIn, nDigitsOut;
    pFile = fopen( pFileName, "w" );
    fprintf( pFile, "# One-hotness with %d vars and %d regs generated by ABC on %s\n", nPis, nRegs, Extra_TimeStamp() );
    fprintf( pFile, "# Used %d intervals of 1-hot registers: { ", Vec_PtrSize(vOnehots) );
    Counter = 0;
    Vec_PtrForEachEntry( vOnehots, vLine, k )
    {
        fprintf( pFile, "%d ", Vec_IntSize(vLine) );
        Counter += Vec_IntSize(vLine) * (Vec_IntSize(vLine) - 1) / 2;
    }
    fprintf( pFile, "}\n" );
    fprintf( pFile, ".model 1hot_%dvars_%dregs\n", nPis, nRegs );
    fprintf( pFile, ".inputs" );
    nDigitsIn = Extra_Base10Log( nPis+nRegs );
    for ( i = 0; i < nPis+nRegs; i++ )
        fprintf( pFile, " i%0*d", nDigitsIn, i );
    fprintf( pFile, "\n" );
    fprintf( pFile, ".outputs" );
    nDigitsOut = Extra_Base10Log( Counter );
    for ( i = 0; i < Counter; i++ )
        fprintf( pFile, " o%0*d", nDigitsOut, i );
    fprintf( pFile, "\n" );
    Counter2 = 0;
    Vec_PtrForEachEntry( vOnehots, vLine, k )
    {
        Vec_IntForEachEntry( vLine, iReg1, i )
        Vec_IntForEachEntryStart( vLine, iReg2, j, i+1 )
        {
            fprintf( pFile, ".names i%0*d i%0*d o%0*d\n", nDigitsIn, nPis+iReg1, nDigitsIn, nPis+iReg2, nDigitsOut, Counter2 ); 
            fprintf( pFile, "11 0\n" ); 
            Counter2++;
        }
    }
    assert( Counter == Counter2 );
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 
    fclose( pFile );
}

#include "aig.h"

/**Function*************************************************************

  Synopsis    [Generates structure of L K-LUTs implementing an N-var function.]

  Description []
               
  SideEffects []

  SeeAlso     []

***********************************************************************/
void Abc_GenRandom( char * pFileName, int nPis )
{
    FILE * pFile;
    unsigned * pTruth;
    int i, b, w, nWords = Aig_TruthWordNum( nPis );
    int nDigitsIn;
    Aig_ManRandom( 1 );
    pTruth = ABC_ALLOC( unsigned, nWords );
    for ( w = 0; w < nWords; w++ )
        pTruth[w] = Aig_ManRandom( 0 );
    pFile = fopen( pFileName, "w" );
    fprintf( pFile, "# Random function with %d inputs generated by ABC on %s\n", nPis, Extra_TimeStamp() );
    fprintf( pFile, ".model rand%d\n", nPis );
    fprintf( pFile, ".inputs" );
    nDigitsIn = Extra_Base10Log( nPis );
    for ( i = 0; i < nPis; i++ )
        fprintf( pFile, " i%0*d", nDigitsIn, i );
    fprintf( pFile, "\n" );
    fprintf( pFile, ".outputs f\n" );
    fprintf( pFile, ".names" );
    nDigitsIn = Extra_Base10Log( nPis );
    for ( i = 0; i < nPis; i++ )
        fprintf( pFile, " i%0*d", nDigitsIn, i );
    fprintf( pFile, " f\n" );
    for ( i = 0; i < (1<<nPis); i++ )
        if ( Aig_InfoHasBit(pTruth, i) )
        {
            for ( b = nPis-1; b >= 0; b-- )
                fprintf( pFile, "%d", (i>>b)&1 );
            fprintf( pFile, " 1\n" );
        }
    fprintf( pFile, ".end\n" ); 
    fprintf( pFile, "\n" ); 
    fclose( pFile );
    ABC_FREE( pTruth );
}


////////////////////////////////////////////////////////////////////////
///                       END OF FILE                                ///
////////////////////////////////////////////////////////////////////////


