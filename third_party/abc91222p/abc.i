%module pyabc
%{
    
#include <main.h>
    
int n_ands()
{
    Abc_Frame_t* pAbc = Abc_FrameGetGlobalFrame();
    Abc_Ntk_t * pNtk = Abc_FrameReadNtk(pAbc);

    if ( pNtk && Abc_NtkIsStrash(pNtk) )
    {        
        return Abc_NtkNodeNum(pNtk);
    }

    return -1;
}

int n_pis()
{
    Abc_Frame_t* pAbc = Abc_FrameGetGlobalFrame();
    Abc_Ntk_t * pNtk = Abc_FrameReadNtk(pAbc);

    if ( pNtk && Abc_NtkIsStrash(pNtk) )
    {        
        return Abc_NtkPiNum(pNtk);
    }

    return -1;
}


int n_pos()
{
    Abc_Frame_t* pAbc = Abc_FrameGetGlobalFrame();
    Abc_Ntk_t * pNtk = Abc_FrameReadNtk(pAbc);

    if ( pNtk && Abc_NtkIsStrash(pNtk) )
    {        
        return Abc_NtkPoNum(pNtk);
    }

    return -1;
}

int n_latches()
{
    Abc_Frame_t* pAbc = Abc_FrameGetGlobalFrame();
    Abc_Ntk_t * pNtk = Abc_FrameReadNtk(pAbc);

    if ( pNtk && Abc_NtkIsStrash(pNtk) )
    {        
        return Abc_NtkLatchNum(pNtk);
    }

    return -1;
}

int run_command(char* cmd)
{
    Abc_Frame_t* pAbc = Abc_FrameGetGlobalFrame();
    int fStatus = Cmd_CommandExecute(pAbc, cmd);
    
    return fStatus;
}

bool has_comb_model()
{
    Abc_Frame_t* pAbc = Abc_FrameGetGlobalFrame();
    Abc_Ntk_t * pNtk = Abc_FrameReadNtk(pAbc);

    return pNtk && pNtk->pModel;
}

bool has_seq_model()
{
    Abc_Frame_t* pAbc = Abc_FrameGetGlobalFrame();
    Abc_Ntk_t * pNtk = Abc_FrameReadNtk(pAbc);

    return pNtk && pNtk->pSeqModel;
}

%}

%init 
%{
    Abc_Start();
%}

int n_ands();
int n_pis();
int n_pos();
int n_latches();

int run_command(char* cmd);

bool has_comb_model();
bool has_seq_model();
