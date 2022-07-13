//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 04/02/08, 09:34:47
// ----------------------------------------------------
// Method: rfc_OnLoadForm
// Description:
// Called from input form
// ----------------------------------------------------

Case of 
	: (Is new record:C668([Finished_Goods_SizeAndStyles:132]))
		uConfirm("Use the Project Screen to add Size and Style requests."; "OK"; "Help")
		CANCEL:C270
		
	Else 
		If (Not:C34(User_AllowedCustomer([Finished_Goods_SizeAndStyles:132]CustID:52; ""; "via SnS "+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)))
			bDone:=1
			CANCEL:C270
		End if 
		
		READ ONLY:C145([Customers_Projects:9])
		READ ONLY:C145([Customers:16])
		ARRAY TEXT:C222(aBrand; 0)
		
		pjtId:=[Finished_Goods_SizeAndStyles:132]ProjectNumber:2  // Added by: Mark Zinke (3/27/13)
		aBrand{0}:=""
		If (Length:C16([Finished_Goods_SizeAndStyles:132]ProjectNumber:2)=5)
			RELATE ONE:C42([Finished_Goods_SizeAndStyles:132]ProjectNumber:2)
			QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Projects:9]Customerid:3)
			uBuildBrandList(->[Finished_Goods_SizeAndStyles:132]Line:11)
		Else 
			REDUCE SELECTION:C351([Customers_Projects:9]; 0)
			REDUCE SELECTION:C351([Customers:16]; 0)
		End if 
		If (aBrand{0}="")
			INSERT IN ARRAY:C227(aBrand; 1; 1)
			aBrand{1}:=[Finished_Goods_SizeAndStyles:132]Line:11
			aBrand{0}:=aBrand{1}
		End if 
		//get any additions
		QUERY:C277([Finished_Goods_SnS_Additions:150]; [Finished_Goods_SnS_Additions:150]FileOutlineNum:1=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
		ORDER BY:C49([Finished_Goods_SnS_Additions:150]; [Finished_Goods_SnS_Additions:150]Addition_Num:2; <)
		C_LONGINT:C283(task1; task2; task3; task4; task5; task6; task7)
		ARRAY TEXT:C222(aPriority; 0)
		ARRAY TEXT:C222(aProvided; 0)
		ARRAY TEXT:C222(aStandard; 0)
		ARRAY TEXT:C222(aStyle; 0)
		ARRAY TEXT:C222(aTop; 0)
		ARRAY TEXT:C222(aBottom; 0)
		LIST TO ARRAY:C288("rfc_Priorities"; aPriority)
		LIST TO ARRAY:C288("rfc_sample"; aProvided)
		LIST TO ARRAY:C288("rfc_standard"; aStandard)
		LIST TO ARRAY:C288("rfc_style"; aStyle)
		LIST TO ARRAY:C288("rfc_top"; aTop)
		LIST TO ARRAY:C288("rfc_bottom"; aBottom)
		aPriority{0}:=String:C10([Finished_Goods_SizeAndStyles:132]Priority:47)
		aProvided{0}:=[Finished_Goods_SizeAndStyles:132]ProvidedSample:43
		aStandard{0}:=[Finished_Goods_SizeAndStyles:132]Standard:13
		aStyle{0}:=[Finished_Goods_SizeAndStyles:132]Style:14
		aTop{0}:=[Finished_Goods_SizeAndStyles:132]Top:15
		aBottom{0}:=[Finished_Goods_SizeAndStyles:132]Bottom:16
		
		//stockList:=RM_BuildStockList ("init")// Modified by: Mel Bohince (12/5/20) removed, choice list instead
		//SAVE LIST(hlStockTypes;"CaliperByStock")
		
		//DISABLE EVERYTHING
		OBJECT SET ENABLED:C1123(*; "product@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "spec@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "plnr@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "img@"; False:C215)
		OBJECT SET ENABLED:C1123(bAddRequest; False:C215)
		OBJECT SET ENABLED:C1123(bShowOL; False:C215)
		OBJECT SET ENABLED:C1123(bSetStart; False:C215)
		OBJECT SET ENABLED:C1123(*; "task@"; False:C215)
		OBJECT SET ENABLED:C1123(bBrian; False:C215)
		
		SetObjectProperties("product@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("spec@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("plnr@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("img@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("Dim@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->bSetStart; True:C214; "Start")  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->bSubmit; True:C214; "Submit")  // Modified by: Mark Zinke (5/6/13)
		
		rfc_OptionsHide  //clear the form of checkboxes that are not set
		rfc_taskCheckBox(->[Finished_Goods_SizeAndStyles:132]TasksCompleted:56; "set-all")
		
		Case of 
			: (User in group:C338(Current user:C182; "RoleCartonDesign"))
				rfc_UpdateByImaging
			Else   //everyone else
				rfc_UpdateByPlanner
		End case 
		
		If (Current user:C182="Brian Hopkins") | (Current user:C182="Designer")
			OBJECT SET ENABLED:C1123(bBrian; True:C214)
		End if 
End case 