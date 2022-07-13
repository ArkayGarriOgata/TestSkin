//%attributes = {}
//Method:  Rprt_Entry_Group
//Description:  This method handles the Group popup

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cCategory)
	
	C_OBJECT:C1216($esReport)
	
	C_TEXT:C284($tGroup)
	C_TEXT:C284($tQuery; $tTableName)
	
	$esReport:=New object:C1471()
	$cCategory:=New collection:C1472()
	
	$tGroup:=Rprt_atEntry_Group{Rprt_atEntry_Group}
	
	$tTableName:=Table name:C256(->[Report:66])
	
	$tQuery:="Group = "+CorektSingleQuote+$tGroup+CorektSingleQuote
	
End if   //Done initialize

$esReport:=ds:C1482[$tTableName].query($tQuery)

If (Not:C34(OB Is empty:C1297($esReport)))  //Valid
	
	$cCategory:=$esReport.distinct("Category")
	
	Compiler_Rprt_Array(Current method name:C684; 0)
	
	COLLECTION TO ARRAY:C1562($cCategory; Rprt_atEntry_Category)
	
	Rprt_Entry_Manager
	
End if   //Done valid
