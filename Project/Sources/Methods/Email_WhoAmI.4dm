//%attributes = {"publishedWeb":true}
//PM: Email_WhoAmI(username{;initials}) -> email address
//@author mlb - 4/27/01  09:27
//mlb - 10/02/06 watch for blank initials  09:27

C_TEXT:C284($0; $iAm; $1; $who; $2; $initials)

READ ONLY:C145([Users:5])

$iAm:=""

Case of 
	: (Count parameters:C259=1)
		$who:=$1
		If (Length:C16($who)>0)
			QUERY:C277([Users:5]; [Users:5]UserName:11=$who)
		Else 
			REDUCE SELECTION:C351([Users:5]; 0)
		End if 
		
	: (Count parameters:C259=2)
		$initials:=$2
		If (Length:C16($initials)>0)
			QUERY:C277([Users:5]; [Users:5]Initials:1=$initials)
			$who:=[Users:5]UserName:11
		Else 
			REDUCE SELECTION:C351([Users:5]; 0)
			$who:=""
		End if 
		
	Else 
		$who:=Current user:C182
		QUERY:C277([Users:5]; [Users:5]UserName:11=$who)
End case 

If (Records in selection:C76([Users:5])>0)
	Case of 
		: ([Users:5]UserName:11="")  //no longer an emp
			$iAm:=""
			
		: ([Users:5]UserName:11="Designer")
			//$iAm:=[Users]FirstName+" "+[Users]LastName+" <mel.bohince@arkay.com>"
			$iAm:="mel.bohince@arkay.com"
			
		: ([Users:5]UserName:11="Unassigned")
			//$iAm:=[Users]FirstName+" "+[Users]LastName+" <mel.bohince@arkay.com>"
			$iAm:="mel.bohince@arkay.com"
			
		Else 
			If (Length:C16([Users:5]email:27)=0)
				//$iAm:=[Users]FirstName+" "+[Users]LastName+" <"+Replace string([Users]UserName;" ";".")+"@arkay.com>"
				$iAm:=Replace string:C233([Users:5]UserName:11; " "; ".")+"@arkay.com"
				
			Else 
				If (Position:C15(Char:C90(64); [Users:5]email:27)=0)
					//$iAm:=[Users]FirstName+" "+[Users]LastName+" <"+[Users]email+"@arkay.com>"
					$iAm:=[Users:5]email:27+"@arkay.com"
				Else 
					//$iAm:=[Users]FirstName+" "+[Users]LastName+" <"+[Users]email+">"
					$iAm:=[Users:5]email:27
				End if 
			End if 
	End case 
	
	REDUCE SELECTION:C351([Users:5]; 0)
End if 

If (Length:C16($iAm)<16)
	$iAm:=""
End if 

$0:=$iAm