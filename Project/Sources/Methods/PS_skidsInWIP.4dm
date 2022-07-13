//%attributes = {"publishedWeb":true}
// _______
// Method: PS_skidsInWIP   ( ) ->
//@author mlb - 4/18/02  16:46
// Description
// estimate the number of skids based on the sheets to
//.  press of started jobs; where skid is 2000 sheets
// ----------------------------------------------------
// Modified by: MelvinBohince (1/21/22) use [ProductionSchedules]JobInfo since "INFO" is not in the jml cache anymore
READ ONLY:C145([ProductionSchedules:110])

$priorityCutOff:=Num:C11(Request:C163("Up to Priority?"; "100"; "Calculate"; "Cancel"))
If (ok=1)
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4<=Current date:C33; *)  //shouldn't have started yet
	QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Priority:3<=$priorityCutOff; *)  //to far out
	QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Priority:3>0; *)  //lifted/hold
	QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23=0)  //not already complete
	
	QUERY SELECTION WITH ARRAY:C1050([ProductionSchedules:110]CostCenter:1; <>aPRESSES)  //in printing
	
	ARRAY TEXT:C222($_JobInfo; 0)
	SELECTION TO ARRAY:C260([ProductionSchedules:110]JobInfo:58; $_JobInfo)
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
	C_LONGINT:C283($sheets; $startAt; $sheetsOnJob)
	
	$sheets:=0
	For ($i; 1; Size of array:C274($_JobInfo))
		$startAt:=Position:C15("pt "; $_JobInfo{$i})+3
		$sheetsOnJob:=Num:C11(Substring:C12($_JobInfo{$i}; $startAt; 3))*1000  //this in thousands (M)
		$sheets:=$sheets+$sheetsOnJob
	End for 
	
	uConfirm(String:C10($sheets/1000)+"M sheets ÷ 2000 ≈ "+String:C10(Round:C94($sheets/2000; 0))+" skids"; "Ok"; "Whew")
	
End if   //calc


