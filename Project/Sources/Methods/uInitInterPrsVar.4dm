//%attributes = {"publishedWeb":true}
//Procedure: uInitInterPrsVar()  
//(p) 00CompileBuild - zero zero compile..◊HasLabelPrinter
//this routine is to seperate the interprocess compiler definitions
//from the code required to poulate some/all of these vars.
//much of the code here was copied from 00CompileInterP
//• 9/22/97 cs  created
//• 6/16/98 cs new flag for client server testing
//• 7/27/98 MLB get Fg at actual
//•072998  MLB upr1966
//•111398  MLB  UPR htk want NRV
//•012899  MLB  Set scrolling on for small screens
//•051099  MLB  UPR 236
// • mel (4/14/05, 10:07:13) only show active salesmen in popup
// mel 11/6/06 added ◊SERVER_DESIGNATION
// Modified by: Mel Bohince (6/3/21)//see PS_JustInTime
// Modified by: Mel Bohince (6/10/21) setup c/c's when c/c's are needed
// Modified by: Mel Bohince (8/30/21) change size of <>lBigMemPart for stack allocations

<>GNS_Doing_FillInSyncIDs:=False:C215  // my mod to skip BOL trigger during a FillinSyncIDs
<>FAX_ENABLED:=False:C215
<>FAX_USER:=False:C215
<>PIN:=""  //see util_UserGetPIN, util_UserValidation, POGetAutorize
<>lastPINentry:=0  //keep track of when the user's PIN was entered or used
<>pdfFileName:=""
<>sCR:=Char:C90(13)
<>sTAB:=Char:C90(9)
<>sDQ:=Char:C90(34)
<>CR:=Char:C90(13)  // Added by: Mark Zinke (4/17/13)
<>TB:=Char:C90(9)  // Added by: Mark Zinke (4/17/13)
<>sBULLET:=Char:C90(165)
<>lHCENTER:=(Screen height:C188/2)+20  //added parens 1/6/94
<>lWCENTER:=Screen width:C187/2
<>lLetterPix:=728  //pixel height of letter orientation page
<>lSidewPix:=550  //pixel height of sideways orientation page
C_OBJECT:C1216($xy)
$xy:=OpenFormWindowCoordinates("set")
If (False:C215)  //see above OpenFormWindowCoordinates
	<>winX:=20  // used by NewWindow for stacking
	<>winY:=60
End if 
<>MAGIC_DATE:=!2025-12-25!  // this is used so that sorted dates are messed up by 00/00/00 (null dates)

C_LONGINT:C283($i; $j)
//----- individual var assignments
<>SHORTDATE:=1  //#/##/##
<>LONGDATE:=3  //   Monday June #, ####
<>MIDDATE:=4  //   ##/##/####
//<>HHMMSS:=1  //     ##:##:##
<>HHMM:=2  //         ##:##
<>HMMAM:=5  //      9:00 PM
<>NULL:=Char:C90(0)
<>DELIMITOR:=":"

//C_LONGINT($vlPlatform;$vlSystem;$vlMachine)
//_O_PLATFORM_PROPERTIES($vlPlatform;$vlSystem;$vlMachine)
Case of 
	: (Is macOS:C1572)
		<>DELIMITOR:=":"
		<>PLATFORM:="mac"
	: (Is Windows:C1573)
		<>DELIMITOR:="\\"
		<>PLATFORM:="windows"
	Else 
		<>DELIMITOR:=":"
		<>PLATFORM:="mac"
End case 

<>A4CLIENTS:=6  //---------- used by api procedures ---------
<>A4INVOICES:=20
<>A4CLIENTID:=28
<>A4CLIENTOLD:=74
<>A4OPEN_AR:=13
<>A4INVO_DATE:=46
<>A4INVO_AMT:=25
<>A4INVO_CLID:=43
ARRAY LONGINT:C221(<>a4Invo; 2)  //set up for multi search
ARRAY LONGINT:C221(<>a4Invofld; 2)
ARRAY TEXT:C222(<>a4Search; 2)
ARRAY TEXT:C222(<>a4Logic; 2)
ARRAY TEXT:C222(<>a4Values; 2)
<>a4Invo{1}:=<>A4INVOICES
<>a4Invo{2}:=<>A4INVOICES
<>a4Invofld{1}:=<>A4INVO_CLID
<>a4Invofld{2}:=<>A4INVO_DATE
<>a4Search{1}:="="
<>a4Search{2}:="="
<>a4Logic{1}:=""
<>a4Logic{2}:="&"
//◊a4Values{1}:="variable"
<>a4Values{2}:="00/00/00"
//•051099  MLB  UPR 236
<>DynamicsPath:=""
<>DynamicsCustFilename:=""
<>DynamicsInvoiceHdrFilename:=""
<>DynamicsInvoiceDtlFilename:=""

