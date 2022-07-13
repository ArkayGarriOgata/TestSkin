//%attributes = {}
//Method:  Tgsn_ExDr_ConnectB(tTungstenExpanDrive)=>bConnect
//Description:  This method makes sure the expand drive is connectd for Tungsten upload 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tTungstenExpanDrive)
	C_BOOLEAN:C305($0; $bConnect)
	
	ARRAY TEXT:C222($atVolume; 0)
	
	$tTungstenExpanDrive:=$1
	
	$bConnect:=False:C215
	
	VOLUME LIST:C471($atVolume)
	
End if   //Done Initialize

$bConnect:=(Find in array:C230($atVolume; $tTungstenExpanDrive)#CoreknNoMatchFound)

$0:=$bConnect
