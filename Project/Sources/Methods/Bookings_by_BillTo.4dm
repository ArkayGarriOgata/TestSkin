//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 07/01/09, 11:36:10
// ----------------------------------------------------
// Method: Bookings_by_BillTo
// Description
//based on:
//PM: Bookings() -> 
//@author mlb - 4/3/03  16:00
//073106 exclude rental orderlines

C_TEXT:C284(docName)
C_TIME:C306($docRef)
C_LONGINT:C283($fiscalYear; $i; $numRels; $changes; $numRecs)  //•3/27/00  mlb  fiscal year roll over
C_DATE:C307(dDateBegin; dDateEnd; $2; $1; $fiscalStartDate)

READ ONLY:C145([Customers_ReleaseSchedules:46])

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Billto:22="02568"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Billto:22="02768"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Billto:22="02769"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>!2008-01-01!)
ORDER BY:C49([Customers_ReleaseSchedules:46]OrderLine:4; >)
$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
uThermoInit($numRels; "Updating Rama Records")
READ WRITE:C146([Customers_Order_Lines:41])
For ($i; 1; $numRels)
	RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
	If ([Customers_Order_Lines:41]defaultBillto:23#[Customers_ReleaseSchedules:46]Billto:22)
		[Customers_Order_Lines:41]defaultBillto:23:=[Customers_ReleaseSchedules:46]Billto:22
		If ([Customers_Order_Lines:41]defaultShipTo:17#[Customers_ReleaseSchedules:46]Shipto:10)
			[Customers_Order_Lines:41]defaultShipTo:17:=[Customers_ReleaseSchedules:46]Shipto:10
		End if 
		SAVE RECORD:C53([Customers_Order_Lines:41])
	End if 
	NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	uThermoUpdate($i)
End for 
uThermoClose
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)

If (Count parameters:C259=2)
	dDateBegin:=$1
	dDateEnd:=$2
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13>=dDateBegin; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=dDateEnd)
	$numRecs:=Records in selection:C76([Customers_Order_Lines:41])
Else 
	$fiscalStartDate:=Date:C102(FiscalYear("start"; 4D_Current_date))
	$numRecs:=qryByDateRange(->[Customers_Order_Lines:41]DateOpened:13; "Orderline Opened from:"; $fiscalStartDate; 4D_Current_date-1)
End if 

