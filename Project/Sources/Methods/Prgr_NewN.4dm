//%attributes = {}
//Method:  Prgr_NewN=>nProgressID
//Description:  This method will create a new progress and set information

If (True:C214)  //Initialize
	
	C_LONGINT:C283($0; $nProgressID)
	
	$nProgressID:=0
	
	$nProgressID:=Progress New  //Create a new progress bar
	
	Progress SET BUTTON ENABLED($nProgressID; True:C214)  // The progress bar must have a Stop button
	
End if   //Done Initialize

$0:=$nProgressID