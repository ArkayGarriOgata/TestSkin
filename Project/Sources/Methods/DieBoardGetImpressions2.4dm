//%attributes = {}
// _______
// Method: DieBoardGetImpressions2   ( ) ->
// By: Mel Bohince @ 05/20/19, 20:25:49
// Description
// count the impression in the past year for the loaded [Job_DieBoard_Inv] record
// ----------------------------------------------------
// Modified by: Mel Bohince (6/6/19) don't run if not an outline specified, force a date if blank

READ ONLY:C145([Job_Forms_Machine_Tickets:61])
C_DATE:C307($dDate)
$dDate:=[Job_DieBoard_Inv:168]DateEntered:6  // Modified by: Mel Bohince (6/6/19) 
If ($dDate=!00-00-00!)
	$dDate:=Add to date:C393(Current date:C33; -1; 0; 0)
End if 

If (Length:C16([Job_DieBoard_Inv:168]OutlineNumber:4)>5)  // Modified by: Mel Bohince (6/6/19) 
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms:42]OutlineNumber:65=[Job_DieBoard_Inv:168]OutlineNumber:4; *)  // Get Job_Forms records for this Outline
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms:42]NumberUp:26=[Job_DieBoard_Inv:168]UpNumber:5; *)  // Get Job_Forms records for this Outline
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=$dDate)
	QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Machine_Tickets:61]CostCenterID:2; <>aBLANKERS)  // Restrict to ONLY those Machine tickets that are Blankers
	
	$0:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)+Sum:C1([Job_Forms_Machine_Tickets:61]Waste_Units:9)
	
Else 
	$0:=0
End if 

REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
