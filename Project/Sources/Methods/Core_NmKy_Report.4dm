//%attributes = {}
//Method:  Core_NmKy_Report
//Description:  This method will generate a report of where things are found.

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cName)
	C_COLLECTION:C1488($cNameValue)
	
	C_COLLECTION:C1488($cKey)
	C_COLLECTION:C1488($cKeyValue)
	
	C_POINTER:C301($pNewName; $pNewKey)
	
	C_OBJECT:C1216($oNameKey)
	
	$cName:=New collection:C1472()
	$cNameValue:=New collection:C1472()
	
	$cKey:=New collection:C1472()
	$cKeyValue:=New collection:C1472()
	
	ARRAY TO COLLECTION:C1563($cName; Core_atNmKy_Name)
	ARRAY TO COLLECTION:C1563($cNameValue; Core_atNmKy_NameValue)
	ARRAY TO COLLECTION:C1563($cKey; Core_atNmKy_Key)
	ARRAY TO COLLECTION:C1563($cKeyValue; Core_atNmKy_KeyValue)
	
	$cName:=$cName.distinct().orderBy().remove(0)
	$cNameValue:=$cNameValue.distinct().orderBy().remove(0)
	$cKey:=$cKey.distinct().orderBy().remove(0)
	$cKeyValue:=$cKeyValue.distinct().orderBy().remove(0)
	
	$oNameKey:=New object:C1471()
	
	$oNameKey.cName:=$cName
	$oNameKey.cNameValue:=$cNameValue
	$oNameKey.cKey:=$cKey
	$oNameKey.cKeyValue:=$cKeyValue
	$oNameKey.nOmitZero:=Core_nNmKy_OmitZero
	$oNameKey.nDelete:=Core_nNmKy_Delete
	
	If (Core_tNmKy_NewName#CorektBlank)
		$oNameKey.pNewName:=->Core_tNmKy_NewName
	End if 
	
	If (Core_tNmKy_NewKey#CorektBlank)
		$oNameKey.pNewKey:=->Core_tNmKy_NewKey
	End if 
	
End if   //Done initialize

Core_Table_DocFindField($oNameKey)
