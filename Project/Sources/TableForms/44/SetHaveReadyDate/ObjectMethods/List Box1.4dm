Case of 
	: (Form event code:C388=On Clicked:K2:4)
		If (ListBox1<=Size of array:C274(ListBox1))
			If (aSelected{ListBox1}="")
				aSelected{ListBox1}:="X"
				If (aDate{ListBox1}<=newHRD)  //move it out
					aDate{ListBox1}:=newHRD
				Else   // Modified by: Mel Bohince (3/10/16) give option to move sooner
					uConfirm("Make "+aCPN{ListBox1}+"'s HRD sooner than "+String:C10(aDate{ListBox1}; Internal date short:K1:7)+"?"; "Sooner"; "No Change")
					If (ok=1)
						aDate{ListBox1}:=newHRD
					Else 
						aSelected{ListBox1}:=""
					End if 
				End if 
				
			Else 
				aSelected{ListBox1}:=""
			End if 
			
			$hit:=Find in array:C230(aSelected; "X")
			If ($hit>-1)
				OBJECT SET ENABLED:C1123(bOk; True:C214)
			Else 
				OBJECT SET ENABLED:C1123(bOk; False:C215)
			End if 
			
		End if 
End case 
