//%attributes = {"publishedWeb":true}
//JIC_Createobform;jobitemn;subformNº;fgkey;{;matl;labor;burden;qt})->recnº 
// or JIC_Create(jobit)->recnº 110999  mlb
//create a JobItemCost record
//utl_Trace 
// • mel (2/10/04, marty tests canHaveExcess == false
// • mel (2/18/04, marty sets want to include a 10% overage
// • mel (1/9/09, brian want to include a 5% overage across the board
// Modified by: Mel Bohince (1/15/13) remove 5% overage, complicates reconciliation

C_TEXT:C284($1)
C_TEXT:C284($4)
C_LONGINT:C283($2)
C_REAL:C285($5; $6; $7; $allowedOverRun)

$allowedOverRun:=1  //.05  // • mel (1/9/09, brian want to include a 5% overage across the board 1/15/13 removed 5%

C_LONGINT:C283($3; $0; $numJIC; $numJMI; $8; $qty)
$params:=Count parameters:C259
$form:=""
$item:=0
$hasSubform:=False:C215
$fgkey:=""
$matl:=0
$labor:=0
$burden:=0
$setCosts:=($params>4)
$qty:=0

Case of 
	: ($params=1)
		$numJMI:=qryJMI($1)
		If ($numJMI>0)
			
			$form:=[Job_Forms_Items:44]JobForm:1
			$item:=[Job_Forms_Items:44]ItemNumber:7
			$hasSubform:=([Job_Forms_Items:44]SubFormNumber:32>0)
			$fgkey:=[Job_Forms_Items:44]CustId:15+":"+[Job_Forms_Items:44]ProductCode:3
			
			If (Not:C34([Job_Forms_Items:44]FormClosed:5))  //use the budgeted costs
				$qty:=[Job_Forms_Items:44]Qty_Want:24*$allowedOverRun
				$matl:=$qty/1000*[Job_Forms_Items:44]PldCostMatl:17
				$labor:=$qty/1000*[Job_Forms_Items:44]PldCostLab:18
				$burden:=$qty/1000*[Job_Forms_Items:44]PldCostOvhd:19
				
			Else   //use the actuals
				If (canHaveExcess)
					If ([Job_Forms_Items:44]Qty_Good:10>([Job_Forms_Items:44]Qty_Want:24*$allowedOverRun))
						$qty:=[Job_Forms_Items:44]Qty_Want:24*$allowedOverRun
					Else 
						$qty:=[Job_Forms_Items:44]Qty_Good:10
					End if 
					
				Else 
					$qty:=[Job_Forms_Items:44]Qty_Good:10
				End if 
				$matl:=$qty/1000*[Job_Forms_Items:44]Cost_Mat:12
				$labor:=$qty/1000*[Job_Forms_Items:44]Cost_LAB:13
				$burden:=$qty/1000*[Job_Forms_Items:44]Cost_Burd:14
			End if 
			
			$setCosts:=True:C214
		End if 
		
	Else 
		$form:=$1
		$item:=$2
		$hasSubform:=($3>0)
		$fgkey:=$4
		If ($setCosts)
			$matl:=$5
			$labor:=$6
			$burden:=$7
			$qty:=$8
		End if 
End case 

$jobit:=JMI_makeJobIt($form; $item)

QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3=$jobit)
If (Records in selection:C76([Job_Forms_Items_Costs:92])=0)  //subform situation may have already created
	CREATE RECORD:C68([Job_Forms_Items_Costs:92])
	[Job_Forms_Items_Costs:92]JobForm:1:=$form
	[Job_Forms_Items_Costs:92]ItemNumber:2:=$item
End if 

[Job_Forms_Items_Costs:92]FG_Key:13:=$fgkey
[Job_Forms_Items_Costs:92]hasSubForms:8:=$hasSubform

If ($setCosts)
	[Job_Forms_Items_Costs:92]AllocatedMaterial:4:=[Job_Forms_Items_Costs:92]AllocatedMaterial:4+Round:C94($matl; 2)
	[Job_Forms_Items_Costs:92]AllocatedLabor:5:=[Job_Forms_Items_Costs:92]AllocatedLabor:5+Round:C94($labor; 2)
	[Job_Forms_Items_Costs:92]AllocatedBurden:6:=[Job_Forms_Items_Costs:92]AllocatedBurden:6+Round:C94($burden; 2)
	[Job_Forms_Items_Costs:92]AllocatedQuantity:14:=[Job_Forms_Items_Costs:92]AllocatedQuantity:14+$qty
End if 

[Job_Forms_Items_Costs:92]AllocatedTotal:7:=[Job_Forms_Items_Costs:92]AllocatedMaterial:4+[Job_Forms_Items_Costs:92]AllocatedLabor:5+[Job_Forms_Items_Costs:92]AllocatedBurden:6

SAVE RECORD:C53([Job_Forms_Items_Costs:92])

$0:=Record number:C243([Job_Forms_Items_Costs:92])