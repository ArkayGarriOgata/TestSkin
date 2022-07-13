//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/05/12, 06:23:07
// ----------------------------------------------------
// Method: WindowPositionRestore
// Description:
// Restores the saved window positions for Schedule windows.
// Window positions are saved in the [WindowSets] table.
// Uses methods in the Press, Board and Finishing menus.
// They all start with PS_Show and then the number of the machine follows.
// ----------------------------------------------------

C_LONGINT:C283($i; $xlWinRef)
C_TEXT:C284(tInfo)
C_BOOLEAN:C305(bRestoreFunction; bSaveFunction)
ARRAY TEXT:C222(atWindowSets; 0)

If (Count parameters:C259>0)
	<>tWindowSetName:=$1
Else 
	bSaveFunction:=False:C215
	tInfo:="Select a window set to restore."
	
	QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]UserName:2=Current user:C182)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		SELECTION TO ARRAY:C260([WindowSetTitles:186]SetName:3; atWindowSets)
		SELECTION TO ARRAY:C260([WindowSetTitles:186]useDefault:5; abDefault)
		SELECTION TO ARRAY:C260([WindowSetTitles:186]pk_id:1; asUUID)
		
	Else 
		
		SELECTION TO ARRAY:C260([WindowSetTitles:186]SetName:3; atWindowSets; *)
		SELECTION TO ARRAY:C260([WindowSetTitles:186]useDefault:5; abDefault; *)
		SELECTION TO ARRAY:C260([WindowSetTitles:186]pk_id:1; asUUID)
		
	End if   // END 4D Professional Services : January 2019
	
	$xlWinRef:=NewWindow(380; 355; 0; 4; "Restore Window Sets")
	DIALOG:C40([WindowSets:185]; "WindowTitleSave")
	CLOSE WINDOW:C154
End if 

If (OK=1)
	If (bRestoreFunction)  //Set in the before phase of the WindowTitleSave dialog also in SetUserDefaultWindows
		WindowPositionCloseWindows
	End if 
	QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]UserName:2=Current user:C182; *)
	QUERY:C277([WindowSetTitles:186];  & ; [WindowSetTitles:186]SetName:3=<>tWindowSetName)
	RELATE MANY:C262([WindowSetTitles:186])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CREATE SET:C116([WindowSets:185]; "TheseRecords")  //WindowPositionDo changes the current selection.
		
	Else 
		
		CREATE SET:C116([WindowSets:185]; "TheseRecords")  //WindowPositionDo changes the current selection.
		ARRAY LONGINT:C221($_TheseRecords; 0)
		LONGINT ARRAY FROM SELECTION:C647([WindowSets:185]; $_TheseRecords)
	End if   // END 4D Professional Services : January 2019
	
	If (Records in selection:C76([WindowSets:185])>0)
		For ($i; 1; Records in selection:C76([WindowSets:185]))
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
				
				GOTO SELECTED RECORD:C245([WindowSets:185]; $i)
				WindowPositionDo
				USE SET:C118("TheseRecords")
				
			Else 
				
				GOTO RECORD:C242([WindowSets:185]; $_TheseRecords{$i})
				WindowPositionDo
				
			End if   // END 4D Professional Services : January 2019
			
		End for 
	End if 
End if 

<>tWindowSetName:=""

REDUCE SELECTION:C351([WindowSetTitles:186]; 0)
REDUCE SELECTION:C351([WindowSets:185]; 0)