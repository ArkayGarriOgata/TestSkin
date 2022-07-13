//%attributes = {}
//Method: Tgsn_PrGb_GetDescriptionT(tProductCode)=>tDescription
//Description:  This method will return the product description

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tProductCode)
	C_TEXT:C284($0; $tDescription)
	
	$tProductCode:=$1
	$tDescription:=CorektBlank
	
End if   //Done Initialize

If (Core_Query_UniqueRecordB(->[Finished_Goods:26]ProductCode:1; ->$tProductCode))  //Get [Finished_Goods]
	
	$tDescription:=[Finished_Goods:26]CartonDesc:3
	
End if   //Done get [Finished_Goods]

$0:=$tDescription
