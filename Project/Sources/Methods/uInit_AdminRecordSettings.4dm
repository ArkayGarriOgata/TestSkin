//%attributes = {}

// Method: uInit_AdminRecordSettings ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/02/14, 09:23:55
// ----------------------------------------------------
// Description
// pull settings from the Admin & Control record for client and server startup
//
// ----------------------------------------------------
// Modified by: Mel Bohince (8/4/17) added open accts company constant
// Modified by: MelvinBohince (5/6/22)  added init of <>Auto_Coating_Percent

C_TEXT:C284(<>OpenAcctsCompany)

If (False:C215)  // TODO TODO Modified by: Mel Bohince (6/4/21) prototype using Storage over IP vars
	If (False:C215)
		If (Storage:C1525.ControlRecord=Null:C1517)
			C_OBJECT:C1216($en; $zzControl)
			$en:=ds:C1482.zz_control.all().first()
			
			$zzControl:=New shared object:C1526
			Use ($zzControl)
				//assigning $zzControl:=$en.toObject() fails when placed in Storage
				//or a for each($attr;OB GET PROPERTY NAMES) if you want them all, but do you?
				
				$zzControl.PHYSICAL_INVENORY_IN_PROGRESS:=$en.InvInProgress
				$zzControl.FlexwareActive:=$en.FlexwareActive
				//etc...
			End use 
			
			
			Use (Storage:C1525)
				
				Storage:C1525.ControlRecord:=New shared object:C1526
				
				Use (Storage:C1525.ControlRecord)
					Storage:C1525.ControlRecord:=$zzControl
				End use 
				
			End use 
		End if 
		
		//then where needed:
		//$x:=Storage.ControlRecord.PHYSICAL_INVENORY_IN_PROGRESS
		
	Else 
		//see uInit_IP_Storage which can be generic, see Phil's in WMS
		C_OBJECT:C1216($ipVariable_o; $en)
		$en:=ds:C1482.zz_control.all().first()
		
		$ipVariable_o:=New shared object:C1526
		Use ($ipVariable_o)
			$ipVariable_o["PHYSICAL_INVENORY_IN_PROGRESS"]:=$en.InvInProgress
			$ipVariable_o["FlexwareActive"]:=$en.FlexwareActive
			
		End use 
		
		Use (Storage:C1525)  //save it for reuse on this machine
			Storage:C1525.IP:=$ipVariable_o
		End use 
		
		//then where needed:
		//$x:=Storage.IP.PHYSICAL_INVENORY_IN_PROGRESS
	End if 
	
End if   //prototype TODO TODO

READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
ONE RECORD SELECT:C189([zz_control:1])
//turn on/off changes made by 4D Professional Services on the  [zz_control];"AdminEvent" form:
//<>modification4D_10_05_19:=[zz_control]_4DProfessionalServices_Step_1
//<>modification4D_14_01_19:=[zz_control]_4DProfessionalServices_Step_1  // added by: Mel Bohince (1/24/19) set this in user enviroment
//<>modification4D_06_02_19:=[zz_control]_4DProfessionalServices_Step_2
//<>modification4D_13_02_19:=[zz_control]_4DProfessionalServices_Step_3
//<>modification4D_28_02_19:=[zz_control]_4DProfessionalServices_Step_4
//<>modification4D_25_03_19:=[zz_control]_4DProfessionalServices_Step_5

// Modified by: Mel Bohince (3/25/19) to disable selectively and leave marker
<>disable_4DPS_mod:=True:C214  //usage: If (Not(<>modification4D_13_02_19)) | (<>disable_4DPS_mod)



<>PHYSICAL_INVENORY_IN_PROGRESS:=[zz_control:1]InvInProgress:24
<>FlexwareActive:=[zz_control:1]FlexwareActive:51

<>OpenAcctsCompany:=[zz_control:1]OpenAcctsCompany:69  // Modified by: Mel Bohince (8/4/17) added open accts company constant

