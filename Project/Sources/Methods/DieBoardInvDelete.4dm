//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/27/18, 11:21:42
// ----------------------------------------------------
// Method: DieBoardInvDelete
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_LONGINT:C283($i)
If (Records in set:C195("DieBoardSet")>0)
	CONFIRM:C162("Are you sure you want to delete the selected Die Boards?")
	If (OK=1)
		READ WRITE:C146([Job_DieBoard_Inv:168])
		USE SET:C118("DieBoardSet")
		DELETE SELECTION:C66([Job_DieBoard_Inv:168])
		DieBoardLoadAllRecs
		CREATE EMPTY SET:C140([Job_DieBoard_Inv:168]; "DieBoardSet")
		HIGHLIGHT RECORDS:C656([Job_DieBoard_Inv:168]; "DieBoardSet")
	End if 
Else 
	ALERT:C41("You must select one or more records to print.")
End if 