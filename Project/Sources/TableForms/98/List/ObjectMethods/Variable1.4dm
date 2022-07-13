uYesNoCancel("Select a report Type"; "FGS_PrepList"; "Not Done's"; "Cancel")
Case of 
	: (bAccept=1)
		$path:=util_DocumentPath("get")+"FGS_PrepList"
		SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
		QR REPORT:C197([Finished_Goods_Specifications:98]; $path)
		SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
		//
		
	: (bNo=1)
		CUT NAMED SELECTION:C334([Finished_Goods_Specifications:98]; "holdOnThere")
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DateReturned:9=!00-00-00!)
		FG_PrepServicesQueries("9")
		SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
		ORDER BY:C49([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]Status:68; >; [Finished_Goods:26]PressDate:64; >; [Finished_Goods_Specifications:98]DateArtReceived:63; >)
		SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
		READ ONLY:C145([Customers:16])
		FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "ReportAll")
		util_PAGE_SETUP(->[Finished_Goods_Specifications:98]; "ReportAll")
		BREAK LEVEL:C302(1)
		ACCUMULATE:C303([Finished_Goods_Specifications:98]HoursCharged:51)
		PRINT SELECTION:C60([Finished_Goods_Specifications:98])
		FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "List")
		
		USE NAMED SELECTION:C332("holdOnThere")
	Else 
		//cancel    
		
End case 