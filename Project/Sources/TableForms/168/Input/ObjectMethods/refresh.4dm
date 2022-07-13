// _______
// Method: [Job_DieBoard_Inv].Input.refresh   ( ) ->
// By: Mel Bohince @ 06/06/19, 12:26:56
// Description
// 
// ----------------------------------------------------


zwStatusMsg("Pls Wait"; "Finding Impressions and last used date...")
[Job_DieBoard_Inv:168]Impressions:14:=DieBoardGetImpressions2

If (Length:C16([Job_DieBoard_Inv:168]OutlineNumber:4)>5)
	READ ONLY:C145([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]OutlineNumber:65=[Job_DieBoard_Inv:168]OutlineNumber:4; *)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]NumberUp:26=[Job_DieBoard_Inv:168]UpNumber:5; *)
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]StartDate:10#!00-00-00!)
	If (Records in selection:C76([Job_Forms:42])>0)
		ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]StartDate:10; <)
		
		[Job_DieBoard_Inv:168]DateLastUsed:13:=[Job_Forms:42]StartDate:10
	Else 
		[Job_DieBoard_Inv:168]DateLastUsed:13:=!00-00-00!
	End if 
	
Else 
	[Job_DieBoard_Inv:168]DateLastUsed:13:=!00-00-00!
End if 
BEEP:C151
zwStatusMsg("Fini"; "Getting Impressions")
REDUCE SELECTION:C351([Job_Forms:42]; 0)
