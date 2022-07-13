Case of 
	: (Form event code:C388=On Load:K2:1)
		C_LONGINT:C283($xlPosition)
		
		SetObjectProperties(""; ->atPath; False:C215)
		LISTBOX EXPAND:C1100(abVideoLB)
		SetObjectProperties(""; ->bExpand; True:C214; "Collapse")
		If (bOneVid)  // Added by: Mark Zinke (5/29/13) Auto play one video
			$xlPosition:=Find in array:C230(atName3; tVidName)
			WA OPEN URL:C1020(waViewer; atPath{$xlPosition})
			LISTBOX SELECT ROW:C912(abVideoLB; $xlPosition)
		End if 
End case 