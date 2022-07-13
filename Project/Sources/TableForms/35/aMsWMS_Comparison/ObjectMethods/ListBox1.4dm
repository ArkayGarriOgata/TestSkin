// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.ListBox1   ( ) ->
// By: Mel Bohince @ 06/10/20, 08:15:18
// Description
// 
// ----------------------------------------------------


app_form_ListBox

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		If (Form:C1466.position>0)
			<>AskMeFG:=Form:C1466.clicked.ProductCode
			<>AskMeCust:=Form:C1466.clicked.CustID
			SET TEXT TO PASTEBOARD:C523(<>AskMeFG)
			zwStatusMsg("COPIED"; "ProductCode "+<>AskMeFG+" is ready to Paste")
		End if 
		
		
	: (Form event code:C388=On Double Clicked:K2:5)
		
		Form:C1466.editEntity:=ds:C1482.Finished_Goods_Locations.query("Jobit = :1 and Location = :2"; Form:C1466.clicked.ProductCode; Form:C1466.clicked.Location)
		
End case 

Release_ShipMgmt_selectBtns

