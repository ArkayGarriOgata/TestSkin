//%attributes = {}
//Method:  Rprt_Entry_Delete
//Description:  This method will delete [Report] and [Rprt_Criterion] records

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esReport; $esRprt_Criterion)
	C_OBJECT:C1216($esNotDropped)
	
	C_OBJECT:C1216($oConfirm)
	
	$esReport:=New object:C1471()
	$esRprt_Criterion:=New object:C1471()
	
	$esNotDropped:=New object:C1471()
	
	$oConfirm:=New object:C1471()
	
	$oConfirm.tMessage:="Are you sure you want to delete "+Form:C1466.tName+"?"
	
	$oConfirm.tDefault:="No"
	$oConfirm.tCancel:="Delete"
	
End if   //Done initialize

If (Core_Dialog_ConfirmN($oConfirm)=CoreknCancel)
	
	$esReport:=ds:C1482.Report.query("Report_Key = :1"; Form:C1466.tReport_Key)
	
	$esNotDropped:=$esReport.drop()
	
	$esRprt_Criterion:=ds:C1482.Rprt_Criterion.query("Report_Key = :1"; Form:C1466.tReport_Key)
	
	$esNotDropped:=$esRprt_Criterion.drop()
	
End if 
