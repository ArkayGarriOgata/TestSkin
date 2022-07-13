// _______
// Method: [Job_DieBoard_Inv].DieBoardInventory.bbPrintList   ( ) ->
// By: phil 11/13/19, 17:02:28
// Description
// 
// ----------------------------------------------------



If (Records in set:C195("DieBoardSet")>0)
	
	CUT NAMED SELECTION:C334([Job_DieBoard_Inv:168]; "HoldDBs")
	USE SET:C118("DieBoardSet")
	
	FORM SET OUTPUT:C54([Job_DieBoard_Inv:168]; "DieBoardInv_P")
	ORDER BY:C49([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]CatelogID:10; >)  // PJK-11/13/19 Added sort
	PRINT SELECTION:C60([Job_DieBoard_Inv:168])
	
	USE NAMED SELECTION:C332("HoldDBs")
	HIGHLIGHT RECORDS:C656([Job_DieBoard_Inv:168]; "DieBoardSet")
	
Else 
	ALERT:C41("You must select one or more records to print.")
End if 
