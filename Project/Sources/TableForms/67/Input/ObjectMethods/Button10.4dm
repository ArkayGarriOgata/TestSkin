C_TEXT:C284(<>JOBIT)
If (app_LoadIncludedSelection("init"; ->[Finished_Goods:26]ProductCode:1)>0)
	
	$i:=qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; [Finished_Goods:26]ProductCode:1)
	If ($i>0)
		<>JOBIT:=[Job_Forms_Items:44]Jobit:4
	Else 
		<>JOBIT:=""
	End if 
	
	PK_ShippingContainerUI([Finished_Goods:26]OutLine_Num:4)
	
	app_LoadIncludedSelection("clear"; ->[Finished_Goods:26]ProductCode:1)
End if 