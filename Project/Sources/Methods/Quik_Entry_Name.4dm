//%attributes = {}
//Method:  Quik_Entry_Name
//Description:  This method handles verifying the name

If (True:C214)  //Initialize
	
	C_TEXT:C284($tReportName)
	
	C_OBJECT:C1216($oAsk)
	$oAsk:=New object:C1471()
	
End if   //Done Initialize

$tReportName:=Quik_Entry_LoadQueryReportT(\
->Quik_nEntry_ParentTable; \
->Quik_lEntry_Query; \
->Quik_lEntry_QuickReport)

Case of   //New or modify
		
	: ((Quik_tEntry_QuickKey=CorektBlank) & (Find in field:C653([Quick:85]Name:2; Quik_tEntry_Name)#CoreknNoMatchFound))
		
		$oAsk.tMessage:="The name "+Quik_tEntry_Name+" is not unique. Please rename the report."
		Core_Dialog_Alert($oAsk)
		
		Quik_tEntry_Name:=CorektBlank
		
		Quik_nEntry_ParentTable:=0
		SET BLOB SIZE:C606(Quik_lEntry_Query; 0)
		SET BLOB SIZE:C606(Quik_lEntry_QuickReport; 0)
		
		OBJECT SET VISIBLE:C603(Quik_nEntry_ShowQuery; True:C214)
		Quik_nEntry_ShowQuery:=1
		
	: (Quik_tEntry_Name=$tReportName)
		
	: ((Quik_tEntry_QuickKey#CorektBlank) & \
		(Find in field:C653([Quick:85]Name:2; $tReportName)#CoreknNoMatchFound))
		
		$oAsk.tMessage:="The name "+$tReportName+" is not unique. Please rename the report."
		Core_Dialog_Alert($oAsk)
		
	Else 
		
		Quik_tEntry_Name:=$tReportName
		
End case   //Done new or modify

Quik_Entry_Manager