// _______
// Method: [Raw_Materials_Transactions].IssueRMtoJob   ( ) ->
// By: Mel Bohince @ 06/22/21, 15:33:24
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (OB Is defined:C1231(Form:C1466; "windowTitle"))  // Modified by: Mel Bohince (10/29/20) 
			SET WINDOW TITLE:C213(Form:C1466.windowTitle; Current form window:C827)
		End if 
End case 

