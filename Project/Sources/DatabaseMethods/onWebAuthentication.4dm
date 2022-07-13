// -------
// Method: On Web Authentication   ( ) ->
// By: Mel Bohince @ 04/13/17, 16:32:06
// Description
// crude i realize, just prototyping a json api
// ----------------------------------------------------
C_BOOLEAN:C305($0)  //true = permission granted
C_TEXT:C284($1; $2; $3; $4; $5; $6; $serverIp; $clientIp)

If (True:C214)
	$0:=True:C214
	
Else 
	//limit to a non-routed ip
	$err:=IT_MyTCPAddr($serverIp; $subnet)
	$serverIp:=Substring:C12($serverIp; 1; 7)  //expecting '192.168'
	$clientIp:=Substring:C12($3; 1; 7)
	If ($clientIp=$serverIp)  //test for intranet call
		If (Position:C15("api/"; $1)>0)  //limit url
			If (Position:C15("GET"; $2)>0)  //limit on header
				$0:=True:C214
			Else 
				$0:=False:C215
			End if 
			
		Else 
			$0:=False:C215
		End if 
		
	Else 
		$0:=False:C215
	End if 
	
End if   //true
