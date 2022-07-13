//Modified to handle a Hierarchal popup menu. Mark Zinke 12/18/12

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$vlItemPos:=Selected list items:C379(xlAskMeList)
		If ($vlItemPos>0)
			GET LIST ITEM:C378(xlAskMeList; $vlItemPos; $vlItemRef; $fgKey; $hSublist; $vbExpanded)
			
			If (AskMeRejectKeys($fgKey))
				If (Position:C15(":"; $fgKey)=6)
					sCustId:=Substring:C12($fgKey; 1; 5)
					sCPN:=Substring:C12($fgKey; 7)
				Else 
					sCustId:=""
					sCPN:=Substring:C12($fgKey; 2)
				End if 
				sAskMeCPN(sCPN)
			End if 
		End if 
End case 