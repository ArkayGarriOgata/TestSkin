If ([Estimates_Carton_Specs:19]ProductCode:5#"")
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Estimates_Carton_Specs:19]CustID:6+":"+[Estimates_Carton_Specs:19]ProductCode:5)
	If (Records in selection:C76([Finished_Goods:26])=0)
		uConfirm([Estimates_Carton_Specs:19]ProductCode:5+" does not exist for this customer. Please enter the details."; "OK"; "Help")
		[Estimates_Carton_Specs:19]OriginalOrRepeat:9:="Original"
	Else 
		uConfirm("Make this carton spec like F/G: "+[Finished_Goods:26]ProductCode:1)
		If (OK=1)
			[Estimates_Carton_Specs:19]OriginalOrRepeat:9:="Repeat"
			FG_CspecLikeFG
			RELATE ONE:C42([Estimates_Carton_Specs:19]ProcessSpec:3)
		End if 
	End if 
Else 
	UNLOAD RECORD:C212([Finished_Goods:26])
End if 