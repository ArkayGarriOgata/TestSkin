sCriterion2:=Substring:C12(aText{0}; 1; 9)
$hit:=Find in array:C230(aPOIpoiKey; sCriterion2)
rReal1:=0
If ($hit>-1)
	
	READ ONLY:C145([Purchase_Orders_Items:12])
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
	SET QUERY LIMIT:C395(0)
	If (Records in selection:C76([Purchase_Orders_Items:12])=1)
		READ ONLY:C145([Purchase_Orders:11])
		READ ONLY:C145([Vendors:7])
		RELATE ONE:C42([Purchase_Orders_Items:12]PONo:2)
		RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
		sCriterion1:=[Vendors:7]Name:2+"'s "+[Purchase_Orders_Items:12]Raw_Matl_Code:15
		rReal1:=-1*asQty{$hit}
		
	Else 
		BEEP:C151
		sCriterion1:="PO item "+sCriterion2+" could not be found."
		sCriterion2:=""
		aText{0}:="Select a PO -->"
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Pick a PO from the PopUp menu.")
	sCriterion2:=""
	aText{0}:="Select a PO -->"
End if 