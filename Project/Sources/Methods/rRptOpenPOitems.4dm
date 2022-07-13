//%attributes = {"publishedWeb":true}
//rRptOpenPOitems upr 1300
//03/14/95 chip
C_DATE:C307(dDateBegin; dDateEnd)
C_LONGINT:C283(rb1; rb2; rb3; b1; b2; b3; b4; cb1; cb2)
C_REAL:C285(real1; real10)
READ ONLY:C145([Purchase_Orders:11])
READ ONLY:C145([Purchase_Orders_Items:12])
//Open window(2;40;638;478;8;"Open PO Items")
//DIALOG([CONTROL];"DateRange2")
CLOSE WINDOW:C154
$winRef:=Open form window:C675([Purchase_Orders_Items:12]; "OpenItemsDialog"; 8)
DIALOG:C40([Purchase_Orders_Items:12]; "OpenItemsDialog")
$details:=""
If (OK=1)
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PromiseDate:9>=dDateBegin; *)
	QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]PromiseDate:9<=dDateEnd; *)
	QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Canceled:44=False:C215; *)
	QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Qty_Open:27>0)
	CREATE SET:C116([Purchase_Orders_Items:12]; "Open_POs")
	
	If (Records in selection:C76([Purchase_Orders_Items:12])>0)
		If (cb1=1)
			$details:=$details+" (Hide INX PO's) "
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]INX_autoPO:48=True:C214)
				RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]PONo:2)
				CREATE SET:C116([Purchase_Orders_Items:12]; "INX_POs")
				
				
			Else 
				SET QUERY DESTINATION:C396(Into set:K19:2; "INX_POs")
				QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders:11]INX_autoPO:48=True:C214)
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			DIFFERENCE:C122("Open_POs"; "INX_POs"; "Open_POs")
			USE SET:C118("Open_POs")
			CLEAR SET:C117("INX_POs")
		End if 
	End if 
	
	If (Records in selection:C76([Purchase_Orders_Items:12])>0)
		Case of 
			: (b1=1)
				//show em all
				$details:=$details+" (All Ship-To's)"
			: (b2=1)
				
				RELATE ONE SELECTION:C349([Purchase_Orders_Items:12]; [Purchase_Orders:11])
				QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]CompanyID:43="2")
				RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]PONo:2)
				CREATE SET:C116([Purchase_Orders_Items:12]; "ShipTos")
				
				INTERSECTION:C121("Open_POs"; "ShipTos"; "Open_POs")
				USE SET:C118("Open_POs")
				CLEAR SET:C117("ShipTos")
				$details:=$details+" Roanoke Ship-To's"
				
			: (b3=1)
				RELATE ONE SELECTION:C349([Purchase_Orders_Items:12]; [Purchase_Orders:11])
				QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]CompanyID:43="1")
				RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]PONo:2)
				CREATE SET:C116([Purchase_Orders_Items:12]; "ShipTos")
				
				
				
				INTERSECTION:C121("Open_POs"; "ShipTos"; "Open_POs")
				USE SET:C118("Open_POs")
				CLEAR SET:C117("ShipTos")
				$details:=$details+" (Hauppauge Ship-To's)"
				
			: (b4=1)
				
				RELATE ONE SELECTION:C349([Purchase_Orders_Items:12]; [Purchase_Orders:11])
				QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]CompanyID:43="4")
				RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]PONo:2)
				CREATE SET:C116([Purchase_Orders_Items:12]; "ShipTos")
				
				
				
				INTERSECTION:C121("Open_POs"; "ShipTos"; "Open_POs")
				USE SET:C118("Open_POs")
				CLEAR SET:C117("ShipTos")
				$details:=$details+" (Vista WH Ship-To's)"
		End case 
	End if 
	//REPORT([PO_Items];"x")
	
	Case of 
		: (rb1=1)
			BREAK LEVEL:C302(1)
			ACCUMULATE:C303(real1)
			ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]CommodityCode:16; >; [Purchase_Orders_Items:12]VendorID:39; >; [Purchase_Orders_Items:12]PromiseDate:9; >)
			util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "OpenPOitems")
			FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "OpenPOitems")
			t2:="OPEN PURCHASE ORDER REPORT"
			t2b:="BY COMMODITY, VENDOR, & PROMISE DATE "+$details
			t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
			
		: (rb2=1)
			ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PromiseDate:9; >; [Purchase_Orders_Items:12]Commodity_Key:26; >)
			util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "DockingRpt")
			FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "DockingRpt")
			t2:="RECEIVING'S DOCKING REPORT"
			t2b:="BY PROMISE DATE & COMMODITY "+$details
			t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
			
		: (rb3=1)
			ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
			util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "DockingRpt")
			FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "DockingRpt")
			t2:="RECEIVING'S DOCKING REPORT"
			t2b:="BY PURCHASE ORDER NUMBER "+$details
			t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
			
	End case 
	
	PRINT SELECTION:C60([Purchase_Orders_Items:12])
	FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "List")
	CLOSE WINDOW:C154
End if 
//