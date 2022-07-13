//%attributes = {}
//Method:  Adrs_GetHarmonizedTariffCodeT (tAddressId)=>tHarmonizedTariffCode
//Description:  This method is currently hardcoded to tAddressId
//  Affected methods:
//.    FG_ShipPrintInternationInvoice 
//.    BOL_PrintDraft 
//.    BOL_PrintBillOfLading 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tAddressID; $0; $tHarmonizedTariffCode)
	
	$tId:=$1
	
	$tHarmonizedTariffCode:="4819.10.0040"  //Default
	
End if   //Done Initialize

Case of   //Hard code for address ID
		
	: (Not:C34(Core_Query_UniqueRecordB(->[Addresses:30]ID:1; ->$tAddressID)))  //Not a uniqued ID
		
	: ([Addresses:30]Country:9="GB")  //England
		
		$tHarmonizedTariffCode:="4819.20.00"
		
	: ([Addresses:30]Country:9="CH")  //Switzerland
		
		$tHarmonizedTariffCode:="4819.20.00"
		
	Else   //Use default
		
End case   //Done hard code for address ID

$0:=$tHarmonizedTariffCode
