//•031297  mBohince 

If (Records in set:C195("Job_Forms_Items")>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "testForOpen")
	USE SET:C118("Job_Forms_Items")
	<>JOBIT:=[Job_Forms_Items:44]Jobit:4
	
	// • mel (3/25/04, 15:52:20) warn about label error potential
	zwStatusMsg("Packing Spec"; "For job item: "+<>JOBIT)
	SET QUERY LIMIT:C395(1)
	READ ONLY:C145([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Items:44]JobForm:1)
	SET QUERY LIMIT:C395(0)
	Case of 
		: ([Job_Forms:42]ClosedDate:11#!00-00-00!)
			uConfirm("Warning: job for selected item is Closed"; "OK"; "Help")
		: ([Job_Forms:42]Completed:18#!00-00-00!)
			uConfirm("Warning: job for selected item is Completed"; "OK"; "Help")
		: ([Job_Forms:42]Status:6#"WIP")
			uConfirm("Warning: job for selected item is not marked Work in Process"; "OK"; "Help")
	End case 
	
	C_LONGINT:C283($numOpen)  // Modified by: Mel Bohince (10/7/21) 
	SET QUERY LIMIT:C395(1)
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numOpen)
	READ ONLY:C145([Job_Forms_Items:44])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=sCPN; *)  //this product
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Jobit:4#<>JOBIT; *)  //but not this jobit
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11=0)  //and not yet produced
	SET QUERY LIMIT:C395(0)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($numOpen>0)
		uConfirm("Warning: there are other open jobs for this Product"; "I'm Sure"; "Help")
	End if 
	USE NAMED SELECTION:C332("testForOpen")
	
	PK_ShippingContainerUI(sOutlineNum)
	
	
Else 
	uConfirm("Select a Jobit in the lower right corner."; "OK"; "Help")
End if 