//%attributes = {"publishedWeb":true}
// doModifyRecord() see also doReviewRecord
//called by viewsetter
// Modified by: Mel Bohince (9/14/15) add parameters to Modify Selection: MODIFY SELECTION(filePtr->;Multiple selection;$enter_in_list;*)
// Modified by: MelvinBohince (5/18/22) initialize showCoGScalc for Invoice table

C_LONGINT:C283($winRef)
C_BOOLEAN:C305($enter_in_list)

uSetUp(1; 1)
READ WRITE:C146(filePtr->)
$enter_in_list:=False:C215

windowTitle:=" Modify records"
Case of   //•061695  MLB  UPR 1636
	: (filePtr=(->[Job_Forms:42]))
		Case of 
			: (<>JFActivity=1)  //• 10/21/97 cs open window ONCE
				$winRef:=OpenFormWindow(filePtr; "InputBudget"; ->windowTitle)
				
			: (<>JFActivity=2)  //• 10/21/97 cs open window ONCE  
				$winRef:=OpenFormWindow(filePtr; "InputActual2"; ->windowTitle)
				
			: (<>JFActivity=4)  //1/23/95 upr 167
				$winRef:=OpenFormWindow(filePtr; "ProductionClose"; ->windowTitle)
				
			: (<>JFActivity=5)  //1/23/95 upr 167
				$winRef:=OpenFormWindow(filePtr; "DieBoard"; ->windowTitle)
				
			Else 
				$winRef:=OpenFormWindow(filePtr; "Input"; ->windowTitle)
		End case 
		
	Else 
		$winRef:=OpenFormWindow(filePtr; "*"; ->windowTitle)
End case 

// ////TABLE SPECIFICS
Case of   //•061695  MLB  UPR 1636
	: (filePtr=(->[Job_Forms_Master_Schedule:67]))
		
		C_OBJECT:C1216($oNameColor)
		$oNameColor:=New object:C1471()
		$oNameColor:=Cust_Name_ColorO()
		
	: (filePtr=(->[Jobs:15]))
		CostCtrCurrent("init"; "00/00/00")
		
	: (filePtr=(->[Job_Forms:42]))
		CostCtrCurrent("init"; "00/00/00")
		ARRAY TEXT:C222(aCommCode; 0)  //choice list verifications
		LIST TO ARRAY:C288("CommCodes"; aCommCode)
		ARRAY TEXT:C222($aCompId; 0)
		LIST TO ARRAY:C288("Company"; $aCompId)
		ARRAY TEXT:C222(aCompany; Size of array:C274($aCompId))
		ARRAY TEXT:C222($Dept; 0)
		LIST TO ARRAY:C288("Departments"; $dept)
		ARRAY TEXT:C222(aDeptCode; Size of array:C274($Dept))
		C_LONGINT:C283($i)
		For ($i; 1; Size of array:C274($aCompId))
			aCompany{$i}:=String:C10(Num:C11(Substring:C12($aCompId{$i}; 1; 2)))
		End for 
		ARRAY TEXT:C222($aCompId; 0)
		
		For ($i; 1; Size of array:C274($Dept))
			aDeptCode{$i}:=Substring:C12($Dept{$i}; 1; 4)
		End for 
		ARRAY TEXT:C222($dept; 0)
		
	: (filePtr=(->[Purchase_Orders:11]))
		C_BOOLEAN:C305(fOrdering)
		fOrdering:=False:C215
		READ WRITE:C146([Purchase_Orders_Items:12])
		READ WRITE:C146([Purchase_Orders_Chg_Orders:13])
		READ ONLY:C145([Vendors:7])
		
	: (filePtr=(->[Customers_Order_Lines:41]))
		ARRAY TEXT:C222(aBilltos; 0)
		ARRAY TEXT:C222(aShiptos; 0)
		
	: (filePtr=(->[Finished_Goods:26]))
		$boolean:=FG_LaunchItem("init")
End case 

