//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/17/07, 16:15:39
// ----------------------------------------------------
// Method: BOL_inputOnUnLoad()  --> 
// ----------------------------------------------------
//utl_Logfile ("debug.log";"     Window Pop")
wWindowTitle("pop")

//utl_Logfile ("debug.log";"     Close floating window")
<>FloatingAlert:=""
POST OUTSIDE CALL:C329(<>FloatingAlert_PID)

//utl_Logfile ("debug.log";"     Trigger Msg clearing")
$msg:=TriggerMessage("tear-down")  //unload trigger messaging record

//utl_Logfile ("debug.log";"  Unload finished")