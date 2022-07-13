//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/13/13, 16:20:17
// ----------------------------------------------------
// Method: Loreal_Optis_Material_Cost
// ----------------------------------------------------

C_LONGINT:C283($i; $hit; $cost_index)
C_REAL:C285($0)
C_TEXT:C284($1; $msg; $differential; $2)

$msg:=$1

Case of 
	: ($msg="init")
		$differential:=$2  // "3-0869.00AA01"  //$1// see standards grouping
		
		
		ARRAY TEXT:C222($RM_Group; 0)
		ARRAY TEXT:C222($_CostRM; 0)
		
		Begin SQL
			
			select commodity_key, cast(sum(cost) as varchar)
			from Estimates_Materials 
			where DiffFormID = :$differential 
			group by Commodity_Key
			into <<$RM_Group>>, <<$_CostRM>>
			
		End SQL
		SORT ARRAY:C229($RM_Group; $_CostRM; >)
		
		//now breakdown by loreal's interest
		ARRAY TEXT:C222(aVariable_raw_materials; 0)
		ARRAY REAL:C219(aVariable_rm_costs; 0)
		ARRAY TEXT:C222(aVariable_raw_materials; 8)
		ARRAY REAL:C219(aVariable_rm_costs; 8)
		aVariable_raw_materials{1}:="board"
		aVariable_raw_materials{2}:="ink"
		aVariable_raw_materials{3}:="varnish"
		aVariable_raw_materials{4}:="leaf"
		aVariable_raw_materials{5}:="window"
		aVariable_raw_materials{6}:="corrugate"
		aVariable_raw_materials{7}:="laminate"
		aVariable_raw_materials{8}:="other"
		
		For ($i; 1; Size of array:C274($RM_Group))
			$commodity:=Num:C11(Substring:C12($RM_Group{$i}; 1; 2))
			$cost_index:=0
			Case of 
				: ($commodity=1)  //board
					$cost_index:=1
					
				: ($commodity=2)  //ink
					$cost_index:=2
					
				: ($commodity=3)  //coating
					$cost_index:=3
					
				: (($commodity=5) | ($commodity=9))  //leaf
					$cost_index:=4
					
				: ($commodity=6)  //corragate
					$cost_index:=6
					
				: ($commodity=17)  //window
					$cost_index:=5
					
				: ($commodity=8)  //laminate
					$cost_index:=7
					
				Else   // other
					$cost_index:=8
			End case 
			aVariable_rm_costs{$cost_index}:=aVariable_rm_costs{$cost_index}+Num:C11($_CostRM{$i})
		End for 
		$0:=Size of array:C274($RM_Group)
		
	: ($msg="get")
		$rm:=$2
		
		$hit:=Find in array:C230(aVariable_raw_materials; $rm)
		If ($hit>-1)
			$0:=aVariable_rm_costs{$hit}
		Else 
			$0:=0
		End if 
		
End case 