//%attributes = {"publishedWeb":true}
//(P) uInitPopUps:
//Purchase Order Status  and Job status has not been handled yet.
//rpt popups are at the bottom find -> REPORTS
//mod 5/11/94 upr 1039
//9/7/94 upr 1206
//9/23/94 BAK
//10/3/94 mod for phy inv chip
//mod 10/13/94 chip
//mod 10/14/94 upr 1203 and split up
//into uInitPopUps1, uInitPopUpsFG, and uInitPopUpsRpts
//10/21/94 reduce IP varible size 
//upr 72
//upr 1138b 2/14/95
//2/15/95 put order cancel status out of sales and into co_approval
//4/19/95 give close order status to cust service so they can close short
//5/3/95 upr 1487 allow  price mgr to downgrade est and cco status
//•051095 remove kill order popup
//•053195  MLB  UPR 1619 allow sales to send cco direct to customer service
//•060195  MLB  UPR 184 add CONTRACT status to estimates and orders for CS
//• 2/28/97 cs removed code initializing ◊ PI arrays upt 1858
//• 9/4/97 cs added new item to FG popup
C_TEXT:C284($user)
$user:=Current user:C182
<>BASE_POPUP_MENU:="New;Modify...;Review..."

ARRAY TEXT:C222(<>asEstStat; 0)  //     j
LIST TO ARRAY:C288("EstimateStatus"; <>asEstStat)

ARRAY TEXT:C222(<>asOrdStat; 0)  //    m
LIST TO ARRAY:C288("C_OrderStatus"; <>asOrdStat)

ARRAY TEXT:C222(<>asChgStat; 0)  //    o
LIST TO ARRAY:C288("COStatus"; <>asChgStat)

ARRAY TEXT:C222(<>aPopEst; 3)
<>aPopEst{1}:="New"
<>aPopEst{2}:="Modify..."
<>aPopEst{3}:="Review..."
<>aPopEst:=0

ARRAY TEXT:C222(<>aPopAlloc; 4)  //12/7/94 need to be able to delete allocations
<>aPopAlloc{1}:="New"
<>aPopAlloc{2}:="Modify..."
<>aPopAlloc{3}:="Review..."
<>aPopAlloc{4}:="Delete..."
<>aPopAlloc:=0

//*SalesReps and SalesCoordinator
If (User in group:C338($user; "SalesReps"))
	
End if 

If (User in group:C338($user; "SalesCoordinator"))
	
End if 


//*Estimators
If (User in group:C338($user; "Estimators"))
	ARRAY TEXT:C222(<>apEst; 3)
	<>apEst{1}:="Use Pjt Ctr"
	<>apEst{2}:="Modify..."
	<>apEst{3}:="Review..."
	<>apEst:=0
	
Else 
	ARRAY TEXT:C222(<>apEst; 1)
	<>apEst{1}:="Access Denied"
End if 
<>apEst:=0

If (User in group:C338($user; "Planners"))
	
End if 

If (User in group:C338($user; "PriceManager"))
	
End if 

If (User in group:C338($user; "CustomerService"))
	
End if 

If (User in group:C338($user; "CCO_Approval"))
	
End if 

//*RMinventory
ARRAY TEXT:C222(<>apRM; 0)
If (User in group:C338($user; "RMinventory"))
	
	If (User in group:C338(Current user:C182; "RMcreate"))
		ARRAY TEXT:C222(<>apRM; Size of array:C274(<>apRM)+1)
		<>apRM{1}:="New"
	End if 
	
	If (User in group:C338(Current user:C182; "RMupdate"))
		ARRAY TEXT:C222(<>apRM; Size of array:C274(<>apRM)+1)
		<>apRM{Size of array:C274(<>apRM)}:="Modify..."
	End if 
	
	If (User in group:C338(Current user:C182; "RMinquire"))
		ARRAY TEXT:C222(<>apRM; Size of array:C274(<>apRM)+1)
		<>apRM{Size of array:C274(<>apRM)}:="Review..."
	End if 
	<>apRM:=0
	
Else 
	ARRAY TEXT:C222(<>apRM; 1)
	<>apRM{1}:="Access Denied"
End if 

//*FGinventory
ARRAY TEXT:C222(<>apFG; 5)
If (User in group:C338($user; "FGinventory"))
	<>apFG{1}:="New"
	<>apFG{2}:="Modify..."
	<>apFG{3}:="Review..."
	<>apFG{4}:="-"  //• 9/4/97 cs 
	<>apFG{5}:="Ask Me"  //• 9/4/97 cs 
	<>apFG:=0
