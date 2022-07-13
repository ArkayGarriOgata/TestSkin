//%attributes = {}
/*
 Method: CostCtrClass_tests ( ) ->
 By: MelvinBohince @ 06/24/22, 08:42:57
 Description:
  simulate having a Estimates machine route
     calculated for hours, costs, and quantities
  should be comparable to Est_FormCostsCalculation
 Example Use:
  just run
*/

CostCtrInit  //set up the standards in storage

$est_differencialToTest:="2-0801.00AA01"

$job_e:=ds:C1482.Estimates_DifferentialsForms.query("DiffFormId = :1"; $est_differencialToTest).first()
$route_es:=ds:C1482.Estimates_Machines.query("DiffFormID = :1 order by Sequence desc"; $est_differencialToTest)

var $costCenterStds_o; $status_o : Object
var $machine_e : cs:C1710.Estimates_Machines
var $costCenter_o : cs:C1710.CostCenter

$jobDetail_o:=New object:C1471
$jobDetail_o.netSheets:=$job_e.NumberSheets
//$costCenter_o:=cs.CostCenterPrinting.new("420")

For each ($machine_e; $route_es)
	$sequenceDetail_o:=New object:C1471()
	//estiblish its class membership based on cc_group
	
	$costCenterStds_o:=Storage:C1525.CostCenters.query("cc = :1"; $machine_e.CostCtrID).shift()  //
	$className:="CostCenter"+util_camelCase(Substring:C12($costCenterStds_o.group; 4); "capFirstChar")
	
	//instanciate its class
	$costCenter_o:=cs:C1710[$className].new($machine_e.CostCtrID)
	
	$machine_e.Qty_Waste:=$costCenter_o.getWaste($jobDetail_o)
	
	$machine_e.MakeReadyHrs:=$costCenter_o.getWaste($sequenceDetail_o)
	
	
	$status_o:=$machine_e.save(dk auto merge:K85:24)
	If ($status_o.success)
		zwStatusMsg("SUCCESS"; "Sequence "+String:C10($release_e.Sequence)+" mode applied.")
		
	Else 
		BEEP:C151
		zwStatusMsg("FAIL"; "Sequence "+String:C10($release_e.Sequence)+" did not save.")
	End if 
	
	//perform the need calculations
	
End for each 

/*
Estimates_DifferentialsForms
Caliper
NumberSheets
NumItems
Lenth
Width

Estimates_Machines
Flex_field1 - 7
MakeReadyHrs
Qty_Gross
Qty_Net
Qty_Waste
RunningHrs
RunningRate
Sequence
*/
