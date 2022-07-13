//%attributes = {"publishedWeb":true}
//(p) gQuickLockTest
//$1 pointer to file to test

ON EVENT CALL:C190("eCancelProc")
CREATE SET:C116($1->; "hold")

Repeat 
	If (Locked:C147($1->)) & (<>fContinue)
		MESSAGE:C88("Waiting for Record of File "+Table name:C256($1)+Char:C90(13)+"Esc - to Cancel")
		UNLOAD RECORD:C212($1->)
		uClearSelection($1)
		DELAY PROCESS:C323(Current process:C322; 120)
		USE SET:C118("hold")
		LOAD RECORD:C52($1->)
	End if 
Until (Not:C34(Locked:C147($1->)))

ON EVENT CALL:C190("")