// ////SEARCH
Case of 
	: (<>PassThrough)  //skip the search stuff  
		useFindWidget:=False:C215  // Added by: Mel Bohince (6/12/19) 
		<>PassThrough:=False:C215
		USE SET:C118("◊PassThroughSet")
		NumRecs1:=Records in selection:C76(filePtr->)
		CLEAR SET:C117("◊PassThroughSet")
		CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
		CREATE SET:C116(filePtr->; "CurrentSet")
		Case of 
			: (filePtr=(->[Customers_Orders:40]))
				ARRAY TEXT:C222(aBilltos; 0)
				ARRAY TEXT:C222(aShiptos; 0)
				fLoop:=False:C215
				READ WRITE:C146([Customers_Order_Lines:41])
				READ WRITE:C146([Customers_ReleaseSchedules:46])
				READ ONLY:C145([Customers:16])  //3/20/95
				
			: (filePtr=(->[x_id_numbers:3]))
				ORDER BY:C49([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1; >)
				
			: (filePtr=(->[Customers_Invoices:88]))  //•060399  mlb  UPR 236
				READ ONLY:C145([Addresses:30])  // Modified by: Mel Bohince (7/15/21) 
				READ ONLY:C145([Customers_Bills_of_Lading:49])  // Modified by: Mel Bohince (7/15/21)
				READ ONLY:C145([Finished_Goods:26])  // Modified by: Mel Bohince (7/15/21)
				
				ORDER BY:C49([Customers_Invoices:88]; [Customers_Invoices:88]BillTo:10; >)
				sCriterion1:="Pending"
				C_BOOLEAN:C305(showCoGScalc)  // Modified by: MelvinBohince (5/18/22) 
				showCoGScalc:=False:C215
				
			: (filePtr=(->[ProductionSchedules_Revisions:118]))
				ORDER BY:C49([ProductionSchedules_Revisions:118]; [ProductionSchedules_Revisions:118]JobSequence:1; >; [ProductionSchedules_Revisions:118]RevDate:3; >)
				
			: (filePtr=(->[ProductionSchedules_BlockTimes:136]))
				ORDER BY:C49([ProductionSchedules_BlockTimes:136]; [ProductionSchedules_BlockTimes:136]BlockId:1; >)
				
			: (filePtr=(->[WMS_SerializedShippingLabels:96]))
				ORDER BY:C49([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5; >)
				
			: (filePtr=(->[Job_Forms:42]))
				ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; <)
				
		End case 
		
		OK:=1
		
	: (filePtr=(->[Finished_Goods_SizeAndStyles:132]))
		QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateSubmitted:5#!00-00-00!; *)
		QUERY:C277([Finished_Goods_SizeAndStyles:132];  & ; [Finished_Goods_SizeAndStyles:132]DateDone:6=!00-00-00!)
		User_AllowedSelection(->[Finished_Goods_SizeAndStyles:132])
		If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])=0)
			ALL RECORDS:C47([Finished_Goods_SizeAndStyles:132])
			<>Activitiy:=6
		End if 
		
		ORDER BY:C49([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]DateWanted:42; >; [Finished_Goods_SizeAndStyles:132]DateSubmitted:5; >)
		NumRecs1:=Records in selection:C76([Finished_Goods_SizeAndStyles:132])
		
	: (filePtr=(->[Finished_Goods_Color_SpecMaster:128]))
		ALL RECORDS:C47([Finished_Goods_Color_SpecMaster:128])
		<>Activitiy:=1
		
		ORDER BY:C49([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]name:2; >)
		C_LONGINT:C283(iJMLTabs)
		iJMLTabs:=0
		NumRecs1:=Records in selection:C76([Finished_Goods_Color_SpecMaster:128])
		
	: (filePtr=(->[Tool_Drawers:151]))
		ALL RECORDS:C47([Tool_Drawers:151])
		ORDER BY:C49([Tool_Drawers:151]; [Tool_Drawers:151]Bin:1; >)
		NumRecs1:=Records in selection:C76([Tool_Drawers:151])
		
	: (filePtr=(->[Customer_Portal_Extracts:158]))
		ALL RECORDS:C47([Customer_Portal_Extracts:158])
		ORDER BY:C49([Customer_Portal_Extracts:158]; [Customer_Portal_Extracts:158]CustId:1; >)
		NumRecs1:=Records in selection:C76([Customer_Portal_Extracts:158])
		
	: (filePtr=(->[Job_Forms:42]))
		If (<>JFActivity=5)
			DIALOG:C40([Job_Forms:42]; "DieBoard_Find")
			ERASE WINDOW:C160
		Else   //don' t short stop the caseof
			NumRecs1:=fSelectBy
		End if 
		
	: (filePtr=(->[Finished_Goods_Specifications:98]))
		Case of 
			: (User in group:C338(Current user:C182; "RolePlanner"))
				<>Activitiy:=2
				FG_PrepServicesQueries("1 Planning")
			: (User in group:C338(Current user:C182; "RoleQA"))
				<>Activitiy:=4
				FG_PrepServicesQueries("3 Quality")
			: (User in group:C338(Current user:C182; "RoleImaging"))
				<>Activitiy:=3
				FG_PrepServicesQueries("2 Imaging")
			: (User in group:C338(Current user:C182; "RoleCustomerService"))
				<>Activitiy:=5
				FG_PrepServicesQueries("4 Mail Room")
			: (User in group:C338(Current user:C182; "RoleSalesman"))
				<>Activitiy:=6
				FG_PrepServicesQueries("5 Customer")
				
			Else 
				<>Activitiy:=7
				FG_PrepServicesQueries("9")
		End case 
		
		If (NumRecs1=0)
			<>Activitiy:=7
			FG_PrepServicesQueries("9")
		End if 
		
		
		ORDER BY:C49([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DateArtReceived:63; >)
		
	: (filePtr=(->[Estimates:17]))
		READ WRITE:C146([Estimates_Carton_Specs:19])
		READ WRITE:C146([Estimates_Machines:20])
		READ WRITE:C146([Estimates_Materials:29])
		READ ONLY:C145([Process_Specs:18])
		READ WRITE:C146([Estimates_PSpecs:57])
		READ WRITE:C146([Finished_Goods:26])
		READ WRITE:C146([Estimates_FormCartons:48])
		READ WRITE:C146([Estimates_DifferentialsForms:47])
		READ WRITE:C146([Estimates_Differentials:38])
		READ ONLY:C145([Customers:16])
		READ ONLY:C145([Customers_Projects:9])
		READ ONLY:C145([Cost_Centers:27])
		READ ONLY:C145([Raw_Materials_Groups:22])
		READ ONLY:C145([Salesmen:32])  // Modified by: Mel Bohince (3/31/21) 
		C_TEXT:C284(thisActivity)
		
		thisActivity:=""
		
		Case of 
			: (<>Activitiy=1)  //sales
				thisActivity:="sales"
				$initials:=Request:C163("Initials of the Saleman or C/S?"; <>zResp)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					QUERY:C277([Estimates:17]; [Estimates:17]Status:30="New"; *)
					QUERY:C277([Estimates:17];  | ; [Estimates:17]Status:30="Hold"; *)
					QUERY:C277([Estimates:17];  | ; [Estimates:17]Status:30="Priced@")
					
					QUERY SELECTION:C341([Estimates:17]; [Estimates:17]Sales_Rep:13=$initials; *)
					QUERY SELECTION:C341([Estimates:17];  | ; [Estimates:17]SaleCoord:46=$initials)
					
				Else 
					
					QUERY BY FORMULA:C48([Estimates:17]; \
						(([Estimates:17]Status:30="New") | ([Estimates:17]Status:30="Hold") | ([Estimates:17]Status:30="Priced@"))\
						 & (([Estimates:17]Sales_Rep:13=$initials) | ([Estimates:17]SaleCoord:46=$initials))\
						)
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				NumRecs1:=Records in selection:C76([Estimates:17])
				ORDER BY:C49([Estimates:17]; [Estimates:17]Status:30; >; [Estimates:17]DateRFQ:52; >)
				If (NumRecs1>0)
					OK:=1
				Else 
					ALERT:C41("You have no RFQ's with status = New, Hold, Priced, or Quoted.")
				End if 
				
			: (<>Activitiy=2)  //planning
				thisActivity:="planning"
				$initials:=Request:C163("Initial in the PlannedBy field?"; <>zResp)
				QUERY:C277([Estimates:17]; [Estimates:17]Status:30="RFQ"; *)
				QUERY:C277([Estimates:17];  | ; [Estimates:17]Status:30="Estimated"; *)
				QUERY:C277([Estimates:17];  | ; [Estimates:17]Status:30="Budget@"; *)
				QUERY:C277([Estimates:17];  & ; [Estimates:17]PlannedBy:16=$initials)
				NumRecs1:=Records in selection:C76([Estimates:17])
				ORDER BY:C49([Estimates:17]; [Estimates:17]Status:30; >; [Estimates:17]DateRFQ:52; >)
				If (NumRecs1>0)
					OK:=1
				Else 
					ALERT:C41("You have no estimates with status = RFQ or Estimated.")
				End if 
				
			: (<>Activitiy=4)  //Estimator
				$enter_in_list:=True:C214
				thisActivity:="estimating"
				QUERY:C277([Estimates:17]; [Estimates:17]Status:30="RFQ")  //•082802  mlb  UPR
				NumRecs1:=Records in selection:C76([Estimates:17])
				ORDER BY:C49([Estimates:17]; [Estimates:17]DateRFQ:52; >; [Estimates:17]DateRFQTime:53; >)
				
				If (NumRecs1>0)
					OK:=1
				Else 
					ALERT:C41("There are no estimates with status = RFQ.")
				End if 
				
			: (<>Activitiy=3)  //pricing
				thisActivity:="pricing"
				QUERY:C277([Estimates:17]; [Estimates:17]Status:30="Estimated")
				
				NumRecs1:=Records in selection:C76([Estimates:17])
				ORDER BY:C49([Estimates:17]; [Estimates:17]Status:30; >; [Estimates:17]z_DateEstimateNeeded:21; >)
				If (NumRecs1>0)
					OK:=1
				Else 
					ALERT:C41("You have no estimates with status = Pricing or Review.")
				End if 
			Else 
				thisActivity:="other"
				NumRecs1:=fSelectBy
		End case 
		
		//: (filePtr=(->[Finished_Goods_Locations]))
		//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location="Ex@")
		//OK:=1
		//NumRecs1:=Records in selection([Finished_Goods_Locations])
		//INPUT FORM([Finished_Goods_Locations];"Input2")
		
	: (filePtr=(->[Salesmen:32]))
		ALL RECORDS:C47([Salesmen:32])
		NumRecs1:=Records in selection:C76([Salesmen:32])
		If (NumRecs1>0)
			OK:=1
		End if 
		
	: (filePtr=(->[Prep_CatalogItems:102]))
		ALL RECORDS:C47([Prep_CatalogItems:102])
		NumRecs1:=Records in selection:C76([Prep_CatalogItems:102])
		If (NumRecs1<2)
			NumRecs1:=2
		End if 
		OK:=1
		
	: (filePtr=(->[Cost_Ctr_Down_Times:139]))
		ALL RECORDS:C47([Cost_Ctr_Down_Times:139])
		ORDER BY:C49([Cost_Ctr_Down_Times:139]; [Cost_Ctr_Down_Times:139]DisplayOrder:3; >)
		NumRecs1:=Records in selection:C76([Cost_Ctr_Down_Times:139])
		OK:=1
		
	: (filePtr=(->[z_administrators:2]))
		ALL RECORDS:C47([z_administrators:2])
		NumRecs1:=1
		OK:=1
		
	: (filePtr=(->[zz_control:1]))
		ALL RECORDS:C47([zz_control:1])
		NumRecs1:=1
		OK:=1
		
	: (filePtr=(->[Customers_Orders:40]))
		fLoop:=False:C215
		ARRAY TEXT:C222(aBilltos; 0)
		ARRAY TEXT:C222(aShiptos; 0)
		READ WRITE:C146([Customers_Order_Lines:41])
		READ WRITE:C146([Customers_ReleaseSchedules:46])
		READ ONLY:C145([Customers:16])  //3/20/95
		NumRecs1:=fSelectBy
		
	: (filePtr=(->[Customers_ReleaseSchedules:46]))
		fLoop:=False:C215
		ARRAY TEXT:C222(aBilltos; 0)
		ARRAY TEXT:C222(aShiptos; 0)
		NumRecs1:=fSelectBy
		
	: (filePtr=(->[Customers_Order_Change_Orders:34]))
		fLoop:=True:C214
		NumRecs1:=fSelectBy
		RELATE ONE SELECTION:C349([Customers_Order_Change_Orders:34]; [Customers_Orders:40])
		
	: (filePtr=(->[Job_Forms_Items:44]))
		OK:=1
		
	: (filePtr=(->[Usage_Problem_Reports:84]))
		OK:=1
		
	: (filePtr=(->[Job_Forms_Master_Schedule:67]))
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#("@.**"))
		ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25; >)
		OK:=1
		CREATE SET:C116([Job_Forms_Master_Schedule:67]; "CurrentSet")
		bModMany:=True:C214
		NumRecs1:=Records in selection:C76(filePtr->)
		
	Else 
		NumRecs1:=fSelectBy
