//%attributes = {"publishedWeb":true}
//(S)sCreateBudget  
//see also  sCopyEstimate
//created: 5/2/94 upr 1039 based on bSearch button on the copy est layout
//upr 1157 8/10/94 copy error
//upr 107 3/22/94 ratio for qtys
//upr 1359  12/21/94 chip, include/exclude excess
//•053095  MLB  UPR 185 don't modify qty's specified on the Order's estimate.
//•053095  MLB  UPR 185 removed the Not()
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
//• 12/2/97 cs stop creation of Est_Ship_tos

C_LONGINT:C283($rev; $recNo; $i; $numRecs; $numRecs2; $i2)  //  CopyEst.dio layout
C_TEXT:C284($newID)
C_BOOLEAN:C305($IncldExcess)

READ WRITE:C146([Estimates:17])
READ WRITE:C146([Estimates_Carton_Specs:19])

//*Ask to include or exclude Excess and Shortages
//°uConfirm ("Do You Want to Include Excess & Shortages in 'Budget Quantity'
//°« Calculations?";"Include";"Exclude")  `UPR 1359
//°$IncldExcess:=(OK=1)
$IncldExcess:=False:C215  //•053095  MLB  UPR 185
$winRef:=NewWindow(400; 300; 0; 8; "Making Budget")

MESSAGE:C88(Char:C90(13)+"Searching for the base estimate")
sCriterion1:=[Customers_Orders:40]EstimateNo:3
QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=sCriterion1)

