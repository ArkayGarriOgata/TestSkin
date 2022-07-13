// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/21/06, 19:45:11
// ----------------------------------------------------
// Method: Trigger: Inbox
// Description
// dup the blob as text (up to 32k) and extract PO numbers from BGM segments for xref
//
// Modified by: Mel Bohince (5/7/15) save po's to records rather than textfield, when many po's, data corrupts
// ----------------------------------------------------

C_LONGINT:C283($0; $len; $position; $i; $keyLength; $dbevent)
$0:=0
C_TEXT:C284($lookingForText; $po; $ignorIfDelfor)
C_TEXT:C284($char)
C_TEXT:C284($poNumbers)
C_TEXT:C284($suffix)

$dbevent:=Trigger event:C369
Case of 
	: ($dbevent=On Saving New Record Event:K3:1) | ($dbevent=On Saving Existing Record Event:K3:2)
		
		If (Length:C16([edi_Inbox:154]Content_Text:10)=0)
			$len:=BLOB size:C605([edi_Inbox:154]Content:3)-1
			$suffix:=""
			If ($len>32000)
				$len:=31997
				$suffix:="..."
			End if 
			//copy the blob into text
			[edi_Inbox:154]Content_Text:10:=BLOB to text:C555([edi_Inbox:154]Content:3; Mac text without length:K22:10)+$suffix
		End if 
		
		If (Length:C16([edi_Inbox:154]PO_Numbers:11)=0) | ([edi_Inbox:154]Error:8="po")
			[edi_Inbox:154]Error:8:=""
			$lookingForText:="BGM+105+"
			$keyLength:=Length:C16($lookingForText)
			ARRAY INTEGER:C220($lookingForBytes; 0)
			ARRAY INTEGER:C220($lookingForBytes; $keyLength)
			//put each of these letters in an array that can be used for a pattern
			For ($i; 1; $keyLength)
				$lookingForBytes{$i}:=Character code:C91($lookingForText[[$i]])
			End for 
			//dropout if this is a delfor
			$delforText:="BGM+241+"  //this is the signature of a delfor message
			$delforLength:=Length:C16($delforText)
			ARRAY INTEGER:C220($stopIfDelfor; 0)
			ARRAY INTEGER:C220($stopIfDelfor; $delforLength)
			For ($i; 1; $delforLength)
				$stopIfDelfor{$i}:=Character code:C91($delforText[[$i]])
			End for 
			
			$len:=BLOB size:C605([edi_Inbox:154]Content:3)-1
			$inWord:=False:C215
			$inDelFor:=False:C215
			$poNumbers:=""  // Modified by: Mel Bohince (5/7/15) this use to hold the po's as text
			$numPOs:=0
			$po:=""
			$char:=""
			
			For ($position; 0; $len)
				
				If (Not:C34($inDelFor))
					
					If ($inWord)  //grab the po
						
						$char:=Char:C90([edi_Inbox:154]Content:3{$position})
						If ($char#"+")  //element marker
							$po:=$po+$char
						Else 
							$inWord:=False:C215
							// Modified by: Mel Bohince (5/7/15) 
							//$poNumbers:=$poNumbers+$po+" "
							CREATE RECORD:C68([edi_po_list:182])
							[edi_po_list:182]customers_po:3:=$po
							[edi_po_list:182]inbox_id:2:=[edi_Inbox:154]ID:1
							SAVE RECORD:C53([edi_po_list:182])
							UNLOAD RECORD:C212([edi_po_list:182])
							$numPOs:=$numPOs+1
							If ($numPOs>3)
								$poNumbers:=String:C10($numPOs)+" PO's"
							Else 
								$poNumbers:=$poNumbers+$po+" "
							End if 
							$po:=""
						End if 
						
					Else   //look for the 'BGM+105+'
						//see if this char and next 8 match the pattern
						For ($i; 1; $keyLength)
							$currentByte:=[edi_Inbox:154]Content:3{$position+($i-1)}
							
							Case of 
								: ($currentByte=$lookingForBytes{$i})
									$inWord:=True:C214  //lookin good so far
									
								: ($currentByte=$stopIfDelfor{$i})
									$inDelFor:=True:C214
									
								Else   //break
									$i:=$i+$keyLength+9999
									$inWord:=False:C215
							End case 
						End for 
						
						If ($inWord)  //advance the cursor
							$position:=$position+($keyLength-1)
						End if 
						
					End if 
					
				Else 
					$position:=$position+$len
					$poNumbers:="DELFOR"
				End if 
				
			End for 
			
			[edi_Inbox:154]PO_Numbers:11:=$poNumbers
			
		End if 
		
	: ($dbevent=On Deleting Record Event:K3:3)
		READ WRITE:C146([edi_po_list:182])
		QUERY:C277([edi_po_list:182]; [edi_po_list:182]inbox_id:2=[edi_Inbox:154]ID:1)
		DELETE SELECTION:C66([edi_po_list:182])
		
		
End case 
