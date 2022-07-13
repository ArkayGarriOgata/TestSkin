//%attributes = {}
// ----------------------------------------------------
// Method: _version210922
// By: Garri Ogata
// Description:  This method will clean up the states fields
// ----------------------------------------------------

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cState)
	
	C_LONGINT:C283($nNumberOfLoops)
	
	C_OBJECT:C1216($esAddresses)
	C_OBJECT:C1216($eAddress)
	C_OBJECT:C1216($oProgress)
	
	ARRAY TEXT:C222($atStripCharacter; 0)
	ARRAY TEXT:C222($atFrontBack; 0)
	
	$cState:=New collection:C1472()
	
	$esAddresses:=New object:C1471()
	$eAddress:=New object:C1471()
	
	$esAddresses:=ds:C1482.Addresses.query("Active = :1 And Country = :2"; True:C214; "US")
	
	$nNumberOfLoops:=$esAddresses.length
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfLoops
	$oProgress.tTitle:="Fixing States"
	$oProgress.nLoop:=0
	
	APPEND TO ARRAY:C911($atStripCharacter; CorektPeriod)
	APPEND TO ARRAY:C911($atStripCharacter; CorektLeftParen)
	APPEND TO ARRAY:C911($atStripCharacter; CorektRightParen)
	
	APPEND TO ARRAY:C911($atFrontBack; CorektSpace)
	APPEND TO ARRAY:C911($atFrontBack; CorektCR)
	APPEND TO ARRAY:C911($atFrontBack; Char:C90(Tab:K15:37))
	APPEND TO ARRAY:C911($atFrontBack; CorektComma)
	
End if   //Done initialize

For each ($eAddress; $esAddresses)  //Addresses
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$oProgress.nLoop:=$oProgress.nLoop+1
		$oProgress.tMessage:="Cleaning "+$eAddress.State
		
		Prgr_Message($oProgress)
		
		$eAddress.Country:=Core_Text_RemoveGremlinsT($eAddress.Country)
		$eAddress.Country:=Core_Text_RemoveT($eAddress.Country; ->$atFrontBack; 3)
		
		If (($eAddress.Country="US") | ($eAddress.Country=CorektBlank))  //US
			
			$eAddress.Country:="US"
			
			//Clean state
			
			$tState:=$eAddress.State
			
			$tState:=Core_Text_RemoveGremlinsT($tState)
			$tState:=Core_Text_RemoveT($tState; ->$atStripCharacter)
			$tState:=Core_Text_RemoveT($tState; ->$atFrontBack; 3)
			
			Case of   //Abbreviate
					
				: (Position:C15("Arizona"; $tState)>0)
					
					$tState:="AZ"
					
				: (Position:C15("Florida"; $tState)>0)
					
					$tState:="FL"
					
				: (Position:C15("Illinois"; $tState)>0)
					
					$tState:="IL"
					
				: (Position:C15("Ohio"; $tState)>0)
					
					$tState:="OH"
					
				: (Position:C15("Oregon"; $tState)>0)
					
					$tState:="OR"
					
				: (Position:C15("Texas"; $tState)>0)
					
					$tState:="TX"
					
				: (Position:C15("Vermont"; $tState)>0)
					
					$tState:="VT"
					
				: (Position:C15("RY"; $tState)>0)
					
					$tState:="KY"
					
				: (Position:C15("ON"; $tState)>0)
					
					$eAddress.Country:="CA"
					
				: (Position:C15("QC"; $tState)>0)
					
					$eAddress.Country:="CA"
					
				: (Position:C15("Quebec"; $tState)>0)
					
					$tState:="QC"
					$eAddress.Country:="CA"
					
			End case   //Done abbreviate
			
			$tState:=Uppercase:C13($tState)
			$tCleanState:=CorektBlank
			
			For ($nCharacter; 1; Length:C16($tState))  //Scrub state
				
				$nAscii:=Character code:C91($tState[[$nCharacter]])
				
				If (($nAscii>=65) & ($nAscii<=90))  //A-Z
					
					$tCleanState:=$tCleanState+Char:C90($nAscii)
					
				End if   //Done A-Z
				
			End for   //Done scrub state
			
			$eAddress.State:=$tCleanState
			
			$oSaveResult:=$eAddress.save()
			
		End if   //Done US
		
	End if   //Done progress
	
End for each   //Done addresses

Prgr_Quit($oProgress)