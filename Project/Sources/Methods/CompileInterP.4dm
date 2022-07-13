//%attributes = {"publishedWeb":true}
//(P) CompileInterP: interprocess compiler directives
//9/26/94 mod for Phy inv
//10/21/94 reduce IP variable space
//10/24/94 add var ◊lMinMemPart to control minimum process size
//3/3/95 add some stuff for the credit check
//3/20/95 upr 66
//5/3/95 added some constants, see below
//•051895  MLB  increase min memory to see if type11 go away
//•mod December 20, 1995.  Adam Soos  PI (for Printronix Printer)  
//• Adam Soos 3/21/96 keep info, that printronix beeing used
//• AJS 03/22/95 In getting ready for ON-LINE Phys. Inv.
//• 3/23/96 Adam, state of last backup attempt, set in uBackupAMS, checked from PI
//Meaning: "Has the last backup attempt, since startup, been succesful?".
//•041096  mBohince  option for serial printing
//•051496  MLB  sort adhoc file picker
//• 12/2/96 cs added definition for ◊aCommand - as text array (size 0) used in 
//  execute dialog        
// `•1/9/97 - cs -  multiple customer on one form
//•022597  MLB  clear saslesman
//•2/28/97 cs upr 1858 removed unused code for new PI
// 3/3/97upr 1858 aded declaration for PI Report Array
//    added ◊fPIActive for PI adjustments
//• 6/3/97 cs added new array for tracking Estimate Commodity keys
//• 6/4/97 cs added new interp var - MaxPO - this is the Maximum value a PO can ha
//  which is NOT approved by upper management (Mitchell, Walter etc.)
//• 6/5/97 cs added var to hold string for requisition file name upr 1872
//• 6/5/97 cs added array for department codes upr 1872
//initialide process list prt value
//• 7/14/97 cs added definition of ◊xMsgText
//• 7/21/97 cs added flag to allow exiting of running notifier if user desides too
//• 9/22/97 cs moved all var assignemnts to procedure '00CompileBuild
//  procedure was getting to large and unweildy
//• 1/14/98 cs added an interprocess NULL (empty) Picture
//• 5/27/98 cs added 2 text vars for tracking CC to divisions
//• 7/27/98 MLB get Fg at actual
//•072998  MLB upr1966
//•04/11/05 - DJC added interprocess var for LiveSync4D

C_BOOLEAN:C305(<>fQuit4D)  //v1.0.0-PJK (12/23/15)

C_TEXT:C284(<>GLUERS; <>ROANOKE_WC; <>PRESSES; <>BLANKERS; <>STAMPERS; <>EMBOSSERS; <>SHEETERS; <>PLATEMAKING; <>LAMINATERS)
C_LONGINT:C283(<>ProcSize)  // Added by: Mark Zinke(12/28/12)
C_TEXT:C284(<>AskMeFG; <>tWindowSetName)  // Added by: Mark Zinke (12/20/12)
C_BOOLEAN:C305(<>TEST_VERSION; <>GNS_Doing_FillInSyncIDs; <>Use_SAP_ink_price; <>Auto_Ink_Issue)  // Modified by: Mel Bohince (8/23/13) 
C_REAL:C285(<>Auto_Ink_Percent)
C_TEXT:C284(<>SERVER_DESIGNATION)  //
C_LONGINT:C283(<>StatusBar)
C_TEXT:C284(<>CurrentUser)
C_TEXT:C284(<>CHAIN_OF_CUSTODY)
C_TEXT:C284(<>ttWMS_CONFIG_MySQL; <>WMS_ALT_LABELS)
C_TEXT:C284(<>ttWMS_CONFIG_4D; <>ttWMS_4D_URL)  //v0.1.0-JJG (05/05/16) - added
C_BOOLEAN:C305(<>fWMS_Use4D)  //v0.1.0-JJG (05/05/16) - added
C_LONGINT:C283(<>SHORTDATE; <>MIDDATE; <>LONGDATE; <>HHMM; <>HMMAM; <>lastPINentry)
C_TEXT:C284(<>NULL)
C_POINTER:C301(<>NIL)
//---------- used by api procedures ---------
C_LONGINT:C283(<>NetworkComponent; <>iServerID; <>iConnectID)
C_TEXT:C284(<>sServName)
C_LONGINT:C283(<>A4CLIENTS; <>A4INVOICES; <>A4CLIENTID; <>A4CLIENTOLD; <>A4OPEN_AR; <>A4INVO_DATE; <>A4INVO_AMT; <>A4INVO_CLID)
C_TEXT:C284(<>DynamicsPath; <>DynamicsCustFilename; <>DynamicsInvoiceHdrFilename; <>DynamicsInvoiceDtlFilename; <>purgeFolderPath; <>PATH_AMS_INBOX; <>PATH_FLEX_INBOX)
C_TEXT:C284(<>PATH_AMS_INBOX; <>PATH_FLEX_INBOX; <>PATH_TO_LOG_FILE; <>PATH_TO_EXTRAS)
C_BOOLEAN:C305(<>FlexwareActive; <>AcctVantageActive)
C_LONGINT:C283(<>AcctVantageVersion)

