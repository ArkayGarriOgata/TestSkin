//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/11/06, 10:45:07
// ----------------------------------------------------
// Method: HR_setUsersInitials(firstname;middlename;lastname)

// Description
// make sure initials are unique
//
// Parameters first, middlem, and last name
// ----------------------------------------------------
// Modifed by:  Garri Ogata on 07/21 Corrected to insure no duplicate keys from fl to fl0-99 or fml to fml0-9

If (True:C214)  //Initialize
	
	C_TEXT:C284($0; $tUniqueInitials)
	C_TEXT:C284($1; $tFirst; $2; $tMiddle; $3; $tLast)
	
	C_TEXT:C284($tQuery; $tUsers)
	C_TEXT:C284($tInitials)
	C_LONGINT:C283($nNext)
	C_OBJECT:C1216($esUsers)
	C_COLLECTION:C1488($cInitial)
	
	$tFirst:=CorektBlank
	$tMiddle:=CorektBlank
	$tLast:=CorektBlank
	
	If (Count parameters:C259>=1)  //Parameters
		$tFirst:=Substring:C12($1; 1; 1)
		If (Count parameters:C259>=2)
			$tMiddle:=Substring:C12($2; 1; 1)
			If (Count parameters:C259>=3)
				$tLast:=Substring:C12($3; 1; 1)
			End if 
		End if 
	End if   //Done parameters
	
	$tInitials:=$tFirst+$tMiddle+$tLast
	
	$tQuery:=CorektBlank
	$tUsers:=Table name:C256(->[Users:5])
	
	$nNext:=0
	
End if   //Done initialize

If (Length:C16($tInitials)>0)  //Initials
	
	$tInitials:=Uppercase:C13($tInitials)
	$tQuery:="Initials="+$tInitials+"@"
	
	$esUsers:=ds:C1482[$tUsers].query($tQuery)
	
	$cInitial:=$esUsers.toCollection("Initials")
	
	$tUniqueInitials:=$tInitials
	
	While ($cInitial.query("Initials = :1"; $tUniqueInitials).length>0)  //Unique
		
		$tUniqueInitials:=$tInitials+String:C10($nNext)
		
		$nNext:=$nNext+1
		
	End while   //Done unique
	
End if   //Done initials

$0:=$tUniqueInitials