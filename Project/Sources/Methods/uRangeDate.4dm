//%attributes = {"publishedWeb":true}
//(P) uRangeDate: Range search on dates
//• 8/21/97 cs rewritten to fix date range search failure
C_DATE:C307($Date1; $Date2)
C_TEXT:C284($Text1; $Text2)
C_BOOLEAN:C305($Continue)

$Text1:=sCriterion2
$Text2:=sCriterion3
$Continue:=True:C214

If ($Text1="")
	$Text1:="00000000"
End if 

If ($Text2="")
	$Text2:="12/31/2100"
End if 

For ($i; 1; Length:C16($Text1))
	If (Position:C15($Text1[[$i]]; "1234567890/-")=0)  //the character is NOT a valid date character
		$i:=1000  //stop loop
		ALERT:C41("The entered date is invalid.")
		uClearSelection(zDefFilePtr)
		$Continue:=False:C215
	End if 
End for 

If ($Continue)
	
	For ($i; 1; Length:C16($Text2))
		
		If (Position:C15($Text2[[$i]]; "1234567890/-")=0)  //the character is NOT a valid date character
			$i:=1000  //stop loop
			ALERT:C41("The entered date is invalid.")
			uClearSelection(zDefFilePtr)
			$Continue:=False:C215
		End if 
	End for 
End if 

If ($Continue)
	$Date1:=Date:C102($Text1)
	$Date2:=Date:C102($Text2)
	
	If ($Date1<=$Date2)  //• 8/21/97 cs if date range is OK
		QUERY:C277(zDefFilePtr->; aSlctField{zSelectNum}->>=$Date1; *)
		QUERY:C277(zDefFilePtr->;  & ; aSlctField{zSelectNum}-><=$Date2)
	Else 
		ALERT:C41("Date Range is Invalid."+Char:C90(13)+"Starting date after Ending date.")
		uClearSelection(zDefFilePtr)
	End if 
End if 
//