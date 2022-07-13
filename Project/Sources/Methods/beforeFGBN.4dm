//%attributes = {"publishedWeb":true}
//(P) beforeFGBN: before phase processing for [FG_BINS]

If (User in group:C338(Current user:C182; "AccountManager"))
	fFGBNMaint:=True:C214
	//asFGBNPages:=Layout page
	If (Record number:C243([Finished_Goods_Locations:35])=-3)
		sFGBNAction:="NEW"
		[Finished_Goods_Locations:35]ModDate:21:=4D_Current_date
		[Finished_Goods_Locations:35]ModWho:22:=<>zResp
		[Finished_Goods_Locations:35]ProductCode:1:=[Finished_Goods:26]ProductCode:1
		[Finished_Goods_Locations:35]CustID:16:=[Finished_Goods:26]CustID:2
	Else 
		sFGBNAction:=fGetMode(iMode)
	End if 
	Case of 
		: (sFGBNAction#"MODIFY")
			OBJECT SET ENABLED:C1123(hdFGBN; False:C215)
		: (sFGBNAction="REVIEW")
			OBJECT SET ENABLED:C1123(haFGBN; False:C215)
	End case 
Else 
	BEEP:C151
	ALERT:C41("You must be an Account Mananger to make inventory adjustments.")
	CANCEL:C270
End if 