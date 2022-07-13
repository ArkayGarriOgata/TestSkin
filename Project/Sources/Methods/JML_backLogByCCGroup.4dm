//%attributes = {"publishedWeb":true}
//PM: JML_backLogByCCGroup() -> 
//@author mlb - 5/16/02  15:07
// Modified by: Mel Bohince (7/1/15) when tallying, use group number, ignore name

MESSAGES OFF:C175

READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Cost_Centers:27])

ARRAY TEXT:C222($aCC_Groups; 0)
ARRAY REAL:C219($aTally_Hours; 0)
ALL RECORDS:C47([Cost_Centers:27])
DISTINCT VALUES:C339([Cost_Centers:27]cc_Group:2; $aCC_Groups)
ARRAY REAL:C219($aTally_Hours; Size of array:C274($aCC_Groups))
For ($i; 1; Size of array:C274($aTally_Hours))
	$aTally_Hours{$i}:=0
End for 

$t:="   "+Char:C90(9)
$cr:=Char:C90(13)
$hrsSheeting:=0
$hrsPrinting:=0
$hrsBlanking:=0
$hrsStamping:=0
$hrsStripping:=0
$hrsGluing:=0
$hrsLaminating:=0
$hrsCoating:=0

If (False:C215)
	CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "hold")
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
	
Else 
	FIRST RECORD:C50([Job_Forms_Master_Schedule:67])
End if 

$numJML:=Records in selection:C76([Job_Forms_Master_Schedule:67])
uThermoInit($numJML; "Calculating Backlog by CostCenter Group")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; $numJML)
		$needsSheeted:=util_isDateNull(->[Job_Forms_Master_Schedule:67]DateStockSheeted:47)
		$needsPrinted:=util_isDateNull(->[Job_Forms_Master_Schedule:67]Printed:32)
		$needsBlanked:=util_isDateNull(->[Job_Forms_Master_Schedule:67]GlueReady:28)
		$needsGlued:=util_isDateNull(->[Job_Forms_Master_Schedule:67]DateComplete:15)
		
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
		
		For ($j; 1; Records in selection:C76([Job_Forms_Machines:43]))
			If (([Job_Forms_Machines:43]Actual_RunHrs:40+[Job_Forms_Machines:43]Actual_MR_Hrs:24)<([Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37))
				RELATE ONE:C42([Job_Forms_Machines:43]CostCenterID:4)
				$group:=[Cost_Centers:27]cc_Group:2
				$hit:=Find in array:C230($aCC_Groups; $group)
				If ($hit>-1)
					//$aTally_Hours{$hit}:=$aTally_Hours{$hit}+[Job_Forms_Machines]Planned_MR_Hrs+[Job_Forms_Machines]Planned_RunHrs
					
					Case of 
						: ($group="30.@")  //($group="30.SHEETING")
							If ($needsSheeted)
								$hrsSheeting:=$hrsSheeting+[Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
							
						: ($group="20.@")  // ($group="20.PRINTING")
							If ($needsPrinted)
								$hrsPrinting:=$hrsPrinting+[Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
							
						: ($group="50.@")  //($group="50.STAMPING")
							If ($needsBlanked)
								$hrsStamping:=$hrsStamping+[Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
							
						: ($group="55.@")  //($group="55.BLANKING")|($group="55.DIE CUTTING") // Modified by: Mel Bohince (7/1/15) 
							If ($needsBlanked)
								$hrsBlanking:=$hrsBlanking+[Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
							
						: ($group="60.@")  // ($group="60.COATING")
							If ($needsBlanked)
								$hrsCoating:=$hrsCoating+[Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
							
						: ($group="70@")  //($group="70.LAMINATING")|($group="70.ACETATE LAMINATOR")|($group="70.ACETATE")|($group="70.LAMINATION"// Modified by: Mel Bohince (7/1/15) 
							If ($needsBlanked)
								$hrsLaminating:=$hrsLaminating+[Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
							
						: ($group="80.@")  //($group="80.FINISHING")
							If ($needsGlued)
								$hrsGluing:=$hrsGluing+[Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
							
						: ($group="90.@")  //($group="90.STRIPPING")
							If ($needsBlanked)
								$hrsStripping:=$hrsStripping+[Job_Forms_Machines:43]Planned_MR_Hrs:15+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
					End case 
					
				End if 
				NEXT RECORD:C51([Job_Forms_Machines:43])
			End if 
		End for 
		
		NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
		uThermoUpdate($i)
	End for 
	
	
Else 
	//laghzaoui remove two next
	
	ARRAY DATE:C224($_DateStockSheeted; 0)
	ARRAY DATE:C224($_Printed; 0)
	ARRAY DATE:C224($_GlueReady; 0)
	ARRAY DATE:C224($_DateComplete; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]DateStockSheeted:47; $_DateStockSheeted; \
		[Job_Forms_Master_Schedule:67]Printed:32; $_Printed; \
		[Job_Forms_Master_Schedule:67]GlueReady:28; $_GlueReady; \
		[Job_Forms_Master_Schedule:67]DateComplete:15; $_DateComplete; \
		[Job_Forms_Master_Schedule:67]JobForm:4; $_JobForm)
	
	For ($i; 1; $numJML)
		
		$needsSheeted:=util_isDateNull(->$_DateStockSheeted{$i})
		$needsPrinted:=util_isDateNull(->$_Printed{$i})
		$needsBlanked:=util_isDateNull(->$_GlueReady{$i})
		$needsGlued:=util_isDateNull(->$_DateComplete{$i})
		
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$_JobForm{$i})
		
		ARRAY REAL:C219($_Actual_RunHrs; 0)
		ARRAY REAL:C219($_Actual_MR_Hrs; 0)
		ARRAY REAL:C219($_Planned_MR_Hrs; 0)
		ARRAY REAL:C219($_Planned_RunHrs; 0)
		ARRAY TEXT:C222($_CostCenterID; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Actual_RunHrs:40; $_Actual_RunHrs; \
			[Job_Forms_Machines:43]Actual_MR_Hrs:24; $_Actual_MR_Hrs; \
			[Job_Forms_Machines:43]Planned_MR_Hrs:15; $_Planned_MR_Hrs; \
			[Job_Forms_Machines:43]Planned_RunHrs:37; $_Planned_RunHrs; \
			[Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID)
		
		
		For ($j; 1; Size of array:C274($_Actual_RunHrs); 1)
			If (($_Actual_RunHrs{$j}+$_Actual_MR_Hrs{$j})<($_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}))
				
				QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$_CostCenterID{$j})
				
				$group:=[Cost_Centers:27]cc_Group:2
				$hit:=Find in array:C230($aCC_Groups; $group)
				
				If ($hit>-1)
					
					Case of 
						: ($group="30.@")
							If ($needsSheeted)
								$hrsSheeting:=$hrsSheeting+$_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}
							End if 
							
						: ($group="20.@")
							If ($needsPrinted)
								$hrsPrinting:=$hrsPrinting+$_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}
							End if 
							
						: ($group="50.@")
							If ($needsBlanked)
								$hrsStamping:=$hrsStamping+$_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}
							End if 
							
						: ($group="55.@")
							If ($needsBlanked)
								$hrsBlanking:=$hrsBlanking+$_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}
							End if 
							
						: ($group="60.@")
							If ($needsBlanked)
								$hrsCoating:=$hrsCoating+$_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}
							End if 
							
						: ($group="70@")
							If ($needsBlanked)
								$hrsLaminating:=$hrsLaminating+$_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}
							End if 
							
						: ($group="80.@")
							If ($needsGlued)
								$hrsGluing:=$hrsGluing+$_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}
							End if 
							
						: ($group="90.@")
							If ($needsBlanked)
								$hrsStripping:=$hrsStripping+$_Planned_MR_Hrs{$j}+$_Planned_RunHrs{$j}
							End if 
					End case 
					
				End if 
			End if 
		End for 
		
		uThermoUpdate($i)
	End for 
	
	
