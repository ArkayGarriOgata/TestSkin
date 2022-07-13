//%attributes = {"publishedWeb":true}
//(p)reservePos
//• 5/1/97 cs replaced thermoset
//• 6/24/97 cs added code to create req. number on reserved po
//• 8/12/97 cs assign req vendor id too

If (True:C214)  //•090399  mlb  discussions with carol
	BEEP:C151
	BEEP:C151
	ALERT:C41("PO's are no longer being reserved, create a new PO with vendor and job#."; "Goodbye Old Friend")
Else 
	C_LONGINT:C283($numPOs; $i)
	C_TEXT:C284($vendor)
	$vendor:=Request:C163("Enter the vendor number:"; "00000")
	
	If ((OK=1) & (Num:C11($vendor)>0))
		QUERY:C277([Vendors:7]; [Vendors:7]ID:1=$vendor)
		
		If (Records in selection:C76([Vendors:7])>0)
			$numPOs:=Num:C11(Request:C163("Enter the number of PO's to reserve:"))
			
			If (OK=1)
				uThermoInit($numPOs; "Reserving PO Numbers")  //• 5/1/97 cs replaced thermoset
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					CREATE EMPTY SET:C140([Purchase_Orders:11]; "newOnes")
					
				Else 
					
					ARRAY LONGINT:C221($_newOnes; 0)
					
				End if   // END 4D Professional Services : January 2019 
				
				For ($i; 1; $numPOs)
					CREATE RECORD:C68([Purchase_Orders:11])
					[Purchase_Orders:11]PONo:1:=PO_setPONumber
					[Purchase_Orders:11]ReqNo:5:=Req_setReqNumber  //assign Requisition number too
					[Purchase_Orders:11]Buyer:11:=<>zResp
					[Purchase_Orders:11]PODate:4:=4D_Current_date
					[Purchase_Orders:11]LastChgOrdNo:18:="00"
					[Purchase_Orders:11]Status:15:="Reserved"
					[Purchase_Orders:11]StatusBy:16:=<>zResp
					[Purchase_Orders:11]ReqBy:6:=<>zResp  //• 8/12/97 cs 
					[Purchase_Orders:11]StatusDate:17:=4D_Current_date
					[Purchase_Orders:11]ModDate:31:=4D_Current_date
					[Purchase_Orders:11]ModWho:32:=<>zResp
					[Purchase_Orders:11]VendorName:42:=[Vendors:7]Name:2
					[Purchase_Orders:11]VendorID:2:=$vendor
					[Purchase_Orders:11]ReqVendorID:46:=$Vendor  //• 8/12/97 cs was not assigning req vendor
					//MEL verify that this is OK and take out comments 
					//BAK 8/9/94 - UPR 117 Terms and FOB not coming over
					[Purchase_Orders:11]AttentionOf:28:=[Vendors:7]DefaultAttn:17
					[Purchase_Orders:11]Terms:9:=[Vendors:7]Std_Terms:13
					[Purchase_Orders:11]ShipVia:10:=[Vendors:7]ShipVia:26
					[Purchase_Orders:11]FOB:8:=[Vendors:7]FOB:27
					[Purchase_Orders:11]Std_Discount:41:=[Vendors:7]Std_Discount:14
					If (User in group:C338(Current user:C182; "Roanoke"))
						PO_SetAddress("Roanoke")
						[Purchase_Orders:11]CompanyID:43:="2"  //•1/31/97 mod for company default
					Else 
						PO_SetAddress("Hauppauge")
						[Purchase_Orders:11]CompanyID:43:="1"  //•1/31/97 mod for company default
					End if 
					
					//ALL RECORDS([ADMINISTRATOR])`beforepO
					//[PURCHASE_ORDER]ShipTo1:=[ADMINISTRATOR]DefaultShipTo1
					//[PURCHASE_ORDER]ShipTo2:=[ADMINISTRATOR]DefaultShipTo2
					//[PURCHASE_ORDER]ShipTo3:=[ADMINISTRATOR]DefaultShipTo3
					//[PURCHASE_ORDER]ShipTo4:=[ADMINISTRATOR]DefaultShipTo4
					//[PURCHASE_ORDER]ShipTo5:=[ADMINISTRATOR]DefaultShipTo5
					//UNLOAD RECORD([ADMINISTRATOR])
					SAVE RECORD:C53([Purchase_Orders:11])
					If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
						
						ADD TO SET:C119([Purchase_Orders:11]; "newOnes")
						
					Else 
						
						APPEND TO ARRAY:C911($_newOnes; Record number:C243([Purchase_Orders:11]))
						
					End if   // END 4D Professional Services : January 2019 
					
					uThermoUpdate($i)  //• 5/1/97 cs replaced thermoset
				End for 
				uThermoClose  //• 5/1/97 cs replaced thermoset
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					USE SET:C118("newOnes")
					
					
				Else 
					
					CREATE SELECTION FROM ARRAY:C640([Purchase_Orders:11]; $_newOnes)
					CREATE SET:C116([Purchase_Orders:11]; "newOnes")
					
					
				End if   // END 4D Professional Services : January 2019 
				dAsof:=4D_Current_date
				FORM SET OUTPUT:C54([Purchase_Orders:11]; "ListRept")
				PRINT SELECTION:C60([Purchase_Orders:11])
				FORM SET OUTPUT:C54([Purchase_Orders:11]; "List")
				UNLOAD RECORD:C212([Purchase_Orders:11])
				CLEAR SET:C117("newOnes")
			End if 
		Else 
			BEEP:C151
			ALERT:C41($vendor+" is not a valid vendor number.")
		End if 
	End if 
End if 