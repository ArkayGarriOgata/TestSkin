Case of 
	: (Form event code:C388=On Getting Focus:K2:7)
		$i:=qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; [Finished_Goods:26]ProductCode:1)
		zwStatusMsg("ENTER HRD"; "Item "+[Finished_Goods:26]ProductCode:1+" of form "+[Job_Forms_Master_Schedule:67]JobForm:4+" called jobit "+[Job_Forms_Items:44]Jobit:4+" cpn "+[Job_Forms_Items:44]ProductCode:3)
		
	: (Form event code:C388=On Data Change:K2:15)
		If ([Job_Forms_Items:44]MAD:37>=[Job_Forms_Master_Schedule:67]MAD:21)
			SAVE RECORD:C53([Job_Forms_Items:44])
		Else 
			uConfirm("You can't enter a date before "+String:C10([Job_Forms_Master_Schedule:67]MAD:21; System date short:K1:1); "OK"; "Help")
			[Job_Forms_Items:44]MAD:37:=Old:C35([Job_Forms_Items:44]MAD:37)
		End if 
End case 