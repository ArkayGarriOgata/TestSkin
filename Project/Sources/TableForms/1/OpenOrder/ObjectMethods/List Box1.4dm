Case of 
	: (Form event code:C388=On Clicked:K2:4)
		If (aSelected{ListBox1}="")
			For ($i; 1; Size of array:C274(aSelected))
				aSelected{$i}:=""
			End for 
			aSelected{ListBox1}:="X"
			
			Ord_findSelectedDifferencial(sPONum; asCaseID{ListBox1})
			
		Else 
			aSelected{ListBox1}:=""
			REDUCE SELECTION:C351([Estimates_Differentials:38]; 0)
		End if 
		
		$hit:=Find in array:C230(aSelected; "X")
		If ($hit>-1)
			OBJECT SET ENABLED:C1123(bPick; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bPick; False:C215)
		End if 
		
End case 





