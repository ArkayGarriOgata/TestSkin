//%attributes = {"publishedWeb":true}
//PM: x_CommissionPlan0801() -> 
//see also x_CommissionOnPlanned
//@author mlb - 10/10/01  14:01
//retroact the commission effective 08/01/01 forward
//• mlb - 10/25/01  16:31
C_LONGINT:C283($i; $numINV)
C_REAL:C285($old; $oldPV; $calcPV)
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
C_TEXT:C284(xTitle; xText)
xTitle:="Commission Retrofit"+$cr
$docRef:=Create document:C266("CommissionRetrofit.txt")
SEND PACKET:C103($docRef; xTitle+$cr+$cr)
MESSAGES OFF:C175

READ WRITE:C146([Customers_Invoices:88])
QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7>=!2001-08-01!)
//QUERY([Invoices]; & [Invoices]CommissionPlan#"0801")
$numINV:=Records in selection:C76([Customers_Invoices:88])

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Customers_Invoices:88])
	
	
Else 
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
xText:="INVOICE"+$t+"OLD_Comm"+$t+"NEW_Comm"+$t+"CHG_Comm"+$t+"OLD_PV"+$t+"NEW_PV"+$cr

uThermoInit($numINV; "Converting Commissions to the Aug'01 plan")
For ($i; 1; $numINV)
	If (Length:C16(xText)>28000)
		SEND PACKET:C103($docRef; xText)
		xText:=""
	End if 
	
	If ([Customers_Invoices:88]PricingUOM:17="M")
		xText:=xText+String:C10([Customers_Invoices:88]InvoiceNumber:1)+$t+String:C10([Customers_Invoices:88]CommissionPayable:21)+$t
		$old:=[Customers_Invoices:88]CommissionPayable:21
		$oldPV:=[Customers_Invoices:88]ProfitVariable:28  //• mlb - 10/25/01  16:31
		$calcPV:=0
		If ([Customers_Invoices:88]ExtendedPrice:19#0)
			$calcPV:=([Customers_Invoices:88]ExtendedPrice:19-[Customers_Invoices:88]CoGS:27)/[Customers_Invoices:88]ExtendedPrice:19
			If ($oldPV#$calcPV)
				[Customers_Invoices:88]ProfitVariable:28:=$calcPV
			End if 
		End if 
		// [Invoices]CommissionPayable:=fSalesCommission ("Normal";[Invoices]OrderLine;[In
		If ([Customers_Order_Lines:41]OrderLine:3#[Customers_Invoices:88]OrderLine:4)
			SET QUERY LIMIT:C395(1)
			READ ONLY:C145([Customers_Order_Lines:41])
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_Invoices:88]OrderLine:4)
			SET QUERY LIMIT:C395(0)
		End if 
		$scale:=INV_getCommissionScale
		[Customers_Invoices:88]CommissionScale:30:=$scale
		$percentCommission:=INV_useScale($scale; [Customers_Invoices:88]ProfitVariable:28)
		[Customers_Invoices:88]CommissionPayable:21:=Round:C94($percentCommission*[Customers_Invoices:88]ExtendedPrice:19; 2)
		[Customers_Invoices:88]CommissionPlan:26:="*801"
		[Customers_Invoices:88]CommissionPercent:31:=$percentCommission
		xText:=xText+String:C10([Customers_Invoices:88]CommissionPayable:21)+$t+String:C10([Customers_Invoices:88]CommissionPayable:21-$old)+$t+String:C10($oldPV)+$t+String:C10([Customers_Invoices:88]ProfitVariable:28)+$cr
		SAVE RECORD:C53([Customers_Invoices:88])
	End if 
	
	NEXT RECORD:C51([Customers_Invoices:88])
	uThermoUpdate($i)
End for 
uThermoClose

SEND PACKET:C103($docRef; xText)

BEEP:C151
BEEP:C151
CLOSE DOCUMENT:C267($docRef)
// obsolete call, method deleted 4/28/20 uDocumentSetType 
$err:=util_Launch_External_App(Document)