//%attributes = {}
//Method:  00_v18_Component
//Descrpition:  This method describes what happened to components when converting to v18

//COMPONENT:                ACTION:
//Feedbacks.4dbase          was removed no code changes

//UserMode_Component        was removed no code changes

//FPWeb                     Obtained source code and recompiled to v18 but not tested.

//4D_Info_Report_v4.4dbase  was removed no code changes. (Code will run only if component is added)
//                          Checks if component is installed and then executes the component method

//Standards.4dbase          was removed and code was commented out if the following methods
//                          Basically used to set version and do updates

//  METHOD:                    ACTION:

//  _____SetVersion            uses GetDBVers and SetDBVers commented out

//  GetVersion                 uses GetDBVers commented out
//                             Left call in the following methods:
//                                 Compiler_Methods 
//                                 CustomerPortal_ProcessMessage 
//                                 INIT_GLOBALS 

//  STD_EventListener          uses STD_ProcessEvent commented out
//                             commented out call to it in UPDATE_INIT

//  UPDATE_DO                  uses STD_NeedsUpdate and STD_AutoUpdate commented out
//                             commented out call to it in UPDATE_INIT

//  Interprocess variable
//    <>kttVersRes             removed from [zz_control].MainEvent
//                             commented out in Compiler_Variables_inter
//                             commented out in INIT_GLOBALS

//    <>kxiVersRes             commented out in UPDATE_DO
//                             commented out in Compiler_Variables_inter
//                             commented out in INIT_GLOBALS
