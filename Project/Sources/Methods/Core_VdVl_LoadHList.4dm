//%attributes = {}
//Method:  Core_VdVl_LoadHList(esCoreValidValue)
//Description:  This will load the HList

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $esCoreValidValue)
	
	$esCoreValidValue:=$1
	
	Compiler_Core_Array("Core_VdVl_LoadHList"; 4)
	
	CoreapParameter{CoreknHListTable}:=->[Core_ValidValue:69]
	CoreapParameter{CoreknHListPrimaryKey}:=->[Core_ValidValue:69]Core_ValidValue_Key:1
	CoreapParameter{CoreknHListFolder}:=->[Core_ValidValue:69]Category:3
	CoreapParameter{CoreknHListTitle}:=->[Core_ValidValue:69]Identifier:2
	
	Core_HList_Clear("1"; True:C214)
	
End if   //Done initialize

If ($esCoreValidValue.length>0)  //Record
	
	$esCoreValidValue.orderBy("Category asc, Identifier asc")
	
	USE ENTITY SELECTION:C1513($esCoreValidValue)
	
	Core_HList_Initialize(1; ->CoreapParameter)
	
	Core_HList_Create(1)
	
Else   //No record
	
	CorenHList1:=0
	
	Core_HList_Clear("1"; True:C214)
	
End if   //Done record  

REDRAW:C174(CorenHList1)
