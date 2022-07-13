//%attributes = {"publishedWeb":true}
//PM: FG_ShipPrintInternationInvoice() -> 
//formerly rIntlInvoice  
//print an nternational invoice for customs(?)
//$1 - string - anythign, flag stopprint setting dialog
//• 3/27/98 cs created
// Modified by: Garri Ogata (6/9/21) Return false so it continues thru case statement

C_BOOLEAN:C305($0)  // Added by: Garri Ogata (6/9/21) 

C_LONGINT:C283($numItems; $i; $currRel; $invoiceNum)
C_TEXT:C284(xText; xText2)

xText:=""
util_PAGE_SETUP(->[Customers_Bills_of_Lading:49]; "IntlInvoice")
FORM SET OUTPUT:C54([Customers_Bills_of_Lading:49]; "IntlInvoice")

RELATE MANY:C262([Customers_Bills_of_Lading:49]Manifest:16)

$numItems:=Records in selection:C76([Customers_Bills_of_Lading_Manif:181])
ORDER BY:C49([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]Arkay_Release:4; >)  //subtotaled by release

$currRel:=[Customers_Bills_of_Lading_Manif:181]Arkay_Release:4
$subrel:=[Customers_Bills_of_Lading_Manif:181]Total_Rel:12  // 
$invoiceNum:=[Customers_Bills_of_Lading_Manif:181]InvoiceNumber:13

For ($i; 1; $numItems)
	PDF_setUp("bolinv-"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"-"+String:C10($i)+".pdf"; False:C215)
	xText2:=String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"-"+String:C10($i)  //fake invoice number
	xText:=txt_Pad([Customers_Bills_of_Lading_Manif:181]Cust_Release:3; " "; 1; 22)  //$custRel)
	xText:=xText+txt_Pad([Customers_Bills_of_Lading_Manif:181]CPN:5; " "; 1; 20)+Char:C90(13)+Char:C90(13)
	xText:=xText+txt_Pad(String:C10([Customers_Bills_of_Lading_Manif:181]NumCases:6); " "; -1; 15)
	xText:=xText+txt_Pad(String:C10([Customers_Bills_of_Lading_Manif:181]Count_PerCase:8); " "; -1; 15)
	xText:=xText+txt_Pad(String:C10([Customers_Bills_of_Lading_Manif:181]Total_Amt:9); " "; -1; 15)
	
	If ([Customers_ReleaseSchedules:46]ReleaseNumber:1#[Customers_Bills_of_Lading_Manif:181]Arkay_Release:4)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=[Customers_Bills_of_Lading_Manif:181]Arkay_Release:4)
	End if 
	
	If ([Customers_Order_Lines:41]OrderLine:3#[Customers_ReleaseSchedules:46]OrderLine:4)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_ReleaseSchedules:46]OrderLine:4)
	End if 
	xText:=xText+txt_Pad(String:C10([Customers_Order_Lines:41]Price_Per_M:8; "$###,###,##0.00"); " "; -1; 20)
	xText:=xText+txt_Pad(String:C10([Customers_Order_Lines:41]Price_Per_M:8*([Customers_Bills_of_Lading_Manif:181]Total_Amt:9/1000); "$###,###,##0.00"); " "; -1; 15)+" USD"+Char:C90(13)
	NEXT RECORD:C51([Customers_Bills_of_Lading_Manif:181])
	PRINT RECORD:C71([Customers_Bills_of_Lading:49]; >)
End for 

FORM SET OUTPUT:C54([Customers_Bills_of_Lading:49]; "list")

$0:=False:C215  //Return so it will continue thru