End case 

If (OK=1)  //perform search
	Case of 
		: (filePtr=(->[Job_Forms_Items:44]))
			doModJMI
			
		: (filePtr=(->[Usage_Problem_Reports:84]))
			doModUPRs
			
		Else 
			Repeat 
				CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
				SET WINDOW TITLE:C213(fNameWindow(filePtr)+" Modifying records")
				If (<>SCROLLING)
					Case of 
						: (NumRecs1=0)
							bDone:=1
							
						: (NumRecs1=1) & (filePtr=(->[Finished_Goods_Specifications:98]))
							bModMany:=True:C214
							MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; $enter_in_list; *)
						: (NumRecs1=1)
							MODIFY RECORD:C57(filePtr->; *)
							bDone:=1
						: (NumRecs1>1)
							bModMany:=True:C214
							MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; $enter_in_list; *)
							bModMany:=False:C215  //may also be set by Done button
					End case 
					
				Else 
					
					Case of 
						: (NumRecs1=0)
							bDone:=1
						: (NumRecs1=1) & (filePtr=(->[Finished_Goods_Specifications:98]))  // (sFile="Finished_Goods_Specifications")
							bModMany:=True:C214
							//MODIFY SELECTION(filePtr->;*)
							MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; $enter_in_list; *)
							bModMany:=False:C215  //may also be set by Done button
							
						: (NumRecs1=1) & (filePtr=(->[Finished_Goods_SizeAndStyles:132]))  // (sFile="Finished_Goods_SizeAndStyles")
							bModMany:=True:C214
							
							MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; $enter_in_list; *)
							bModMany:=False:C215  //may also be set by Done button
						: (NumRecs1=1) & (filePtr=(->[ProductionSchedules_BlockTimes:136]))  //(sFile="ProductionSchedules_BlockTimes")
							bModMany:=True:C214
							MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; $enter_in_list; *)
							bModMany:=False:C215  //may also be set by Done button
							
						: (NumRecs1=1)
							MODIFY RECORD:C57(filePtr->; *)
							bDone:=1
						: (NumRecs1>1)
							bModMany:=True:C214
							MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; $enter_in_list; *)
							bModMany:=False:C215  //may also be set by Done button
					End case 
				End if 
			Until (bDone>=1)
	End case 
