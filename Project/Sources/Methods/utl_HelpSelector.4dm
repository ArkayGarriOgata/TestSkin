//%attributes = {"publishedWeb":true}
//PM:  utl_HelpSelector  3/01/00  mlb
//      
$stayPut:=False:C215
iHelpItem:=Selected list items:C379(hlHelp)
If (iHelpItem>0)
	GET LIST ITEM:C378(hlHelp; iHelpItem; $itemRef; $itemText)
	
	zwStatusMsg("Help:"; String:C10(iHelpItem)+" "+$itemText)
	
	Case of 
		: ($itemText="Index")
			FORM SET INPUT:C55([x_help:8]; "HelpStartPage")
			
		: ($itemText="Customer Order Status")  //*State Diagrams
			FORM SET INPUT:C55([x_help:8]; "stateDiagramOrders")
			
		: ($itemText="Job Status")
			FORM SET INPUT:C55([x_help:8]; "stateDiagramJobs")
			
		: ($itemText="Customer Orders")  //*Class Diagrams
			FORM SET INPUT:C55([x_help:8]; "classDiagramOrders")
			
		: ($itemText="Jobs")
			FORM SET INPUT:C55([x_help:8]; "classDiagramJobs")
			
		: ($itemText="Inventory Items")
			FORM SET INPUT:C55([x_help:8]; "classDiagramInventory")
			
		: ($itemText="Job Process")
			FORM SET INPUT:C55([x_help:8]; "activityJob")
			
		: ($itemText="Prepress Process")
			FORM SET INPUT:C55([x_help:8]; "activityPrepress")
			
		: ($itemText="Prepare for Production")
			FORM SET INPUT:C55([x_help:8]; "activityProduction")
			
		: ($itemText="Physical Inventory")
			FORM SET INPUT:C55([x_help:8]; "activityPhysInventory")
			
		: ($itemText="Set up a Pay Use consignment")  //*How to
			iHelpUPR:=1729
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Track Art and OKs")
			iHelpUPR:=1848
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Recognize Roanoke on Picks")
			iHelpUPR:=1849
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Combine Customers on 1 Job")
			iHelpUPR:=1600
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Enter Case Packing Counts")
			iHelpUPR:=1908
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Take Physical Inventory")
			iHelpUPR:=2014
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Estimate Prep Charges")
			iHelpUPR:=1636
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Bill for Prep and special serv.")
			iHelpUPR:=1508
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Execute a Bill & Hold")
			iHelpUPR:=2074
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Barcode Raw Materials")
			iHelpUPR:=237
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="See Current Production Standards")
			iHelpUPR:=247
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Notify Avon of Expiration")
			iHelpUPR:=993
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Measure Plant Contribution")
			iHelpUPR:=239
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Invoice Customers")
			iHelpUPR:=236
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Notify Customer Old Inventory")
			iHelpUPR:=232
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Sell 'Excess' Inventory")
			iHelpUPR:=230
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
			//: ($itemText="Analyze Supply and Demand")
			//iHelpUPR:=2074
			//INPUT FORM([Help];"helpViaUPR")
			
		: ($itemText="Calculate Estimates w/o Carton")
			iHelpUPR:=192
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Prepare a Quote")
			iHelpUPR:=216
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Schedule based on Need to Mfg")
			iHelpUPR:=1608
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Quote Process")
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Job Process")
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Enter Contract order w/o EDI")
			iHelpUPR:=184
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
			//: ($itemText="Time Horizon Calculation (THC)")  `*What is
			//iHelpUPR:=0
			//INPUT FORM([Help];"helpViaUPR")
			
		: ($itemText="CPI-Shipping Performance")
			iHelpUPR:=1915
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="FIFO Inventory")
			iHelpUPR:=77
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Inventory Monthly Report")
			iHelpUPR:=1490
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="MSDS")
			iHelpUPR:=1936
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="Waste")
			iHelpUPR:=1951
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		: ($itemText="AskMe")
			iHelpUPR:=1964
			FORM SET INPUT:C55([x_help:8]; "helpViaUPR")
			
		Else 
			$stayPut:=True:C214
			//    INPUT FORM([Help];"HelpStartPage")
			iHelpItem:=0
	End case 
	
	If (Not:C34($stayPut))
		bDone:=0
		CANCEL:C270
	End if 
	
End if 