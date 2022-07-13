//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/27/18, 10:31:49
// ----------------------------------------------------
// Method: DieBoardInventory
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284(ttQueryString)
Case of 
	: (Form event code:C388=On Load:K2:1)
		READ WRITE:C146([Job_DieBoard_Inv:168])
		ttQueryString:=""
		DieBoardLoadAllRecs
		
		
		//: (Form event=On Timer)
		//If (Length(sBin)=0)
		//DieBoardLoadAllRecs (ttQueryString)
		//SET TIMER(0)
		//End if 
		
End case 

