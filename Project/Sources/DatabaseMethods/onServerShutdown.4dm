// User name (OS): Mel Bohince
// ----------------------------------------------------
// Method: On Server Shutdown

FLUSH CACHE:C297
SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 2)  //turn debug log on

<>fQuit4D:=True:C214

If (<>Sync_Activated)
	//LiveSync_Quit
	//GNS_Sync ("OnQuit")
End if 

If (<>FLEX_EXCHG_PID#0)
	DELAY PROCESS:C323(<>FLEX_EXCHG_PID; 0)
End if 

If (<>aa4D_pid#0)
	DELAY PROCESS:C323(<>aa4D_pid; 0)
End if 

utl_Logfile("server.log"; "###################")
app_CommonArrays("die!")
REL_getRecertificationRequired("die!")
CostCtrCurInit("die!")
FG_LaunchItemInit("die!")
REL_ShippingCloseouts("die!")
FG_Inventory_Array("die!")
THC_request_update("die!")
RM_PostReceipt_SP("die!")

DELAY PROCESS:C323(Current process:C322; 120)
FLUSH CACHE:C297

app_CleanKill("CommonArrays")
app_CleanKill("RecertificationRequiredArray")
app_CleanKill("CostCenterStandards")
app_CleanKill("FG_LaunchItems")
app_CleanKill("REL_ShippingCloseouts")
app_CleanKill("FG_Inventory_Array")
app_CleanKill("THC_Updater")
app_CleanKill("RM_PostReceipt_SP")
utl_Logfile("server.log"; "Shutdown with "+String:C10(Count users:C342)+" users and "+String:C10(Count user processes:C343)+" processes")

//hunting for why the server hangs on shutdown
//C_LONGINT($pid;$vlState;$vlElapsedTime;$origin)
//C_LONGINT($uniqID)
//C_BOOLEAN($vbVisible)
//C_TEXT($vsProcessName)
//For ($pid;1;Count tasks)
//PROCESS PROPERTIES($pid;$vsProcessName;$vlState;$vlElapsedTime;$vbVisible;$uniqID;$origin)
//  //If ($origin>-1)
//utl_Logfile ("server.log";"pidName:"+$vsProcessName+" state:"+String($vlState)+" time:"+String($vlElapsedTime)+" visible:"+String(Num($vbVisible))+" uid:"+String($uniqID)+" origin:"+String($origin))
//  //End if 
//End for 
utl_Logfile("server.log"; "###################")