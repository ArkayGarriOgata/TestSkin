//%attributes = {"publishedWeb":true}
//(p) uCloseWindow
//procedure to close windows using Command W
PROCESS PROPERTIES:C336(Current process:C322; $Name; $State; $Time)

Case of 
	: (Position:C15("Palette"; $Name)>0)
		CANCEL:C270
		POST KEY:C465(3)
	: (Position:C15("Rev:"; $Name)>0)
		CANCEL:C270
		POST KEY:C465(Character code:C91("."); 256)
	: (Position:C15("Search"; $Name)>0)
		CANCEL:C270
		POST KEY:C465(Character code:C91("."); 256)
	Else 
		uYesNoCancel("Save Changes before Closing?"; "Save"; "Discard"; "Cancel")
		
		Case of 
			: (OK=1)  //save
				POST KEY:C465(3)  //post enter to pick up the script(s) in the OK button(s)
			: (bNo=1)  //discard
				CANCEL:C270
				POST KEY:C465(Character code:C91("."); 256)
			Else   //cancel (was a mistake)
		End case 
End case 
//