C_LONGINT:C283(<>winX; <>winY)
C_LONGINT:C283(<>lMinMemPart; <>lMidMemPart; <>lBigMemPart)  //minimum memory to start a process with
C_LONGINT:C283(<>Activitiy; <>BOL)  //used on EstEvent buttons to indicate type of search
C_POINTER:C301(<>filePtr; <>NIL_PTR)  //used for parameter passing
C_BOOLEAN:C305(<>fContinue; <>SCROLLING; <>fEstimating; <>plsHold; <>fHelpLoaded; <>apiFlag; <>fSendTrans; <>fFG; <>fCust; <>fContact; <>fOrd; <>fJob; <>fAddr)
C_BOOLEAN:C305(<>fCls; <>fTodo; <>RecordSaved; <>PassThrough; <>fPhyInv; <>AllocateGoodQty; <>IgnorObsoleteAndOld)
C_TEXT:C284(<>whichRpt; <>pdfFileName)  //parameter passer
C_LONGINT:C283(<>iMode; <>ibEst; <>lastNew; <>iLayout)
//ARRAY LONGINT(◊aOffSet;Count tables)  `number to be added when using sequence co

//Setup for PO Clause Table Lookup
C_BOOLEAN:C305(<>fLoadClaus; <>FAX_ENABLED; <>FAX_USER)
C_LONGINT:C283(<>lClausNum)  //number of clauses selected
//process naming, see (P) uNextView
C_BOOLEAN:C305(<>fMultiviews)

C_LONGINT:C283(<>PrcsListPr)  //number of Process List process
//setup constants, see (P) uzCharInit
C_DATE:C307(<>dLASTUPDATE)
C_TEXT:C284(<>sCR; <>sDQ)
C_LONGINT:C283(<>MainEventWindow; <>mewLeft; <>mewTop; <>mewRight; <>mewBottom)
C_TEXT:C284(<>sAPPVERSION; <>sVERSION)
C_TEXT:C284(<>sDATANAME; <>sSTRUCNAME)
C_TEXT:C284(<>sAPPNAME; <>sCOMPANY)
C_TEXT:C284(<>sHdPath)
C_LONGINT:C283(<>lHCENTER; <>lLetterPix; <>lWCENTER; <>lSidewPix; <>lCOMP)
C_LONGINT:C283(<>lMODE; <>RecNum)
//setup choise list mod dialog items
//see ScrapBook name AMS List Management
ARRAY TEXT:C222(<>aListNames; 0)  //choice lists names

//--- array transversal
C_LONGINT:C283(<>bUpArrow; <>bDownArrow)

//--- track current user initals
C_TEXT:C284(<>zResp)
C_TEXT:C284(<>PLATFORM)
C_TEXT:C284(<>DELIMITOR)
//PO Control
ARRAY TEXT:C222(<>asBuyers; 0)
ARRAY TEXT:C222(<>asBuyerName; 0)
C_TEXT:C284(<>sPOI2Mod)  //POItem to modify from req item
//Estimate Control
C_TEXT:C284(<>Est2Zoom)
<>Est2Zoom:=""
//Cost Defaults
C_TEXT:C284(<>GLCostDef; <>GLIncomDef; <>GLInvenDef)
//AdHoc Setup
//ARRAY TEXT(◊axFiles;0)  `File Names
//ARRAY INTEGER(◊axFileNums;0)  `File Numbers`•051496  MLB 
C_BOOLEAN:C305(<>fRestrictCO; <>fRestrictCR; <>fRestrictJO; <>fRestrictPO; <>fLabelErr; <>SubformCalc; <>SerialPrn; <>UseNRV)

//---------- ESTIMATE input layout Interface stuff ------------------
C_TEXT:C284(<>TheEstID; <>PIN)
C_TEXT:C284(<>sCartonTtle)
C_TEXT:C284(<>sEstDiffID)
C_LONGINT:C283(vCartonPID)
C_TEXT:C284(<>WhatToPrint)  //•••• added 9/22/94 chip for invent ticket printing process
C_TEXT:C284(<>sQtyWorksht)
//<>sQtyWorksht:="00"  //used in [carton_spec], indicates record is part of Qty-worksheet & not a differe
//the quantity-worksheet is an user-friendly interface tool.  It allows salesperso
//all the quantity breaks in a handful of records, rather than 1 qty value per rec

C_TEXT:C284(<>xText1)  //used in MachineTicket exception report
//ARRAY TEXT(◊aCommand;0)  `Array previously for executed code for execute dialog

//•1/9/97 - cs -  multiple customer on one form
C_TEXT:C284(<>sCombindID)
C_TEXT:C284(<>sCombindNam)
//end mods for multiple customer on one form

//--- Pi
//ARRAY TEXT(◊aPIRptPop;0)  `•3/3/97 cs upr 1858 declare report array
C_BOOLEAN:C305(<>fPIActive; <>NEW_FEATURE)  //• 3/27/97 cs addd for Adjust ment screens

