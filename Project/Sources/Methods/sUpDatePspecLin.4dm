//%attributes = {"publishedWeb":true}
//sUpDatePspecLin
//mod 2.22.94
//12/21/94
//• 10/9/97 cs tag PSpec with use date
C_LONGINT:C283($TT; $zz)

MESSAGES OFF:C175

UNLOAD RECORD:C212([Process_Specs:18])  //• 10/9/97 cs unload and make table read./write
READ ONLY:C145([Process_Specs:18])
LOAD RECORD:C52([Process_Specs:18])

If ([Estimates:17]EstimateNo:1#(Substring:C12([Estimates_DifferentialsForms:47]DiffFormId:3; 1; 9)))
	READ ONLY:C145([Estimates:17])
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=(Substring:C12([Estimates_DifferentialsForms:47]DiffFormId:3; 1; 9)))
End if 

If ([Process_Specs:18]PSpecKey:106#([Estimates:17]Cust_ID:2+":"+[Estimates_DifferentialsForms:47]ProcessSpec:23))
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]PSpecKey:106=([Estimates:17]Cust_ID:2+":"+[Estimates_DifferentialsForms:47]ProcessSpec:23))
End if 

//SEARCH([PROCESS_SPEC]; & [PROCESS_SPEC]Cust_ID=[ESTIMATE]Cust_ID)
If ([Process_Specs:18]ID:1=[Estimates_DifferentialsForms:47]ProcessSpec:23)
	[Process_Specs:18]LastUsed:5:=4D_Current_date  //• 10/9/97 cs set last used date
	SAVE RECORD:C53([Process_Specs:18])
	UNLOAD RECORD:C212([Process_Specs:18])  //• 10/9/97 cs unload and make table read./write
	READ ONLY:C145([Process_Specs:18])
	LOAD RECORD:C52([Process_Specs:18])
	RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)
	APPLY TO SELECTION:C70([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemCost_Per_M:6:=0)
	APPLY TO SELECTION:C70([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemCost_Per_M_Yld:8:=0)
	DELETE SELECTION:C66([Estimates_Materials:29])
	DELETE SELECTION:C66([Estimates_Machines:20])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		PSpecEstimateLd("Machines")
		FIRST RECORD:C50([Process_Specs_Machines:28])
		
	Else 
		
		PSpecEstimateLd("Machines")
		//See PSpecEstimateLd
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	$TT:=Records in selection:C76([Process_Specs_Machines:28])
	For ($zz; 1; $TT)
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Process_Specs_Machines:28]CostCenterID:4)
		CREATE RECORD:C68([Estimates_Machines:20])
		[Estimates_Machines:20]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
		[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13
		[Estimates_Machines:20]LaborStd:7:=[Cost_Centers:27]MHRlaborSales:4
		[Estimates_Machines:20]OverheadStd:8:=[Cost_Centers:27]MHRburdenSales:5
		[Estimates_Machines:20]OOPStd:17:=[Cost_Centers:27]MHRoopSales:7
		[Estimates_Machines:20]CostCtrName:2:=[Process_Specs_Machines:28]CostCtrName:5
		[Estimates_Machines:20]CostCtrID:4:=[Process_Specs_Machines:28]CostCenterID:4
		[Estimates_Machines:20]Sequence:5:=[Process_Specs_Machines:28]Seq_Num:3
		[Estimates_Machines:20]CalcScrapFlg:11:=[Process_Specs_Machines:28]CalcScrapFlag:11
		[Estimates_Machines:20]EstimateType:16:="PROD"
		[Estimates_Machines:20]FormChangeHere:9:=[Process_Specs_Machines:28]formChangeHere:9
		[Estimates_Machines:20]EstimateNo:14:=Substring:C12([Estimates_DifferentialsForms:47]DiffFormId:3; 1; 9)  //12/21/94
		[Estimates_Machines:20]Flex_field1:18:=[Process_Specs_Machines:28]Flex_Field1:12
		[Estimates_Machines:20]Flex_Field2:19:=[Process_Specs_Machines:28]Flex_Field2:13
		[Estimates_Machines:20]Flex_Field3:20:=[Process_Specs_Machines:28]Flex_Field3:14
		[Estimates_Machines:20]Flex_Field4:21:=[Process_Specs_Machines:28]Flex_Field4:15
		[Estimates_Machines:20]Flex_Field5:25:=[Process_Specs_Machines:28]Flex_Field5:16
		[Estimates_Machines:20]Flex_field6:37:=[Process_Specs_Machines:28]Flex_Field6:17
		[Estimates_Machines:20]Flex_Field7:38:=[Process_Specs_Machines:28]Flex_Field7:18
		[Estimates_Machines:20]MR_Override:26:=[Process_Specs_Machines:28]MR_Override:19
		[Estimates_Machines:20]Run_Override:27:=[Process_Specs_Machines:28]Run_Override:20
		[Estimates_Machines:20]WasteAdj_Percen:40:=[Process_Specs_Machines:28]WasteAdj_Percen:22
		[Estimates_Machines:20]Comment:29:=[Process_Specs_Machines:28]Comment:21
		[Estimates_Machines:20]OutSideService:33:=[Process_Specs_Machines:28]OutsideService:23
		SAVE RECORD:C53([Estimates_Machines:20])
		NEXT RECORD:C51([Process_Specs_Machines:28])
	End for 
	UNLOAD RECORD:C212([Process_Specs_Machines:28])
	UNLOAD RECORD:C212([Cost_Centers:27])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		PSpecEstimateLd(""; "Materials")
		FIRST RECORD:C50([Process_Specs_Materials:56])
		
	Else 
		
		PSpecEstimateLd(""; "Materials")
		// see PSpecEstimateLd
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	$TT:=Records in selection:C76([Process_Specs_Materials:56])
	For ($zz; 1; $TT)
		CREATE RECORD:C68([Estimates_Materials:29])
		[Estimates_Materials:29]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
		[Estimates_Materials:29]CostCtrID:2:=[Process_Specs_Materials:56]CostCtrID:3
		// [Material_Est]OverRidesUsed:=[Material_PSpec]CoveragePercent
		[Estimates_Materials:29]Raw_Matl_Code:4:=[Process_Specs_Materials:56]Raw_Matl_Code:13
		[Estimates_Materials:29]EstimateNo:5:=Substring:C12([Estimates_DifferentialsForms:47]DiffFormId:3; 1; 9)  //12/21/94
		[Estimates_Materials:29]Commodity_Key:6:=[Process_Specs_Materials:56]Commodity_Key:8
		[Estimates_Materials:29]EstimateType:7:="PROD"
		[Estimates_Materials:29]UOM:8:=[Process_Specs_Materials:56]UOM:9
		//[Material_Est]Qty:=
		[Estimates_Materials:29]RMName:10:=[Process_Specs_Materials:56]RMName:6
		[Estimates_Materials:29]Sequence:12:=[Process_Specs_Materials:56]Sequence:4
		[Estimates_Materials:29]Comments:13:=[Process_Specs_Materials:56]Comments:7
		[Estimates_Materials:29]Real1:14:=[Process_Specs_Materials:56]Real1:14
		[Estimates_Materials:29]Real2:15:=[Process_Specs_Materials:56]Real2:15
		[Estimates_Materials:29]Real3:16:=[Process_Specs_Materials:56]Real3:16
		[Estimates_Materials:29]Real4:17:=[Process_Specs_Materials:56]Real4:17
		[Estimates_Materials:29]alpha20_2:18:=[Process_Specs_Materials:56]alpha20_2:18
		[Estimates_Materials:29]alpha20_3:19:=[Process_Specs_Materials:56]alpha20_3:19
		
		SAVE RECORD:C53([Estimates_Materials:29])
		NEXT RECORD:C51([Process_Specs_Materials:56])
	End for 
	UNLOAD RECORD:C212([Process_Specs_Materials:56])
	
	QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
	ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
	QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
	ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
	
	[Estimates_DifferentialsForms:47]CostTTL:18:=0  //init the calc fields
	[Estimates_DifferentialsForms:47]CostTtlOH:16:=0
	[Estimates_DifferentialsForms:47]CostTtlMatl:17:=0
	[Estimates_DifferentialsForms:47]CostTtlLabor:15:=0
	[Estimates_DifferentialsForms:47]Cost_Overtime:25:=0
	[Estimates_DifferentialsForms:47]SheetsQtyGross:19:=0
	[Estimates_DifferentialsForms:47]Cost_Scrap:24:=0
	[Estimates_DifferentialsForms:47]Cost_Dups:20:=0
	[Estimates_DifferentialsForms:47]Cost_Plates:21:=0
	[Estimates_DifferentialsForms:47]Cost_Dies:22:=0
	[Estimates_DifferentialsForms:47]Cost_Yield_Adds:27:=0
	SAVE RECORD:C53([Estimates_DifferentialsForms:47])
	
	If ([Estimates_DifferentialsForms:47]DiffId:1=[Estimates_Differentials:38]Id:1)
		[Estimates_Differentials:38]CostTtlLabor:11:=0
		[Estimates_Differentials:38]CostTtlOH:12:=0
		[Estimates_Differentials:38]CostTtlMatl:13:=0
		[Estimates_Differentials:38]Cost_Overtime:17:=0
		[Estimates_Differentials:38]Cost_Scrap:15:=0
		[Estimates_Differentials:38]Cost_Dups:19:=0
		[Estimates_Differentials:38]Cost_Plates:20:=0
		[Estimates_Differentials:38]Cost_Dies:21:=0
		[Estimates_Differentials:38]Cost_Yield_Adds:30:=0
		Estimate_ReCalcNeeded
	End if 
Else 
	BEEP:C151
	ALERT:C41("P-Spec: "+[Estimates_DifferentialsForms:47]ProcessSpec:23+" not found.")
End if 
MESSAGES ON:C181
//