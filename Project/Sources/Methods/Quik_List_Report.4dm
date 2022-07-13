//%attributes = {}
//Method:  Quik_List_Report (tQuick_Key)
//Description:  This method will  

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tQuick_Key)
	
	C_OBJECT:C1216($oQuickReport)
	
	$tQuick_Key:=$1
	
	$oQuickReport:=New object:C1471()
	
End if   //Done Initialize

If (Core_Query_UniqueRecordB(->[Quick:85]Quick_Key:1; ->$tQuick_Key))  //Unique
	
	$oQuickReport.nParentTable:=[Quick:85]ParentTable:6
	$oQuickReport.tDocumentName:=[Quick:85]Name:2
	
	QkRp_LaunchExcel($oQuickReport; [Quick:85]QuickReport:7)
	
End if   //Done unique