C_DATE:C307(<>FgBatchDat; <>OrdBatchDat; <>JobBatchDat; <>ThcBatchDat; <>MAGIC_DATE)  // <>MAGIC_DATE is used so that sorted dates are messed up by 00/00/00 (null dates)


//ARRAY TEXT(◊EstCommKey;0)
C_TEXT:C284(<>sReqName)

//--- Notifier
C_LONGINT:C283(<>PrcsListPr)  //• 7/9/97 cs added - found this reference in proccess list & uspawnprocess not 
C_TEXT:C284(<>xMsgText)  //used for message on notify window
C_BOOLEAN:C305(<>fQuitNotify)

//---Requisition & PO
C_LONGINT:C283(<>DeptProc)

C_TEXT:C284(<>zRespDept)  //• 9/22/97 cs used to track user department settings
C_PICTURE:C286(<>pNullPict)  //null (empty) picture var, used to clear other Pict vars

//--- for Tracking CCs to divsions
C_TEXT:C284(<>Roanoke_CCs; <>Ny_CCs)
C_BOOLEAN:C305(<>UseActCost)  //•072998  MLB
C_BOOLEAN:C305(<>NewAlloccat)  //•072998  MLB 
//
C_TEXT:C284(<>GLUERS; <>ROANOKE_WC; <>PRESSES; <>BLANKERS; <>STAMPERS; <>SHEETERS; <>COATERS)

C_TEXT:C284(<>pjtId)  //•5/03/00  mlb  pjt interface, pass pjt ref to new objects
C_LONGINT:C283(<>pjt_picker; <>HasLabelPrinter)
C_BOOLEAN:C305(<>PHYSICAL_INVENORY_IN_PROGRESS)

C_TEXT:C284(<>EMAIL_STMP_HOST; <>EMAIL_FROM; <>EMAIL_REPLYTO)
C_LONGINT:C283(<>pid_bagTrack; <>pid_eBag; <>pid_ShiftCard; <>pid_ToDo; <>pid_WIPmgmt; <>pid_Workorder; <>pid_ToolDrawer; <>EDI_ASN_pid)

C_LONGINT:C283(<>pidTimer)
C_LONGINT:C283(<>cacheJMLts)
C_TEXT:C284(<>psOUTSIDE_SERVICE_MENU)
//C_LONGINT(◊pid600;◊pid601;◊pid602;◊pid603;◊pid604;◊pid605;◊pid606;◊pid606)
//C_LONGINT(◊winRef600;◊winRef601;◊winRef602;◊winRef603)

C_TEXT:C284(<>jobform; <>jobformseq)
C_BOOLEAN:C305(<>rmXferInquire; <>fgXferInquire; <>EDI_ASN_keep_running)

C_LONGINT:C283(<>FloatingAlert_PID; <>WMS_GET_PID; <>WMS_ERROR; <>CUSTPORT_ERROR)
C_TEXT:C284(<>FloatingAlert)
C_BOOLEAN:C305(<>PrintToPDF)
C_TEXT:C284(<>EL_Companies)
C_TEXT:C284(<>FNC1)  //for barcode 128's

C_BOOLEAN:C305(<>COM_SerialPortActive)
C_LONGINT:C283(<>COM_SerialPort_PID; <>RFTBASE_STATION_PID; <>waitInterval)

C_TEXT:C284(<>cr)

//For LiveSync4D
C_BOOLEAN:C305(<>Sync_Activated)  //DJC - 4/11/05

C_TEXT:C284(<>JOBIT)

C_TEXT:C284(<>AdobeAcrobat; <>EngDrawing_Volume; <>LayoutPDF_Volume)

C_TEXT:C284(<>tICN; <>tGCN; <>tTXN)  //these variables will be set by mapping process
C_LONGINT:C283(<>FTP_PID; <>DelForWiz; <>PID_inbox; <>PID_outbox; <>pid_Usage; <>FLEX_EXCHG_PID; <>aa4D_pid; <>pid_RMX)
C_TEXT:C284(<>inboxFolderPath; <>outboxFolderPath; <>tempFolderPath)

C_BOOLEAN:C305(<>zz_PNGA_DoNotRunTriggers; <>Rama_Palette_Entry)  //<>MySQL_Registered

C_LONGINT:C283(<>MainWindowRef; <>MainWindowLeft; <>MainWindowTop; <>MainWindowRight; <>MainWindowBottom)
C_BOOLEAN:C305(<>IsMainWindowHidden)

C_TEXT:C284(<>ttPriorEventCall)  //v0.1.0-JJG (02/03/16) - added
C_BOOLEAN:C305(<>fHasPriorEvent)  //v0.1.0-JJG (02/03/16) - added
C_LONGINT:C283(<>xlIdleMonitorProcessPeriod; <>xlGracePeriod; <>xlMaxIdlePeriod; <>xlKeystrokePeriod)  //v0.1.0-JJG (02/04/16) - added