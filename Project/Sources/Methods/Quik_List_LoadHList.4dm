//%attributes = {}
//Method:  Quik_List_LoadHList
//Description:  This will load the HList

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bUseArray)
	C_LONGINT:C283($nHListNumber)
	
	ARRAY TEXT:C222($atQuickReportFile; 0)
	ARRAY TEXT:C222($atGroup; 0)
	
	Compiler_Quik_Array(Current method name:C684; 0)
	Compiler_Quik_Array(Current method name:C684+"Parameter"; 4)
	
	$bUseArray:=True:C214
	$nHListNumber:=1
	
	Quik_apList_Parameter{CoreknHListTable}:=->$bUseArray
	Quik_apList_Parameter{CoreknHListPrimaryKey}:=->Quik_atList_QuickKey
	Quik_apList_Parameter{CoreknHListFolder}:=->Quik_atList_Category
	Quik_apList_Parameter{CoreknHListTitle}:=->Quik_atList_Name
	
End if   //Done initialize

Grup_GetUsersGroup(->$atGroup)

If (Find in array:C230($atGroup; GrupktDevelopment)=CoreknNoMatchFound)
	
	QUERY WITH ARRAY:C644([Quick:85]Group:3; $atGroup)
	
Else 
	
	ALL RECORDS:C47([Quick:85])
	
End if   //Done get reports

SELECTION TO ARRAY:C260(\
[Quick:85]Quick_Key:1; Quik_atList_QuickKey; \
[Quick:85]Category:4; Quik_atList_Category; \
[Quick:85]Name:2; Quik_atList_Name)

MULTI SORT ARRAY:C718(Quik_atList_Category; >; Quik_atList_Name; >; Quik_atList_QuickKey)

Core_HList_Initialize($nHListNumber; ->Quik_apList_Parameter)

Core_HList_Create($nHListNumber)
