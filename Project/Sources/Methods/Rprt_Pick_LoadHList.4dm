//%attributes = {}
//Method:  Rprt_Pick_LoadHList
//Description:  This method will load the HList for reports

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esReport)
	
	ARRAY TEXT:C222($atGroup; 0)
	
	$esReport:=New object:C1471()
	
	Grup_GetUsersGroup(->$atGroup)
	
	APPEND TO ARRAY:C911($atGroup; Current user:C182)
	
	If (Find in array:C230($atGroup; GrupktDevelopment)=CoreknNoMatchFound)
		
		QUERY WITH ARRAY:C644([Report:66]Group:2; $atGroup)
		
	Else 
		
		ALL RECORDS:C47([Report:66])
		
	End if   //Done get reports
	
	Compiler_Rprt_Array(Current method name:C684; 4)
	
	RprtapParameter{CoreknHListTable}:=->[Report:66]
	RprtapParameter{CoreknHListPrimaryKey}:=->[Report:66]Report_Key:1
	RprtapParameter{CoreknHListFolder}:=->[Report:66]Category:7
	RprtapParameter{CoreknHListTitle}:=->[Report:66]Name:3
	
End if   //Done initialize

ORDER BY:C49([Report:66]; [Report:66]Category:7; >; [Report:66]Name:3; >)

If (Records in selection:C76([Report:66])>0)  //Record
	
	Core_HList_Initialize(1; ->RprtapParameter)
	
	Core_HList_Create(1; True:C214)
	
	UNLOAD RECORD:C212([Report:66])
	
Else 
	
	CorenHList1:=0
	
End if   //Done record  

REDRAW:C174(CorenHList1)

