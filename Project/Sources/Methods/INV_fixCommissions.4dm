//%attributes = {"publishedWeb":true}
//PM:  INV_fixCommissions  071802  mlb
//find 2cent'ers
//verify fgx cost is zero
//is remaining jic cost, no, set commish to 0
//   else is glue date older than ship, no, set commission to 0
//        else repair xfer, reduce jic, recalc commish

C_DATE:C307($fromDate)
C_REAL:C285($cogs; $badCommish)
C_LONGINT:C283($numINV; $invoice; $numXfers; $xaction)

MESSAGES OFF:C175

$fromDate:=Date:C102(Request:C163("≥ what date?"; "06/01/00"))
$badCommish:=Num:C11(Request:C163("Current [Invoices]CommissionPayable="; "0.02"))

READ WRITE:C146([Customers_Invoices:88])
READ WRITE:C146([Finished_Goods_Transactions:33])
READ WRITE:C146([Job_Forms_Items_Costs:92])
READ ONLY:C145([Job_Forms_Items:44])

QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]CommissionPayable:21=$badCommish; *)
QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]PricingUOM:17="M"; *)
QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7>=$fromDate)
$numINV:=Records in selection:C76([Customers_Invoices:88])
utl_Trace
uThermoInit($numINV; "Repairing "+String:C10($badCommish)+" commissions")
For ($invoice; 1; $numINV)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_Invoices:88]OrderLine:4+"/"+String:C10([Customers_Invoices:88]ReleaseNumber:5)))
	If (Records in selection:C76([Finished_Goods_Transactions:33])=0)  //try as payuse
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_Invoices:88]OrderLine:4+"/PayU"+String:C10([Customers_Invoices:88]InvoiceNumber:1)))
	End if 
	$cogs:=Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
	If ($cogs=0)
		$numXfers:=Records in selection:C76([Finished_Goods_Transactions:33])
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionNum:24; >)
			FIRST RECORD:C50([Finished_Goods_Transactions:33])
			
			
		Else 
			
			ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionNum:24; >)
			// see previous line
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		For ($xaction; 1; $numXfers)
			[Finished_Goods_Transactions:33]CoGSExtended:8:=JIC_Relieve(([Customers_Invoices:88]CustomerID:6+":"+[Customers_Invoices:88]ProductCode:14); [Finished_Goods_Transactions:33]Qty:6; ->[Finished_Goods_Transactions:33]CoGSextendedMatl:32; ->[Finished_Goods_Transactions:33]CoGSextendedLabor:33; ->[Finished_Goods_Transactions:33]CoGSextendedBurden:34; [Customers_Invoices:88]Invoice_Date:7)
			[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/[Finished_Goods_Transactions:33]Qty:6*1000
			$cogs:=$cogs+[Finished_Goods_Transactions:33]CoGSExtended:8
			SAVE RECORD:C53([Finished_Goods_Transactions:33])
		End for 
	End if   //cogs missing
	
	[Customers_Invoices:88]CommissionPayable:21:=fSalesCommission("Normal"; [Customers_Invoices:88]OrderLine:4; [Customers_Invoices:88]Quantity:15/1000)
	SAVE RECORD:C53([Customers_Invoices:88])
	
	NEXT RECORD:C51([Customers_Invoices:88])
	uThermoUpdate($invoice; 1)
End for 
uThermoClose

QUERY SELECTION:C341([Customers_Invoices:88]; [Customers_Invoices:88]CommissionPayable:21#0.02)