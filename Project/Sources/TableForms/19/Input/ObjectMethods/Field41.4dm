// ----------------------------------------------------
// Object Method: [Estimates_Carton_Specs].Input.Field41
// ----------------------------------------------------

If ([Estimates_Carton_Specs:19]Classification:72#"00") & ([Estimates_Carton_Specs:19]Classification:72#"__") & ([Estimates_Carton_Specs:19]Classification:72#"")
	QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Estimates_Carton_Specs:19]Classification:72)
	If (Records in selection:C76([Finished_Goods_Classifications:45])=0)
		uConfirm("Invalid Classification."; "OK"; "Help")
		[Estimates_Carton_Specs:19]Classification:72:=Old:C35([Estimates_Carton_Specs:19]Classification:72)
		GOTO OBJECT:C206([Estimates_Carton_Specs:19]Classification:72)
	End if 
End if 