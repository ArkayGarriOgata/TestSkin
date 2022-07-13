//%attributes = {}
//Method: _Version220318
//Desctiption:  This method was add so we could see jobs that are missing board

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($eBatch; $eDistribution; $oResult)
	
	C_TEXT:C284($tSaved)
	
	$eBatch:=New object:C1471()
	$eDistribution:=New object:C1471()
	$oResult:=New object:C1471()
	
	$tSaved:=CorektBlank
	
End if   //Done initialize

$eBatch:=ds:C1482.y_batches.new()

$eBatch.BatchName:="Jobs Missing Board"
$eBatch.Daily:=True:C214
$eBatch.Description:="List of completed jobs that do not have board associated to them."
$eBatch.sort_order:=91

$oResult:=$eBatch.save()

$tSaved:=Choose:C955($oResult.success; "Saved"; "Failed")

ALERT:C41("y_batches"+CorektSpace+$tSaved)

$eDistribution:=ds:C1482.y_batch_distributions.new()

$eDistribution.BatchName:="Jobs Missing Board"
$eDistribution.EmailAddress:="Jessica.Bryant@arkay.com"

$oResult:=$eDistribution.save()

$tSaved:=Choose:C955($oResult.success; "Saved"; "Failed")

ALERT:C41("y_batch_distributions"+CorektSpace+$tSaved)