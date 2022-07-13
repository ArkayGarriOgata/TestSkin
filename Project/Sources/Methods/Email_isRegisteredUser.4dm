//%attributes = {"publishedWeb":true}
//PM: Email_isRegisteredUser()-> boolean:true if registered
//@author mlb - 4/16/01  14:26

C_LONGINT:C283($i)
C_BOOLEAN:C305($0; $registered)
C_TEXT:C284($1; $interrogant)

If (Count parameters:C259=1)
	$interrogant:=$1
	$registered:=False:C215
	
	If (Position:C15("bohince"; $interrogant)>0)  // | (Position("mitnick";$interrogant)>0)
		$registered:=True:C214
		
	Else   //everyone else    
		For ($i; 1; Size of array:C274(<>aEmailClient))
			If (Position:C15(<>aEmailClient{$i}; $interrogant)>0)
				$registered:=True:C214
				$i:=999999  //break
			End if 
		End for 
		
		If (Not:C34($registered))
			For ($i; 1; Size of array:C274(<>aEmailClient))
				If (Position:C15(Replace string:C233(<>aEmailClient{$i}; " "; "."); $interrogant)>0)
					$registered:=True:C214
					$i:=999999  //break
				End if 
			End for 
		End if 
		
	End if   //not bohince
	
	$0:=$registered
	
Else   //init
	ARRAY TEXT:C222(<>aEmailClient; 0)
	READ ONLY:C145([Users:5])
	QUERY:C277([Users:5]; [Users:5]AllowedEmailClient:21=True:C214)  //ALL RECORDS([USER])
	SELECTION TO ARRAY:C260([Users:5]UserName:11; <>aEmailClient)
	REDUCE SELECTION:C351([Users:5]; 0)
	$0:=(Size of array:C274(<>aEmailClient)>0)
End if 