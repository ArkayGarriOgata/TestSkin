//%attributes = {}
//Method: COM_ErrorEncountered(severity;errNum;msg)  102098  MLB
//send error message to status bar

com_SessionLog:=com_SessionLog+Char:C90(13)+"** ERROR @"+Substring:C12(String:C10(Current time:C178; HH MM SS:K7:1); 4; 5)+" #"+String:C10($2)+" "+$3+Char:C90(13)
BEEP:C151
Case of 
	: ($1=0)  //just continue
		
		zwStatusMsg("Note:"+String:C10($2); $3)
	: ($1=1)
		zwStatusMsg("Error:"+String:C10($2); $3)
		DELAY PROCESS:C323(Current process:C322; 3*60)
		
	Else 
		zwStatusMsg("Abort:"+String:C10($2); $3)
		BEEP:C151
		DELAY PROCESS:C323(Current process:C322; 5*60)
End case 

utl_Trace