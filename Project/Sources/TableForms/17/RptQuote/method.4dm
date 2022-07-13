//(LP)[CustomerOrder]RptQuot:
Case of 
	: (Form event code:C388=On Header:K2:17)
		sName:=""
		dDate:=4D_Current_date
		sAddress:=fGetAddressText([Estimates:17]z_Bill_To_ID:5)
		If ([Addresses:30]Salutation:29#"")
			sName:=sName+[Addresses:30]Salutation:29+" "
		End if 
		If ([Addresses:30]FirstName:27#"")
			sName:=sName+[Addresses:30]FirstName:27+" "
		End if 
		If ([Addresses:30]MI:28#"")
			sName:=sName+[Addresses:30]MI:28+" "
		End if 
		If ([Addresses:30]ArkayPOAddress:26#"")
			sName:=sName+[Addresses:30]ArkayPOAddress:26
		End if 
		If (sName#"")
			sAddress:=sName+Char:C90(13)+sAddress
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		sIntro:="Dear "
		Case of 
			: ([Addresses:30]FirstName:27#"")
				sIntro:=sIntro+[Addresses:30]FirstName:27
			: ([Addresses:30]ArkayPOAddress:26#"")
				sIntro:=sIntro+[Addresses:30]Salutation:29+" "+[Addresses:30]ArkayPOAddress:26
			Else 
				sIntro:=sIntro+[Addresses:30]Name:2
		End case 
		sIntro:=sIntro+";"+Char:C90(13)+Char:C90(13)
		//Text2Array2 (xText;axText;530;"Helvetica";10;0)
		// For ($i;1;Size of array(axText))
		// sStr255:=axText{$i}
		//  sIntro:=sIntro+sStr255+Char(13)+Char(13)
		// End for 
		sIntro:=sIntro+xText+Char:C90(13)+Char:C90(13)
		gRptQuoteBody
End case 
//EOP