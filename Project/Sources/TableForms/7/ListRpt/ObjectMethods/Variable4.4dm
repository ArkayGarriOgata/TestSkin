//(S) xText2
If (Form event code:C388=On Load:K2:1)
	xText2:=""
	If ([Vendors:7]Phone:11#"")
		xText2:="Ph:  ("+Substring:C12([Vendors:7]Phone:11; 1; 3)+")"+Substring:C12([Vendors:7]Phone:11; 4; 3)+"-"+Substring:C12([Vendors:7]Phone:11; 7)+<>sCR+<>sCR
	End if 
	If ([Vendors:7]Fax:12#"")
		xText2:=xText2+"Fax: ("+Substring:C12([Vendors:7]Fax:12; 1; 3)+")"+Substring:C12([Vendors:7]Fax:12; 4; 3)+"-"+Substring:C12([Vendors:7]Fax:12; 7)
	End if 
End if 
//EOS