//%attributes = {}
//Method:  Rprt_Pick_Save
//Description:  This method will save the SampleRaw report
//. It can be used to save the result of the last report run or
//. an example of the report

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oViewProArea; $eReport; $oSaveReport)
	
	C_TEXT:C284($tViewProArea)
	
	$eReport:=New object:C1471()
	$oSaveReport:=New object:C1471()
	
	$tViewProArea:="ViewProArea"
	
End if   //Done initialize

$eReport:=ds:C1482.Report.query("Report_Key = :1"; Form:C1466.tReport_Key).first()

$eReport.SampleRaw:=VP Export to object($tViewProArea)

$eReport.RunBy:=Current user:C182
$eReport.RunOn:=Current date:C33(*)
$eReport.RunCount:=$eReport.RunCount+1

$oSaveReport:=$eReport.save()
