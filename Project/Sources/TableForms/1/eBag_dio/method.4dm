//FM: eBag_dio() -> 
//@author mlb - 1/29/02  15:11

$gluingUser:=(Substring:C12(Current user:C182; 1; 4)="Glue")  // Modified by: Mel Bohince (10/12/17)
//If (Current user="Designer")  // Modified by: Mel Bohince (10/12/17)
//CONFIRM("Act like Glue line user?";"Regular";"Gluer")
//If (ok=1)
//$gluingUser:=False
//Else 
//$gluingUser:=True
//End if 
//End if 
C_LONGINT:C283($tab; $itemRef)
C_TEXT:C284($itemText; $seq)

If (Length:C16(<>jobform)=8)
	sCriterion1:=<>jobform
	If (Length:C16(<>jobformseq)=12) & (Substring:C12(<>jobformseq; 1; 8)=sCriterion1)  // Modified by: Mel Bohince (10/12/17) 
		sJobSeq:=Substring:C12(<>jobformseq; 10)
	Else 
		sJobSeq:=""
	End if 
End if 
<>jobformseq:=""  //single serving size

Case of 
	: (Form event code:C388=On Load:K2:1)
		vAskMePID:=0
		SetObjectProperties("repeat@"; -><>NULL; False:C215)
		repeatJobText:=""
		C_LONGINT:C283(hlAssignable)
		hlAssignable:=Load list:C383("ToDoAssignable")
		
		If (Length:C16(sCriterion1)=8)
			eBag_findJobForm
			$lastSequenceTab:=Count list items:C380(ieBagTabs)  // Modified by: Mel Bohince (10/12/17) 
			
			Case of 
				: ($gluingUser)  //gluers always start at the back
					
					eBag_SetView($lastSequenceTab)  // controls Machine Ticket buttons too
					
				Else   //maybe go direct to sequence's tab
					
					If (Length:C16(sJobSeq)=3)  // Modified by: Mel Bohince (10/12/17) select tab
						For ($tab; 1; $lastSequenceTab)
							GET LIST ITEM:C378(ieBagTabs; $tab; $itemRef; $itemText)
							$seq:=Substring:C12($itemText; 1; 3)
							If ($seq=sJobSeq)
								eBag_SetView($tab)
								$tab:=$tab+$lastSequenceTab  //break
							End if 
						End for 
						
					Else   //seq unknown goto spec
						eBag_SetView(1)
					End if 
					
			End case 
			
			
		End if 
		
		If (<>PHYSICAL_INVENORY_IN_PROGRESS)  // Modified by: Mel Bohince (12/18/19) 
			OBJECT SET ENABLED:C1123(*; "MachTick@"; False:C215)
			OBJECT SET ENABLED:C1123(*; "RMIssue"; False:C215)  // Modified by: Mel Bohince (1/2/20) 
		End if 
		
	: (Form event code:C388=On Outside Call:K2:11)  //• mlb - 11/14/02  12:20
		If (<>fQuit4D)
			CANCEL:C270
		Else 
			If (Length:C16(sCriterion1)=8)
				eBag_findJobForm
				$lastSequenceTab:=Count list items:C380(ieBagTabs)
				
				Case of 
					: ($gluingUser)
						eBag_SetView($lastSequenceTab)  // controls Machine Ticket buttons too
						
					Else 
						If (Length:C16(sJobSeq)=3)  // Modified by: Mel Bohince (10/12/17) select tab
							For ($tab; 1; $lastSequenceTab)
								GET LIST ITEM:C378(ieBagTabs; $tab; $itemRef; $itemText)
								$seq:=Substring:C12($itemText; 1; 3)
								If ($seq=sJobSeq)
									eBag_SetView($tab)
									$tab:=$tab+$lastSequenceTab  //break
								End if 
							End for 
						Else 
							eBag_SetView(1)  //seq unknown goto spec
						End if 
						
				End case 
			End if   //form
		End if   //quit
		
	: (Form event code:C388=On Close Box:K2:21)
		//sCriterion1:="82123.03"  `kludge to release stubborn record lock
		//eBag_findJobForm   `kludge to release stubborn record lock
		
		eBag_releaseRecords
		//GOTO PAGE(1)
		eBag_unloadRelated
		CANCEL:C270
		//HIDE PROCESS(Current process)
End case 