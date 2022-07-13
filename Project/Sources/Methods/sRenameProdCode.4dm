//%attributes = {"publishedWeb":true}
//(S)bRename->sRenameProdCode  see also sRenameProdCod2
//upr 1247 10/3/94
//1/31/95
//•051195 re-include transaction file
//•060796  MLB  make sure that read write staets are on, use Apply to selection
// • mel (12/9/04, 09:13:46) include [WMS_ItemMaster] and chg fg_specifications, remove [FG_PriceHistory]

C_TEXT:C284($cust; $oldPC; $newPC; $newKEY; $oldKey; $1)  //(S)bRename->sRenameProdCode
C_LONGINT:C283($type; $len)  //                                                              modified 1/18/94
C_DATE:C307($date)  //   mod 3/22/94 added param 1 for change order acceptance
// fCnclTrn used to cancel change order acceptance transaction
$date:=4D_Current_date


READ WRITE:C146([Estimates_Carton_Specs:19])  //•060796  MLB  
READ WRITE:C146([Customers_Order_Lines:41])
READ WRITE:C146([Customers_ReleaseSchedules:46])
READ WRITE:C146([Job_Forms_Items:44])
//READ WRITE([FG_PriceHistory])
READ WRITE:C146([Finished_Goods_Locations:35])
READ WRITE:C146([Finished_Goods_Transactions:33])
READ WRITE:C146([Finished_Goods_Specifications:98])
READ WRITE:C146([WMS_ItemMasters:123])

GET FIELD PROPERTIES:C258(->[Finished_Goods:26]ProductCode:1; $type; $len)
$oldPC:=[Finished_Goods:26]ProductCode:1
$cust:=[Finished_Goods:26]CustID:2
$OldKey:=$Cust+":"+$OldPc
If (Count parameters:C259=0)
	$newPC:=fStripSpace("B"; Substring:C12(Request:C163("Enter the new "+String:C10($len)+" character product code:"; $oldPC); 1; $len))
Else 
	$newPC:=fStripSpace("B"; $1)
	ok:=1
End if 

If (($newPC#"") & (ok=1))
	$newKEY:=$cust+":"+$newPC
	//gFGChange (5)  `
	BEEP:C151
	uConfirm("Change all occurrances of "+Char:C90(13)+$oldPC+Char:C90(13)+"to "+Char:C90(13)+$newPC; "Change"; "Don't Change")
	If (ok=1)
		//start transaction 
		MESSAGES OFF:C175
		NewWindow(300; 150; 6; -722; "Renaming "+$oldPC)
		
		MESSAGE:C88("Changing a product code, this will take awhile..."+Char:C90(13))
		[Finished_Goods:26]ProductCode:1:=$newPC
		[Finished_Goods:26]FG_KEY:47:=$newKEY
		[Finished_Goods:26]Notes:20:="Renamed from "+$oldPC+" on "+String:C10($date; <>MIDDATE)+Char:C90(13)+[Finished_Goods:26]Notes:20
		<>RecordSaved:=True:C214
		ON ERR CALL:C155("eSaveRecError")
		SAVE RECORD:C53([Finished_Goods:26])
		ON ERR CALL:C155("")
		If (Not:C34(<>RecordSaved))
			BEEP:C151
			ALERT:C41($newKEY+" has already been used by this customer. ")
			<>RecordSaved:=True:C214
			[Finished_Goods:26]ProductCode:1:=$oldPC
			[Finished_Goods:26]FG_KEY:47:=$cust+":"+$oldPC
			If (Count parameters:C259#0)
				fCnclTrn:=True:C214
			End if 
		Else 
			QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProductCode:5=$oldPC; *)
			QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]CustID:6=$cust)
			MESSAGE:C88("CartonSpecs..."+Char:C90(13))
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				FIRST RECORD:C50([Estimates_Carton_Specs:19])
				
				
			Else 
				
				// see line 65
				
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			While (Not:C34(End selection:C36([Estimates_Carton_Specs:19])))
				FG_CspecLikeFG(1)
				[Estimates_Carton_Specs:19]CartonComment:12:=[Estimates_Carton_Specs:19]CartonComment:12+" Renamed from "+$oldPC
				[Estimates_Carton_Specs:19]ModDate:39:=$date
				[Estimates_Carton_Specs:19]ModWho:40:=<>zResp
				SAVE RECORD:C53([Estimates_Carton_Specs:19])
				NEXT RECORD:C51([Estimates_Carton_Specs:19])
			End while 
			
			MESSAGE:C88("Transactions..."+Char:C90(13))  //•051195
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=$oldPC; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=$cust)
			APPLY TO SELECTION:C70([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1:=$newPC)
			APPLY TO SELECTION:C70([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ModDate:17:=$date)
			APPLY TO SELECTION:C70([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ModWho:18:=<>zResp)
			
			MESSAGE:C88("Orders..."+Char:C90(13))
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$oldPC; *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=$cust)
			APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5:=$newPC)
			APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ModDate:15:=$date)
			APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ModWho:16:=<>zResp)
			
			MESSAGE:C88("Releases..."+Char:C90(13))
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$oldPC; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=$cust)
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11:=$newPC)
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ModDate:18:=$date)
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ModWho:19:=<>zResp)
			
			MESSAGE:C88("Job items..."+Char:C90(13))  //upr 1247 
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$oldPC; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]CustId:15=$cust)
			APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3:=$newPC)
			
			MESSAGE:C88("Bins..."+Char:C90(13))
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$oldPC; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=$cust)
			APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1:=$newPC)
			APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ModDate:21:=$date)
			APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ModWho:22:=<>zResp)
			
			//MESSAGE("Price history..."+Char(13))
			//QUERY([FG_PriceHistory];[FG_PriceHistory]FG_KEY=$oldKey)
			//APPLY TO SELECTION([FG_PriceHistory];[FG_PriceHistory]ProductCode:=$newPC)
			//APPLY TO SELECTION([FG_PriceHistory];[FG_PriceHistory]FG_KEY:=$newKey)
			
			MESSAGE:C88("[FG_Specification]..."+Char:C90(13))  //• mlb - 4/3/03  14:59
			QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=$oldKey)
			APPLY TO SELECTION:C70([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1:=$newKey)
			FIRST RECORD:C50([Finished_Goods_Specifications:98])
			APPLY TO SELECTION:C70([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProductCode:3:=$newPC)
			
			MESSAGE:C88("[WMS_ItemMaster]..."+Char:C90(13))  //• mlb - 4/3/03  14:59
			QUERY:C277([WMS_ItemMasters:123]; [WMS_ItemMasters:123]SKU:2=$oldPC)
			APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]SKU:2:=$newPC)
			
			UNLOAD RECORD:C212([Estimates_Carton_Specs:19])  //•060796  MLB  
			UNLOAD RECORD:C212([Customers_Order_Lines:41])
			UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
			UNLOAD RECORD:C212([Job_Forms_Items:44])
			//UNLOAD RECORD([FG_PriceHistory])
			UNLOAD RECORD:C212([Finished_Goods_Locations:35])
			UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
			UNLOAD RECORD:C212([Finished_Goods_Specifications:98])
			UNLOAD RECORD:C212([WMS_ItemMasters:123])
			
			CLOSE WINDOW:C154
		End if   //duplicate
		
	Else 
		If (Count parameters:C259#0)
			fCnclTrn:=True:C214
		End if 
	End if   //want change
	
Else   //something is a miss..
	If (Count parameters:C259#0)
		fCnclTrn:=True:C214
	End if 
End if   // can change
//