End if   // END 4D Professional Services : January 2019 
uThermoClose

xText:="GROUP       "+$t+"HOURS"+$cr
xText:=xText+"------------"+$t+"-----"+$cr
xText:=xText+"SHEETING    "+$t+String:C10($hrsSheeting; "^^^^^")+$cr
xText:=xText+"PRINTING    "+$t+String:C10($hrsPrinting; "^^^^^")+$cr
xText:=xText+"COATING     "+$t+String:C10($hrsCoating; "^^^^^")+$cr
xText:=xText+"LAMINATING  "+$t+String:C10($hrsLaminating; "^^^^^")+$cr
xText:=xText+"STAMPING    "+$t+String:C10($hrsStamping; "^^^^^")+$cr
xText:=xText+"DIE CUTTING "+$t+String:C10($hrsBlanking; "^^^^^")+$cr
xText:=xText+"STRIPPING   "+$t+String:C10($hrsStripping; "^^^^^")+$cr
xText:=xText+"GLUING      "+$t+String:C10($hrsGluing; "^^^^^")+$cr+$cr
xText:=xText+"TOTAL       "+$t+String:C10($hrsGluing+$hrsStripping+$hrsBlanking+$hrsStamping+$hrsLaminating+$hrsCoating+$hrsPrinting+$hrsSheeting; "^^^^^")+$cr

utl_LogIt("init")
utl_LogIt(xText; 0)
utl_LogIt("show")

