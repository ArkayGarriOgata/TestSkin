//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/29/10, 13:56:48
// ----------------------------------------------------
// Method: ams_get_tables
// Description
// was   `(LP) [CONTROL]'SelectFile
// 051496  MLB  Sort the list of files
// ----------------------------------------------------

If (Size of array:C274(<>axFiles)=0) | (Current user:C182="Designer")  //Load 'em
	C_LONGINT:C283($i; $t; $err; $visable; $deleteOpt)
	$t:=Get last table number:C254
	ARRAY TEXT:C222(<>axFiles; $t)
	ARRAY INTEGER:C220(<>axFileNums; $t)  //•051496  MLB 
	$Count:=0
	
	For ($i; 1; $t)
		If (Is table number valid:C999($i))
			GET TABLE PROPERTIES:C687($i; $invisible)
			If (Not:C34($invisible))
				$Name:=Table name:C256($i)
				If ($Name[[1]]#"_")
					$Count:=$Count+1
					<>axFiles{$Count}:=$Name
					<>axFileNums{$Count}:=$i  //Store the filenumber by position
				End if 
			End if 
		End if 
	End for 
	ARRAY TEXT:C222(<>axFiles; $Count)  //• 6/10/98 cs resize
	ARRAY INTEGER:C220(<>axFileNums; $Count)  //•051496  MLB 
	
	SORT ARRAY:C229(<>axFiles; <>axFileNums; >)  //•051496  MLB 
End if 