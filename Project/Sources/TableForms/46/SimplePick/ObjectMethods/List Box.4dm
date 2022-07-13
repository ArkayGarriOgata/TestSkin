// ----------------------------------------------------
// Method: [Customers_ReleaseSchedules].SimplePick.List Box
// ----------------------------------------------------

If (PickListBox<=Size of array:C274(PickListBox))
	OBJECT SET ENABLED:C1123(bInvoice; False:C215)
	Rama_Event_Notifier("list_box_click"; Current process:C322; aGCAST{PickListBox})
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=aGCAST{PickListBox}; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]skid_number:43#"000@"; *)  //gaylord
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:AV=@")
	Rama_Load_Inventory
	SORT ARRAY:C229(aPallet; aRecNo; aCPN; aBin; aQtyOnHand; aState; aPicked; >)
	
End if 

Case of   // Added by: Mark Zinke (11/21/12)
	: ((Form event code:C388=On Selection Change:K2:29) | (Form event code:C388=On Clicked:K2:4))
		If ((Find in array:C230(PickListBox; True:C214)>0) & (Records in selection:C76([Finished_Goods_Locations:35])>0))
			OBJECT SET ENABLED:C1123(bPrintDetail; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bPrintDetail; False:C215)
		End if 
End case 