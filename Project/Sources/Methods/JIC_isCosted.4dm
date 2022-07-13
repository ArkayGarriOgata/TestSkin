//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/28/07, 16:45:27
// ----------------------------------------------------
// Method: JIC_isCosted()  --> 
// Description
// don't cost r&d and proofing jobs
// ----------------------------------------------------

C_TEXT:C284($1; $form)
C_BOOLEAN:C305($0)

$form:=Substring:C12($1; 1; 8)
$0:=True:C214

READ ONLY:C145([Job_Forms:42])
SET QUERY LIMIT:C395(1)
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$form)
SET QUERY LIMIT:C395(0)
If (Records in selection:C76([Job_Forms:42])>0)
	If (Position:C15([Job_Forms:42]JobType:33; " 2 Proof 6 R & D")>0)  //don't cost it
		$0:=False:C215
	End if 
End if 

REDUCE SELECTION:C351([Job_Forms:42]; 0)