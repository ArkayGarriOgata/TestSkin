//Script: b1()  112296  
//save data in arrays to disk file

C_TEXT:C284($text; $docPath)
C_LONGINT:C283($i; $cntTickets)
C_TIME:C306($docRef)
C_TEXT:C284($t; $cr)

$t:=Char:C90(9)
$cr:=Char:C90(13)
//*make sure there is something to save

$cntTickets:=Size of array:C274(adMADate)
If ($cntTickets>0)
	//*Open a document
	
	docName:="MachineTickets"+String:C10(TSTimeStamp)+".xls"
	$docRef:=util_putFileName(->docName)
	//$docPath:=PutFileName ("Save Machine Tickets as";("MachineTickets"+String(TSTimeStamp )))
	
	If ($docRef#?00:00:00?)
		$text:=""
		For ($i; 1; $cntTickets)
			$text:=$text+String:C10(adMADate{$i}; <>MIDDATE)+$t
			$text:=$text+asMAjob{$i}+$t
			$text:=$text+String:C10(aiMASeq{$i})+$t
			$text:=$text+asMACC{$i}+$t
			$text:=$text+String:C10(aiMAItemNo{$i})+$t
			$text:=$text+String:C10(arMAMRHours{$i})+$t
			$text:=$text+String:C10(arMARHours{$i})+$t
			$text:=$text+String:C10(arMADTHours{$i})+$t
			$text:=$text+asMADTCat{$i}+$t
			$text:=$text+String:C10(alMAGood{$i})+$t
			$text:=$text+String:C10(alMAWaste{$i})+$t
			$text:=$text+String:C10(aiShift{$i})+$t
			$text:=$text+aMRcode{$i}+$t
			$text:=$text+asP_C{$i}+$cr
		End for 
		
		SEND PACKET:C103($docRef; $text)
		
		CLOSE DOCUMENT:C267($docRef)
		zwStatusMsg("SAVED"; "Filename: "+docName)
		
	End if 
End if 