<>AcctVantageVersion:=[zz_control:1]AcctVantageVersion:53
<>AcctVantageIP:=[zz_control:1]API_TCPaddress:32
If (<>AcctVantageVersion>0)  // Modified by: Mel Bohince (7/13/17) add switch for OpenAccounts
	<>AcctVantageActive:=True:C214
	<>OpenAccountsActive:=False:C215
	<>FlexwareActive:=False:C215
	
Else 
	//see also On Server Startup
	<>OpenAccountsActive:=True:C214
	<>AcctVantageActive:=False:C215
	<>FlexwareActive:=False:C215
End if 

<>YearStart:=[zz_control:1]FiscalYearStart:34  //month the fiscal year starts
<>MaxPO:=[zz_control:1]MaxPO:36  //• 6/4/97 cs max $ a PO can Have before being sent to Manger for approval
<>PATH_FLEX_INBOX:=[zz_control:1]ShopfloorPathOutbox:54
<>PATH_AMS_INBOX:=[zz_control:1]TrelloBoardEmailAddress:55
<>LOG_USER_ACTIONS:=[zz_control:1]Log_User_Actions:9
<>Use_SAP_ink_price:=[zz_control:1]Use_SAP_ink_price:57

<>Auto_Ink_Issue:=([zz_control:1]InkVendorID:39="ISSUE")  // Modified by: Mel Bohince (8/23/13) 
<>Auto_Ink_Percent:=Num:C11([zz_control:1]Auto_Ink_Percent:41)
If (<>Auto_Ink_Percent<=0)
	<>Auto_Ink_Percent:=0.029
End if 
<>Auto_Coating_Percent:=[zz_control:1]Auto_Coating_Percent:63  // Modified by: MelvinBohince (5/6/22) 
<>Auto_Corr_Percent:=[zz_control:1]Auto_Corrugate_Percent:68
UNLOAD RECORD:C212([zz_control:1])


READ ONLY:C145([z_administrators:2])
ALL RECORDS:C47([z_administrators:2])
<>fRestrictCO:=[z_administrators:2]RestrictCO:10
<>fRestrictCR:=[z_administrators:2]RestrictCR:11
<>fRestrictJO:=[z_administrators:2]RestrictJO:12
<>fRestrictPO:=[z_administrators:2]RestrictPO:13
<>fRestrictRM:=[z_administrators:2]RestrictRM:14
<>SubformCalc:=[z_administrators:2]SubformCalcs:16  //3/20/95 upr 66
<>SerialPrn:=[z_administrators:2]SerialPrinting:19  //•041096  mBohince
<>fRestrictFG:=(True:C214)
<>UseActCost:=[z_administrators:2]UseActualCost:20  //•072998  MLB
<>NewAlloccat:=[z_administrators:2]FixVarAllocatio:21  //•072998  MLB  UPR 1966
<>UseNRV:=[z_administrators:2]NetRealizaValue:22  //•111398  MLB  htk request
<>EMAIL_STMP_HOST:=[z_administrators:2]SMTP_HOST:23
<>EMAIL_FROM:=[z_administrators:2]MAIL_FROM:24
<>EMAIL_REPLYTO:=[z_administrators:2]MAIL_REPLYTO:25
<>EMAIL_POP3_HOST:=[z_administrators:2]POP3_HOST:26
<>EMAIL_POP3_USERNAME:=[z_administrators:2]POP3_USERNAME:27
<>EMAIL_POP3_PASSWORD:=[z_administrators:2]POP3_PASSWORD:28
<>AllocateGoodQty:=[z_administrators:2]AllocateGoodQty:29
<>TEST_VERSION:=[z_administrators:2]TestMode:30
<>sCOMPANY:=[z_administrators:2]CompanyName:2
<>NEW_FEATURE:=[z_administrators:2]USE_NEW_FEATURE:17
<>SERVER_DESIGNATION:=[z_administrators:2]ServerDesignation:31
<>Sync_Activated:=[z_administrators:2]SyncronizeServers:33
<>IgnorObsoleteAndOld:=[z_administrators:2]IgnorObsoleteAndOld:34
<>CHAIN_OF_CUSTODY:=[z_administrators:2]ChainOfCustodyNumber:35
<>MTfromScan:=[z_administrators:2]MachTickFromRcvScan:36
UNLOAD RECORD:C212([z_administrators:2])