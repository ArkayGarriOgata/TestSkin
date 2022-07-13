//Script: [finishedGood]AskMe.(ReleaseSection).b2New()  101095  MLB
//the 'new' button on Askme release section
//•060295  MLB  UPR 184 add brand
//•101095  MLB  
//•102297  MLB  was, -4, chg so it show up as not being processed yet
//•5/04/00  mlb 

C_TEXT:C284($treat_special)

$treat_special:="  00074 00199 "  //E.Arden can make releases without orderline link, others can be added

Case of 
	: (Records in set:C195("Customers_Order_Line")=1)  //original code
		CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "holdOL")
		USE SET:C118("Customers_Order_Line")
		$ordline:=[Customers_Order_Lines:41]OrderLine:3
		$ordline:=Request:C163("P.O. "+[Customers_Order_Lines:41]PONumber:21+" selected.  Create for Order Line:"; $ordline; "New Release"; "Cancel")
		If (ok=1)
			If (Position:C15([Customers_Order_Lines:41]Status:9; " Closed Cancel Kill Rejected ")=0)
				CREATE RECORD:C68([Customers_ReleaseSchedules:46])
				[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
				[Customers_ReleaseSchedules:46]OrderNumber:2:=[Customers_Order_Lines:41]OrderNumber:1
				[Customers_ReleaseSchedules:46]OrderLine:4:=[Customers_Order_Lines:41]OrderLine:3
				[Customers_ReleaseSchedules:46]Shipto:10:=[Customers_Order_Lines:41]defaultShipTo:17
				[Customers_ReleaseSchedules:46]Billto:22:=[Customers_Order_Lines:41]defaultBillto:23
				[Customers_ReleaseSchedules:46]ProductCode:11:=[Customers_Order_Lines:41]ProductCode:5
				[Customers_ReleaseSchedules:46]CustomerRefer:3:=[Customers_Order_Lines:41]PONumber:21
				[Customers_ReleaseSchedules:46]CustID:12:=[Customers_Order_Lines:41]CustID:4
				[Customers_ReleaseSchedules:46]CustomerLine:28:=[Customers_Order_Lines:41]CustomerLine:42  //•060295  MLB  UPR 184
				[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
				[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
				[Customers_ReleaseSchedules:46]PayU:31:=Num:C11([Customers_Order_Lines:41]PayUse:47)  //•101095  MLB 
				[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
				[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  was, -4, chg so it show up as not being processed yet
				[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Customers_Order_Lines:41]ProjectNumber:50  //•5/04/00  mlb 
				If (Position:C15([Customers_ReleaseSchedules:46]CustID:12; " 00074 02085 ")>0)
					If (Length:C16(sAlias)>0)
						uConfirm("Put "+sAlias+" in the BOL Remarks field?"; "Yes"; "No")
						If (ok=1)
							[Customers_ReleaseSchedules:46]RemarkLine2:26:=sAlias
						End if 
					End if 
				End if 
				
				SAVE RECORD:C53([Customers_ReleaseSchedules:46])
				ADD TO SET:C119([Customers_ReleaseSchedules:46]; "displayRels")
				ADD TO SET:C119([Customers_ReleaseSchedules:46]; "twoLoaded")
				
				pattern_PassThru(->[Customers_ReleaseSchedules:46])
				UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
				ViewSetter(2; ->[Customers_ReleaseSchedules:46])
				
				USE SET:C118("twoLoaded")
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
				iitotal2:=iitotal2+[Customers_ReleaseSchedules:46]OpenQty:16
				
			Else 
				uConfirm("The status of orderline "+$ordline+" is "+[Customers_Order_Lines:41]Status:9; "OK"; "Help")
			End if 
			
		End if 
		
		USE NAMED SELECTION:C332("holdOL")
		// Modified by: Mel Bohince (9/3/14) allow all without orderline so can get on glue schedule
	: (Position:C15(sCustId; $treat_special)>0) | (True:C214)  //not orderline, but cust is special
		CREATE RECORD:C68([Customers_ReleaseSchedules:46])
		[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
		[Customers_ReleaseSchedules:46]OrderNumber:2:=0
		[Customers_ReleaseSchedules:46]OrderLine:4:=""
		[Customers_ReleaseSchedules:46]Shipto:10:="00000"
		[Customers_ReleaseSchedules:46]Billto:22:="N/A"
		[Customers_ReleaseSchedules:46]ProductCode:11:=sCPN
		[Customers_ReleaseSchedules:46]CustomerRefer:3:="NO_ORDERLINE"
		[Customers_ReleaseSchedules:46]CustID:12:=sCustId
		[Customers_ReleaseSchedules:46]CustomerLine:28:=sBrand
		[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
		[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
		[Customers_ReleaseSchedules:46]PayU:31:=0
		[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
		[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  was, -4, chg so it show up as not being processed yet
		[Customers_ReleaseSchedules:46]ProjectNumber:40:=""
		If (Position:C15([Customers_ReleaseSchedules:46]CustID:12; " 00074 02085 ")>0)
			If (Length:C16(sAlias)>0)
				uConfirm("Put "+sAlias+" in the BOL Remarks field?"; "Yes"; "No")
				If (ok=1)
					[Customers_ReleaseSchedules:46]RemarkLine2:26:=sAlias
				End if 
			End if 
		End if 
		
		SAVE RECORD:C53([Customers_ReleaseSchedules:46])
		ADD TO SET:C119([Customers_ReleaseSchedules:46]; "displayRels")
		ADD TO SET:C119([Customers_ReleaseSchedules:46]; "twoLoaded")
		
		pattern_PassThru(->[Customers_ReleaseSchedules:46])
		UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
		ViewSetter(2; ->[Customers_ReleaseSchedules:46])
		
		USE SET:C118("twoLoaded")
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
		iitotal2:=iitotal2+[Customers_ReleaseSchedules:46]OpenQty:16
		
	Else 
		uConfirm("Select an Orderline first."; "OK"; "Help")
End case 