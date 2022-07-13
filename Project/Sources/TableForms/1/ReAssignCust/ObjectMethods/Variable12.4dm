//Script: bReassign()   MLB
//•051596  MLB  add custcontlink
//• 6/6/97 cs changed locked record message to include user info,
//  also changed unload record -> uClearSelection
//• 8/20/97 cs remove bookings Jim B request
//• 9/15/97 cs Redesigning layout
//•102198  MLB  UPR send api rec
//•081399  mlb  don't touch CustOrder or Orderline for commission reasons
If (vNewRep#"")
	//uClearSelection (»[old_Bookings])
	uConfirm("Do Orders?"; "Orders"; "Skip")
	If (ok=1)
		$doOrders:=True:C214
	Else 
		$doOrders:=False:C215
	End if 
	
	uClearSelection(->[Customers:16])
	uClearSelection(->[Job_Forms_Master_Schedule:67])
	uClearSelection(->[Estimates:17])
	uClearSelection(->[Salesmen:32])
	uClearSelection(->[Customers_Orders:40])
	uClearSelection(->[Customers_Order_Lines:41])
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	//READ WRITE([old_Bookings])
	READ WRITE:C146([Customers_Orders:40])
	READ WRITE:C146([Customers_Order_Lines:41])
	READ WRITE:C146([Customers:16])
	READ WRITE:C146([Customers_Contacts:52])
	READ WRITE:C146([Contacts:51])
	C_LONGINT:C283($i; $DelayTime; $Count)
	
	$DelayTime:=60*60  //(60 ticks/sec, 60 secs per minute)
	$CustIndex:=Find in array:C230(aBullet; "√")
	$Count:=0
	MESSAGES OFF:C175
	NewWindow(350; 50; 0; -720)
	
	Repeat 
		
		If ($CustIndex>0)  //if there is a customer selected & a new rep
			MESSAGE:C88("Locating records for... "+aCustName{$CustIndex}+Char:C90(13))
			$Count:=$Count+1
			QUERY:C277([Customers:16]; [Customers:16]ID:1=aCustId{$CustIndex})
			$OldRep:=[Customers:16]SalesmanID:3
			
			User_GiveAccess(vNewRep; "Customers"; [Customers:16]ID:1; "RWD")
			
			Repeat 
				APPLY TO SELECTION:C70([Customers:16]; [Customers:16]SalesmanID:3:=vNewRep)
				USE SET:C118("LockedSet")
				If (Records in selection:C76([Customers:16])>0)
					uLockMessage(->[Customers:16]; "*")
					DELAY PROCESS:C323(Current process:C322; $DelayTime)
				End if 
			Until (Records in set:C195("LockedSet")=0)
			fWindOpen:=False:C215
			//•102198  MLB  UPR send api rec
			//QUERY([CUSTOMER];[CUSTOMER]ID=aCustId{$CustIndex})
			//QUERY([CustAddressLink];[CustAddressLink]CustID=aCustId{$CustIndex})
			//For ($j;1;Records in selection([CustAddressLink]))
			//If ([CustAddressLink]AddressType="Bill to")
			//QUERY([Addresses];[Addresses]ID=[CustAddressLink]CustAddrID)
			//If (Records in selection([Addresses])>0)
			//API_CustTrans ("MOD")
			//End if 
			//End if 
			//NEXT RECORD([CustAddressLink])
			//End for 
			//REDUCE SELECTION([CustAddressLink];0)
			//REDUCE SELECTION([Addresses];0)
			//•102198  MLB  UPR send api rec  end
			
			//  CLOSE WINDOW
			
			//•102198  MLB  UPR moved this after new code
			QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=$OldRep)
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Customer:2=aCustId{$CustIndex})
			QUERY:C277([Estimates:17]; [Estimates:17]Cust_ID:2=aCustId{$CustIndex})
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustID:2=aCustId{$CustIndex})  //upr 1307
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=aCustId{$CustIndex})
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=aCustId{$CustIndex})  //•051596  MLB  
			QUERY:C277([Contacts_Tags:183]; [Contacts_Tags:183]UserID:1=$OldRep)
			
			Repeat 
				APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Salesman:1:=vNewRep)
				USE SET:C118("LockedSet")
				If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
					uLockMessage(->[Job_Forms_Master_Schedule:67]; "*")
					DELAY PROCESS:C323(Current process:C322; $DelayTime)
				End if 
			Until (Records in set:C195("LockedSet")=0)
			fWindOpen:=False:C215
			// CLOSE WINDOW
			
			Repeat 
				APPLY TO SELECTION:C70([Estimates:17]; [Estimates:17]Sales_Rep:13:=vNewRep)
				USE SET:C118("LockedSet")
				If (Records in selection:C76([Estimates:17])>0)
					uLockMessage(->[Estimates:17]; "*")
					DELAY PROCESS:C323(Current process:C322; $DelayTime)
				End if 
			Until (Records in set:C195("LockedSet")=0)
			fWindOpen:=False:C215
			// CLOSE WINDOW
			
			If ($doOrders)  //•081399  mlb  
				Repeat 
					APPLY TO SELECTION:C70([Customers_Orders:40]; [Customers_Orders:40]SalesRep:13:=vNewRep)
					USE SET:C118("LockedSet")
					If (Records in selection:C76([Customers_Orders:40])>0)
						uLockMessage(->[Customers_Orders:40]; "*")
						DELAY PROCESS:C323(Current process:C322; $DelayTime)
					End if 
				Until (Records in set:C195("LockedSet")=0)
				fWindOpen:=False:C215
				//  CLOSE WINDOW
				
				Repeat 
					APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SalesRep:34:=vNewRep)
					USE SET:C118("LockedSet")
					If (Records in selection:C76([Customers_Order_Lines:41])>0)
						uLockMessage(->[Customers_Order_Lines:41]; "*")
						DELAY PROCESS:C323(Current process:C322; $DelayTime)
					End if 
				Until (Records in set:C195("LockedSet")=0)
				fWindOpen:=False:C215
			End if 
			//   CLOSE WINDOW
			
			MESSAGE:C88("Updating records for... "+aCustName{$CustIndex}+Char:C90(13))
			
			Repeat   //•051596  MLB  
				APPLY TO SELECTION:C70([Customers_Contacts:52]; [Customers_Contacts:52]SalesmanId:4:=vNewRep)
				USE SET:C118("LockedSet")
				If (Records in selection:C76([Customers_Contacts:52])>0)
					uLockMessage(->[Customers_Contacts:52]; "*")
					DELAY PROCESS:C323(Current process:C322; $DelayTime)
				End if 
			Until (Records in set:C195("LockedSet")=0)
			fWindOpen:=False:C215
			//  CLOSE WINDOW
			
			
			APPLY TO SELECTION:C70([Contacts_Tags:183]; [Contacts_Tags:183]UserID:1:=vNewRep)
			
			t3:=t3+"  '"+aCustName{$CustIndex}+"'    moved from sales rep.   "+$OldRep+"   ->   "+vNewRep+Char:C90(13)
			aBullet{$CustIndex}:=""
		End if 
		$CustIndex:=Find in array:C230(aBullet; "√"; $CustIndex+1)
	Until ($CustIndex<0)
	
	
	uClearSelection(->[Customers:16])
	uClearSelection(->[Job_Forms_Master_Schedule:67])
	uClearSelection(->[Estimates:17])
	uClearSelection(->[Salesmen:32])
	//uClearSelection (->[CustomerOrder])
	//uClearSelection (->[OrderLines])
	vNewRep:=""
	t1:=""
	t2:=""
	
	// •reset customer arrays• 
	//SEARCH([CUSTOMER];[CUSTOMER]SalesmanID=vOldRep)
	//SEARCH([SALESMAN];[SALESMAN]ID=vOldRep)
	//
	//If (Records in selection([CUSTOMER])=0)
	//t2:=""
	//t1:=""
	//t2b:=""
	//GOTO AREA(vOldRep)
	//vOldRep:=""
	//$Count:=0
	//ARRAY TEXT(aCustId;$Count)
	//ARRAY TEXT(aCustName;$Count)
	//ARRAY TEXT(aBullet;$Count)
	//Else 
	//t2b:=[SALESMAN]FirstName+" "+[SALESMAN]MI+" "+[SALESMAN]LastName
	//$Count:=Records in selection([CUSTOMER])
	//ARRAY TEXT(aCustId;$Count)
	//ARRAY TEXT(aCustName;$Count)
	//ARRAY TEXT(aBullet;$Count)
	//SELECTION TO ARRAY([CUSTOMER]ID;aCustId;[CUSTOMER]Name;aCustName)
	//GOTO AREA(vNewRep)
	
	$Count:=Records in table:C83([Customers:16])
	
	For ($i; 1; $Count)
		aBullet{$i}:=""
	End for 
	CLOSE WINDOW:C154
Else 
	ALERT:C41("You Must enter/select a New Sales Rep first")
End if 
//