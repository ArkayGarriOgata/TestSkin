//%attributes = {}
//Method:  Ship_Invc_CanadaFormEvent
//Description:  This method will

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nSkidWeight)
	
	C_TEXT:C284($tVendor)
	C_TEXT:C284($tCommodity)
	C_TEXT:C284($tTransportation)
	C_TEXT:C284($tLbs)
	
	$nSkidWeight:=40
	
	$tVendor:="ARKAY PACKAGKING"+CorektCR+\
		"350 East Park Drive"+CorektCR+\
		"Roanoke, VA  24019"
	
	$tCommodity:="K-Dot Corrugated Folding Cartons"
	
	$tTransportation:="Delmar"
	
	$tLbs:="lb"
	
	OBJECT SET VISIBLE:C603(Ship_nInvc_Canada; False:C215)  //Hide form event button
	
End if   //Done initialize

Ship_tInvc_Page:="1"
Ship_tInvc_PageCount:="1"

Ship_tInvc_Vendor:=$tVendor  //1

Ship_tInvc_ShipDate:=[Customers_Bills_of_Lading:49]ShipDate:20  //2
Ship_tInvc_Reference:=CorektBlank  //3

Ship_tInvc_Consignee:=fGetAddressText([Customers_Bills_of_Lading:49]ShipTo:3; CorektAsterisk)  //4

Ship_tInvc_Purchase:=fGetAddressText([Customers_Bills_of_Lading:49]BillTo:4; CorektAsterisk)  //5

Ship_tInvc_Country:="USA"  //6

Ship_tInvc_CountryOrigin:="USA"  //7

Ship_tInvc_Transportation:=$tTransportation  //8

Ship_tInvc_Sale:="Sale"  //9

Ship_tInvc_Currency:="US Dollar"  //10

Ship_tInvc_PackageCount:=String:C10([Customers_Bills_of_Lading:49]Total_Cases:14)+CorektSpace+"Cases"  //11

Ship_tInvc_Commodity:=$tCommodity  //12

Ship_tInvc_Quantity:=String:C10([Customers_Bills_of_Lading:49]Total_Cases:14)+CorektSpace+"Cases"  //13

Ship_tInvc_Price:=String:C10(Round:C94([Customers_Bills_of_Lading:49]DeclaredValue:33/[Customers_Bills_of_Lading:49]Total_Cases:14; 2); "$##,###,###.00")  //14

Ship_tInvc_Total:=String:C10([Customers_Bills_of_Lading:49]DeclaredValue:33; "$##,###,###.00")  //15

Ship_tInvc_WeightNet:=String:C10([Customers_Bills_of_Lading:49]Total_Wgt:18-([Customers_Bills_of_Lading:49]Total_Skids:17*$nSkidWeight))+CorektSpace+$tLbs  //16a
Ship_tInvc_WeightGross:=String:C10([Customers_Bills_of_Lading:49]Total_Wgt:18)+CorektSpace+$tLbs  //16b

Ship_tInvc_InvoiceTotal:=String:C10([Customers_Bills_of_Lading:49]DeclaredValue:33; "$##,###,###.00")  //17 Invoice

Ship_tInvc_CommercialInvoice:=[Customers_Bills_of_Lading:49]ShippersNo:1  //18a see FG_ShipPrintInternationInvoice (~30) Fake invoice number
Ship_tInvc_CheckCommercial:="X"  //18b

Ship_tInvc_Exporter:=CorektBlank  //19
Ship_tInvc_Originator:=CorektBlank  //20

Ship_tInvc_Agency:=CorektBlank  //21
Ship_tInvc_CheckNotApplicable:="X"  //22

Ship_tInvc_Expenses:=CorektBlank  //23i
Ship_tInvc_Assembly:=CorektBlank  //23ii
Ship_tInvc_Export:=CorektBlank  //23iii

Ship_tInvc_ExpensesCost:=CorektBlank  //24i
Ship_tInvc_AssemblyCost:=CorektBlank  //24ii
Ship_tInvc_ExportCost:=CorektBlank  ///24iii

Ship_tInvc_CheckRoyalty:=CorektBlank  //25i blank it
Ship_tInvc_CheckPurchaser:=CorektBlank  //25ii blank it
