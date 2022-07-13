//OM: sCriterion1() -> 
//@author mlb - 5/30/02  10:28

app_Log_Usage("log"; "eBag"; sCriterion1)
sJobSeq:=""

eBag_findJobForm
If (Length:C16(sCriterion1)=8)
	$gluingUser:=(Substring:C12(Current user:C182; 1; 4)="Glue")  // Modified by: Mel Bohince (10/12/17)
	
	$lastSequenceTab:=Count list items:C380(ieBagTabs)  // Modified by: Mel Bohince (10/12/17) 
	Case of 
		: ($gluingUser)
			eBag_SetView($lastSequenceTab)  // controls Machine Ticket buttons too
			
		Else   //maybe go direct to sequence's tab
			
			If (Length:C16(sJobSeq)=3)  // Modified by: Mel Bohince (10/12/17) select tab
				For ($item; 1; $lastSequenceTab)
					GET LIST ITEM:C378(ieBagTabs; $tab; $itemRef; $itemText)
					$seq:=Substring:C12($itemText; 1; 3)
					If ($seq=sJobSeq)
						eBag_SetView($tab)
						//FORM GOTO PAGE($item)  //was 3
						//SELECT LIST ITEMS BY REFERENCE(ieBagTabs;$itemRef)
						$item:=$item+$lastSequenceTab  //break
					End if 
				End for 
				
			Else   //seq unknown
				eBag_SetView(1)
			End if 
			
	End case 
	
Else 
	BEEP:C151
End if 