ARRAY LONGINT:C221(<>alClausChk; 0)
ARRAY TEXT:C222(<>asClausID; 0)
ARRAY TEXT:C222(<>asClausTitl; 0)
ARRAY TEXT:C222(<>aViewName; 0)  //stores name of process
ARRAY LONGINT:C221(<>aViewNum; 0)  //stores last incremental number of process
//setup arrays to handle timing of report generation with (P) uNowOrDelay
ARRAY LONGINT:C221(<>lReportPrcs; 0)  //holds number of the process generating the report
ARRAY LONGINT:C221(<>lReportTime; 0)  //holds time the report is to begin
ARRAY DATE:C224(<>dReportDate; 0)  //holds date the report is to begin
//setup arrays for process list
ARRAY TEXT:C222(<>aPrcsName; 0)  //name of process
ARRAY TEXT:C222(<>aPrcsStatus; 0)  //status of process
ARRAY LONGINT:C221(<>aPrcsNum; 0)  //number of process
ARRAY TEXT:C222(<>aListNames; 0)  //choice lists names

//PO Control
ARRAY TEXT:C222(<>asBuyers; 0)
ARRAY TEXT:C222(<>asBuyerName; 0)
ARRAY TEXT:C222(<>axFiles; 0)  //File Names
ARRAY INTEGER:C220(<>axFileNums; 0)  //File Numbers`•051496  MLB 
ARRAY TEXT:C222(<>aCommand; 0)  //Array previously for executed code for execute dialog
ARRAY TEXT:C222(<>aPIRptPop; 0)  //•3/3/97 cs upr 1858 declare report array



//---Requisition & PO

ARRAY TEXT:C222(<>aDeptRptPop; 0)  //used for deparmtent report popup

// Modified by: Mel Bohince (7/9/21) use the 0 for new process
<>lMinMemPart:=0  // 64*1024  //140880  `min memory to allocate to a new process (>40k of process variables!), 
<>lMidMemPart:=0  //128*1024
<>lBigMemPart:=512*1024  // Modified by: Mel Bohince (8/30/21) revert back to specifing stack

//old value 2/10/98 122880
//was 88`•051895 for type 11 problems
//<>ContProcess:=0
//<>HelpProcess:=0
//<>SaleProcess:=0
<>PIProcess:=0
//<>xActionProc:=0
<>Activitiy:=0  //used on EstEvent buttons to indicate type of search
<>BOL:=0

<>PassThrough:=False:C215  //avoid fSelect by in viewstter calls
<>fContinue:=True:C214  //globle event killer
<>SCROLLING:=False:C215
If (Screen width:C187<800) | (Screen height:C188<600)
	<>SCROLLING:=True:C214
End if 

<>plsHold:=False:C215
<>fHelpLoaded:=False:C215
<>apiFlag:=False:C215
<>fSendTrans:=False:C215
<>fPhyInv:=False:C215
<>RecordSaved:=True:C214  //used by eSaveRecError
<>fQuit4D:=False:C215  //BAK 10/17/94 - to set quit for 4D used in API.
<>whichRpt:=""
<>iMode:=0
<>lastNew:=-3
<>iLayout:=0
<>fLoadClaus:=True:C214  //clause table not loaded yet
<>fMultiviews:=True:C214  //allow multiple open processes of same option
<>GLCostDef:="99999999999"  //default GL Cost Code
<>GLIncomDef:="99999999999"  //default GL Income COde
<>GLInvenDef:="99999999999"  //default GL Inventory Code
<>fLabelErr:=False:C215  //used for label printing Ascii map problems
<>sCartonTtle:=""
<>sEstDiffID:=""
<>TheEstID:=""
vCartonPID:=0
<>WhatToPrint:=""
<>fMultiple:=False:C215  //used to set the √box in execute dialog◊fPIActive:=False  `used to control 'Reaso
<>ProcIndex:=1
<>sReqName:="Requisitions"  //` • 6/5/97 cs used to consistantly reference when accessing requisitions user ac
<>PrcsListPr:=-1  //default  initialize
<>fQuitNotify:=False:C215  //flag tell notifer to stop running

//-----Other assignments - requires search etc
uInit_AdminRecordSettings


If (Not:C34(<>modification4D_10_05_19))
	
	
	
