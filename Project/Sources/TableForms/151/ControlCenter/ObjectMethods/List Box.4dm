
Case of 
	: (Form event code:C388=On After Edit:K2:43)
		C_OBJECT:C1216($status_o)
		$status_o:=Form:C1466.toolDrawers.currItem.save()
		Form:C1466.toolDrawers.data:=Form:C1466.toolDrawers.data
		
		
		
	: (Form event code:C388=On Double Clicked:K2:5)
		C_OBJECT:C1216($obForm)
		$obForm:=New object:C1471
		$obForm.ent:=Form:C1466.toolDrawers.currItem
		vlWindowCounter:=vlWindowCounter+1
		$hPos:=vlWindowCounter*25
		$vPos:=100+(vlWindowCounter*25)
		
		$win:=Open form window:C675([Tool_Drawers:151]; "Detail"; Plain form window:K39:10; $hPos; $vPos)
		SET WINDOW TITLE:C213("Bin: "+$obForm.ent.Bin; $win)
		DIALOG:C40([Tool_Drawers:151]; "Detail"; $obForm; *)
		
		
		
End case 
