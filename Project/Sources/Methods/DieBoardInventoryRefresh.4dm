//%attributes = {"executedOnServer":true}
// _______
// Method: DieBoardInventoryRefresh   ( ) ->
// By: Mel Bohince @ 05/20/19, 20:54:05
// Description
// populate impressions and last use
// ----------------------------------------------------



READ WRITE:C146([Job_DieBoard_Inv:168])
READ ONLY:C145([Job_Forms:42])

ALL RECORDS:C47([Job_DieBoard_Inv:168])
APPLY TO SELECTION:C70([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]Impressions:14:=0)
APPLY TO SELECTION:C70([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]Impressions:14:=DieBoardGetImpressions2)

FIRST RECORD:C50([Job_DieBoard_Inv:168])


$numRecs:=Records in selection:C76([Job_DieBoard_Inv:168])
//uThermoInit ($numRecs;"Updating Records")
For ($i; 1; $numRecs)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]OutlineNumber:65=[Job_DieBoard_Inv:168]OutlineNumber:4; *)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]NumberUp:26=[Job_DieBoard_Inv:168]UpNumber:5; *)
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]StartDate:10#!00-00-00!)
	If (Records in selection:C76([Job_Forms:42])>0)
		ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]StartDate:10; <)
		
		[Job_DieBoard_Inv:168]DateLastUsed:13:=[Job_Forms:42]StartDate:10
		SAVE RECORD:C53([Job_DieBoard_Inv:168])
	End if 
	NEXT RECORD:C51([Job_DieBoard_Inv:168])
	//uThermoUpdate ($i)
End for 

//uThermoClose 

REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_DieBoards:152]; 0)
//BEEP