End if 

CLOSE WINDOW:C154($winRef)
uSetUp(0; 0)

Case of 
	: (filePtr=(->[Estimates:17]))
		SAVE RECORD:C53([Estimates_Carton_Specs:19])
		SAVE RECORD:C53([Estimates_Machines:20])
		SAVE RECORD:C53([Process_Specs:18])
		SAVE RECORD:C53([Estimates_FormCartons:48])
		SAVE RECORD:C53([Estimates_DifferentialsForms:47])
		SAVE RECORD:C53([Estimates_Differentials:38])
		
		uClearEstimates
		
		<>Activitiy:=0
		
	: (filePtr=(->[Customers_Orders:40]))
		fLoop:=False:C215
		ARRAY TEXT:C222(aBilltos; 0)
		ARRAY TEXT:C222(aShiptos; 0)
		SAVE RECORD:C53([Customers_Order_Lines:41])
		SAVE RECORD:C53([Customers_ReleaseSchedules:46])
		uClearSelection(->[Customers_Order_Lines:41])  //•022597  MLB  chg unloads to clear
		uClearSelection(->[Customers_ReleaseSchedules:46])
		uClearSelection(->[Estimates:17])
		
	: (filePtr=(->[Purchase_Orders:11]))
		<>fButtonOn:=False:C215
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
		REDUCE SELECTION:C351([Purchase_Orders_Chg_Orders:13]; 0)
		
	: (filePtr=(->[Job_Forms:42]))
		<>JFActivity:=0
		REDUCE SELECTION:C351([Jobs:15]; 0)  //•031397  mBohince  and the lines below as well
		REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
		REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
		REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		REDUCE SELECTION:C351([Job_DieBoards:152]; 0)
		REDUCE SELECTION:C351([Job_Forms_CloseoutSummaries:87]; 0)
		REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
		REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
		ARRAY TEXT:C222(aCompany; 0)  //clear arrays
		ARRAY TEXT:C222(aCommCode; 0)
		ARRAY TEXT:C222(aDeptCode; 0)
		//CostCtrCurrent ("kill")
		
	: (filePtr=(->[Customers_Order_Change_Orders:34]))
		fChg:=False:C215
		fLoop:=False:C215
		
	: (filePtr=(->[y_accounting_departments:4]))  //• 10/28/97 cs need to update department lists
		UpdateDeptList  //recreate the department lists 
		
	: (filePtr=(->[Cost_Centers:27]))
		uSetupCCDivisio  //update interprocess sets
		
	: (filePtr=(->[Finished_Goods_Specifications:98]))
		CLEAR SET:C117("anyPressDate")
		
	: (filePtr=(->[QA_Corrective_ActionsLocations:107]))
		$i:=CAR_Locations("init")
		
	Else 
		uClearSelection(filePtr)
End case 