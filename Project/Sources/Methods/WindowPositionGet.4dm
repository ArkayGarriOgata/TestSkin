//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/12/12, 09:32:52
// ----------------------------------------------------
// Method: WindowPositionGet
// Description:
// Used for the Production Schedule windows.
// The position of the window is recorded in a textfile for each user.
// When the user opens the same window it will be opened at that position.
// Windows positioned on extra monitors will not be saved.
// Modified by: Mark Zinke (12/17/12) Modified to work with more windows than PressSchedule windows.

// $1 = Name of window
// $2 = Pointer to left coordinate
// $3 = Pointer to top coordinate
// $4 = Pointer to right coordinate
// $5 = Pointer to bottom coordinate
// $6 = Form width
// $7 = Form height
// $0 = True/False
// ----------------------------------------------------

C_TEXT:C284($tName; $1; $tWinTitle; $tLeft; $tTop; $tRight; $tBottom; $tAltTitle)
C_POINTER:C301($pLeft; $2; $pTop; $3; $pRight; $4; $pBottom; $5)
C_BOOLEAN:C305($0)
C_LONGINT:C283($xlWidth; $xlHeight)

$tName:=$1
$pLeft:=$2
$pTop:=$3
$pRight:=$4
$pBottom:=$5
If (Count parameters:C259>5)
	$xlWidth:=$6
	$xlHeight:=$7
Else 
	$xlWidth:=$pRight->-$pLeft->
	$xlHeight:=$pBottom->-$pTop->
	$tAltTitle:=""
End if 

$0:=False:C215

If (Substring:C12($tName; 1; 1)=" ")
	$tName:=Substring:C12($tName; 2)
End if 

If (WindowPositionWindows($tName))  // Added by: Mark Zinke (12/17/12)
	If (<>tWindowSetName#"")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]UserName:2=Current user:C182; *)
			QUERY:C277([WindowSetTitles:186];  & ; [WindowSetTitles:186]SetName:3=<>tWindowSetName)
			RELATE MANY:C262([WindowSetTitles:186])  // Added by: Mark Zinke (12/11/12)
			QUERY SELECTION:C341([WindowSets:185]; [WindowSets:185]WindowTitle:3=$tName)
			
		Else 
			
			QUERY BY FORMULA:C48([WindowSets:185]; \
				([WindowSetTitles:186]UserName:2=Current user:C182)\
				 & ([WindowSetTitles:186]SetName:3=<>tWindowSetName)\
				 & ([WindowSets:185]WindowTitle:3=$tName)\
				)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	Else 
		QUERY:C277([WindowSets:185]; [WindowSets:185]WindowTitle:3=$tName; *)
		QUERY:C277([WindowSets:185];  & ; [WindowSets:185]UserName:2=Current user:C182)  // Modified by: Mel Bohince (11/4/15) wtf mark, add the user
	End if 
	Case of 
		: (($xlWidth+[WindowSets:185]LeftSide:4)>Screen width:C187) | (($xlHeight+[WindowSets:185]Top:5)>Screen height:C188)  //The window would open off screen, so reset to the upper left
			$pLeft->:=2
			$pTop->:=80
			$pRight->:=$xlWidth+2
			$pBottom->:=$xlHeight+80
			
		: (Records in selection:C76([WindowSets:185])=1)
			$pLeft->:=[WindowSets:185]LeftSide:4
			$pTop->:=[WindowSets:185]Top:5
			$pRight->:=[WindowSets:185]RightSide:6
			$pBottom->:=[WindowSets:185]Bottom:7
			
		Else   //Do this if it's a supported window but it hasn't been saved anywhere or it's saved in multiple windowsets.
			//Just open it the last place it was manually opened.
			$pLeft->:=<>winX
			$pTop->:=<>winY
			$pRight->:=$xlWidth+<>winX
			$pBottom->:=$xlHeight+<>winY
	End case 
	
	$0:=True:C214
	
Else 
	$0:=False:C215
	
End if 