//Layout Proc.: MakeBatch_Dio()  041197  MLB
//• 5/9/97 cs made system deault to current date not !00/00/00!
If (Form event code:C388=On Load:K2:1)
	dDate:=4D_Current_date  //• 5/9/97 cs made system deault to current date not !00/00/00!
	//• 5/9/97 cs placed code to defaul pseudo po also
	sCriterion2:=Substring:C12([Raw_Materials:21]Raw_Matl_Code:1; 1; 5)+Substring:C12(String:C10(dDate; <>MIDDATE); 1; 5)
	sCriterion2:=Replace string:C233(sCriterion2; "/"; "")
	READ ONLY:C145([Purchase_Orders_Items:12])
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
	If (Records in selection:C76([Purchase_Orders_Items:12])=1)
		sCriterion2:=""
		uClearSelection(->[Purchase_Orders_Items:12])
	End if 
	rReal:=0
	sCriterion3:=""
End if 
//