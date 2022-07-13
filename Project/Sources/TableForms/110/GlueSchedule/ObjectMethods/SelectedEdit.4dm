// ----------------------------------------------------

//***TODO  set mulitple gluers

//try get the hilited rows

//ask for a gluer, validate choice

//set the aGluer array

//save to jmi record

//catch nothing hilited
$switch:=Request:C163("Set what?"; "Gluer, Priority, Separate, Comment, HRD, or Style")
If (ok=1)
	READ WRITE:C146([Job_Forms_Items:44])
	$value:=""
	Case of 
		: ($switch="Gluer")
			$value:=Request:C163("Gluer's ID:"; "")
			If (ok=1)
				For ($i; 1; Size of array:C274(aGlueListBox))
					If (aGlueListBox{$i})
						aGluer{$i}:=$value
						GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{$i})
						If (fLockNLoad(->[Job_Forms_Items:44]))
							[Job_Forms_Items:44]Gluer:47:=$value
							SAVE RECORD:C53([Job_Forms_Items:44])
						Else 
							uConfirm("Changes were not saved for item "+aJobit{$i}+", try again later."; "Ok"; "Help")
							aGluer{$i}:=[Job_Forms_Items:44]Gluer:47
						End if 
					End if 
				End for 
			End if 
			
		: ($switch="Priority")
			$value:=Request:C163("Priority: (negative = lifted)"; "1 Rush")
			If (ok=1)
				If (Length:C16($value)=0)
					$value:="0"
				End if 
				For ($i; 1; Size of array:C274(aGlueListBox))
					If (aGlueListBox{$i})
						aPrior{$i}:=Num:C11($value)
						GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{$i})
						If (fLockNLoad(->[Job_Forms_Items:44]))
							[Job_Forms_Items:44]Priority:48:=aPrior{$i}
							SAVE RECORD:C53([Job_Forms_Items:44])
						Else 
							uConfirm("Changes were not saved for item "+aJobit{$i}+", try again later."; "Ok"; "Help")
							aPrior{$i}:=[Job_Forms_Items:44]Priority:48
						End if 
					End if 
				End for 
			End if 
			
		: ($switch="Separate")
			$value:=Request:C163("Separate:"; "Done")
			If (ok=1)
				For ($i; 1; Size of array:C274(aGlueListBox))
					If (aGlueListBox{$i})
						aSeparate{$i}:=$value
						GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{$i})
						If (fLockNLoad(->[Job_Forms_Items:44]))
							[Job_Forms_Items:44]Separate:49:=$value
							SAVE RECORD:C53([Job_Forms_Items:44])
						Else 
							uConfirm("Changes were not saved for item "+aJobit{$i}+", try again later."; "Ok"; "Help")
							aSeparate{$i}:=[Job_Forms_Items:44]Separate:49
						End if 
					End if 
				End for 
			End if 
			
		: ($switch="Comment")
			$value:=Request:C163("Comment:"; "")
			If (ok=1)
				For ($i; 1; Size of array:C274(aGlueListBox))
					If (aGlueListBox{$i})
						aComment{$i}:=$value
						GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{$i})
						If (fLockNLoad(->[Job_Forms_Items:44]))
							[Job_Forms_Items:44]GluerComment:50:=$value
							SAVE RECORD:C53([Job_Forms_Items:44])
						Else 
							uConfirm("Changes were not saved for item "+aJobit{$i}+", try again later."; "Ok"; "Help")
							aComment{$i}:=[Job_Forms_Items:44]GluerComment:50
						End if 
					End if 
				End for 
			End if 
			
		: ($switch="HRD")
			$value:=Request:C163("HRD:"; "")
			If (ok=1)
				For ($i; 1; Size of array:C274(aGlueListBox))
					If (aGlueListBox{$i})
						aHRD{$i}:=Date:C102($value)
						GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{$i})
						If (fLockNLoad(->[Job_Forms_Items:44]))
							[Job_Forms_Items:44]MAD:37:=aHRD{$i}
							SAVE RECORD:C53([Job_Forms_Items:44])
						Else 
							uConfirm("Changes were not saved for item "+aJobit{$i}+", try again later."; "Ok"; "Help")
							aHRD{$i}:=[Job_Forms_Items:44]MAD:37
						End if 
					End if 
				End for 
			End if 
			
		: ($switch="Style")
			$value:=Request:C163("Style:"; "")
			If (ok=1)
				For ($i; 1; Size of array:C274(aGlueListBox))
					If (aGlueListBox{$i})
						aStyle{$i}:=$value
						GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{$i})
						If (fLockNLoad(->[Job_Forms_Items:44]))
							[Job_Forms_Items:44]GlueStyle:51:=aStyle{$i}
							SAVE RECORD:C53([Job_Forms_Items:44])
						Else 
							uConfirm("Changes were not saved for item "+aJobit{$i}+", try again later."; "Ok"; "Help")
							aStyle{$i}:=[Job_Forms_Items:44]GlueStyle:51
						End if 
					End if 
				End for 
			End if 
			
		Else 
			uConfirm("'"+$switch+"' was not understood.")
	End case 
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
		
		UNLOAD RECORD:C212([Job_Forms_Items:44])
		REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)  // Modified by: Mel Bohince (5/6/15) 
		
		
	Else 
		
		REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)  // Modified by: Mel Bohince (5/6/15) 
		
	End if   // END 4D Professional Services : January 2019 
	
	READ ONLY:C145([Job_Forms_Items:44])
	PSG_ServerArrays("die!")  //Kill the stored procedure so other users can get the changes
	
End if 



