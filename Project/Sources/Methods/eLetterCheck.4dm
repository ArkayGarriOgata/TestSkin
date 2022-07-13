//%attributes = {"publishedWeb":true}
//(p) eLetterCheck
//determines if the user type a letter and then sets an interP to carry the char
//◊aArrayPtr points to array to check
//system DEPENDS on the existance of an Up & down arrow attached buttons
//see [control]selectfile as example
//• 8/13/97 cs created

If ((keycode>=65) & (KeyCode<=90)) | ((Keycode>=97) & (KeyCOde<=122))  //this is alphbetic  
	Repeat   //after user enters a letterlocate it
		$loc:=Find in array:C230(<>aArrayPtr->; Char:C90(KeyCode)+"@")
		
		If ($Loc<0)  //if it can not be found
			KeyCode:=KeyCode-1  // find the next smallest letter and try again
		End if 
	Until ($Loc>0) | ((keycode<65) | ((KeyCode>90) & (Keycode<97)) | (KeyCode>122))
	
	If ($Loc>0)
		<>aArrayPtr->:=$loc
		If ($Loc<Size of array:C274(<>aArrayPtr->))
			POST KEY:C465(31)  //down
			DELAY PROCESS:C323(Current process:C322; 5)  //delay to allow window to update
			POST KEY:C465(30)  //up
		Else 
			POST KEY:C465(30)  //up
			DELAY PROCESS:C323(Current process:C322; 5)  //delay to allow window to update
			POST KEY:C465(31)  //down
		End if 
	End if 
End if 