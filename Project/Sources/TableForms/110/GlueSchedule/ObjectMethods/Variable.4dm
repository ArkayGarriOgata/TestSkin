If (Length:C16(tText)>0)
	If (Position:C15("."; tText)=6)  //find by job
		$hit:=Find in array:C230(aJobit; tText+"@")
		If ($hit>-1)
			If (abHidden{$hit}=False:C215)
				OBJECT SET SCROLL POSITION:C906(aGlueListBox; $hit; *)
				LISTBOX SELECT ROW:C912(aGlueListBox; $hit; 0)
				EDIT ITEM:C870(aGlueListBox; $hit)
			Else 
				uConfirm(aJobit{$hit}+" is currently hidden"; "Ok"; "Shucks")
			End if 
		Else 
			BEEP:C151
		End if 
	Else   //find by product
		$hit:=Find in array:C230(aCPN; tText+"@")
		If ($hit>-1)
			If (abHidden{$hit}=False:C215)
				OBJECT SET SCROLL POSITION:C906(aGlueListBox; $hit; *)
				LISTBOX SELECT ROW:C912(aGlueListBox; $hit; 0)
			Else 
				uConfirm(aCPN{$hit}+" is currently hidden"; "Ok"; "Shucks")
			End if 
		Else 
			BEEP:C151
		End if 
	End if 
	
Else 
	BEEP:C151
End if 