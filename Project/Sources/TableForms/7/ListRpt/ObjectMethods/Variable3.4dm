//(S) xText
If (Form event code:C388=On Display Detail:K2:22)
	xText:=[Vendors:7]Name:2+<>sCR+[Vendors:7]Address1:4+<>sCR
	If ([Vendors:7]Address2:5#"")
		xText:=xText+[Vendors:7]Address2:5+<>sCR
	End if 
	If ([Vendors:7]Web_URL:6#"")
		xText:=xText+[Vendors:7]Web_URL:6+<>sCR
	End if 
	xText:=xText+[Vendors:7]City:7+", "+[Vendors:7]State:8+" "+Substring:C12([Vendors:7]Zip:9; 1; 5)
	If (Substring:C12([Vendors:7]Zip:9; 6; 4)#"")
		xText:=xText+"-"+Substring:C12([Vendors:7]Zip:9; 6; 4)
	End if 
	xText:=xText+<>sCR+[Vendors:7]Country:10
End if 
//EOS