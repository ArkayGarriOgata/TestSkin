//%attributes = {}
//Method:  Prgr_Quit
//Description:  This method will quit a progress indicator

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oProgress)
	
	$oProgress:=$1
	
End if   //Done initialize

Progress QUIT($oProgress.nProgressID)
