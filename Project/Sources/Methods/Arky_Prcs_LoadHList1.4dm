//%attributes = {}
//Method:  Arky_Prcs_LoadHList1(tProcess)
//Description:  This will load the HList1

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tProcess)
	
	C_BOOLEAN:C305($bUseArray; $bExpanded)
	C_LONGINT:C283($nHListNumber)
	
	ARRAY TEXT:C222($atTableName; 0)
	ARRAY TEXT:C222($atFieldName; 0)
	
	Compiler_Arky_Array(Current method name:C684; 0)
	Compiler_Arky_Array(Current method name:C684+"Parameter"; 4)
	
	$tProcess:=$1
	
	$bUseArray:=True:C214
	$bExpanded:=False:C215
	
	$nHListNumber:=1
	
	Arky_apPrcs_Parameter1{CoreknHListTable}:=->$bUseArray
	Arky_apPrcs_Parameter1{CoreknHListPrimaryKey}:=->Arky_atPrcs_TableField
	Arky_apPrcs_Parameter1{CoreknHListFolder}:=->Arky_atPrcs_TableName
	Arky_apPrcs_Parameter1{CoreknHListTitle}:=->Arky_atPrcs_FieldName
	
End if   //Done initialize

Arky_Prcs_LoadTable($tProcess)  //Loads Arky_atPrcs_TableField, Arky_atPrcs_TableName and Arky_atPrcs_FieldName

Core_HList_Initialize($nHListNumber; ->Arky_apPrcs_Parameter1)

Core_HList_Create($nHListNumber; $bExpanded)
