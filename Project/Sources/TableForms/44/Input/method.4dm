// ----------------------------------------------------
// Form Method: [Job_Forms_Items].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Not:C34(User_AllowedCustomer([Job_Forms_Items:44]CustId:15; ""; "via JOBIT: "+[Job_Forms_Items:44]Jobit:4)))
			bDone:=1
			CANCEL:C270
		End if 
		
		wWindowTitle("Push"; "Job Form Item "+[Job_Forms_Items:44]Jobit:4)
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		
		If (Read only state:C362([Job_Forms_Items:44]))
			READ ONLY:C145([Customers_Order_Lines:41])
			READ ONLY:C145([Finished_Goods:26])
		Else 
			READ ONLY:C145([Customers_Order_Lines:41])
			READ WRITE:C146([Finished_Goods:26])
			[Job_Forms_Items:44]LastCase:41:=Zebra_CaseNumberManager("last"; [Job_Forms_Items:44]Jobit:4)
		End if 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			[Job_Forms_Items:44]SellPrice_M:25:=[Customers_Order_Lines:41]Price_Per_M:8
		End if 
		
		READ WRITE:C146([Finished_Goods:26])
		$hit:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
		
		If (User in group:C338(Current user:C182; "RoleCostAccountant")) | (Current user:C182="Designer")
			SetObjectProperties(""; ->[Job_Forms_Items:44]JobForm:1; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[Job_Forms_Items:44]OrderItem:2; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]ProductCode:3; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]ItemNumber:7; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]NumberUp:8; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Qty_Yield:9; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Qty_Actual:11; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Cost_Mat:12; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Cost_LAB:13; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Cost_Burd:14; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]CustId:15; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Cost_SE:16; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostLab:18; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostMatl:17; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostOvhd:19; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostS_E:20; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostTotal:21; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]SqInches:22; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]AllocationPercent:23; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Qty_Want:24; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]SellPrice_M:25; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]ActCost_M:27; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]FinRunStdM_Hr:28; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Category:31; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Finished_Goods:26]OriginalOrRepeat:71; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]SubFormNumber:32; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Glued:33; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Qty_Good:10; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Completed:39; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]MAD:37; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]LineSpec:42; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]OutlineNumber:43; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]ControlNumber:26; True:C214; ""; True:C214)
		Else 
			SetObjectProperties(""; ->[Job_Forms_Items:44]JobForm:1; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[Job_Forms_Items:44]OrderItem:2; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]ProductCode:3; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]ItemNumber:7; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]NumberUp:8; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Qty_Yield:9; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Qty_Actual:11; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Cost_Mat:12; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Cost_LAB:13; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Cost_Burd:14; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]CustId:15; True:C214; ""; True:C214)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Cost_SE:16; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostLab:18; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostMatl:17; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostOvhd:19; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostS_E:20; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]PldCostTotal:21; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]SqInches:22; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]AllocationPercent:23; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Qty_Want:24; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]SellPrice_M:25; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]ActCost_M:27; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]FinRunStdM_Hr:28; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Category:31; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Finished_Goods:26]OriginalOrRepeat:71; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]SubFormNumber:32; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Glued:33; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Qty_Good:10; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]Completed:39; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]MAD:37; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]LineSpec:42; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]OutlineNumber:43; True:C214; ""; False:C215)
			SetObjectProperties(""; ->[Job_Forms_Items:44]ControlNumber:26; True:C214; ""; False:C215)
		End if 
		
		If (User in group:C338(Current user:C182; "RolePlanner"))
			SetObjectProperties(""; ->[Job_Forms_Items:44]CustId:15; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		End if 
		
		xMemo:=TS2iso([Job_Forms_Items:44]GlueEstimatedEnd:53)
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Job_Forms_Items:44]ModDate:29; ->[Job_Forms_Items:44]ModWho:30)
		SAVE RECORD:C53([Finished_Goods:26])
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("Pop")
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 