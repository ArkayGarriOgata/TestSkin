//%attributes = {"publishedWeb":true}
//(p) ndTestDates
//$1 new date to test
//$2 old to compare with
//$3 text to add to confirm

C_DATE:C307($1; $2; $0)
C_TEXT:C284($3)

If ($1=!00-00-00!)
	$0:=$2
Else 
	$0:=$1
End if 

If (False:C215)  //save for later use
	If ($1>=$2)  //new date more recent or equal to old return new
		$0:=$1
	Else 
		
		If (True:C214)  //(fPrinting)  `called from print routine, set in sJobTrackUpdate
			$0:=$2
		Else 
			CONFIRM:C162("The Date found for "+$3+"is Older Than Current Entry."+<>sCr+"Replace?")
			
			If (OK=1)
				$0:=$1
			Else 
				$0:=$2
			End if 
		End if 
	End if 
End if 