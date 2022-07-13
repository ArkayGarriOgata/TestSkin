//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/13/13, 15:06:08
// ----------------------------------------------------
// Method: PlusMinusCheckColumns
// Description:
// Code for the columns to run.
// When clicked, put the JobIt number in the tJobIt var at the top.
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		tJobIt:=atJobIt{abJobIts}
		If (tJobIt#"")
			OBJECT SET ENABLED:C1123(*; "selected@"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		tJobIt:=atJobIt{abJobIts}
		If (tJobIt#"")
			OBJECT SET ENABLED:C1123(*; "selected@"; True:C214)
			ACCEPT:C269
			
		Else 
			OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
		End if 
		
End case 
