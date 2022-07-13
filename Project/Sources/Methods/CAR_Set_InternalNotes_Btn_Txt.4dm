//%attributes = {}
//CAR_Set_InternalNotes_Btn_Txt
//By: DJC
//Date: 5-17-05

//Purpose: Checks to see if there are any open To Dos for this
//CAR record and if so, changes the button text to reflect
//how many are currently open.
// • mel (6/6/05, 09:57:35) chg qry destination
//mlb drop todos, touch up the notes
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)

C_LONGINT:C283($LRIS; $numToDo)

READ WRITE:C146([QA_Corrective_Actions_Notes:143])
QUERY:C277([QA_Corrective_Actions_Notes:143]; [QA_Corrective_Actions_Notes:143]RequestNumber:1=[QA_Corrective_Actions:105]RequestNumber:1)
If (Records in selection:C76([QA_Corrective_Actions_Notes:143])>0)
	$LRIS:=Length:C16([QA_Corrective_Actions_Notes:143]Note:5)
Else 
	$LRIS:=0
End if 
$numToDo:=0  // Modified by: Mel Bohince (6/9/21) 
SET QUERY DESTINATION:C396(Into variable:K19:4; $numToDo)
QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Category:2="CAR"+[QA_Corrective_Actions:105]RequestNumber:1; *)
QUERY:C277([To_Do_Tasks:100];  & ; [To_Do_Tasks:100]Done:4=False:C215)
SET QUERY DESTINATION:C396(Into current selection:K19:1)
$LRIS:=$LRIS+$numToDo

If ($LRIS>0)  //we have some open To Dos
	SetObjectProperties(""; ->bInternalNotesAndToDos; True:C214; "Internal Notes & ToDo (entries)")
Else 
	SetObjectProperties(""; ->bInternalNotesAndToDos; True:C214; "Internal Notes & ToDo")
End if 