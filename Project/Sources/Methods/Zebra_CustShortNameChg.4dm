//%attributes = {"publishedWeb":true}
//PM: Zebra_CustShortNameChg() -> 
//@author mlb - 4/24/03  11:09

If (fCanChange)
	If (Position:C15(Char:C90(13); tTo)=0)
		uConfirm("Do you want "+tTo+" to be saved for the next time you print labels for this customer?"; "Save"; "Just this time")
		If (ok=1)
			UNLOAD RECORD:C212([Customers:16])
			READ WRITE:C146([Customers:16])
			LOAD RECORD:C52([Customers:16])
			[Customers:16]ShortName:57:=tTo
			SAVE RECORD:C53([Customers:16])
			If ([Customers:16]ShortName:57#tTo)
				BEEP:C151
				ALERT:C41("Name change failed, try again later or contact Systems Dept.")
			Else 
				zwStatusMsg("Saved"; "Default Shortname is now "+tTo)
			End if 
			UNLOAD RECORD:C212([Customers:16])
			READ ONLY:C145([Customers:16])
			LOAD RECORD:C52([Customers:16])
		End if 
	End if 
	
Else 
	BEEP:C151
	zwStatusMsg("Can't Save"; "Default name used is from a Shipto Address")
End if 