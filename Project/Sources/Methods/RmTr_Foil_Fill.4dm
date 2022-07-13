//%attributes = {}
//Method: RmTr_Foil_Fill(oOptions)
//Description:  This method is used to fill in dropdowns
//. These are hard coded into form [Raw_Materials_Transactions];"ColdFoilUsage"

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oOptions)
	
	$oOptions:=$1
	
	//Compiler_RmTr_Array (Current method name;0)
	
	//Form.vendorID:="03070"
	//Form.vendorName:="ITW"
	
	
	//Form.vendorID:="11128"
	//Form.vendorName:="Kurz"
	
	
	//Form.vendorID:="00690"
	//Form.vendorName:="Univacco"
	
	
	
End if   //Done initialize

//Form.matchingInventory_es:=Form.inventory_es.query("RAW_MATERIAL.Flex4 = :1 and RAW_MATERIAL.Flex2 = :2 and PO_ITEM.VendorID  = :3";\
Form.color;Form.width;Form.vendorID)


