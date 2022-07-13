//%attributes = {"publishedWeb":true}
uConfirm("Are you sure you want to DELETE "+[Finished_Goods:26]ProductCode:1+"?"; "Delete"; "Cancel")
If (OK=1)
	$sCPN:=[Finished_Goods:26]ProductCode:1
	READ ONLY:C145([Finished_Goods_Locations:35])
	READ ONLY:C145([Finished_Goods_Transactions:33])  //•022597  MLB  
	READ ONLY:C145([Job_Forms_Items:44])
	READ ONLY:C145([Customers_Order_Lines:41])  // need to make changes
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$sCPN; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$sCPN)
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$sCPN; *)  //switch to fg_key
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //upr 1326 2/14/95 2/15/95
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"C@"; *)  //upr 1326 2/14/95
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Rejected")
	
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$sCPN; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProductCode:3=$sCPN; *)
	QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6=!00-00-00!)
	
	$msg:="There are: "
	$num:=Records in selection:C76([Customers_ReleaseSchedules:46])
	$msg:=$msg+String:C10($num)+" [Customers_ReleaseSchedules], "
	
	$num:=Records in selection:C76([Finished_Goods_Locations:35])
	$msg:=$msg+String:C10($num)+" [Finished_Goods_Locations], "
	
	$num:=Records in selection:C76([Customers_Order_Lines:41])
	$msg:=$msg+String:C10($num)+" [Customers_Order_Lines], "
	
	$num:=Records in selection:C76([Job_Forms_Items:44])
	$msg:=$msg+String:C10($num)+" [Job_Forms_Items], "
	
	$num:=Records in selection:C76([Finished_Goods_Specifications:98])
	$msg:=$msg+String:C10($num)+" [Finished_Goods_Specifications]."
	
	uConfirm("Note: "+$msg; "Delete"; "Cancel")
	If (OK=1)
		$id:=FGX_NewFG_Transaction("DELETED"; 4D_Current_date; <>zResp)
		[Finished_Goods_Transactions:33]CustID:12:=[Finished_Goods:26]CustID:2
		[Finished_Goods_Transactions:33]ProductCode:1:=[Finished_Goods:26]ProductCode:1
		[Finished_Goods_Transactions:33]XactionTime:13:=4d_Current_time
		SAVE RECORD:C53([Finished_Goods_Transactions:33])
		
		DELETE RECORD:C58([Finished_Goods:26])
		
		uConfirm("Delete transaction recorded."; "OK"; "Help")
		
		CANCEL:C270
	End if 
End if 