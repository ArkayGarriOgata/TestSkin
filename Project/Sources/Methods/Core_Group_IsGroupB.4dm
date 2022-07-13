//%attributes = {}
//Method:  Core_Group_IsGroupB(nGroupNumber)=>bIsGroup
//Description:  This method validates nGroupNumber is indeed a group number

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bIsGroup)
	C_LONGINT:C283($1; $nGroupNumber)
	
	ARRAY TEXT:C222($atGroup; 0)
	ARRAY LONGINT:C221($anGroupNumber; 0)
	
	$nGroupNumber:=$1
	$bIsGroup:=False:C215
	
	GET GROUP LIST:C610($atGroup; $anGroupNumber)
	
End if   //Done Initialize

$bIsGroup:=(Find in array:C230($anGroupNumber; $nGroupNumber)#CoreknNoMatchFound)

$0:=$bIsGroup
