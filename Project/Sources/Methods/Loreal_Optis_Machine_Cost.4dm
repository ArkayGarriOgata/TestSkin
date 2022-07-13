//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/13/13, 15:53:16
// ----------------------------------------------------
// Method: Loreal_Optis_Machine_Cost
// ----------------------------------------------------

C_LONGINT:C283($i; $hit; $cost_index)
C_REAL:C285($0)
C_TEXT:C284($1; $msg; $differential; $2)

$msg:=$1

Case of 
	: ($msg="init")
		$differential:=$2  //"3-0869.00AA01"  //$1// see standards grouping
		ARRAY TEXT:C222($aGroup; 0)
		ARRAY TEXT:C222($aRunning; 0)
		ARRAY TEXT:C222($aSetup; 0)
		
		Begin SQL
			select c.cc_Group, cast(sum((e.RunningHrs*e.OOPStd)) as varchar), cast(sum((e.MakeReadyHrs*e.OOPStd)) as varchar) 
			from Estimates_Machines e, Cost_Centers c 
			where e.DiffFormID = :$differential and c.ID = e.CostCtrID 
			group by c.cc_Group
			into <<$aGroup>>, <<$aRunning>>, <<$aSetup>>
			
		End SQL
		SORT ARRAY:C229($aGroup; $aRunning; $aSetup; >)
		
		//now breakdown by loreal's interest
		ARRAY TEXT:C222(aVariable_production; 0)
		ARRAY REAL:C219(aVariable_mr_costs; 0)
		ARRAY REAL:C219(aVariable_run_costs; 0)
		ARRAY TEXT:C222(aVariable_production; 6)
		ARRAY REAL:C219(aVariable_mr_costs; 6)
		ARRAY REAL:C219(aVariable_run_costs; 6)
		aVariable_production{1}:="printing"
		aVariable_production{2}:="stamping"
		aVariable_production{3}:="blanking"
		aVariable_production{4}:="gluing"
		aVariable_production{5}:="antidiverstion"
		aVariable_production{6}:="other"
		
		
		For ($i; 1; Size of array:C274($aGroup))
			$cost_index:=0
			Case of 
				: ($aGroup{$i}="20.PRINTING")
					$cost_index:=1
					
				: ($aGroup{$i}="50.STAMPING")
					$cost_index:=2
					
				: ($aGroup{$i}="55.BLANKING")
					$cost_index:=3
					
				: ($aGroup{$i}="80.FINISHING")
					$cost_index:=4
					
				Else   // other
					$cost_index:=6
			End case 
			aVariable_mr_costs{$cost_index}:=aVariable_mr_costs{$cost_index}+Num:C11($aSetup{$i})
			aVariable_run_costs{$cost_index}:=aVariable_run_costs{$cost_index}+Num:C11($aRunning{$i})
		End for 
		$0:=Size of array:C274($aGroup)
		
	: ($msg="getMR")
		$group:=$2
		
		$hit:=Find in array:C230(aVariable_production; $group)
		If ($hit>-1)
			$0:=aVariable_mr_costs{$hit}
		Else 
			$0:=0
		End if 
		
	: ($msg="getRUN")
		$group:=$2
		
		$hit:=Find in array:C230(aVariable_production; $group)
		If ($hit>-1)
			$0:=aVariable_run_costs{$hit}
		Else 
			$0:=0
		End if 
		
End case 