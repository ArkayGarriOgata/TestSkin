//%attributes = {}
//Method: JbMc_Rprt_RunRate(oRunRate)
//Description: This method handles the run rates

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oRunRate)
	
	ARRAY TEXT:C222($atJobSequence; 0)
	
	C_COLLECTION:C1488($cJobSequence)
	C_COLLECTION:C1488($cWorkSheet)
	C_COLLECTION:C1488($cRow)
	C_COLLECTION:C1488($cCostCenter)
	
	C_DATE:C307($dDay)
	
	C_REAL:C285($rMRMin; $rMRMax; $rMRDelta)  //Make Ready
	C_REAL:C285($rRunMin; $rRunMax; $rRunDelta)
	C_REAL:C285($rRunRateMin; $rRunRateMax; $rRunRateDelta)
	C_REAL:C285($rRunRatePercent)
	
	C_OBJECT:C1216($esJobFormsMachines)
	C_OBJECT:C1216($eJobFormsmachines)
	
	$oRunRate:=$1
	
	$cJobSequence:=New collection:C1472()
	$cWorkSheet:=New collection:C1472()
	$cRow:=New collection:C1472()
	$cCostCenter:=New collection:C1472()
	
	$dDay:=!2021-09-23!
	
	$hMidNight:=?13:59:59?
	
	$nStart:=TSTimeStamp($oRunRate.dStart; $hMidNight)
	$nEnd:=TSTimeStamp($oRunRate.dEnd; $hMidNight)
	
	$esJobFormsMachines:=New object:C1471()
	$eJobFormsmachines:=New object:C1471()
	
	$rMRMin:=-0.25
	$rMRMax:=0.25
	
	$rRunMin:=-0.5
	$rRunMax:=0.5
	
	$rRunRatePercent:=0.1
	
	$tBad:="Off by"+CorektSpace
	$tGood:="Acceptable delta"+CorektSpace
	
	$cCostCenter.push("476")
	$cCostCenter.push("478")
	$cCostCenter.push("479")
	$cCostCenter.push("480")
	$cCostCenter.push("481")
	$cCostCenter.push("482")
	$cCostCenter.push("483")
	$cCostCenter.push("484")
	$cCostCenter.push("485")
	$cCostCenter.push("487")
	$cCostCenter.push("491")
	
End if   //Done initialize

$cJobSequence:=ds:C1482.Job_Forms_Machine_Tickets.query(\
"TimeStampEntered > :1 &"+CorektSpace+\
"TimeStampEntered <= :2 &"+CorektSpace+\
"CostCenterID IN :3"; \
$nStart; \
$nEnd; \
$cCostCenter).toCollection("JobFormSeq").distinct("JobFormSeq")

COLLECTION TO ARRAY:C1562($cJobSequence; $atJobSequence)

QUERY WITH ARRAY:C644([Job_Forms_Machines:43]JobSequence:8; $atJobSequence)

$esJobFormsMachines:=Create entity selection:C1512([Job_Forms_Machines:43])

$esJobFormsMachines.orderBy(\
"CostCenterID asc,"+CorektSpace+\
"ModDate asc,"+CorektSpace+\
"JobForm asc")

$cRow.clear()

$cRow.push("Gluer")
$cRow.push("Job Form")
$cRow.push("Operators")
$cRow.push("Comment")

$cRow.push("Actual MR Hrs")
$cRow.push("Planned MR Hrs")
$cRow.push("Make Ready")
$cRow.push("Actual Run Hrs")
$cRow.push("Planned Run Hrs")
$cRow.push("Run Time")
$cRow.push("Actual Run Rate")
$cRow.push("Planned Run Rate")
$cRow.push("Run Rate")

$cRow.push("Down Time")

$cWorkSheet.push($cRow.copy())  //Add header

For each ($eJobFormsmachines; $esJobFormsMachines)  //JobFormsMachines
	
	$rMRDelta:=$eJobFormsMachines.Actual_MR_Hrs-$eJobFormsMachines.Planned_MR_Hrs
	
	$rRunDelta:=$eJobFormsMachines.Actual_RunHrs-$eJobFormsMachines.Planned_RunHrs
	
	$rRunRateDelta:=$eJobFormsMachines.Actual_RunRate-$eJobFormsMachines.Planned_RunRate
	
	$tMR:=Choose:C955(\
		(($rMRDelta<$rMRMin) | ($rMRDelta>$rMRMax)); \
		$tBad+String:C10($rMRDelta); \
		$tGood+String:C10($rMRDelta))
	
	$tRun:=Choose:C955(\
		(($rRunDelta<$rRunMin) | ($rRunDelta>$rRunMax)); \
		$tBad+String:C10($rRunDelta); \
		$tGood+String:C10($rRunDelta))
	
	$rRunRateMin:=-($eJobFormsMachines.Planned_RunRate*$rRunRatePercent)
	$rRunRateMax:=($eJobFormsMachines.Planned_RunRate*$rRunRatePercent)
	
	$tRunRate:=Choose:C955(\
		(($rRunRateDelta<$rRunRateMin) | ($rRunRateDelta>$rRunRateMax)); \
		$tBad+String:C10($rRunRateDelta); \
		$tGood+String:C10($rRunRateDelta))
	
	$tDownTime:=String:C10($eJobFormsMachines.Downtime)
	
	$cRow.clear()
	
	$cRow.push($eJobFormsMachines.CostCenterID)
	$cRow.push($eJobFormsMachines.JobForm)
	$cRow.push($eJobFormsMachines.Operators)
	$cRow.push($eJobFormsMachines.Comment)
	
	$cRow.push($eJobFormsMachines.Actual_MR_Hrs)
	$cRow.push($eJobFormsMachines.Planned_MR_Hrs)
	$cRow.push($tMR)
	
	$cRow.push($eJobFormsMachines.Actual_RunHrs)
	$cRow.push($eJobFormsMachines.Planned_RunHrs)
	$cRow.push($tRun)
	
	$cRow.push($eJobFormsMachines.Actual_RunRate)
	$cRow.push($eJobFormsMachines.Planned_RunRate)
	$cRow.push($tRunRate)
	
	$cRow.push($tDownTime)
	
	$cWorkSheet.push($cRow.copy())
	
End for each   //Done JobFormsMachines

Core_Cltn_DocumentTo($cWorkSheet; "Run Rates for "+Core_Date_yyyymmddT($dDay))
