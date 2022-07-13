//%attributes = {}
//(p) JBN_PrintHeader 
//form feed the print layout, increment page counter
//return the number of pixels printed
//$1 (optioinal) string  - flag do print specific header
//• 12/4/97 cs created
//• 1/30/98 cs added printing of checkboxes on page 2 below header
//• 2/13/98 cs problem with printing checkboxe area, fixed

C_LONGINT:C283($Pixels; $0)
C_TEXT:C284($1)

PAGE BREAK:C6(>)
iPage:=iPage+1  //increment page counter
Print form:C5([Jobs:15]; "JBN_Head1")
$Pixels:=29
Print form:C5([Jobs:15]; "JBN_Head2")
$Pixels:=$Pixels+34

Case of 
	: ($1="M")  //print machine header
		Print form:C5([Jobs:15]; "JBN_Head4")  //this header needs to show [caseform]formnumber
		$Pixels:=$Pixels+20
	: ($1="P")  //print Production item header
		
		If (Not:C34(fPrinted))  //print this ONLY on page 2,`• 2/13/98 cs 
			//------------- checkbox section -------
			
			If (Position:C15(";"; t21)>0)  //if the cust code key is a composite
				t21:=Replace string:C233(t21; ";"; ";        ")
			Else 
				t21:=""
			End if 
			t21:=t21+"  "+[Job_Forms:42]Notes:32
			
			$i:=Job_ProdHistory("find"; ([Jobs:15]CustID:2+":"+[Job_Forms:42]ProcessSpec:46); "JobBag")
			If ($i>0)
				$i:=Job_ProdHistory("gather"; "2"; "3"; "4"; "5"; ->t21)
			End if 
			$i:=Job_ProdHistory("finished")
			
			Print form:C5([Jobs:15]; "JBN_End")
			$Pixels:=$Pixels+176
			Print form:C5([Jobs:15]; "JBN_ProdHead")
			$Pixels:=$Pixels+24
			fPrinted:=True:C214  //• 2/13/98 cs mark this section as printed
		End if 
	Else 
		//print no special header    
End case 

$0:=$Pixels