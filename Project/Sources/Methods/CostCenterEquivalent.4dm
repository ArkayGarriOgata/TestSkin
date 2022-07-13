//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/30/07, 15:08:57
// ----------------------------------------------------
// Method: CostCenterEquivalent({cc_id})  --> 
// Description
// after removing old Haup CC's, need to replace in estimates with a 
// CC of equal class
// If you add code here, add it to PS_qryPrintingOnly, uInitInterPrsVar, MainEventCase, CostCenterEquivalent, and Object Method: [zz_control].MainEvent.Schedule1.
// ----------------------------------------------------
// Modified by: Mel Bohince (7/9/21) //set up group ipv's


C_TEXT:C284($0; $cc; $candidate)
C_LONGINT:C283($i; $hit)
C_TEXT:C284($list; $possible)

CostCtrInit  // Modified by: Mel Bohince (7/9/21) //set up group ipv's

$0:=""

Case of 
	: (Count parameters:C259=0)  //loaded by app_CommonArrays server-side on startup
		ARRAY TEXT:C222(aCostCenterEquivalent; 0)  //see also uInitInterPrsVar
		APPEND TO ARRAY:C911(aCostCenterEquivalent; <>PLATEMAKING)
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 405 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; <>PRESSES)
		//APPEND TO ARRAY(aCostCenterEquivalent;" 414 415 ")
		//APPEND TO ARRAY(aCostCenterEquivalent;" 41S ")
		//APPEND TO ARRAY(aCostCenterEquivalent;" 419 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; <>SHEETERS)
		//APPEND TO ARRAY(aCostCenterEquivalent;" 427 ")
		//APPEND TO ARRAY(aCostCenterEquivalent;" 431 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 442 443 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; <>STAMPERS)
		//APPEND TO ARRAY(aCostCenterEquivalent;" 551 552 553 554 555 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; <>BLANKERS)
		APPEND TO ARRAY:C911(aCostCenterEquivalent; <>EMBOSSERS)
		//APPEND TO ARRAY(aCostCenterEquivalent;" 463 563 ")
		//APPEND TO ARRAY(aCostCenterEquivalent;" 471 472 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; <>LAMINATERS)
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 491 493 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; <>GLUERS)
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 486 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 490 492 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 496 497 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 501 502 503 505 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 581 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 583 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 584 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 585 ")
		APPEND TO ARRAY:C911(aCostCenterEquivalent; " 888 ")
		
		READ ONLY:C145([Cost_Centers:27])  //see  aStdCC in CostCtrCurInit
		ALL RECORDS:C47([Cost_Centers:27])
		ARRAY TEXT:C222(aCostCenterValid; 0)
		SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; aCostCenterValid)
		REDUCE SELECTION:C351([Cost_Centers:27]; 0)
		SORT ARRAY:C229(aCostCenterValid; >)
		
	: (Count parameters:C259=1)
		$cc:=$1
		$hit:=Find in array:C230(<>CostCenterValid; $cc)
		If ($hit>-1)
			$0:=$cc
			
		Else   //find a replacement
			$cc:="@"+$cc+"@"
			$hit:=Find in array:C230(<>CostCenterEquivalent; $cc)
			If ($hit>-1)  //build a list of possible replacements
				$list:=""
				$possible:=Replace string:C233(<>CostCenterEquivalent{$hit}; " "; "")  // remove spaces and chomp by 3's
				
				For ($i; 1; Length:C16($possible); 3)
					$candidate:=Substring:C12($possible; $i; 3)
					$hit:=Find in array:C230(<>CostCenterValid; $candidate)
					If ($hit>-1)
						$list:=$list+$candidate+" "
					End if 
				End for 
				
				If (Length:C16($list)>2)
					//only take 3 characters, coerce to number and back again, then retest
					$cc:=Substring:C12(Request:C163("Enter one replacement for the "+Substring:C12($cc; 2; 3)+":"; $list; "Change"; "Cancel"); 1; 3)
					$cc:=String:C10(Num:C11($cc))
					If (OK=1)
						
						$hit:=Position:C15($cc; $list)  //make sure it was something in the list of possibles
						If ($hit>0)
							zwStatusMsg("C/C CHANGE"; $1+" was replaced with "+$cc)
							$0:=$cc
							
						Else 
							BEEP:C151
							ALERT:C41("Your entry was not one of "+$list+". Delete this sequence and re-add a C/C.")
						End if 
						
					End if 
					
				Else 
					BEEP:C151
					ALERT:C41("No valid equivalent C/C found. Delete this sequence and re-add a C/C.")
				End if 
				
			Else 
				BEEP:C151
				ALERT:C41("No equivalent C/C found. Delete this sequence and re-add a C/C.")
			End if 
			
		End if 
End case 