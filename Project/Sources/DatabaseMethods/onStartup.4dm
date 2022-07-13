// _______
// Method: On Startup   ( ) ->
// ----------------------------------------------------

C_BOOLEAN:C305(<>v18_PROBLEM)  // Modified by: Mel Bohince (6/9/21) 
<>v18_PROBLEM:=True:C214

CompileBoolean
CompileDate
CompileInteger
CompileInterP
CompileLongInt
CompilePointer
CompileReal
CompileString
CompileText
CompileTime
Compiler_Cal  //Compiler_CalPrm 
Cal_initialize

C_BOOLEAN:C305(<>modification4D_14_01_19; <>modification4D_06_02_19; <>modification4D_13_02_19; <>modification4D_28_02_19; <>modification4D_25_03_19; <>modification4D_10_05_19)
<>modification4D_14_01_19:=True:C214  // set in uInit_AdminRecordSettings called by Startup and On server startup
<>modification4D_06_02_19:=True:C214
<>modification4D_13_02_19:=True:C214
<>modification4D_28_02_19:=True:C214
<>modification4D_25_03_19:=True:C214
<>modification4D_10_05_19:=True:C214

// Modified by: Mel Bohince (3/25/19) to disable selectively and leave marker
<>disable_4DPS_mod:=True:C214  //usage: If (Not(<>modification4D_13_02_19)) | (<>disable_4DPS_mod)

//Run 4DPop
//This code is available even if the component is not present like in the final application.
If (Not:C34(Is compiled mode:C492))
	ARRAY TEXT:C222($tTxt_Components; 0)
	COMPONENT LIST:C1001($tTxt_Components)
	If (Find in array:C230($tTxt_Components; "4DPop")>0)
		EXECUTE METHOD:C1007("4DPop_Palette")
	End if 
End if 

<>MainWindowRef:=Frontmost window:C447  //user mode output form
GET WINDOW RECT:C443(<>MainWindowLeft; <>MainWindowTop; <>MainWindowRight; <>MainWindowBottom; <>MainWindowRef)
If (Current user:C182="Designer")
	$resize:=False:C215
	If ((<>MainWindowRight-<>MainWindowLeft)<20)
		$resize:=True:C214
	End if 
	If ((<>MainWindowBottom-<>MainWindowTop)<20)
		$resize:=True:C214
	End if 
	If ($resize)
		util_MainWindowVisible("Show")
	End if 
End if 
<>IsMainWindowHidden:=(<>MainWindowTop<=0)

// Modified by: Mel Bohince (3/21/17) disable these v11 hacks, next 4 commands
//set these to save resources and prevent router disconnections
//SET DATABASE PARAMETER(Idle connections timeout;40)  //40 and 180 works; new processes, applies to db4d and sql connections only (default unlimited in v11, 20 in v12)
//SET DATABASE PARAMETER(Idle connections timeout;-40)  //for setting current processes, 20 may be causing some funkyness
//address abnormal situations
//SET DATABASE PARAMETER(4D Server timeout;240)  //client is not responding, application connection only
//SET DATABASE PARAMETER(4D Remote mode timeout;240)  //server is not responsive


// Modified by: Mel Bohince (11/7/18) disable ping for everyone
//If (False)  //(Current user#"Designer")  // Modified by: Mel Bohince (10/10/18) see if this does anything if removed
//util_ping_server 
//Else 
//<>PING_PID:=0
//End if 

If (UTIL_CompareAppVersions)
	STARTUP
	
Else 
	ALERT:C41("You do not have the correct version of 4D. Contact the IT Dept.")
	QUIT 4D:C291
End if 