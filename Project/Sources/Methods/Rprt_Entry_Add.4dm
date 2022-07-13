//%attributes = {}
//Method:  Rprt_Entry_Add
//Description:  This method will add a [Rprt_Criterion] record to be modified in the list box

If (True:C214)
	
	C_OBJECT:C1216($eRprt_Criterion; $oSave)
	
	$eRprt_Criterion:=New object:C1471()
	$oSave:=New object:C1471()
	
End if 

$eRprt_Criterion:=ds:C1482.Rprt_Criterion.new()

$eRprt_Criterion.Report_Key:=Form:C1466.tReport_Key
$eRprt_Criterion.Rprt_Criterion_Key:=Generate UUID:C1066

$oSave:=$eRprt_Criterion.save()

Form:C1466.esRprt_CriterionList:=ds:C1482.Rprt_Criterion.query("Report_Key = :1"; Form:C1466.tReport_Key).orderBy("Title asc")
