//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/12/12, 10:00:24
// ----------------------------------------------------
// Method: WindowPositionSave
// Description:
// When the user clicks on the closebox of supported windows,
// the position of the window will be written to the [UserPrefs] record.
// ----------------------------------------------------

C_TEXT:C284($0; $tWinTitle; tInfo; tMsg)
C_LONGINT:C283($xlLeft; $xlTop; $xlRight; $xlBottom; $xlPosition)
C_BOOLEAN:C305(bSaveFunction)
ARRAY TEXT:C222(atWindowSets; 0)
ARRAY BOOLEAN:C223(abDefault; 0)
ARRAY TEXT:C222(asUUID; 0)

bSaveFunction:=True:C214

tInfo:="Enter the name of the window set you want to save or pick from "
tInfo:=tInfo+"the list below to replace with the current set."

QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]UserName:2=Current user:C182)

If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	SELECTION TO ARRAY:C260([WindowSetTitles:186]SetName:3; atWindowSets)
	SELECTION TO ARRAY:C260([WindowSetTitles:186]useDefault:5; abDefault)
	SELECTION TO ARRAY:C260([WindowSetTitles:186]pk_id:1; asUUID)
	
Else 
	
	SELECTION TO ARRAY:C260([WindowSetTitles:186]SetName:3; atWindowSets; *)
	SELECTION TO ARRAY:C260([WindowSetTitles:186]useDefault:5; abDefault; *)
	SELECTION TO ARRAY:C260([WindowSetTitles:186]pk_id:1; asUUID)
	
End if   // END 4D Professional Services : January 2019 

REDUCE SELECTION:C351([WindowSetTitles:186]; 0)
$xlWinRef:=NewWindow(380; 355; 0; 4; "Save Window Sets")
DIALOG:C40([WindowSets:185]; "WindowTitleSave")
CLOSE WINDOW:C154

If (OK=1)
	tMsg:="Save the Window Set called "+util_Quote(<>tWindowSetName)+"?"
	$xlPosition:=Find in array:C230(abDefault; True:C214)
	If ($xlPosition>0)
		tMsg:=tMsg+<>CR+"and make the Set "+util_Quote(atWindowSets{$xlPosition})+" the default?"
	End if 
	CONFIRM:C162(tMsg)
	If (OK=1)
		QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]UserName:2=Current user:C182; *)
		QUERY:C277([WindowSetTitles:186];  & ; [WindowSetTitles:186]SetName:3=<>tWindowSetName)
		If (Records in selection:C76([WindowSetTitles:186])=0)
			CREATE RECORD:C68([WindowSetTitles:186])
			[WindowSetTitles:186]ID:4:=[WindowSetTitles:186]pk_id:1
			[WindowSetTitles:186]SetName:3:=<>tWindowSetName
			[WindowSetTitles:186]UserName:2:=Current user:C182
			INSERT IN ARRAY:C227(asUUID; 1)
			asUUID{1}:=[WindowSetTitles:186]ID:4
		Else 
			RELATE MANY:C262([WindowSetTitles:186])
			DELETE SELECTION:C66([WindowSets:185])
		End if 
		SAVE RECORD:C53([WindowSetTitles:186])
		<>tWindowSetName:=""
		
		WINDOW LIST:C442($hWinRefs)
		
		For ($i; 1; Size of array:C274($hWinRefs))
			$tWinTitle:=Get window title:C450($hWinRefs{$i})
			If (WindowPositionWindows($tWinTitle))
				GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom; $hWinRefs{$i})
				CREATE RECORD:C68([WindowSets:185])
				[WindowSets:185]ID:1:=[WindowSetTitles:186]pk_id:1
				[WindowSets:185]WindowTitle:3:=$tWinTitle
				[WindowSets:185]UserName:2:=Current user:C182
				[WindowSets:185]LeftSide:4:=$xlLeft
				[WindowSets:185]Top:5:=$xlTop
				[WindowSets:185]RightSide:6:=$xlRight
				[WindowSets:185]Bottom:7:=$xlBottom
				[WindowSets:185]WindowRef:8:=$hWinRefs{$i}
				[WindowSets:185]ProcID:12:=Window process:C446($hWinRefs{$i})
				[WindowSets:185]SetDate:10:=4D_Current_date
				[WindowSets:185]SetTime:11:=4d_Current_time
				SAVE RECORD:C53([WindowSets:185])
				If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
					
					UNLOAD RECORD:C212([WindowSets:185])
					
					
				Else 
					
					// you have reduce selection on line 116
					
					
				End if   // END 4D Professional Services : January 2019 
			End if 
		End for 
		
		//Save the Default setting
		QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]UserName:2=Current user:C182)
		APPLY TO SELECTION:C70([WindowSetTitles:186]; [WindowSetTitles:186]useDefault:5:=False:C215)
		$xlPosition:=Find in array:C230(abDefault; True:C214)
		If ($xlPosition>0)  //A Default has been set.
			QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]pk_id:1=asUUID{$xlPosition})
			[WindowSetTitles:186]useDefault:5:=True:C214
			SAVE RECORD:C53([WindowSetTitles:186])
		End if 
	End if 
End if 

bSaveFunction:=False:C215

REDUCE SELECTION:C351([WindowSetTitles:186]; 0)
REDUCE SELECTION:C351([WindowSets:185]; 0)