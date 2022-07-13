//%attributes = {"publishedWeb":true}
//Procedure: sAskMeLoadwith(sCPN;sCustID)  020896  MLB

//load the quadrants with customer search

//see also sAskMeLoadwo

//• 1/9/98 cs Lena wants to see B&H too

// • mel (8/25/04, 12:44:30) use jmi completed date

C_TEXT:C284($1; $sCPN)
C_TEXT:C284($2; $sCustID)

$sCPN:=$1
$sCustID:=$2

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$sCPN; *)  //switch to fg_key
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=$sCustID)  //switch to fg_key

CREATE SET:C116([Customers_ReleaseSchedules:46]; "CurrentSet")
CREATE SET:C116([Customers_ReleaseSchedules:46]; "twoLoaded")

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$sCPN; *)  //switch to fg_key
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=$sCustID)  //switch to fg_key

CREATE SET:C116([Finished_Goods_Locations:35]; "threeLoaded")
If (allinventory=0)
	QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:@"; *)
	QUERY SELECTION:C341([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="BH:@")  //• 1/9/98 cs Lena wants to see B&H too\
		
End if 

If (allorderlines=0)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$sCPN; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=$sCustID; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //upr 1326 2/14/95 2/15/95
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //upr 1326 2/14/95
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Rejected")  //`•5/04/99  MLB  UP
	
Else 
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$sCPN; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=$sCustID)  //switch to fg_key  
	
End if 
CREATE SET:C116([Customers_Order_Lines:41]; "oneLoaded")
//•060195  MLB  UPR 187 Don't display closed orderlines or their release unless

// Find button is clicked

If (allreleases=0)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9="Closed")
		CREATE SET:C116([Customers_Order_Lines:41]; "closedOrders")
		RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)  //get the closed releases
		
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "closedRelease")
		DIFFERENCE:C122("oneLoaded"; "closedOrders"; "displayOrders")  //don't display the closed orders
		
		USE SET:C118("displayOrders")
		CLEAR SET:C117("closedOrders")
		
	Else 
		
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9="Closed")
		CREATE SET:C116([Customers_Order_Lines:41]; "displayOrders")
		RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)  //get the closed releases
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "closedRelease")
		DIFFERENCE:C122("oneLoaded"; "displayOrders"; "displayOrders")  //don't display the closed orders
		
		USE SET:C118("displayOrders")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	//CLEAR SET("displayOrders")
	
	DIFFERENCE:C122("twoLoaded"; "closedRelease"; "displayRels")
	//•060995  MLB  UPR 1642 alway show unshiped releases
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		
		USE SET:C118("twoLoaded")
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "openRels")
		
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "openRels")
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$sCPN; *)  //switch to fg_key
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=$sCustID; *)  //switch to fg_key
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	UNION:C120("displayRels"; "openRels"; "displayRels")
	CLEAR SET:C117("openRels")
	CLEAR SET:C117("closedRelease")
	//end 1642
	
	USE SET:C118("displayRels")
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"Rtn:@ ")
	CREATE SET:C116([Customers_ReleaseSchedules:46]; "displayRels")
End if 

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$sCPN; *)  //switch to fg_key
QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]CustId:15=$sCustID)  //switch to fg_key

CREATE SET:C116([Job_Forms_Items:44]; "fourLoaded")
If (alljobs=0)
	//QUERY SELECTION BY FORMULA([JobMakesItem];[JobMakesItem]Qty_Actual=0)  `•020896  MLB 
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)  //•08.25.04  MLB  
End if 



If (bCache=1)  //•020896  MLB 
	SAVE SET:C184("displayOrders"; ("1-"+$sCPN))
	SAVE SET:C184("displayRels"; ("2-"+$sCPN))
	SAVE SET:C184("threeLoaded"; ("3-"+$sCPN))
	SAVE SET:C184("fourLoaded"; ("4-"+$sCPN))
End if 