Else 
	<>apFG{1}:="Access Denied"
	<>apFG{2}:="Access Denied"
	<>apFG{3}:="Review..."
	<>apFG{4}:="-"  //• 9/4/97 cs 
	<>apFG{5}:="Ask Me"  //• 9/4/97 cs 
	<>apFG:=0
End if 

//*Purchasing
If (User in group:C338($user; "Purchasing"))
	ARRAY TEXT:C222(<>apPO; 3)
	If (User in group:C338(Current user:C182; "Purchasing Modify"))
		<>apPO{1}:="New"
		<>apPO{2}:="Modify..."
		<>apPO{3}:="Review..."
	Else 
		<>apPO{1}:="Access Denied"
		<>apPO{2}:="Access Denied"
		<>apPO{3}:="Review..."
	End if 
	<>apPO:=0
	
Else 
	ARRAY TEXT:C222(<>apPO; 1)
	<>apPO{1}:="Access Denied"
	<>apPO:=0
End if 

//*Requisitioning
If (User in group:C338($user; "Requisitions"))
	ARRAY TEXT:C222(<>apReq; 3)
	<>apReq{1}:="New"
	<>apReq{2}:="Modify..."
	<>apReq{3}:="Review..."
	<>apReq:=0
	
Else 
	ARRAY TEXT:C222(<>apReq; 1)
	<>apReq{1}:="Access Denied"
	<>apReq:=0
End if 

//*Vendors
If (User in group:C338($user; "Vendors"))
	ARRAY TEXT:C222(<>apVend; 3)
	<>apVend{1}:="New"
	<>apVend{2}:="Modify..."
	<>apVend{3}:="Review..."
	<>apVend:=0
Else 
	ARRAY TEXT:C222(<>apVend; 1)
	<>apVend{1}:="Access Denied"
	<>apVend:=0
End if 

//*Addresses
If (User in group:C338($user; "Addresses"))
	ARRAY TEXT:C222(<>apAddr; 3)
	<>apAddr{1}:="New"
	<>apAddr{2}:="Modify..."
	<>apAddr{3}:="Review..."
	<>apAddr:=0
Else 
	ARRAY TEXT:C222(<>apAddr; 1)
	<>apAddr{1}:="Access Denied"
	<>apAddr:=0
End if 

//*Customers
If (User in group:C338($user; "Customers"))
	ARRAY TEXT:C222(<>apCust; 3)
	<>apCust{1}:="New"
	<>apCust{2}:="Modify..."
	<>apCust{3}:="Review..."
	<>apCust:=0
Else 
	ARRAY TEXT:C222(<>apCust; 1)
	<>apCust{1}:="Access Denied"
	<>apCust:=0
End if 

//*Contacts
If (User in group:C338($user; "Contacts"))
	ARRAY TEXT:C222(<>apContact; 3)
	<>apContact{1}:="New"
	<>apContact{2}:="Modify..."
	<>apContact{3}:="Review..."
	<>apContact:=0
Else 
	ARRAY TEXT:C222(<>apContact; 1)
	<>apContact{1}:="Access Denied"
	<>apContact:=0
End if 

//*Jobs
If (User in group:C338($user; "Jobs"))
	ARRAY TEXT:C222(<>apJob; 3)
	<>apJob{1}:="New"
	<>apJob{2}:="Modify..."
	<>apJob{3}:="Review..."
	<>apJob:=0
	
Else 
	ARRAY TEXT:C222(<>apJob; 1)
	<>apJob{1}:="Access Denied"
	<>apJob:=0
	ARRAY TEXT:C222(<>apJob; 3)
End if 

//*CustomerOrdering
If (User in group:C338($user; "CustomerOrdering"))
	ARRAY TEXT:C222(<>apOrd; 5)  //•051095
	<>apOrd{1}:="Enter Order"
	<>apOrd{2}:="Modify Order..."
	<>apOrd{3}:="Review Order..."
	<>apOrd{4}:="-"  //was kill
	<>apOrd{5}:="Print Order..."
	<>apOrd:=0
Else 
	ARRAY TEXT:C222(<>apOrd; 1)
	<>apOrd{1}:="Access Denied"
	<>apOrd:=0
End if 


ARRAY TEXT:C222(<>apQA; 3)
<>apQA{1}:="New"
<>apQA{2}:="Modify..."
<>apQA{3}:="Review..."
<>apJob:=0
