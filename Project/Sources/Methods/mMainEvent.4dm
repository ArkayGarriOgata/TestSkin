//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 09/6/95
// ----------------------------------------------------
// Method: mMainEvent
// Description:
// Main Event Handler
// ----------------------------------------------------

C_TEXT:C284($tType)  // Added by: Mark Zinke (2/13/13)

gClearFlags  //•090695  MLB  UPR 231 so adhoc works from main palette

fAdHocLocal:=False:C215  //indicates adhocs to process locally
fChg:=False:C215

SET MENU BAR:C67(<>DefaultMenu)
DEFAULT TABLE:C46([zz_control:1])

If (<>TEST_VERSION)
	<>mewRight:=<>mewRight+10
	<>mewBottom:=<>mewBottom+24
End if 

QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)  // Added by: Mark Zinke (1/24/13)
QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="ButtonLayout")

If ((Records in selection:C76([UserPrefs:184])=0) | ([UserPrefs:184]TextField3:11=""))  // Added by: Mark Zinke (2/5/13)
	UserPrefsWindowRecord
End if 

Case of   // Added by: Mark Zinke (2/27/13)
	: (Substring:C12([UserPrefs:184]TextField3:11; 1; 1)="B")
		$tType:="Buttons"
	: (Substring:C12([UserPrefs:184]TextField3:11; 1; 1)="M")
		$tType:="Modified"
	Else 
		$tType:="Icons"
End case 
UNLOAD RECORD:C212([UserPrefs:184])

Case of   // Added by: Mark Zinke (1/24/13)
	: (($tType="Icons") | ($tType=""))
		<>MainEventWindow:=Open form window:C675([zz_control:1]; "MainEvent"; Plain form window:K39:10; <>mewLeft; <>mewTop)
		SET WINDOW TITLE:C213(<>sAPPNAME)
		DIALOG:C40([zz_control:1]; "MainEvent")
		
		//: ($tType="Modified")
		//CountSlots (-><>mewRight;-><>mewBottom;"Modified")
		//<>MainEventWindow:=Open window(<>mewLeft;<>mewTop;<>mewRight;<>mewBottom;Plain fixed size window;<>sAPPNAME;"wCloseWinBox")
		//SET WINDOW TITLE(<>sAPPNAME)
		//DIALOG([zz_control];"MainEventIcons")
		
		//: ($tType="Buttons")
		//CountSlots (-><>mewRight;-><>mewBottom;"Buttons")
		//<>MainEventWindow:=Open window(<>mewLeft;<>mewTop;<>mewRight;<>mewBottom;Plain fixed size window;<>sAPPNAME;"wCloseWinBox")
		//SET WINDOW TITLE(<>sAPPNAME)
		//DIALOG([zz_control];"MainEventButtons")
		
End case 

If (Current user:C182="Administrator") & (Current machine:C483="intranet")  // Modified by: Mel Bohince (10/10/18) save 2 clicks and allow for auto restart after power outage
	$id:=uSpawnProcess("bBatch_Runner"; <>lBigMemPart; "bBatch_Runner")
	If (False:C215)
		bBatch_Runner
	End if 
End if 

fromZoom:=False:C215
bModMany:=False:C215
bExit:=0

uWinListCleanup