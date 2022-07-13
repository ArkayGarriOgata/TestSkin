
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([x_shell_scripts:138]))
			If (Length:C16(<>Script)>0)
				[x_shell_scripts:138]scriptText:3:=<>Script
				$theTable:=Position:C15("from "; <>Script)+5
				[x_shell_scripts:138]description:2:="["+<>zResp+"] "+Substring:C12(<>Script; $theTable; 30)
				<>Script:=""
			End if 
		End if   //new
		
		
	: (Form event code:C388=On Validate:K2:3)
		If (Position:C15("select"; [x_shell_scripts:138]scriptText:3)>0)
			If (Substring:C12([x_shell_scripts:138]scriptName:1; 1; 4)#"SQL_")
				[x_shell_scripts:138]scriptName:1:="SQL_"+[x_shell_scripts:138]scriptName:1
			End if 
		End if 
		
End case 
