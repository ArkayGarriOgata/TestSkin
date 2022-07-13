//%attributes = {}
// _______
// Method: EDI_DESADV_BookingConf_manual   ( ) ->
// By: Mel Bohince @ 07/16/20, 08:15:46
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (7/21/20) pass the mode off to the BOL
// Modified by: Mel Bohince (3/30/21) check for locked record before beginning 

C_OBJECT:C1216($release_e; $status_o)
C_TEXT:C284($mode)
C_LONGINT:C283($loadNumber)

If (Form:C1466.selected.length>0)
	
	C_BOOLEAN:C305($continue)  // Modified by: Mel Bohince (3/30/21) check for locked record before beginning 
	$continue:=util_EntitySelectionLockTest(Form:C1466.selected)
	If ($continue)
		
		$mode:=Request:C163("Mode Load#"; "Ocean "; "Apply"; "Cancel")
		If (ok=1)
			
			
			C_LONGINT:C283($outerBar; $outerLoop; $out)  // Added by: Mel Bohince (6/26/20) progress indicator
			$outerBar:=Progress New  //new progress bar
			Progress SET TITLE($outerBar; "Setting mode and load#...")  //optional init of the thermoeters title
			Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button, see $continueInteration
			
			$out:=0  //init a counter for status message
			$outerLoop:=Form:C1466.selected.length  //set a limit for status message
			$continueInteration:=True:C214  //option to break out of ForEach
			//
			For each ($release_e; Form:C1466.selected) While ($continueInteration)
				
				$out:=$out+1  //update a counter// Added by: Mel Bohince (6/26/20) progress indicator
				Progress SET PROGRESS($outerBar; $out/$outerLoop)  //update the thermometer
				
				$continueInteration:=(Not:C34(Progress Stopped($outerBar)))  //test if cancel button clicked
				If ($continueInteration)  //respect the cancel if necessary
					//
					If (IBD_Append_b)  // Modified by: Mel Bohince (1/9/21) 
						$release_e.Mode:=$release_e.Mode+" "+$mode
					Else 
						$release_e.Mode:=$mode
					End if 
					
					If ($release_e.Milestones=Null:C1517)
						$release_e.Milestones:=New object:C1471
					End if 
					$release_e.Milestones.BKC:=String:C10(Current date:C33; Internal date short special:K1:4)
					
					// Modified by: Mel Bohince (7/21/20) pass the mode off to the BOL
					$loadNumber:=Num:C11($release_e.Mode)
					$release_e.RemarkLine2:=String:C10(Abs:C99($loadNumber))  //get the number, no hyphen
					$release_e.RemarkLine1:=Replace string:C233($release_e.Mode; String:C10($loadNumber); "")  //remove the number
					$release_e.RemarkLine1:=Replace string:C233($release_e.RemarkLine1; "-"; "")  //remove the hyphen
					
					$status_o:=$release_e.save(dk auto merge:K85:24)
					If ($status_o.success)
						zwStatusMsg("SUCCESS"; "Release "+String:C10($release_e.ReleaseNumber)+" mode set to "+$mode)
					Else 
						BEEP:C151
						zwStatusMsg("FAIL"; "Release "+String:C10($release_e.ReleaseNumber)+" could NOT set mode.")
					End if 
					
				Else   //bailed// Added by: Mel Bohince (6/26/20) progress indicator
					ALERT:C41("Aborted before working on item "+String:C10($out)+": "+$outItem)  //optional debrief
				End if   //$continueInteration
				//
			End for each 
			
			Progress QUIT($outerBar)  //remove the thermometer// Added by: Mel Bohince (6/26/20) progress indicator
			
			Form:C1466.listBoxEntities:=Form:C1466.listBoxEntities  //Form.selected
			
		End if   //requested mode
		
	Else   //something was locked
		Form:C1466.listBoxEntities:=Form:C1466.selected
	End if   //locked record detected
	
	
Else 
	uConfirm("Please select the releases that have received the Booking Confirmation."; "Ok"; "Help")
End if 