If ($numRecs>0)
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"New"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Contract"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Open@"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Rejected"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustomerLine:42#"Rental"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4#"00614"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4#"01585")
	
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Customers_Order_Lines:41])
	If ($numRecs>0)
		docName:="Bookings"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")
		$docRef:=util_putFileName(->docName)
		
		C_TEXT:C284($t; $cr)
		$t:=Char:C90(9)
		$cr:=Char:C90(13)
		uThermoInit($numRecs; "Exporting Orderline Records")
		SEND PACKET:C103($docRef; "OrderLine"+$t+"SalesRep"+$t+"CustomerName"+$t+"CustomerLine"+$t+"Quantity"+$t+"Cost_Per_M"+$t+"Price_Per_M"+$t+"Qty_Shipped"+$t+"Qty_Returned"+$t+"specialBilling"+$t+"DateOpened"+$t+"DateApproved"+$cr)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; $numRecs)
				If ($break)
					$i:=$i+$numRecs
				End if 
				RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
				
				$billToName:=ADDR_getName([Customers_Order_Lines:41]defaultBillto:23)
				If ($billToName="N/F")
					$billToName:=ADDR_getName([Customers_Orders:40]defaultBillTo:5)
				End if 
				
				If ([Customers_Order_Lines:41]SpecialBilling:37)
					$splBill:="True"
				Else 
					$splBill:="False"
				End if 
				SEND PACKET:C103($docRef; [Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]SalesRep:34+$t+$billToName+$t+[Customers_Order_Lines:41]CustomerLine:42+$t+String:C10([Customers_Order_Lines:41]Quantity:6)+$t+String:C10([Customers_Order_Lines:41]Cost_Per_M:7)+$t+String:C10([Customers_Order_Lines:41]Price_Per_M:8)+$t+String:C10([Customers_Order_Lines:41]Qty_Shipped:10)+$t+String:C10([Customers_Order_Lines:41]Qty_Returned:35)+$t+$splBill+$t+String:C10([Customers_Order_Lines:41]DateOpened:13; System date short:K1:1)+$t+String:C10([Customers_Orders:40]DateApproved:45; System date short:K1:1)+$cr)  //+$t+String([Customers_Order_Lines]ExcessQtySold)
				
				NEXT RECORD:C51([Customers_Order_Lines:41])
				uThermoUpdate($i)
			End for 
			
		Else 
			
			GET FIELD RELATION:C920([Customers_Order_Lines:41]OrderNumber:1; $lienAller; $lienRetour)
			SET FIELD RELATION:C919([Customers_Order_Lines:41]OrderNumber:1; Automatic:K51:4; Do not modify:K51:1)
			
			
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderNumber:1; $_OrderNumber; [Customers_Order_Lines:41]defaultBillto:23; $_defaultBillto; [Customers_Order_Lines:41]SpecialBilling:37; $_SpecialBilling; [Customers_Order_Lines:41]OrderLine:3; $_OrderLine; [Customers_Order_Lines:41]SalesRep:34; $_SalesRep; [Customers_Order_Lines:41]CustomerLine:42; $_CustomerLine; [Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]Cost_Per_M:7; $_Cost_Per_M; [Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M; [Customers_Order_Lines:41]Qty_Shipped:10; $_Qty_Shipped; [Customers_Order_Lines:41]Qty_Returned:35; $_Qty_Returned; [Customers_Order_Lines:41]DateOpened:13; $_DateOpened; [Customers_Orders:40]OrderNumber:1; $_OrderNumber1; [Customers_Orders:40]defaultBillTo:5; $_defaultBillTo2; [Customers_Orders:40]DateApproved:45; $_DateApproved)
			
			SET FIELD RELATION:C919([Customers_Order_Lines:41]OrderNumber:1; $lienAller; $lienRetour)
			
			For ($i; 1; $numRecs)
				If ($break)
					$i:=$i+$numRecs
				End if 
				$billToName:=ADDR_getName($_defaultBillto{$i})
				If ($billToName="N/F")
					$billToName:=ADDR_getName($_defaultBillTo2{$i})
				End if 
				
				If ($_SpecialBilling{$i})
					$splBill:="True"
				Else 
					$splBill:="False"
				End if 
				
				SEND PACKET:C103($docRef; $_OrderLine{$i}+$t+$_SalesRep{$i}+$t+$billToName+$t+$_CustomerLine{$i}+$t+String:C10($_Quantity{$i})+$t+String:C10($_Cost_Per_M{$i})+$t+String:C10($_Price_Per_M{$i})+$t+String:C10($_Qty_Shipped{$i})+$t+String:C10($_Qty_Returned{$i})+$t+$splBill+$t+String:C10($_DateOpened{$i}; System date short:K1:1)+$t+String:C10($_DateApproved{$i}; System date short:K1:1)+$cr)
				
				uThermoUpdate($i)
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		uThermoClose
		
		CLOSE DOCUMENT:C267($docRef)
		//$err:=  // obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		If ($err=0)
			zwStatusMsg("Booking Data!"; "Type Changed on document named: "+docName)
		Else 
			zwStatusMsg("Booking Data!"; "Type Changed on document named: "+docName+" Error: "+String:C10($err))
		End if 
		
		$err:=util_Launch_External_App(docName)
		If ($err=0)
			zwStatusMsg("Booking Data"; "Saved to document named: "+docName)
		Else 
			zwStatusMsg("Booking Data"; "Saved to document named: "+docName+" Error: "+String:C10($err))
		End if 
	End if 
End if 