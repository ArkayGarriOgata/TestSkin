//%attributes = {"publishedWeb":true}
//(p) NotifySearch
//   returns message(s) for user in ◊xText
//6/24/97 cs created
//• 9/13/97 cs added zero recvd cost
//• 3/26/98 cs added new items to options (opened orders, Priced Rfqs)

C_TEXT:C284($MsgText)
C_BOOLEAN:C305($Found)  //$0
C_LONGINT:C283($Find; $i)
ARRAY TEXT:C222(aPreference; 0)

READ ONLY:C145([Purchase_Orders:11])

<>fSearchDone:=False:C215
$Find:=NotifyParse(<>xPrefText)  //◊xpreftext set in notifySpawn,user notification routines
$Found:=False:C215
$MsgText:=""

For ($i; 1; $Find)  //for every possible preference check wether this user wants to process it
	Case of   //if so do the nessesary work
		: ($i>Size of array:C274(aPreference))
			//pass
		: (aPreference{$i}="Requisitions to Approve") & (User in group:C338(Current user:C182; "Req_Approval"))
			qryReqtoApprove
		: ((aPreference{$i}="Apprvd Reqs to Review") | (aPreference{$i}="Approved Requisitions")) & (User in group:C338(Current user:C182; "Purchasing"))  //• 8/8/97 cs added new search string last is old - remove
			qryReqtoReview
		: (aPreference{$i}="POs to Approve") & (User in group:C338(Current user:C182; "Po_Approval"))
			qryPO2Approve
		: (aPreference{$i}="POs to Approve - Mgr") & (User in group:C338(Current user:C182; "Po_Approval_Mgr"))
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Po Needs Mgr")
		: (aPreference{$i}="POs to Order") | (aPreference{$i}="Orders Pending")  //• 8/8/97 cs added new search string last is old - remove
			qryPo2Order
		: (aPreference{$i}="Negative FG Bins")
			If (qryFGbins>0)
				$MsgText:=$MsgText+aPreference{$i}+" "+String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+Char:C90(13)
			End if 
			uClearSelection(->[Purchase_Orders:11])
			
		: (aPreference{$i}="Received w/Zero Cost")
			qryZeroRecpt
			
			If (Records in selection:C76([Purchase_Orders_Items:12])>0)
				$MsgText:=$MsgText+aPreference{$i}+" "+String:C10(Records in selection:C76([Purchase_Orders_Items:12]))+Char:C90(13)
			End if 
			uClearSelection(->[Purchase_Orders_Items:12])
		: (aPreference{$i}="CCO@")
			
			Case of 
				: (aPreference{$i}="CCO - Customer Service")
					QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]ChgOrderStatus:20="Customer@")
					
				: (aPreference{$i}="CCO - New/Opened")
					QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]ChgOrderStatus:20="New"; *)
					QUERY:C277([Customers_Order_Change_Orders:34];  | ; [Customers_Order_Change_Orders:34]ChgOrderStatus:20="Open@")
					
				: (aPreference{$i}="CCO - Pricing")
					QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]ChgOrderStatus:20="Pricing")
			End case 
			
			If (Records in selection:C76([Customers_Order_Change_Orders:34])>0)
				$MsgText:=$MsgText+aPreference{$i}+" "+String:C10(Records in selection:C76([Customers_Order_Change_Orders:34]))+Char:C90(13)
			End if 
			
		: (aPreference{$i}="'Opened' Orders")
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Opened")
			
			If (Records in selection:C76([Customers_Orders:40])>0)
				$MsgText:=$MsgText+aPreference{$i}+" "+String:C10(Records in selection:C76([Customers_Orders:40]))+Char:C90(13)
			End if 
			
		: (aPreference{$i}="Priced RFQs")
			QUERY:C277([Estimates:17]; [Estimates:17]Status:30="Priced")
			
			If (Records in selection:C76([Estimates:17])>0)
				$MsgText:=$MsgText+aPreference{$i}+" "+String:C10(Records in selection:C76([Estimates:17]))+Char:C90(13)
			End if 
			
			
	End case 
	
	If (Records in selection:C76([Purchase_Orders:11])>0)  //if there was something found -
		$Found:=True:C214  //flag it
		$MsgText:=$MsgText+aPreference{$i}+Char:C90(13)  //add to message to display
	End if 
End for 
uClearSelection(->[Purchase_Orders:11])

If ($msgText="")  //forces window open & display message 
	$MsgText:="Nothing Pending"  //- code in window looking for this string!
End if 

<>xMsgText:=$MsgText
<>fSearchDone:=True:C214