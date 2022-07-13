//On Server Startup()  042699  MLB
//make certain of somethings
// Modified by: Mel Bohince (6/10/21) chg how c/c's are setup
// Modified by: Mel Bohince (6/30/21) add stored procedure util_BackupToDropBox_EOS
// Modified by: Mel Bohince (7/13/21) remove util_BackupToDropBox_EOS and add util_BackupLogFile, see also 'On Backup Shutdown'
// Modified by: Garri Ogata (8/4/21) changed name of production and Test names (131 and 137)
// Modified by: Garri Ogata (8/23/21) commented out check for backup of production. Since it is now down in the backup process (176)
// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
// Modified by: Garri Ogata (2/2/22) disable Server monitor

Compiler_0000_ConstantsToDo
C_BOOLEAN:C305(<>modification4D_14_01_19; <>modification4D_06_02_19; <>modification4D_13_02_19; <>modification4D_28_02_19; <>modification4D_25_03_19)  //turn these on/off from the DBA button on main palette [zz_control];"AdminEvent"
<>modification4D_14_01_19:=True:C214  // set in uInit_AdminRecordSettings called by Startup and On server startup
<>modification4D_06_02_19:=True:C214
<>modification4D_13_02_19:=True:C214
<>modification4D_28_02_19:=True:C214
<>modification4D_25_03_19:=True:C214
<>modification4D_10_05_19:=True:C214
// Modified by: Mel Bohince (3/25/19) to disable selectively and leave marker
<>disable_4DPS_mod:=True:C214  //usage: If (Not(<>modification4D_13_02_19)) | (<>disable_4DPS_mod)
SET DATABASE PARAMETER:C642(4D Server timeout:K37:13; 240)  //client is not responding, application connection only
SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 0)  //turn debug log off (turned on during shutdown)

error:=0
ON ERR CALL:C155("eServerErrorCall")

CompileInterP

// Modified by: Mel Bohince (6/3/19)
C_OBJECT:C1216(<>4d_Time)  // <>modification4D_10_05_19
<>4d_Time:=New object:C1471("Difference"; 0; "compare"; False:C215)

CostCtrInit  // Modified by: Mel Bohince (6/10/21) 
// now called by CostCtrInit       uInit_CostCenterGroups   // see also uInitInterPrsVar that client startup uses
uInit_AdminRecordSettings

// Modified by: Mel Bohince (3/6/18) 
ARRAY TEXT:C222(<>aSetC128; 0)  //barcode stuff for sscc numbers using 128
<>FNC1:=Char:C90(230)

<>fQuit4D:=False:C215
//<>AcctVantageActive:=True
<>GNS_Doing_FillInSyncIDs:=False:C215  // my mod to skip BOL trigger during a FillinSyncIDs 
<>FLEX_EXCHG_PID:=0  //run this on client
<>aa4D_pid:=0
<>MAGIC_DATE:=!2025-12-25!
<>lMinMemPart:=0  //64*1024  // Modified by: Mel Bohince (3/21/17) // Modified by: Mel Bohince (6/30/21) set to 0 for recommended default


//C_BOOLEAN(<>MySQL_Registered)
//If (Not(<>MySQL_Registered))
//$error:=MySQL Register ("AJAUOAJ15D58M5DG")
//If ($error=0)
//utl_Logfile ("server.log";"MyConnect Registration Failed.")
//Else 
//<>MySQL_Registered:=True
//End if [zz_control];"AdminEvent"
//$wasSet:=MySQL Set Error Handler ("DB_Error")
//End if 

util_SetSystemDelimitor
<>PATH_TO_LOG_FILE:=util_PathToLogFile("aMs")
utl_Logfile("server.log"; "START UP version "+000_version_number)

app_server_volumes  // Modified by: Mel Bohince (10/5/17) 

If (<>modification4D_14_01_19)
	utl_Logfile("server.log"; "<>modification4D_14_01_19 is true ")
End if 

If (<>modification4D_06_02_19)
	utl_Logfile("server.log"; "<>modification4D_06_02_19 is true ")
End if 

If (<>TEST_VERSION)
	utl_Logfile("server.log"; "Running in TEST_VERSION mode ")
End if 

<>CurrentUser:="aMs_Server"
<>zResp:="aMs!"
<>StatusBar:=0  //New process("zwStatusBar";(24*1024);"$StatusBar")

READ WRITE:C146([z___Kill_User_Processes:50])  //see 00_Logoff_Users
ALL RECORDS:C47([z___Kill_User_Processes:50])
If (Records in selection:C76([z___Kill_User_Processes:50])>0)
	[z___Kill_User_Processes:50]_STOP_NOW_:2:=util_StartMaintenanceMode
	SAVE RECORD:C53([z___Kill_User_Processes:50])
	REDUCE SELECTION:C351([z___Kill_User_Processes:50]; 0)
End if 

util_SetSyncParameters


