// _______
// Method: [ProductionSchedules].PrePressViewer.settings   ( ) ->
// By: MelvinBohince @ 03/07/22, 08:33:18
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($costCenters_t)
$costCenters:=Request:C163("Which cost centers?(separate with commas)"; "420,421,418,419")
If (Length:C16($costCenters)=15) & (ok=1)
	
	C_COLLECTION:C1488($costCenters_c)
	$costCenters_c:=New collection:C1472
	$costCenters_c:=Split string:C1554($costCenters; ",")
	
	//pairing press id's to each quadrant
	Form:C1466.topLeftPress:=$costCenters_c[0]
	Form:C1466.bottomLeftPress:=$costCenters_c[1]
	Form:C1466.topRightPress:=$costCenters_c[2]
	Form:C1466.bottomRightPress:=$costCenters_c[3]
	
	//selected job sequences of last clicked quadrant
	Form:C1466.activeJobSequence_t:=""
	
	//base entity selections for each quad to filter against on the form
	Form:C1466.topLeftBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; Form:C1466.topLeftPress)
	Form:C1466.bottomLeftBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; Form:C1466.bottomLeftPress)
	Form:C1466.topRightBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; Form:C1466.topRightPress)
	Form:C1466.bottomRightBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; Form:C1466.bottomRightPress)
	
	
	$criterion_s:=PS_PrePressFilter
	zwStatusMsg("PrePressViewer"; "Filter: "+$criterion_s)
	
End if 
