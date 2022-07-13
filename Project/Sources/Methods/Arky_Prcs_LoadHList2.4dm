//%attributes = {}
//Method:  Arky_Prcs_LoadHList2(cArkyProcess)
//Description:  This will load the HList

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cArkyProcess)
	
	C_BOOLEAN:C305($bUseArray; $bExpanded)
	C_LONGINT:C283($nHListNumber)
	
	Compiler_Arky_Array(Current method name:C684; 0)
	Compiler_Arky_Array(Current method name:C684+"Parameter"; 4)
	
	$cArkyProcess:=New collection:C1472()
	$cArkyProcess:=$1
	
	$bUseArray:=True:C214
	$bExpanded:=False:C215
	
	$nHListNumber:=2
	
	COLLECTION TO ARRAY:C1562($cArkyProcess; \
		Arky_atPrcs_ArkyProcessKey; "Arky_Process_Key"; \
		Arky_atPrcs_Category; "Category"; \
		Arky_atPrcs_Title; "Title"; \
		Arky_atPrcs_Description; "Description")
	
	MULTI SORT ARRAY:C718(\
		Arky_atPrcs_Category; >; \
		Arky_atPrcs_Title; >; \
		Arky_atPrcs_Description; \
		Arky_atPrcs_ArkyProcessKey)
	
	Arky_apPrcs_Parameter2{CoreknHListTable}:=->$bUseArray
	Arky_apPrcs_Parameter2{CoreknHListPrimaryKey}:=->Arky_atPrcs_ArkyProcessKey
	Arky_apPrcs_Parameter2{CoreknHListFolder}:=->Arky_atPrcs_Category
	Arky_apPrcs_Parameter2{CoreknHListTitle}:=->Arky_atPrcs_Title
	
End if   //Done initialize

Core_HList_Initialize($nHListNumber; ->Arky_apPrcs_Parameter2)

Core_HList_Create($nHListNumber; $bExpanded)
