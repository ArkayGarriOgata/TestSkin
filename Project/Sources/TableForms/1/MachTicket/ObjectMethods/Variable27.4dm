//Script:[control].MachTicket.b2()  112296  
//restore saved machine tickets to the arrays
//•112696    typo, declare $oneTicket as text

C_TEXT:C284($text; $docPath; $oneTicket)
C_LONGINT:C283($i; $cntTickets; $Position)
C_TIME:C306($docRef)
C_TEXT:C284($t; $cr)

$t:=Char:C90(9)
$cr:=Char:C90(13)

//*make sure there is something to save
CONFIRM:C162("Replace displayed Machine Tickets with saved ones?")  //•112696    typo
If (OK=1)
	$docRef:=Open document:C264($docPath)
	If (OK=1)
		$text:=""
		RECEIVE PACKET:C104($docRef; $text; 32000)
		
		If (OK=1)
			$cntTickets:=EDI_countCR(Length:C16($text); $text)
			gMTsizeArrays(0)
			gMTsizeArrays($cntTickets)
			
			For ($i; 1; $cntTickets)
				$Position:=Position:C15($CR; $text)
				$oneTicket:=Substring:C12($text; 1; $Position-1)  //get the first line
				$text:=Substring:C12($text; $Position+1)  //chop off the first line
				adMADate{$i}:=Date:C102(EDI_GetField(1; $oneTicket))  //•112696    Runtime error
				asMAjob{$i}:=EDI_GetField(2; $oneTicket)
				aiMASeq{$i}:=Num:C11(EDI_GetField(3; $oneTicket))
				asMACC{$i}:=EDI_GetField(4; $oneTicket)
				aiMAItemNo{$i}:=Num:C11(EDI_GetField(5; $oneTicket))
				arMAMRHours{$i}:=Num:C11(EDI_GetField(6; $oneTicket))
				arMARHours{$i}:=Num:C11(EDI_GetField(7; $oneTicket))
				arMADTHours{$i}:=Num:C11(EDI_GetField(8; $oneTicket))
				asMADTCat{$i}:=EDI_GetField(9; $oneTicket)
				alMAGood{$i}:=Num:C11(EDI_GetField(10; $oneTicket))
				alMAWaste{$i}:=Num:C11(EDI_GetField(11; $oneTicket))
				aiShift{$i}:=Num:C11(EDI_GetField(12; $oneTicket))
				aMRcode{$i}:=EDI_GetField(13; $oneTicket)
				asP_C{$i}:=EDI_GetField(14; $oneTicket)
			End for 
			OBJECT SET ENABLED:C1123(bOK; True:C214)  // Added by: Mark Zinke (11/1/13) 
			OBJECT SET ENABLED:C1123(bOKStay; True:C214)  // Added by: Mark Zinke (11/1/13) 
			
		Else 
			BEEP:C151
			ALERT:C41("Error reading "+$docPath)
		End if 
		
		CLOSE DOCUMENT:C267($docRef)
		
	End if 
End if 