//%attributes = {"publishedWeb":true}
//(P) uEqualSrch: search equal condition
//• 8/21/97 cs fixed date searcing problem
//•042199  MLB fix cs's code, add today, tommorrow, and yesterday for dates

C_DATE:C307($date)
C_TEXT:C284($Text1)  //• 8/21/97 cs DO NOT replace criterion1
C_BOOLEAN:C305($TF; $Continue)

Case of 
	: ((sSlctType="N") | (sSlctType="R") | (sSlctType="L"))  //Number
		QUERY:C277(zDefFilePtr->; aSlctField{zSelectNum}->=Num:C11(sCriterion1))
		
	: (sSlctType="A")  //Alphanumeric
		QUERY:C277(zDefFilePtr->; aSlctField{zSelectNum}->=sCriterion1)
		
	: (sSlctType="B")  //Boolean
		$TF:=(sCriterion1="True")
		QUERY:C277(zDefFilePtr->; aSlctField{zSelectNum}->=$TF)
		
	: (sSlctType="D")  //Date
		$Text1:=sCriterion1  //•042199  MLB fix cs's code
		$Continue:=True:C214  //• 8/21/97 cs 
		
		If ($Text1="")  //• 8/21/97 cs 
			$Text1:="00000000"
		End if 
		
		Case of 
			: ($Text1="today")
				$Text1:=String:C10(4D_Current_date; Internal date short:K1:7)
			: ($Text1="yesterday")
				$Text1:=String:C10(4D_Current_date-1; Internal date short:K1:7)
			: ($Text1="tomorrow")
				$Text1:=String:C10(4D_Current_date+1; Internal date short:K1:7)
		End case 
		
		For ($i; 1; Length:C16($Text1))  //• 8/21/97 cs 
			If (Position:C15($Text1[[$i]]; "1234567890/-")=0)  //the character is NOT a valid date character
				$i:=1000  //stop loop
				ALERT:C41("The entered date is invalid.")
				uClearSelection(zDefFilePtr)
				$Continue:=False:C215
			End if 
		End for 
		
		If ($Continue)  //• 8/21/97 cs 
			$Date:=Date:C102($Text1)  //• 8/21/97 cs 
			QUERY:C277(zDefFilePtr->; aSlctField{zSelectNum}->=$Date)
		End if 
End case 