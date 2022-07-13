//• mlb - 10/17/02  15:19 allow path  to be reset if in RoleImaging
C_TIME:C306($docRef)

If (User in group:C338(Current user:C182; "RoleImaging"))
	$path:=FG_ArtProPath("get")
	If (Length:C16($path)>10)
		uConfirm("This F/G is currently linked to "+$path; "OK"; "Reset")
		If (ok=0)  //reset
			$docRef:=Open document:C264(""; "*"; Read mode:K24:5)
			If (ok=1)
				CLOSE DOCUMENT:C267($docRef)
				$path:=FG_ArtProPath("set"; document)
				uConfirm("Open "+$path+" with ArtPro?"; "Open"; "Nope")
				If (ok=1)
					$path:=FG_ArtProPath("view")
				End if 
				
			Else 
				ALERT:C41("No link saved.")
			End if 
			
		Else   //imaging happy with path
			uConfirm("Open with ArtPro?"; "Open"; "Nope")
			If (ok=1)
				$path:=FG_ArtProPath("view")
			End if 
		End if 
		
	Else   //path not found
		$docRef:=Open document:C264(""; "*"; Read mode:K24:5)
		If (ok=1)
			CLOSE DOCUMENT:C267($docRef)
			$path:=FG_ArtProPath("set"; document)
			uConfirm("Open "+$path+" with ArtPro?"; "Open"; "Nope")
			If (ok=1)
				$path:=FG_ArtProPath("view")
			End if 
			
		Else 
			ALERT:C41("No link saved.")
		End if 
	End if   //path
	
Else   //not in Imaging, just open
	$path:=FG_ArtProPath("view")
End if 