If (Records in selection:C76([Estimates:17])=1)
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		SAVE RECORD:C53([Customers_Orders:40])
		COPY NAMED SELECTION:C331([Customers_Orders:40]; "beforeHeaders")
		SAVE RECORD:C53([Customers_Order_Lines:41])
		COPY NAMED SELECTION:C331([Customers_Order_Lines:41]; "beforeDetails")
		
	Else 
		
		ARRAY LONGINT:C221($_beforeHeaders; 0)
		ARRAY LONGINT:C221($_beforeDetails; 0)
		SAVE RECORD:C53([Customers_Orders:40])
		LONGINT ARRAY FROM SELECTION:C647([Customers_Orders:40]; $_beforeHeaders)
		SAVE RECORD:C53([Customers_Order_Lines:41])
		LONGINT ARRAY FROM SELECTION:C647([Customers_Order_Lines:41]; $_beforeDetails)
		
	End if   // END 4D Professional Services : January 2019 
	
	//*.   set recNo cursor  
	$recNo:=Record number:C243([Estimates:17])
	//*.   Get its p-specs
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=sCriterion1)
		CREATE SET:C116([Estimates_PSpecs:57]; "thePspecs")
		
		//*.   Get its worksheet c-specs
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=sCriterion1; *)  //find Estimate Qty worksheet
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		CREATE SET:C116([Estimates_Carton_Specs:19]; "worksheet")
		//*.   Get its order diff c-specs
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=sCriterion1; *)  //find Estimate Qty diff
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=[Customers_Orders:40]CaseScenario:4)
		CREATE SET:C116([Estimates_Carton_Specs:19]; "justsome")
		//*.      Merge the worksheet and diff c-specs into one list
		UNION:C120("worksheet"; "justsome"; "theList")
		CLEAR SET:C117("worksheet")
		CLEAR SET:C117("justsome")
		//*.   Get its case scenario
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=sCriterion1+[Customers_Orders:40]CaseScenario:4)
		CREATE SET:C116([Estimates_Differentials:38]; "diffs")
		//*.   Get its forms
		QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3=sCriterion1+[Customers_Orders:40]CaseScenario:4+"@")
		CREATE SET:C116([Estimates_DifferentialsForms:47]; "forms")
		//*.   Get its machines
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=sCriterion1+[Customers_Orders:40]CaseScenario:4+"@")
		CREATE SET:C116([Estimates_Machines:20]; "mach")
		//*.   Get its materials
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=sCriterion1+[Customers_Orders:40]CaseScenario:4+"@")
		CREATE SET:C116([Estimates_Materials:29]; "matl")
		
		
	Else 
		
		ARRAY LONGINT:C221($_thePspecs; 0)
		QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=sCriterion1)
		LONGINT ARRAY FROM SELECTION:C647([Estimates_PSpecs:57]; $_thePspecs)
		
		//*.   Get its worksheet c-specs
		
		$criteria:=[Customers_Orders:40]CaseScenario:4
		ARRAY LONGINT:C221($_theList; 0)
		
		QUERY BY FORMULA:C48([Estimates_Carton_Specs:19]; (([Estimates_Carton_Specs:19]Estimate_No:2=sCriterion1) & ([Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)) | (([Estimates_Carton_Specs:19]Estimate_No:2=sCriterion1) & ([Estimates_Carton_Specs:19]diffNum:11=$criteria)))
		
		LONGINT ARRAY FROM SELECTION:C647([Estimates_Carton_Specs:19]; $_theList)
		
		
		
		ARRAY LONGINT:C221($_diffs; 0)
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=sCriterion1+[Customers_Orders:40]CaseScenario:4)
		LONGINT ARRAY FROM SELECTION:C647([Estimates_Differentials:38]; $_diffs)
		//*.   Get its forms
		ARRAY LONGINT:C221($_forms; 0)
		QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3=sCriterion1+[Customers_Orders:40]CaseScenario:4+"@")
		LONGINT ARRAY FROM SELECTION:C647([Estimates_DifferentialsForms:47]; $_forms)
		
		//*.   Get its machines
		ARRAY LONGINT:C221($_mach; 0)
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=sCriterion1+[Customers_Orders:40]CaseScenario:4+"@")
		LONGINT ARRAY FROM SELECTION:C647([Estimates_Machines:20]; $_mach)
		
		ARRAY LONGINT:C221($_matl; 0)
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=sCriterion1+[Customers_Orders:40]CaseScenario:4+"@")
		LONGINT ARRAY FROM SELECTION:C647([Estimates_Materials:29]; $_matl)
		
	End if   // END 4D Professional Services : January 2019
	
	//*Determine the budget estimate's number
	$newID:=Substring:C12(sCriterion1; 1; 7)
	//GOTO XY(10;22)
	MESSAGE:C88(Char:C90(13)+"Determining next revision number")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$newID+"@")
		ORDER BY:C49([Estimates:17]; [Estimates:17]EstimateNo:1; <)
		FIRST RECORD:C50([Estimates:17])
		
	Else 
		
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$newID+"@")
		ORDER BY:C49([Estimates:17]; [Estimates:17]EstimateNo:1; <)
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	$rev:=Num:C11(Substring:C12([Estimates:17]EstimateNo:1; 8; 2))
	If ($rev=99)
		BEEP:C151
		ALERT:C41("Sorry, only 99 revisions allowed.")
		REJECT:C38
	End if 
	$newID:=$newID+String:C10($rev+1; "00")
	MESSAGE:C88(Char:C90(13)+"Preparing budget number "+$newID)
	//GOTO XY(1;22)
	//MESSAGE((" "*90))
	//*Duplicate & update the base estimate
	GOTO RECORD:C242([Estimates:17]; $recNo)
	DUPLICATE RECORD:C225([Estimates:17])
	[Estimates:17]pk_id:68:=Generate UUID:C1066
	[Estimates:17]EstimateNo:1:=$newID
	[Estimates:17]Comments:34:="This Budget is Based on Estimate Number "+sCriterion1+". "+[Estimates:17]Comments:34+Char:C90(13)+[Customers_Orders:40]Comments:15
	[Estimates:17]Status:30:="Budgeting"
	//[ESTIMATE]Last_Scenario:=0
	[Estimates:17]DateOriginated:19:=4D_Current_date  //refresh some things
	[Estimates:17]z_Bill_To_ID:5:=[Customers_Orders:40]defaultBillTo:5
	[Estimates:17]POnumber:18:=[Customers_Orders:40]PONumber:11
	[Estimates:17]z_LastRelease:28:=[Customers_Orders:40]ContractExpires:12
	[Estimates:17]Terms:7:=[Customers_Orders:40]Terms:23
	[Estimates:17]ShippingVia:6:=[Customers_Orders:40]ShipVia:24
	[Estimates:17]FOB:8:=[Customers_Orders:40]FOB:25
	[Estimates:17]z_Contact_Agent:43:=[Customers_Orders:40]Contact_Agent:36
	[Estimates:17]z_Contact_Enginee:44:=[Customers_Orders:40]z_Contact_Enginee:37
	[Estimates:17]z_Contact_Analyst:45:=[Customers_Orders:40]EmailTo:38
	
	[Estimates:17]EstimatedBy:14:=""  //upr 1154
	[Estimates:17]DateEstimated:64:=!00-00-00!
	[Estimates:17]DateEstimatedTime:65:=?00:00:00?
	[Estimates:17]DatePrice:60:=!00-00-00!
	[Estimates:17]DateQuoted:61:=!00-00-00!
	[Estimates:17]DateRFQ:52:=!00-00-00!
	[Estimates:17]DateRFQTime:53:=?00:00:00?
	
	[Estimates:17]ModWho:38:=<>zResp
	[Estimates:17]CreatedBy:59:=<>zResp
	// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates]z_SYNC_ID;->[Estimates]z_SYNC_DATA)
	SAVE RECORD:C53([Estimates:17])
	//*.   Update recNo cursor
	$recNo:=Record number:C243([Estimates:17])
	//*Duplicate each c-spec in the merged list
	//GOTO XY(10;22)
	MESSAGE:C88(Char:C90(13)+"Copying Carton Specs.")
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		USE SET:C118("theList")
		
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Estimates_Carton_Specs:19]; $_theList)
		
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	$numRecs:=Records in selection:C76([Estimates_Carton_Specs:19])
	For ($i; 1; $numRecs)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("theList")
			GOTO SELECTED RECORD:C245([Estimates_Carton_Specs:19]; $i)
			
			
		Else 
			
			GOTO RECORD:C242([Estimates_Carton_Specs:19]; $_theList{$i})
			
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		//*.   Do a supply\demand analysis if not a worksheet c-spec & want to include inv
		If ([Estimates_Carton_Specs:19]diffNum:11#<>sQtyWorksht)
			
			If ($IncldExcess)  //•053095  MLB  UPR 185 removed the Not()
				sCPN:=[Estimates_Carton_Specs:19]ProductCode:5  //Note: this logic is also used in FGvaluation reports
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=sCPN; *)  //switch to fg_key
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Estimates_Carton_Specs:19]CustID:6)
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=sCPN; *)  //switch to fg_key
				QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]CustId:15=[Estimates_Carton_Specs:19]CustID:6)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=sCPN; *)  //switch to fg_key
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Estimates_Carton_Specs:19]CustID:6)
				sAskMeTotals  //totalStatOR used below
				If (totalStatOR<0)  //shortage calculated
					totalStatOR:=totalStatOR*(-1)
				Else 
					totalStatOR:=0  //excess available
				End if 
				
			Else   //excess Excluded UPR 1359, just add overrun
				//°TotalStatOR:=[CARTON_SPEC]Quantity_Want+([CARTON_SPEC]Quantity
				//°«_Want*([CARTON_SPEC]OverRun/100))  `total to create is wanted qty + overunr
				//°« %
				TotalStatOR:=[Estimates_Carton_Specs:19]Quantity_Want:27  //•053095  MLB  UPR 185 don't adjust the qty
			End if 
			
		Else   //don't adj worksheet
			totalStatOR:=0
		End if   //worksheet
		
		$pctchg:=0
		//*.   Get the form cartons
		RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)
		CREATE SET:C116([Estimates_FormCartons:48]; "cartons")
		//*.   Dup and re-key the c-spec
		DUPLICATE RECORD:C225([Estimates_Carton_Specs:19])
		[Estimates_Carton_Specs:19]pk_id:78:=Generate UUID:C1066
		[Estimates_Carton_Specs:19]Estimate_No:2:=$newID
		//°[CARTON_SPEC]CartonSpecKey:=Sequ444ence number([CARTON_SPEC])+◊aOffSet{19}
		[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
		If (Not:C34($IncldExcess))
			[Estimates_Carton_Specs:19]CartonComment:12:=[Estimates_Carton_Specs:19]CartonComment:12+<>sCr+"Excess/Shoratge Excluded from Calculation."+"  Original Quantity = "+String:C10([Estimates_Carton_Specs:19]Quantity_Want:27)
		End if 
		If ([Estimates_Carton_Specs:19]diffNum:11#<>sQtyWorksht)
			$pctchg:=totalStatOR/[Estimates_Carton_Specs:19]Quantity_Want:27
			[Estimates_Carton_Specs:19]Quantity_Want:27:=totalStatOR  //adjust to meet demand+overun
			[Estimates_Carton_Specs:19]Qty1Temp:52:=totalStatOR  //for display on the estimate
		End if 
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Carton_Specs]z_SYNC_ID;->[Estimates_Carton_Specs]z_SYNC_DATA)
		SAVE RECORD:C53([Estimates_Carton_Specs:19])
		//*.   Dup and re-key the form cartons
		USE SET:C118("cartons")
		$numRecs2:=Records in selection:C76([Estimates_FormCartons:48])
		For ($i2; 1; $numRecs2)
			USE SET:C118("cartons")
			GOTO SELECTED RECORD:C245([Estimates_FormCartons:48]; $i2)
			DUPLICATE RECORD:C225([Estimates_FormCartons:48])
			[Estimates_FormCartons:48]pk_id:18:=Generate UUID:C1066
			[Estimates_FormCartons:48]Carton:1:=[Estimates_Carton_Specs:19]CartonSpecKey:7
			[Estimates_FormCartons:48]DiffFormID:2:=$newID+Substring:C12([Estimates_FormCartons:48]DiffFormID:2; 10; 4)
			If (False:C215)  //•053095  MLB  UPR 185
				If ($numRecs2=1)  //carton is only on one form
					[Estimates_FormCartons:48]FormWantQty:9:=totalStatOR
					[Estimates_FormCartons:48]NetSheets:7:=Round:C94((totalStatOR/[Estimates_FormCartons:48]NumberUp:4); 0)
					[Estimates_FormCartons:48]MakesQty:5:=[Estimates_FormCartons:48]NumberUp:4*[Estimates_FormCartons:48]NetSheets:7
				Else 
					
					[Estimates_FormCartons:48]FormWantQty:9:=[Estimates_FormCartons:48]FormWantQty:9*$pctchg  //default to customer want at Cartonspec, planner to modify
					[Estimates_FormCartons:48]NetSheets:7:=Round:C94(([Estimates_FormCartons:48]FormWantQty:9/[Estimates_FormCartons:48]NumberUp:4); 0)
					[Estimates_FormCartons:48]MakesQty:5:=[Estimates_FormCartons:48]NumberUp:4*[Estimates_FormCartons:48]NetSheets:7
				End if 
			End if   //false      
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_FormCartons]_SYNC_ID;->[Estimates_FormCartons]_SYNC_DATA)
			SAVE RECORD:C53([Estimates_FormCartons:48])
		End for 
		CLEAR SET:C117("cartons")
		
	End for 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CLEAR SET:C117("theList")
		
		
	Else 
		
	End if   // END 4D Professional Services : January 2019 query selection
	//*Duplicate and re-key link to p-specs
	//GOTO XY(10;22)
	MESSAGE:C88(Char:C90(13)+"Copying Process Specs.")
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		USE SET:C118("thePspecs")
		$numRecs:=Records in selection:C76([Estimates_PSpecs:57])
		For ($i; 1; $numRecs)
			USE SET:C118("thePspecs")
			GOTO SELECTED RECORD:C245([Estimates_PSpecs:57]; $i)
			DUPLICATE RECORD:C225([Estimates_PSpecs:57])
			[Estimates_PSpecs:57]pk_id:6:=Generate UUID:C1066
			[Estimates_PSpecs:57]EstimateNo:1:=$newID
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_PSpecs]z_SYNC_ID;->[Estimates_PSpecs]z_SYNC_DATA)
			SAVE RECORD:C53([Estimates_PSpecs:57])
		End for 
		CLEAR SET:C117("thePspecs")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Estimates_PSpecs:57]; $_thePspecs)
		
		$numRecs:=Records in selection:C76([Estimates_PSpecs:57])
		For ($i; 1; $numRecs)
			GOTO RECORD:C242([Estimates_PSpecs:57]; $_thePspecs{$i})
			DUPLICATE RECORD:C225([Estimates_PSpecs:57])
			[Estimates_PSpecs:57]pk_id:6:=Generate UUID:C1066
			[Estimates_PSpecs:57]EstimateNo:1:=$newID
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_PSpecs]z_SYNC_ID;->[Estimates_PSpecs]z_SYNC_DATA)
			SAVE RECORD:C53([Estimates_PSpecs:57])
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	sb2:=1
	If (sb2=1)  //copy all
		//*Duplicate and re-key the caseScenario
		//GOTO XY(10;22)
		MESSAGE:C88(Char:C90(13)+"Copying the Differentials.")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("diffs")
			$numRecs:=Records in selection:C76([Estimates_Differentials:38])
			For ($i; 1; $numRecs)
				USE SET:C118("diffs")
				GOTO SELECTED RECORD:C245([Estimates_Differentials:38]; $i)
				DUPLICATE RECORD:C225([Estimates_Differentials:38])
				[Estimates_Differentials:38]pk_id:46:=Generate UUID:C1066
				[Estimates_Differentials:38]estimateNum:2:=$newID
				[Estimates_Differentials:38]Id:1:=$newID+[Estimates_Differentials:38]diffNum:3
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Differentials]z_SYNC_ID;->[Estimates_Differentials]z_SYNC_DATA)
				SAVE RECORD:C53([Estimates_Differentials:38])
			End for 
			CLEAR SET:C117("diffs")
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Estimates_Differentials:38]; $_diffs)
			
			$numRecs:=Records in selection:C76([Estimates_Differentials:38])
			For ($i; 1; $numRecs)
				GOTO RECORD:C242([Estimates_Differentials:38]; $_diffs{$i})
				DUPLICATE RECORD:C225([Estimates_Differentials:38])
				[Estimates_Differentials:38]pk_id:46:=Generate UUID:C1066
				[Estimates_Differentials:38]estimateNum:2:=$newID
				[Estimates_Differentials:38]Id:1:=$newID+[Estimates_Differentials:38]diffNum:3
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Differentials]z_SYNC_ID;->[Estimates_Differentials]z_SYNC_DATA)
				SAVE RECORD:C53([Estimates_Differentials:38])
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		//*Duplicate and re-key the forms
		//GOTO XY(10;22)
		MESSAGE:C88(Char:C90(13)+"Copying the Forms.                 ")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("forms")
			$numRecs:=Records in selection:C76([Estimates_DifferentialsForms:47])
			For ($i; 1; $numRecs)
				USE SET:C118("forms")
				GOTO SELECTED RECORD:C245([Estimates_DifferentialsForms:47]; $i)
				DUPLICATE RECORD:C225([Estimates_DifferentialsForms:47])
				[Estimates_DifferentialsForms:47]pk_id:37:=Generate UUID:C1066
				[Estimates_DifferentialsForms:47]DiffFormId:3:=$newID+Substring:C12([Estimates_DifferentialsForms:47]DiffId:1; 10; 2)+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")
				[Estimates_DifferentialsForms:47]DiffId:1:=$newID+Substring:C12([Estimates_DifferentialsForms:47]DiffId:1; 10; 2)
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_DifferentialsForms]z_SYNC_ID;->[Estimates_DifferentialsForms]z_SYNC_DATA)
				SAVE RECORD:C53([Estimates_DifferentialsForms:47])
			End for 
			CLEAR SET:C117("forms")
			
		Else 
			CREATE SELECTION FROM ARRAY:C640([Estimates_DifferentialsForms:47]; $_forms)
			
			$numRecs:=Records in selection:C76([Estimates_DifferentialsForms:47])
			For ($i; 1; $numRecs)
				GOTO RECORD:C242([Estimates_DifferentialsForms:47]; $_forms{$i})
				DUPLICATE RECORD:C225([Estimates_DifferentialsForms:47])
				[Estimates_DifferentialsForms:47]pk_id:37:=Generate UUID:C1066
				[Estimates_DifferentialsForms:47]DiffFormId:3:=$newID+Substring:C12([Estimates_DifferentialsForms:47]DiffId:1; 10; 2)+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")
				[Estimates_DifferentialsForms:47]DiffId:1:=$newID+Substring:C12([Estimates_DifferentialsForms:47]DiffId:1; 10; 2)
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_DifferentialsForms]z_SYNC_ID;->[Estimates_DifferentialsForms]z_SYNC_DATA)
				SAVE RECORD:C53([Estimates_DifferentialsForms:47])
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		//*Duplicate and re-key the machines
		//GOTO XY(10;22)
		MESSAGE:C88(Char:C90(13)+"Copying the Machines.")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("mach")
			$numRecs:=Records in selection:C76([Estimates_Machines:20])
			For ($i; 1; $numRecs)
				USE SET:C118("mach")
				GOTO SELECTED RECORD:C245([Estimates_Machines:20]; $i)
				DUPLICATE RECORD:C225([Estimates_Machines:20])
				[Estimates_Machines:20]pk_id:48:=Generate UUID:C1066
				[Estimates_Machines:20]DiffFormID:1:=$newID+Substring:C12([Estimates_Machines:20]DiffFormID:1; 10; 4)
				[Estimates_Machines:20]EstimateNo:14:=$newID
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Machines]_SYNC_ID;->[Estimates_Machines]_SYNC_DATA)
				SAVE RECORD:C53([Estimates_Machines:20])
			End for 
			CLEAR SET:C117("mach")
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Estimates_Machines:20]; $_mach)
			
			$numRecs:=Records in selection:C76([Estimates_Machines:20])
			For ($i; 1; $numRecs)
				GOTO RECORD:C242([Estimates_Machines:20]; $_mach{$i})
				DUPLICATE RECORD:C225([Estimates_Machines:20])
				[Estimates_Machines:20]pk_id:48:=Generate UUID:C1066
				[Estimates_Machines:20]DiffFormID:1:=$newID+Substring:C12([Estimates_Machines:20]DiffFormID:1; 10; 4)
				[Estimates_Machines:20]EstimateNo:14:=$newID
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Machines]_SYNC_ID;->[Estimates_Machines]_SYNC_DATA)
				SAVE RECORD:C53([Estimates_Machines:20])
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		//*Duplicate and re-key the materials
		//GOTO XY(10;22)
		MESSAGE:C88(Char:C90(13)+"Copying the Materials.")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			USE SET:C118("matl")
			$numRecs:=Records in selection:C76([Estimates_Materials:29])
			For ($i; 1; $numRecs)
				USE SET:C118("matl")
				GOTO SELECTED RECORD:C245([Estimates_Materials:29]; $i)
				DUPLICATE RECORD:C225([Estimates_Materials:29])
				[Estimates_Materials:29]pk_id:33:=Generate UUID:C1066
				[Estimates_Materials:29]DiffFormID:1:=$newID+Substring:C12([Estimates_Materials:29]DiffFormID:1; 10; 4)
				[Estimates_Materials:29]EstimateNo:5:=$newID
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Materials]z_SYNC_ID;->[Estimates_Materials]z_SYNC_DATA)
				SAVE RECORD:C53([Estimates_Materials:29])
			End for 
			CLEAR SET:C117("matl")
		Else 
			CREATE SELECTION FROM ARRAY:C640([Estimates_Materials:29]; $_matl)
			
			$numRecs:=Records in selection:C76([Estimates_Materials:29])
			For ($i; 1; $numRecs)
				GOTO RECORD:C242([Estimates_Materials:29]; $_matl{$i})
				DUPLICATE RECORD:C225([Estimates_Materials:29])
				[Estimates_Materials:29]pk_id:33:=Generate UUID:C1066
				[Estimates_Materials:29]DiffFormID:1:=$newID+Substring:C12([Estimates_Materials:29]DiffFormID:1; 10; 4)
				[Estimates_Materials:29]EstimateNo:5:=$newID
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Materials]z_SYNC_ID;->[Estimates_Materials]z_SYNC_DATA)
				SAVE RECORD:C53([Estimates_Materials:29])
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		
	End if   //copy all    
	
	//GOTO XY(1;22)
	MESSAGE:C88(Char:C90(13)+" Opening Budget Estimate")
	GOTO RECORD:C242([Estimates:17]; $recNo)
	CREATE SET:C116([Estimates:17]; "◊LastSelection17")
	<>PassThrough:=True:C214
	COPY SET:C600("◊LastSelection17"; "◊PassThroughSet")
	REDUCE SELECTION:C351([Estimates:17]; 0)
	REDUCE SELECTION:C351([Estimates_Materials:29]; 0)
	REDUCE SELECTION:C351([Estimates_Machines:20]; 0)
	REDUCE SELECTION:C351([Estimates_DifferentialsForms:47]; 0)
	REDUCE SELECTION:C351([Estimates_Differentials:38]; 0)
	REDUCE SELECTION:C351([Estimates_PSpecs:57]; 0)
	REDUCE SELECTION:C351([Estimates_FormCartons:48]; 0)
	REDUCE SELECTION:C351([Estimates_Differentials:38]; 0)
	REDUCE SELECTION:C351([Estimates_Carton_Specs:19]; 0)
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("beforeHeaders")
		USE NAMED SELECTION:C332("beforeDetails")
		CLEAR NAMED SELECTION:C333("beforeHeaders")
		CLEAR NAMED SELECTION:C333("beforeDetails")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Customers_Orders:40]; $_beforeHeaders)
		CREATE SELECTION FROM ARRAY:C640([Customers_Order_Lines:41]; $_beforeDetails)
		
	End if   // END 4D Professional Services : January 2019 
	
	
	ViewSetter(2; ->[Estimates:17])
	
Else 
	BEEP:C151
	ALERT:C41(sCriterion1+" could not be found.")
	REJECT:C38
End if 
CLOSE WINDOW:C154($winRef)