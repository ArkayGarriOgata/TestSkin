//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/11/12, 09:14:55
// ----------------------------------------------------
// Method: Rama_Show_Blanking
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283(<>pid_RamaBS; $item; $numJMI; $winRef)

If (Count parameters:C259=0)
	If (<>pid_RamaBS=0)
		<>pid_RamaBS:=New process:C317("Rama_Show_Blanking"; <>lMinMemPart; "Rama Blanking"; "init")
		
	Else 
		SHOW PROCESS:C325(<>pid_RamaBS)
		BRING TO FRONT:C326(<>pid_RamaBS)
	End if 
	
Else 
	$winRef:=Open form window:C675([ProductionSchedules:110]; "SimpleSchedule"; Plain form window:K39:10)
	SET WINDOW TITLE:C213("Rama/Cayey Blanking"; $winRef)
	MESSAGE:C88("Please Wait, Loading Blanking Schedule...")
	
	If (Rama_Find_CPNs("query"; ->[Job_Forms_Items:44]ProductCode:3)>0)
		//get active items
		
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33=!00-00-00!; *)
		QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!; *)
		QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]OrderItem:2#"Killed"; *)
		QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]FormClosed:5=False:C215)
		
		
		
		ARRAY LONGINT:C221(aRecNo; 0)
		ARRAY TEXT:C222(aCPN; 0)
		ARRAY TEXT:C222(aJobit; 0)
		ARRAY LONGINT:C221(aQtySched; 0)
		ARRAY DATE:C224(aDateSched; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]; aRecNo; [Job_Forms_Items:44]ProductCode:3; aCPN; [Job_Forms_Items:44]Jobit:4; aJobit; [Job_Forms_Items:44]Qty_Want:24; aQtySched)
		$numJMI:=Size of array:C274(aRecNo)
		ARRAY DATE:C224(aDateSched; $numJMI)
		
		For ($item; 1; $numJMI)
			$jf:=Substring:C12(aJobit{$item}; 1; 8)+"@"
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$jf)
			PS_qryDieCuttingOnly("*")
			If (Records in selection:C76([Addresses:30])>0)  //blanking scheduled
				aDateSched{$item}:=[ProductionSchedules:110]StartDate:4
			Else 
				aDateSched{$item}:=<>MAGIC_DATE
			End if 
		End for 
		
		FORM SET INPUT:C55([ProductionSchedules:110]; "SimpleSchedule")
		ADD RECORD:C56([ProductionSchedules:110]; *)
		CLOSE WINDOW:C154($winRef)
		FORM SET INPUT:C55([ProductionSchedules:110]; "Input")
		
	Else 
		uConfirm("No Job items found."; "OK"; "Help")
	End if 
	
	<>pid_RamaBS:=0
End if 