Else 
	
	
	//$Difference:=(Current time+0)-(4d_Current_time +0)
	$Difference:=(Current time:C178+0)-(Current time:C178(*)+0)  // Modified by: Mel Bohince (5/22/19) 
	If ($Difference>0)
		
		$Compare:=True:C214
		
	Else 
		
		$Compare:=False:C215
		
	End if 
	$Difference:=Abs:C99($Difference)
	
	
	$Tolerence:=181  //180 seconde
	Case of 
			//: (Current date#4D_Current_date )
		: (Current date:C33#Current date:C33(*))  // Modified by: Mel Bohince (5/22/19) 
			ALERT:C41("your date is incorrect on your post.Please contact your administrator")
			If (Current user:C182="Designer")
				TRACE:C157
			Else 
				QUIT 4D:C291
			End if 
		: ($Difference>$Tolerence)
			ALERT:C41("your time is shifted to your position, please contact your administrator")
			If (Current user:C182="Designer")
				TRACE:C157
			Else 
				QUIT 4D:C291
			End if 
		: ($Difference<$Tolerence)
			
			C_OBJECT:C1216(<>4d_Time)
			<>4d_Time:=New object:C1471("Difference"; $Difference; "compare"; $Compare)
			
			
	End case 
	
End if   // END 4D Professional Services : April 2019 


<>ProcSize:=<>lMinMemPart  // Added by: Mark Zinke (12/28/12)

C_TEXT:C284($tablePrefix)
For ($i; 1; Get last table number:C254)
	If (Is table number valid:C999($i))
		$tablePrefix:=Substring:C12(Table name:C256($i); 1; 1)
		If ($tablePrefix<"x")
			filePtr:=Table:C252($i)
			CREATE EMPTY SET:C140(filePtr->; "◊LastSelection"+String:C10($i))
		End if 
	End if 
End for 

app_CommonArrays("client-prep")
app_CommonArrays("available?")
app_CommonArrays("exchange")
//MESSAGE(Char(13)+"Common arrays ready")
//get ◊aOffSet
//◊EstCommKey
//◊aGenDepts
//◊EL_Companies


// • mel (11/17/03, 14:02:38) hardcode id of combined customer
//•1/9/97 - cs -  multiple customer on one form
<>CombinedCustomerName:="Combined Customer"
<>sCombindID:="01080"  //[CUSTOMER]ID  `save id
<>JobMergePjtID:="03723"

//Build Month array
uInitMonths

//project control center stuff
ARRAY TEXT:C222(<>aCustid; 0)
<>pjt_picker:=0
Pjt_setReferId("")  //◊pjtId:="", use Pjt_getReferId() to access
//%%%%%%%%%%%%%%
//%% update PS_CallProcesses also!
//%%%%%%%%%%%%%%%%
// Modified by: Mel Bohince (7/9/21) remove <>pids
//◊pid411:=0
//<>pid412:=0  //press schedule process numbers
//<>pid414:=0
//<>pid415:=0
//<>pid416:=0
//<>pid417:=0
//<>pid418:=0  // Added by: Mark Zinke (10/23/13) 
//<>pid419:=0
//<>pid420:=0
//<>pid425:=0
//  //◊pid426:=0
//<>pid428:=0
//<>pid452:=0
//<>pid466:=0  // Added by: Mark Zinke (7/31/13) 
//<>pid467:=0
//<>pid468:=0
//<>pid469:=0  //• mlb - 3/7/03  11:56
//  //◊pid453:=0
//<>pid454:=0
//  //◊pid461:=0
//  //◊pid462:=0
//<>pid471:=0
//<>pid472:=0
//<>pid474:=0
//<>pid470:=0
//<>pidALLPrinting:=0
//<>pidALLDC:=0
<>pidTimer:=0

//<>EDI_ASN_pid:=0  //see EDI_DESADV_aka_ASN
//<>EDI_ASN_keep_running:=False

//◊winRef411:=0  `press schedule process window numbers
//<>winRef412:=0  //press schedule process window numbers
//<>winRef414:=0
//<>winRef415:=0
//<>winRef416:=0
//<>winRef417:=0
//<>winRef418:=0  // Added by: Mark Zinke (10/23/13) 
//<>winRef419:=0
//<>winRef420:=0
//  //◊winRef425:=0
//  //◊winRef426:=0
//<>winRef428:=0
//<>winRef452:=0
//<>winRef466:=0  // Added by: Mark Zinke (7/31/13) 
//<>winRef468:=0
//<>winRef469:=0  //• mlb - 3/7/03  11:56
//  //◊winRef453:=0
//<>winRef454:=0
//  //◊winRef462:=0
//  //◊winRef461:=0
//<>winRef471:=0
//<>winRef472:=0
//<>winRef474:=0
//<>winRef470:=0
//<>winRefALLPrinting:=0
//<>winRefALLDC:=0

<>HasLabelPrinter:=0

<>pid_bagTrack:=0
<>pid_eBag:=0

<>pid_RMX:=0
//
ARRAY TEXT:C222(<>aJML; 0)
ARRAY DATE:C224(<>aMAD; 0)
ARRAY DATE:C224(<>a1ST; 0)
ARRAY TEXT:C222(<>aFiniAt; 0)
ARRAY TEXT:C222(<>aInfo; 0)
ARRAY DATE:C224(<>aBagGot; 0)
ARRAY DATE:C224(<>aBagOK; 0)
ARRAY DATE:C224(<>aStockGot; 0)
ARRAY DATE:C224(<>aStockShted; 0)
ARRAY DATE:C224(<>aPlatesDone; 0)
ARRAY DATE:C224(<>aInkDone; 0)
ARRAY DATE:C224(<>aDiesDone; 0)
ARRAY TEXT:C222(<>aCustName; 0)  //040102
ARRAY LONGINT:C221(<>aColor; 0)  //040102

<>cacheJMLts:=0
<>pid_ShiftCard:=0
<>jobform:=""
<>pid_ToDo:=0

<>rmXferInquire:=True:C214
<>fgXferInquire:=True:C214

ARRAY TEXT:C222(<>FGwarehouseProgram; 0)
ARRAY TEXT:C222(<>FGLaunchItem; 0)

<>FloatingAlert_PID:=0
<>FloatingAlert:=""

C_BOOLEAN:C305(<>PrintToPDF)
<>PrintToPDF:=False:C215


If (True:C214)  // Modified by: Mel Bohince (6/3/21)//see PS_JustInTime
	<>psOUTSIDE_SERVICE_MENU:=""
Else 
	$err:=PS_pid_mgr("init")
	$err:=PS_menu_mgr("init")
	uInit_CostCenterGroups  // Modified by: Mel Bohince (6/10/21) setup c/c's when c/c's are needed
End if 

ARRAY TEXT:C222(<>aSetC128; 0)  //barcode stuff for sscc numbers using 128, see also Server Startup
<>FNC1:=Char:C90(230)

ARRAY TEXT:C222(<>rft_portMainMenu; 0)
ARRAY TEXT:C222(<>rft_appBuildPalletStart; 0)

<>RFTBASE_STATION_PID:=0
<>COM_SerialPort_PID:=0
<>COM_SerialPortActive:=False:C215
ARRAY TEXT:C222(<>rft_terminalIDs; 0)
ARRAY INTEGER:C220(<>rft_TerminalLoggedIn; 0)
ARRAY TEXT:C222(<>aReasonRequiredForMove; 0)  // managed by wms_locationsRequiringReason

C_LONGINT:C283(<>pid_WIPmgmt; <>pid_Workorder; <>pid_RFM)
<>pid_WIPmgmt:=0
<>pid_Workorder:=0
<>pid_RFM:=0

<>JOBIT:=""

C_PICTURE:C286(<>nilPicture)  //see HR_getSignaturePicture
ARRAY TEXT:C222(<>UserInitials; 0)  //see HR_getSignaturePicture
ARRAY PICTURE:C279(<>Signatures; 0)  //see HR_getSignaturePicture

//keep position of main window
//these are defaults until user changes its position
<>MainEventWindow:=0
<>mewLeft:=20
<>mewTop:=40
<>mewRight:=421
<>mewBottom:=327

ARRAY TEXT:C222(<>aCPN_ReCert; 0)  //REL_getRecertificationRequired
ARRAY DATE:C224(<>aCPN_ReCertReleased; 0)
C_LONGINT:C283(<>SERVER_PID_RECERT; <>JFActivity)
<>SERVER_PID_RECERT:=0
<>JFActivity:=0

<>EngDrawing_Volume:=""
<>AdobeAcrobat:=""
<>LayoutPDF_Volume:=""
<>WMS_GET_PID:=0
<>FLEX_EXCHG_PID:=0

// ///////////////////// EDI /////////////
C_TEXT:C284(<>tICN; <>tGCN; <>tTXN)  //these variables will be set by mapping process
C_LONGINT:C283(<>FTP_PID; <>DelForWiz; <>PID_inbox; <>PID_outbox; <>pid_forecast_viewer; <>FLEX_EXCHG_PID; <>pid_Usage)
<>DelForWiz:=0  //*DelFor Wizard pid
<>FTP_PID:=0
<>PID_inbox:=0
<>PID_outbox:=0
<>pid_forecast_viewer:=0
<>FLEX_EXCHG_PID:=0
<>pid_Usage:=0
app_Log_Usage

C_TEXT:C284(<>inboxFolderPath; <>outboxFolderPath; <>tempFolderPath)
//SEE EDIevent on load
<>inboxFolderPath:=""
<>outboxFolderPath:=""
<>tempFolderPath:=""

C_TEXT:C284(<>sQtyWorksht)
<>sQtyWorksht:="00"

//<>MySQL_Registered:=False
<>WMS_ERROR:=0
<>CUSTPORT_ERROR:=0

<>Rama_Palette_Entry:=False:C215