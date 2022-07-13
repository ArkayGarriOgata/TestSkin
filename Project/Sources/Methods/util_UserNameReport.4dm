//%attributes = {"publishedWeb":true}
//PM:  util_UserNameReport  3/05/01  mlb
//report current access

C_TEXT:C284($t; $cr)

$t:=Char:C90(9)
$cr:=Char:C90(13)

GET GROUP LIST:C610($aGroupNames; $aGroupNumbers)
SORT ARRAY:C229($aGroupNames; $aGroupNumbers; >)
$numGroups:=Size of array:C274($aGroupNames)

ARRAY TEXT:C222($aRoles; $numGroups)
ARRAY REAL:C219($aRoleID; $numGroups)
ARRAY TEXT:C222($aFunction; $numGroups)
ARRAY REAL:C219($aFunctionId; $numGroups)
$numRoles:=0
$numFunctions:=0
For ($i; 1; $numGroups)
	If ($aGroupNames{$i}="Role@")
		$numRoles:=$numRoles+1
		$aRoles{$numRoles}:=$aGroupNames{$i}
		$aRoleID{$numRoles}:=$aGroupNumbers{$i}
	Else 
		$numFunctions:=$numFunctions+1
		$aFunction{$numFunctions}:=$aGroupNames{$i}
		$aFunctionId{$numFunctions}:=$aGroupNumbers{$i}
	End if 
End for 
ARRAY TEXT:C222($aRoles; $numRoles)
ARRAY REAL:C219($aRoleID; $numRoles)
ARRAY TEXT:C222($aFunction; $numFunctions)
ARRAY REAL:C219($aFunctionId; $numFunctions)

ARRAY TEXT:C222($aIsMember; $numFunctions; $numRoles)  //row x column
//Function to Role
For ($func; 1; $numFunctions)
	GET GROUP PROPERTIES:C613($aFunctionId{$func}; $name; $owner; $aMembership)
	For ($role; 1; $numRoles)
		$hit:=Find in array:C230($aMembership; $aRoleID{$role})
		If ($hit>-1)
			$aIsMember{$func}{$role}:="1"
		Else 
			$aIsMember{$func}{$role}:="0"
		End if 
	End for 
End for 

//the headers
xText:="FUNCTION"+$t
For ($i; 1; $numRoles)
	xText:=xText+$aRoles{$i}+$t
End for 
xText:=xText+$cr
//the matrix
For ($func; 1; $numFunctions)
	xText:=xText+$aFunction{$func}+$t
	For ($role; 1; $numRoles)
		xText:=xText+$aIsMember{$func}{$role}+$t
	End for 
	xText:=xText+$cr
End for 
xText:=xText+$cr
xText:=xText+$cr

//User to Role
GET USER LIST:C609($aUserNames; $aUserNumbers)
SORT ARRAY:C229($aUserNames; $aUserNumbers; >)
$numUsers:=Size of array:C274($aUserNames)
ARRAY DATE:C224($aDate; $numUsers)
ARRAY LONGINT:C221($aUses; $numUsers)

ARRAY TEXT:C222($aIsMember; 0; 0)
ARRAY TEXT:C222($aIsMember; $numUsers; $numRoles)

For ($user; 1; $numUsers)
	If (Not:C34(Is user deleted:C616($aUserNumbers{$user})))
		GET USER PROPERTIES:C611($aUserNumbers{$user}; $name; $startup; $password; $nbLogin; $lastLogin; $aMembership)
		$aDate{$user}:=$lastLogin
		$aUses{$user}:=$nbLogin
		For ($role; 1; $numRoles)
			$hit:=Find in array:C230($aMembership; $aRoleID{$role})
			If ($hit>-1)
				$aIsMember{$user}{$role}:="1"
			Else 
				$aIsMember{$user}{$role}:="0"
			End if 
		End for 
	End if 
End for 

//the headers
xText:=xText+"USER"+$t
For ($i; 1; $numRoles)
	xText:=xText+$aRoles{$i}+$t
End for 
xText:=xText+"LastLogin"+$t+"#OfLogins"+$t
xText:=xText+$cr
//the matrix
For ($user; 1; $numUsers)
	If (Not:C34(Is user deleted:C616($aUserNumbers{$user})))
		xText:=xText+$aUserNames{$user}+$t
		For ($role; 1; $numRoles)
			xText:=xText+$aIsMember{$user}{$role}+$t
		End for 
		xText:=xText+String:C10($aDate{$user}; System date short:K1:1)+$t+String:C10($aUses{$user})+$t
		xText:=xText+$cr
	End if 
End for 
xText:=xText+$cr

xTitle:="ROLE VS. FUNCTION AND USER MATRIX"
$fileName:="USER&GROUPS"+(fYYMMDD(4D_Current_date))+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
rPrintText($fileName)
ALERT:C41("Report saved in document "+$fileName; "Well OK then")