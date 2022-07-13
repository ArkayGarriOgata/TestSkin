
// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/27/18, 16:09:06
// ----------------------------------------------------
// Method: [Job_DieBoard_Inv].Input
// Description
// 


//
// Parameters
// ----------------------------------------------------
C_LONGINT:C283(xlImpressions; xlImpRemaining)
Case of 
	: (Form event code:C388=On Load:K2:1)
		If ([Job_DieBoard_Inv:168]MaxImpressions:11>0)  // Modified by: Mel Bohince (5/21/19) see Refresh button on listing
			xlImpRemaining:=DieBoardGetImpressions(->xlImpressions)
		End if 
End case 