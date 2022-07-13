//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/09/12, 12:35:37
// ----------------------------------------------------
// Method: Rama_Find_CPNs
// Description:
// Build an array of current cpn's sent to Rama
// ----------------------------------------------------
// Modified by: Mel Bohince (6/27/13) annotate Sleeves in the Status column so they can be converted (tagged) by Rama, or not

C_LONGINT:C283($0)
C_TEXT:C284($1)  //switch
C_POINTER:C301($2)

Case of 
	: (Count parameters:C259=0)
		Rama_Find_CPNs("init")
		
	: ($1="init")
		ARRAY TEXT:C222(<>aRama_CPNs; 0)
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="02563"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10="01666"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; <>aRama_CPNs)
		$0:=Size of array:C274(<>aRama_CPNs)
		REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
		
		// See Rama_Load_Inventory for use on ◊aSleeves
		ARRAY TEXT:C222(<>aSleeves; 0)  // Modified by: Mel Bohince (6/27/13) find sleeves that are in inventory
		Begin SQL
			select distinct(ProductCode) from Finished_Goods_Locations where ProductCode in (SELECT ProductCode from Finished_Goods where lower(style) like '%sleeve%' and custid = '00199') and location like 'FG:AV%' order by productcode into <<[<>aSleeves]>>
		End SQL
		
	: ($1="kill")
		ARRAY TEXT:C222(<>aRama_CPNs; 0)
		ARRAY TEXT:C222(<>aSleeves; 0)
		
	: ($1="query")
		If (Size of array:C274(<>aRama_CPNs)=0)
			Rama_Find_CPNs("init")
		End if 
		
		QUERY WITH ARRAY:C644($2->; <>aRama_CPNs)
		$table_ptr:=Table:C252(Table:C252($2))
		$0:=Records in selection:C76($table_ptr->)
		
	: ($1="forecast")
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="01666"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3=("<@"); *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		$0:=Records in selection:C76([Customers_ReleaseSchedules:46])
		
	: ($1="delivery")
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="01666"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<(4D_Current_date+15); *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31=0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		$0:=Records in selection:C76([Customers_ReleaseSchedules:46])
		
	: ($1="gaylords")
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="02563"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]PayU:31>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		$0:=Records in selection:C76([Customers_ReleaseSchedules:46])
		
	: ($1="inventory")
		//QUERY WITH ARRAY([Finished_Goods_Locations]ProductCode;<>aRama_CPNs)
		//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location=("FG:AV=RAMA@"))
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="XC@"; *)
		QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]KillStatus:30#0)
		//QUERY SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]Location=("FG:AV=@"))  //the hyphen changed to equal when recieved
		$0:=Records in selection:C76([Finished_Goods_Locations:35])
		
	: ($1="wip")
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:R@"; *)
		QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="FG:V@")
		$0:=Records in selection:C76([Finished_Goods_Locations:35])
		
	: ($1="transit")
		//QUERY WITH ARRAY([Finished_Goods_Locations]ProductCode;<>aRama_CPNs)
		//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location=("FG:AV-RAMA@"))
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="@_TRANSIT")
		$0:=Records in selection:C76([Finished_Goods_Locations:35])
		
	: ($1="server")
		Rama_Find_CPNs_On_Server("client-side")  //populate aCPN 
		//ARRAY TEXT(aCPN;0)
		//c_date($yearAgo)
		//$yearAgo:=Add to date(Current date;-1;0;0)
		//Begin SQL
		//SELECT distinct(productcode) from Customers_ReleaseSchedules where (Shipto='01666' or Shipto='02563') and Sched_Date >= :$yearAgo into :aCPN;
		//End SQL
		
	Else 
		BEEP:C151
End case 