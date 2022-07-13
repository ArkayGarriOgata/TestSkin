//%attributes = {"publishedWeb":true}
//PM: REL_ReleaseShipped(qty;date;release#) -> success or failure
//formerly uManifestRel()  092995  MLB
//`•020596  MLB 
//use Execute button on DBA palette to run like: REL_ReleaseShipped(5200;!10/8/07!;815277;"mlb";6) and make sure actual date is zero'd first

C_LONGINT:C283($1; $qty; $relNum; $3; $5; $0)
C_DATE:C307($2; $XactDate)
C_TEXT:C284($4)

$qty:=$1
$XactDate:=$2
$relNum:=$3

If (Count parameters:C259>3)
	$modifiedBy:=$4
Else 
	$modifiedBy:=<>zResp
End if 

If (Count parameters:C259>4)
	QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=$5)
End if 

$0:=No current record:K29:2

READ WRITE:C146([Customers_ReleaseSchedules:46])
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$relNum)
If (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
	If (fLockNLoad(->[Customers_ReleaseSchedules:46]))
		[Customers_ReleaseSchedules:46]ModDate:18:=$XactDate  //•020596  MLB 
		[Customers_ReleaseSchedules:46]ModWho:19:=$modifiedBy  //•020596  MLB 
		[Customers_ReleaseSchedules:46]Actual_Qty:8:=[Customers_ReleaseSchedules:46]Actual_Qty:8+$qty
		[Customers_ReleaseSchedules:46]Actual_Date:7:=$XactDate
		[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]OpenQty:16-$qty
		[Customers_ReleaseSchedules:46]B_O_L_number:17:=[Customers_Bills_of_Lading:49]ShippersNo:1
		
		If ([Customers_ReleaseSchedules:46]RemarkLine1:25#"Bill and Hold")  // not shipping something that was already billed
			If ([Customers_Bills_of_Lading:49]PayUseFlag:11=0)  //normal shipment, set up for invoicing
				[Customers_ReleaseSchedules:46]InvoiceNumber:9:=Invoice_GetNewNumber  //*    Get an invoice number
			Else   //moving inventory for consignment use
				[Customers_ReleaseSchedules:46]InvoiceNumber:9:=New record:K29:1  //-3
			End if 
			
		Else 
			[Customers_ReleaseSchedules:46]InvoiceNumber:9:=New record:K29:1  //-3  trigger_CustomersReleaseSchedul looks for this
			qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
			[Finished_Goods:26]Bill_and_Hold_Qty:108:=[Finished_Goods:26]Bill_and_Hold_Qty:108-$qty
			SAVE RECORD:C53([Finished_Goods:26])
		End if 
		SAVE RECORD:C53([Customers_ReleaseSchedules:46])  //see trigger_CustomersReleaseSchedul `update orderline in Release Trigger
		$0:=[Customers_ReleaseSchedules:46]InvoiceNumber:9
		
	Else   //release locked
		If (Count parameters:C259>=4)
			$0:=TriggerMessage_Set(-31000-Table:C252(->[Customers_ReleaseSchedules:46]); "[Customers_ReleaseSchedules] Record Locked")
			utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"; "+"Release# "+String:C10($relNum)+" was locked so not marked as Shipped")
			utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"; "+"run  REL_ReleaseShipped("+String:C10($qty)+";"+String:C10(Current date:C33; System date short:K1:1)+";"+String:C10($relNum)+";'mlb';"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+")")
			ToDo_postTask("mlb"; "Shipping Error"; ("run  REL_ReleaseShipped("+String:C10($qty)+";!"+String:C10(Current date:C33; System date short:K1:1)+"!;"+String:C10($relNum)+";"+Char:C90(34)+"mlb"+Char:C90(34)+";"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+")"); "00000"; Current date:C33)
			
		Else   //old shipping screen
			sCriterion2:=CustNum  //else ya got problems so this is a guess
			BEEP:C151
			ALERT:C41(" 1 Release record not found or locked"; "Cancel")
		End if 
	End if   //release locked  
	
Else 
	$0:=TriggerMessage_Set(-31000-Table:C252(->[Customers_ReleaseSchedules:46]); "[Customers_ReleaseSchedules] Record N/F")
	utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"; "+"Release# "+String:C10($relNum)+" was not found so not marked as Shipped")
	utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"; "+"run  REL_ReleaseShipped("+String:C10($qty)+";"+String:C10(Current date:C33; System date short:K1:1)+";"+String:C10($relNum)+";'mlb';"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+")")
	ToDo_postTask("mlb"; "Shipping Error"; ("run  REL_ReleaseShipped("+String:C10($qty)+";!"+String:C10(Current date:C33; System date short:K1:1)+"!;"+String:C10($relNum)+";"+Char:C90(34)+"mlb"+Char:C90(34)+";"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+")"); "00000"; Current date:C33)
End if 