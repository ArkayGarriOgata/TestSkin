C_LONGINT:C283($xlColumn; $xlRow)

If (Find in array:C230(bWindowNames; True:C214)>0)
	OBJECT SET ENABLED:C1123(bRemove; True:C214)
	OBJECT SET ENABLED:C1123(bOK; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bRemove; False:C215)
	OBJECT SET ENABLED:C1123(bOK; False:C215)
End if 

If (Form event code:C388=On Data Change:K2:15)
	LISTBOX GET CELL POSITION:C971(bWindowNames; $xlColumn; $xlRow)
	For ($i; 1; Size of array:C274(abDefault))
		If ($i#$xlRow)
			abDefault{$i}:=False:C215
		End if 
	End for 
End if 