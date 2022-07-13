// ----------------------------------------------------
// Object Method: [ProductionSchedules].GlueSchedule.bFind
// ----------------------------------------------------

If (Length:C16(tText)>0)
	If (Position:C15("."; tText)=6)  //find by job
		$rtn:=PSG_LocalArray("sort"; 4)  // sort by jobit
		
		$hit:=Find in array:C230(aJobit; tText+"@")
		If ($hit>-1)
			If (abHidden{$hit}=False:C215)
				OBJECT SET SCROLL POSITION:C906(aGlueListBox; $hit; *)
				LISTBOX SELECT ROW:C912(aGlueListBox; $hit; 0)
				EDIT ITEM:C870(aGlueListBox; $hit)
				
				If (Length:C16(tText)=8)  //find by jobform
					Repeat 
						$hit:=Find in array:C230(aJobit; tText+"@"; ($hit+1))
						If ($hit>-1)
							If (abHidden{$hit}=False:C215)
								LISTBOX SELECT ROW:C912(aGlueListBox; $hit; 1)
							End if   //hidden
						End if   // found
					Until ($hit=-1)
					
				End if 
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


/////
//If (Length(<>jobform)=8)
//tText:=<>jobform
//$numElements:=Size of array(aGlueListBox)
//uThermoInit ($numElements;"Looking for "+tText)
//For ($i;1;$numElements)
//If (aJobit{$i}=(tText+"@"))
//abHidden{$i}:=False
//Else 
//abHidden{$i}:=True
//End if 
//uThermoUpdate ($i)
//End for 
//uThermoClose 
//Else 
//BEEP
//End if 

