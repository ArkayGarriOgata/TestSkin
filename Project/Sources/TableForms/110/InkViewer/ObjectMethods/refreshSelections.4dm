// _______
// Method: [ProductionSchedules].PrePressViewer.refreshSelections   ( ) ->
// By: MelvinBohince @ 03/04/22, 11:39:06
// Description
// 
// ----------------------------------------------------

Form:C1466.topLeftBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; Form:C1466.topLeftPress)
Form:C1466.bottomLeftBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; Form:C1466.bottomLeftPress)
Form:C1466.topRightBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; Form:C1466.topRightPress)
Form:C1466.bottomRightBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; Form:C1466.bottomRightPress)

$criterion_s:=PS_PrePressFilter
zwStatusMsg("PrePressViewer"; "Refresh selections @ "+TS2iso)
