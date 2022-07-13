//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/03/12, 09:41:49
// ----------------------------------------------------
// Method: Rama_Accounts_Payable
// Description
// assist in reconciling invoices with gluing & freight accrued
// [Raw_Materials_Transactions]ReceivingNum is set to zero when posted, date stamped when payed
//[Raw_Materials_Transactions]Invoiced:=!00/00/00!
//[Raw_Materials_Transactions]Payed:=!00/00/00!
// ----------------------------------------------------
// Modified by: Mel Bohince (1/13/15) change to [Finished_Goods_Transactions] shipped perspective, 
//    unfortunately layouts still under [Raw_Materials_Transactions] since array based, why bother, rama to go away.

C_TEXT:C284($1)
C_LONGINT:C283(<>pid_RamaAP; $winRef)
//<>pid_RamaAP:=0

If (Count parameters:C259=0)
	If (<>pid_RamaAP=0)
		app_Log_Usage("log"; "RAMA"; "Rama_Accounts_Payable")
		<>pid_RamaAP:=New process:C317("Rama_Accounts_Payable"; <>lMinMemPart; "Rama Accounts Payable"; "init")
		If (False:C215)
			Rama_Accounts_Payable
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_RamaAP)
		BRING TO FRONT:C326(<>pid_RamaAP)
	End if 
	
Else 
	//If (Rama_Find_Payables ("open2")>0)  //(or "pay")
	$numFound:=Rama_Find_Payables("open2")
	zwStatusMsg("RAMA A/P"; String:C10($numFound)+" shipments found")
	$winRef:=Open form window:C675([Raw_Materials_Transactions:23]; "Rama_transactions"; Plain form window:K39:10)
	SET WINDOW TITLE:C213("Rama/Cayey Accounts Payable"; $winRef)
	
	MESSAGE:C88("Please Wait, loading transactions...")
	Rama_Load_Transactions
	
	FORM SET INPUT:C55([Raw_Materials_Transactions:23]; "Rama_transactions")
	ADD RECORD:C56([Raw_Materials_Transactions:23]; *)
	CLOSE WINDOW:C154($winRef)
	FORM SET INPUT:C55([Raw_Materials_Transactions:23]; "Input")
	
	//Else 
	//uConfirm ("No transactions found.";"OK";"Help")
	//End if 
	
	<>pid_RamaAP:=0
End if 