//start stored procedures
//PS_Exchange_Data_with_Flex 
$server_pid:=Execute on server:C373("app_CommonArrays"; <>lMinMemPart; "CommonArrays"; "init")
$server_pid:=Execute on server:C373("REL_getRecertificationRequired"; <>lMinMemPart; "RecertificationRequiredArray"; "init")
// Modified by: Mel Bohince (6/24/21) disabled next line
//$server_pid:=Execute on server("CostCtrCurInit";<>lMinMemPart;"CostCenterStandards";"init";"00/00/00")
$server_pid:=Execute on server:C373("FG_LaunchItemInit"; <>lMinMemPart; "FG_LaunchItems"; "init")
$server_pid:=Execute on server:C373("REL_ShippingCloseouts"; <>lMinMemPart; "REL_ShippingCloseouts"; "init")
$server_pid:=Execute on server:C373("FG_Inventory_Array"; <>lMinMemPart; "FG_Inventory_Array"; "init")
$server_pid:=Execute on server:C373("THC_request_update"; <>lMinMemPart; "THC_Updater"; "init")
//$server_pid:=Execute on server("RM_PostReceipt_SP";<>lMinMemPart;"RM_PostReceipt_SP";"init")
//$server_pid:=Execute on server("util_BackupToDropBox_EOS";<>lMinMemPart;"util_BackupToDropBox_EOS")  // Modified by: Mel Bohince (6/30/21) 
$server_pid:=Execute on server:C373("util_BackupLogFile"; <>lMinMemPart; "util_BackupLogFile")  // Modified by: Mel Bohince (7/13/21) 


C_LONGINT:C283($report_frequency; $content_mode)
$report_frequency:=60  //5 is recommended
$content_mode:=0

If (Core_Component_ExistsB("4D_Info_Report@"))
	//◊aa4D_pid:=Execute on server("aa4D_Report_SP";64*1024;"Information Component")
	utl_Logfile("server.log"; "4D_Info_Report found, executing: aa4D_NP_Schedule_Report_Server: "+String:C10($report_frequency)+" "+String:C10($content_mode))
	//EXECUTE METHOD("aa4D_NP_Schedule_Report_Server";*;$report_frequency;$content_mode)  // or another shared method.
	//<>aa4D_pid:=Execute on server("aa4D_NP_Schedule_Reports_Server";128*1024;"Info Component";$report_frequency;$content_mode)
	EXECUTE METHOD:C1007("aa4D_NP_Schedule_Reports_Server"; *; $report_frequency; 0)  // Added by: Mel Bohince (6/24/19) 
Else 
	utl_Logfile("server.log"; "4D_Info_Report was not found.")
End if 

READ WRITE:C146([Users:5])
QUERY:C277([Users:5]; [Users:5]UserName:11="Administrator")
[Users:5]NotifyPressSchdChg:22:=New record:K29:1
SAVE RECORD:C53([Users:5])
REDUCE SELECTION:C351([Users:5]; 0)

UrWk_ClearTable  //GNO added to recreate the [User_Workstation] data after every server startup

C_BOOLEAN:C305($bDoNotMonitorServer)  // Modified by: Garri Ogata (2/2/22)
$bDoNotMonitorServer:=True:C214

Case of   //Which server
	: ($bDoNotMonitorServer)  // Modified by: Garri Ogata (2/2/22)
		
	: (Current machine:C483="WMS Mac Mini 2020")  //WMS
		
	: (Current machine:C483="AMS-NY-2021")  //Production
		
		Batch_CheckBatchRunner  //GNO added to make sure BatchRunner is running and set to correct date and time
		
		Core_Database_BackupAlert  //GNO added to make sure database backup is set
		
	: (Current machine:C483="VAAMS’s Mac mini")  //Test 
		
		C_OBJECT:C1216($oServer)
		C_OBJECT:C1216($oBackup)
		
		$oServer:=New object:C1471()
		
		$oServer.tDistributionList:=ArkyktAmsHelpEmail
		
		$oServer.bStartProcess:=True:C214
		$oServer.tName:="aMs"
		$oServer.tHost:="192.168.1.62"
		$oServer.tPort:="19812"
		$oServer.tUser:="Designer"
		$oServer.tPassword:="1147"
		
		Core_ServerUp($oServer)
		
		WMS_API_LoginLookup  //Set IP variables for WMS_API_4D_GetLogin methods
		
		$oServer.bStartProcess:=True:C214
		$oServer.tName:="wMs"
		$oServer.tHost:=WMS_API_4D_GetLoginHost  //192.168.3.98
		$oServer.tPort:=WMS_API_4D_GetLoginPort  //3306
		$oServer.tUser:=WMS_API_4D_GetLoginUser
		$oServer.tPassword:=WMS_API_4D_GetLoginPassword
		
		Core_ServerUp($oServer)
		
		$oBackup:=New object:C1471()
		
		$oBackup.bStartProcess:=True:C214
		$oBackup.tDistributionList:=ArkyktAmsHelpEmail
		$oBackup.tPathname:="Macintosh HD:Users:ladmin:Dropbox:ams_bkup:"
		$oBackup.tBackup:="aMs-data"
		$oBackup.tLog:="log-file"
		$oBackup.rSize:=1000000000  //1.0 GB
		
		//Core_Backup_Verify ($oBackup)  //Stored proc on server to test backups are being done every day and logfile every few minutes.
		
		$oBackup.bStartProcess:=True:C214
		$oBackup.tDistributionList:=ArkyktAmsHelpEmail
		$oBackup.tPathname:="Macintosh HD:Users:ladmin:Dropbox:wms_backup:"
		$oBackup.tBackup:="WMS Daily Backup.zip"
		$oBackup.tLog:="Log File.zip"
		$oBackup.rSize:=40000000  //40 MB
		
		Core_Backup_Verify($oBackup)  //Stored proc on server to test backups are being done every day and logfile every few minutes.
		
End case   //Done which server

SF_ShopHolidays  //v1.0.0-PJK (12/23/15) initialize the Holidays list
$intervalsPerHr:=SF_CalendarIntervalsSettings  //set to the default 6/hr or 10minute chunks

