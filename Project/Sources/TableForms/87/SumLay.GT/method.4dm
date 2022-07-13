If (Form event code:C388=On Display Detail:K2:22)
	If (cbUseK=1)
		For ($c; 4; 18)  //* for each column assign detail value
			If (($c#13) & ($c#15))
				$ptrT:=Get pointer:C304("tCol"+String:C10($c))
				OBJECT SET FORMAT:C236($ptrT->; "###,##0 k;(###,##0) k")
			End if 
		End for 
		
		
	End if 
End if 