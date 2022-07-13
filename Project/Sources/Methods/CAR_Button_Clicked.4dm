//%attributes = {}
//CAR_Button_Clicked
//By: DJC
//Date: 5-17-05
//Purpose:  This method handles all the button actions on page 3 of the
//[CorrectiveAction]Input form.  The buttons are all the creation and modification
//of To Dos and Internal Notes.
//Note: The use of modal dialogs so that the user cant click behind the box.  Also,
//note the query at the end of the procedure.  I use this to refresh the screen in case
//any To Dos had been deleted.  The Refresh Window command wasnt working so I
//used a Query to get back the current selection.

C_TEXT:C284($sButtonName)
C_TEXT:C284($1)
C_TEXT:C284($sCurrentUser)
C_LONGINT:C283($LWinRef)
C_TEXT:C284($tMsg)

$sButtonName:=$1
$sCurrentUser:=Current user:C182
FORM SET INPUT:C55([QA_Corrective_Actions_Notes:143]; "Input")
FORM SET INPUT:C55([QA_Corrective_Actions_ToDos:144]; "Input")

Case of 
	: ($sButtonName="Modify a To Do")  //Modifying a To Do
		$LWinRef:=Open form window:C675([QA_Corrective_Actions_ToDos:144]; "Input"; Modal form dialog box:K39:7; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		FORM SET INPUT:C55([QA_Corrective_Actions_ToDos:144]; "Input")
		MODIFY RECORD:C57([QA_Corrective_Actions_ToDos:144])
		CLOSE WINDOW:C154($LWinRef)
		UNLOAD RECORD:C212([QA_Corrective_Actions_ToDos:144])
		
	: ($sButtonName="Modify Notes")  //Modify a Note
		tNote:=[QA_Corrective_Actions_Notes:143]Note:5
		$title:="Notes for CAR# "+[QA_Corrective_Actions:105]RequestNumber:1
		$LWinRef:=Open form window:C675([QA_Corrective_Actions_Notes:143]; "Input"; Regular window:K27:1; Horizontally centered:K39:1; Vertically centered:K39:4)
		SET WINDOW TITLE:C213($title)
		DIALOG:C40([QA_Corrective_Actions_Notes:143]; "Input")
		CLOSE WINDOW:C154($LWinRef)
		
	: ($sButtonName="Create a New To Do")  //Create a new To Do
		$LWinRef:=Open form window:C675([QA_Corrective_Actions_ToDos:144]; "Input"; Modal form dialog box:K39:7; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		ADD RECORD:C56([QA_Corrective_Actions_ToDos:144])
		CLOSE WINDOW:C154($LWinRef)
		
	: ($sButtonName="Create a New Note")
		QUERY:C277([QA_Corrective_Actions_Notes:143]; [QA_Corrective_Actions_Notes:143]RequestNumber:1=[QA_Corrective_Actions:105]RequestNumber:1)
		If (Records in selection:C76([QA_Corrective_Actions_Notes:143])=0)  //should only ever be 1 CAR_Notes record
			//need to create a [CAR_Notes] record
			CREATE RECORD:C68([QA_Corrective_Actions_Notes:143])  //DJC - 5-17-05
			[QA_Corrective_Actions_Notes:143]RequestNumber:1:=[QA_Corrective_Actions:105]RequestNumber:1
			SAVE RECORD:C53([QA_Corrective_Actions_Notes:143])  //mlb 101905 trigger added
		End if 
		
		//tHoldNoteField:=[CAR_Notes]Note
		tNote:=""
		sRecordStatus:="New Note"
		$title:="Notes for CAR# "+[QA_Corrective_Actions:105]RequestNumber:1
		$LWinRef:=Open form window:C675([QA_Corrective_Actions_Notes:143]; "Input"; Regular window:K27:1; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		SET WINDOW TITLE:C213($title)
		DIALOG:C40([QA_Corrective_Actions_Notes:143]; "Input")
		CLOSE WINDOW:C154($LWinRef)
		sRecordStatus:=""
		
	: ($sButtonName="Delete a To Do")  //Deleting a To Do
		//is the person deleting the same person who created it or a member of  QA managment group
		If (($sCurrentUser=[QA_Corrective_Actions_ToDos:144]CreationAuthor:4) | (User in group:C338($sCurrentUser; "RoleQAMgmt")))
			CONFIRM:C162("Are you sure you want to delete this To Do?"; "No"; "Yes")
			If (oK=0)
				DELETE RECORD:C58([QA_Corrective_Actions_ToDos:144])
				//set the button text on the internal notes & to dos button
				CAR_Set_InternalNotes_Btn_Txt  //DJC - 5/17/05
			End if 
			
		Else 
			BEEP:C151
			BEEP:C151
			$tMsg:="You cannot delete a record unless you created it"+Char:C90(Carriage return:K15:38)
			$tMsg:=$tMsg+"OR"+Char:C90(Carriage return:K15:38)+"You are a member of the RoleQAMgmt group."
			ALERT:C41($tMsg)
		End if   //(($sCurrentUser=[CAR_ToDos]CreationAuthor)†|†(User in group($sCurrentUser;"QARoleMgmt")))
		
End case 

//QUERY([CAR_ToDos];[CAR_ToDos]RequestNumber=[CorrectiveAction]RequestNumber)  `get all ToDos & will refresh screen
//ORDER BY([CAR_ToDos];[CAR_ToDos]DateCreated;<)  `newest To Dos on top of list