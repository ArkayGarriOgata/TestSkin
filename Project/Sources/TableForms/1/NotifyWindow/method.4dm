//(lp) [control]notify window
//• 7/21/97 cs allow a second flag to exit process
Case of 
	: (Form event code:C388=On Outside Call:K2:11)  //if this activated from a 'call process' command
		
		If (<>fQuit4D) | (<>fQuitNotify) | (<>xMsgText="")  //and 4D is quiting, or the search returned nothing
			CANCEL:C270  //close process
			CLOSE WINDOW:C154
		End if 
End case 