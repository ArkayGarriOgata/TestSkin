//%attributes = {"publishedWeb":true}
//gEstDiff_NewOne().     -JML   9/29/93,
// mod mlb 1/25/94 debug and optimized
// upr 1365 12/21/94
//•081595  MLB  
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
//New Differential Record.
//allows user to pick desired pspecxQty combination when creating one or
//more differentials.
//Note this is usually used just once by user-for 1st differential of an Estimate.
//For additional Differentials, it is usually more efficient to use the Duplicate 
//or Diff_Group functions.
// • mel (5/3/05, 16:12:24) add default commsion, and markups
// • mel (5/11/05, 11:57:37) use normal commission rates
// Modified by: Mel Bohince (4/8/19) change array name from cost ctr name to cost ctr id on line 304
C_TEXT:C284($EstimateDifferenctialForm)
C_TEXT:C284($estimateNumber; $processSpec)
C_TEXT:C284($differentialDesignation; $formNumber)
C_LONGINT:C283($processSpecList; $numberInCollection; $countOfItemsOnWorksheet; $pSpec; $item; $countOfItems; $totalNumberOfCartons)
C_LONGINT:C283($cartonSpecTableNumber; $cartonSpecQty1Field; $cartonSpecQtyTargetFieldNumber; $scale)
C_POINTER:C301($ptrTargetQuantityField)
C_REAL:C285($targetPV)

MESSAGES OFF:C175
$winRef:=OpenSheetWindow(->[zz_control:1]; "SelectNewDiff")  //•081595  MLB  
DIALOG:C40([zz_control:1]; "SelectNewDiff")
CLOSE WINDOW:C154
If (OK=1)
	//uConfirm ("Put all worksheet cartons on the default form?";"Yes";"Multiform")
	If (cb1=1)
		$countOfItemsOnWorksheet:=Records in selection:C76([Estimates_Carton_Specs:19])
	Else 
		$countOfItemsOnWorksheet:=0
	End if 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		COPY NAMED SELECTION:C331([Estimates_Carton_Specs:19]; "CSpecSelect")
		
	Else 
		
		ARRAY LONGINT:C221($_CSpecSelect; 0)
		LONGINT ARRAY FROM SELECTION:C647([Estimates_Carton_Specs:19]; $_CSpecSelect)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	zwStatusMsg("Adding Diff"; "Creating Differentials...")
	
	//gEstimateLDWkSh ("Wksht") already done in the before phase of above layout
	
	$estimateNumber:=[Estimates:17]EstimateNo:1
	$cartonSpecTableNumber:=Table:C252(->[Estimates_Carton_Specs:19])
	$cartonSpecQty1Field:=Field:C253(->[Estimates_Carton_Specs:19]Qty1Temp:52)
	
	$processSpecList:=Size of array:C274(asDiff)
	uThermoInit($processSpecList; "Creating Differentials")
	For ($pSpec; 1; $processSpecList)
		If (aSelected{$pSpec}="X")
			$differentialDesignation:=gEstMakeDiffID  //make a name like AA, AB,...ZA
			$processSpec:=Substring:C12(asDiff{$pSpec}; 6)  //asDiff{} = QTY#-PspecID...
			QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=$processSpec)
			$QtyNum:=Num:C11(Substring:C12(asDiff{$pSpec}; 4; 1))
			$cartonSpecQtyTargetFieldNumber:=$cartonSpecQty1Field+$QtyNum-1  //the target qty field
			$ptrTargetQuantityField:=Field:C253($cartonSpecTableNumber; $cartonSpecQtyTargetFieldNumber)
			
			CREATE RECORD:C68([Estimates_Differentials:38])  //creates diff record
			[Estimates_Differentials:38]Id:1:=$estimateNumber+$differentialDesignation
			[Estimates_Differentials:38]estimateNum:2:=$estimateNumber
			[Estimates_Differentials:38]diffNum:3:=$differentialDesignation
			[Estimates_Differentials:38]NumForms:4:=1
			[Estimates_Differentials:38]LastFormID:27:=1
			$formNumber:=String:C10([Estimates_Differentials:38]LastFormID:27; "00")
			[Estimates_Differentials:38]ProcessSpec:5:=$processSpec
			[Estimates_Differentials:38]PSpec_Qty_TAG:25:=asDiff{$pSpec}
			[Estimates_Differentials:38]BreakOutSpls:18:=[Estimates:17]BreakOutSpls:10
			
			// • mel (5/11/05, 11:57:37) use normal commission rates
			[Estimates_Differentials:38]CommissionRate:42:=0
			[Estimates_Differentials:38]MarkupConversion:40:=1.49071
			[Estimates_Differentials:38]MarkupMaterial:41:=0.1
			$scale:=INV_getCommissionScale([Estimates:17]Cust_ID:2; [Estimates:17]ProjectNumber:63; [Estimates:17]Brand:3)
			$markup:=[Estimates_Differentials:38]MarkupConversion:40+[Estimates_Differentials:38]MarkupMaterial:41
			If ($markup>0)
				$targetPV:=($markup-1)/$markup
				[Estimates_Differentials:38]CommissionRate:42:=INV_useScale($scale; $targetPV)
			Else 
				[Estimates_Differentials:38]CommissionRate:42:=0
			End if 
			
			$EstimateDifferenctialForm:=$estimateNumber+$differentialDesignation+$formNumber  //
			CREATE RECORD:C68([Estimates_DifferentialsForms:47])  //creates 1 form
			[Estimates_DifferentialsForms:47]DiffId:1:=$estimateNumber+$differentialDesignation
			[Estimates_DifferentialsForms:47]FormNumber:2:=Num:C11($formNumber)
			[Estimates_DifferentialsForms:47]DiffFormId:3:=$EstimateDifferenctialForm
			[Estimates_DifferentialsForms:47]DateCustomerWant:7:=[Estimates:17]DateCustomerWant:23
			[Estimates_DifferentialsForms:47]JobType:9:=[Estimates:17]JobType:29
			[Estimates_DifferentialsForms:47]ProcessSpec:23:=$processSpec
			[Estimates_DifferentialsForms:47]Width:5:=[Process_Specs:18]formWidth:96
			[Estimates_DifferentialsForms:47]Lenth:6:=[Process_Specs:18]formLength:97
			$countOfItems:=0
			$totalNumberOfCartons:=0
			For ($item; 1; $countOfItemsOnWorksheet)  //create a cspec for each carton with a qty in the target qty field
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
					
					USE NAMED SELECTION:C332("CSpecSelect")
					GOTO SELECTED RECORD:C245([Estimates_Carton_Specs:19]; $item)
					
					
				Else 
					
					GOTO RECORD:C242([Estimates_Carton_Specs:19]; $_CSpecSelect{$item})
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				If ($ptrTargetQuantityField->#0)  //only create carton if a Qty exists for it.
					If (Round:C94([Estimates_Carton_Specs:19]SquareInches:16; 4)=Round:C94(0; 4))
						uConfirm("WARNING: "+[Estimates_Carton_Specs:19]ProductCode:5+" does not have square inches specified."; "OK"; "Help")
					End if 
					
					$wantQty:=$ptrTargetQuantityField->
					DUPLICATE RECORD:C225([Estimates_Carton_Specs:19])
					[Estimates_Carton_Specs:19]pk_id:78:=Generate UUID:C1066
					[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
					[Estimates_Carton_Specs:19]Quantity_Want:27:=$wantQty
					[Estimates_Carton_Specs:19]Qty1Temp:52:=$wantQty
					[Estimates_Carton_Specs:19]Qty2Temp:53:=0
					[Estimates_Carton_Specs:19]Qty3Temp:54:=0
					[Estimates_Carton_Specs:19]Qty4Temp:55:=0
					[Estimates_Carton_Specs:19]Qty5Temp:56:=0
					[Estimates_Carton_Specs:19]Qty6Temp:57:=0
					[Estimates_Carton_Specs:19]diffNum:11:=$differentialDesignation
					[Estimates_Carton_Specs:19]ProcessSpec:3:=$processSpec
					// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Carton_Specs]z_SYNC_ID;->[Estimates_Carton_Specs]z_SYNC_DATA)
					SAVE RECORD:C53([Estimates_Carton_Specs:19])
					
					CREATE RECORD:C68([Estimates_FormCartons:48])
					[Estimates_FormCartons:48]Carton:1:=[Estimates_Carton_Specs:19]CartonSpecKey:7
					[Estimates_FormCartons:48]DiffFormID:2:=$EstimateDifferenctialForm
					[Estimates_FormCartons:48]ItemNumber:3:=Num:C11([Estimates_Carton_Specs:19]Item:1)
					[Estimates_FormCartons:48]NumberUp:4:=1
					[Estimates_FormCartons:48]MakesQty:5:=$wantQty
					[Estimates_FormCartons:48]FormWantQty:9:=$wantQty
					SAVE RECORD:C53([Estimates_FormCartons:48])
					
					$countOfItems:=$countOfItems+1
					$totalNumberOfCartons:=$totalNumberOfCartons+$wantQty
				End if 
			End for 
			Estimate_ReCalcNeeded  // so it says to calculate $totalNumberOfCartons
			SAVE RECORD:C53([Estimates_Differentials:38])
			
			[Estimates_DifferentialsForms:47]NumItems:8:=$countOfItems
			SAVE RECORD:C53([Estimates_DifferentialsForms:47])
			
			//zwStatusMsg ("Adding Diff";"    Form:"+[Estimates_DifferentialsForms]DiffFormId)
			//creates materials & machines
			
			//zwStatusMsg ("Adding Diff";" Seqs = ")
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				PSpecEstimateLd("Machines")
				$numberInCollection:=Records in selection:C76([Process_Specs_Machines:28])
				
				For ($zz; 1; $numberInCollection)
					QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Process_Specs_Machines:28]CostCenterID:4)
					CREATE RECORD:C68([Estimates_Machines:20])
					[Estimates_Machines:20]DiffFormID:1:=$EstimateDifferenctialForm
					[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13
					[Estimates_Machines:20]LaborStd:7:=[Cost_Centers:27]MHRlaborSales:4
					[Estimates_Machines:20]OverheadStd:8:=[Cost_Centers:27]MHRburdenSales:5
					[Estimates_Machines:20]OOPStd:17:=[Cost_Centers:27]MHRoopSales:7
					[Estimates_Machines:20]CostCtrName:2:=[Process_Specs_Machines:28]CostCtrName:5
					[Estimates_Machines:20]CostCtrID:4:=[Process_Specs_Machines:28]CostCenterID:4
					[Estimates_Machines:20]Sequence:5:=[Process_Specs_Machines:28]Seq_Num:3
					[Estimates_Machines:20]CalcScrapFlg:11:=[Process_Specs_Machines:28]CalcScrapFlag:11
					[Estimates_Machines:20]EstimateNo:14:=$estimateNumber
					[Estimates_Machines:20]EstimateType:16:="PROD"
					[Estimates_Machines:20]FormChangeHere:9:=[Process_Specs_Machines:28]formChangeHere:9
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
				
			Else 
				PSpecEstimateLd("Machines")
				$numberInCollection:=Records in selection:C76([Process_Specs_Machines:28])
				
				ARRAY TEXT:C222($_CostCenterID; 0)
				ARRAY TEXT:C222($_CostCtrName; 0)
				ARRAY INTEGER:C220($_Seq_Num; 0)
				ARRAY BOOLEAN:C223($_CalcScrapFlag; 0)
				ARRAY BOOLEAN:C223($_formChangeHere; 0)
				ARRAY LONGINT:C221($_Flex_Field1; 0)
				ARRAY LONGINT:C221($_Flex_Field2; 0)
				ARRAY LONGINT:C221($_Flex_Field3; 0)
				ARRAY LONGINT:C221($_Flex_Field4; 0)
				ARRAY BOOLEAN:C223($_Flex_Field5; 0)
				ARRAY BOOLEAN:C223($_Flex_Field6; 0)
				ARRAY LONGINT:C221($_Flex_Field7; 0)
				ARRAY REAL:C219($_MR_Override; 0)
				ARRAY REAL:C219($_Run_Override; 0)
				ARRAY REAL:C219($_WasteAdj_Percen; 0)
				ARRAY TEXT:C222($_Comment; 0)
				ARRAY BOOLEAN:C223($_OutsideService; 0)
				
				
				SELECTION TO ARRAY:C260([Process_Specs_Machines:28]CostCenterID:4; $_CostCenterID; [Process_Specs_Machines:28]CostCtrName:5; $_CostCtrName; [Process_Specs_Machines:28]Seq_Num:3; $_Seq_Num; [Process_Specs_Machines:28]CalcScrapFlag:11; $_CalcScrapFlag; [Process_Specs_Machines:28]formChangeHere:9; $_formChangeHere; [Process_Specs_Machines:28]Flex_Field1:12; $_Flex_Field1; [Process_Specs_Machines:28]Flex_Field2:13; $_Flex_Field2; [Process_Specs_Machines:28]Flex_Field3:14; $_Flex_Field3; [Process_Specs_Machines:28]Flex_Field4:15; $_Flex_Field4; [Process_Specs_Machines:28]Flex_Field5:16; $_Flex_Field5; [Process_Specs_Machines:28]Flex_Field6:17; $_Flex_Field6; [Process_Specs_Machines:28]Flex_Field7:18; $_Flex_Field7; [Process_Specs_Machines:28]MR_Override:19; $_MR_Override; [Process_Specs_Machines:28]Run_Override:20; $_Run_Override; [Process_Specs_Machines:28]WasteAdj_Percen:22; $_WasteAdj_Percen; [Process_Specs_Machines:28]Comment:21; $_Comment; [Process_Specs_Machines:28]OutsideService:23; $_OutsideService)
				
				
				For ($zz; 1; $numberInCollection; 1)
					QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$_CostCenterID{$zz})
					CREATE RECORD:C68([Estimates_Machines:20])
					[Estimates_Machines:20]DiffFormID:1:=$EstimateDifferenctialForm
					[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13
					[Estimates_Machines:20]LaborStd:7:=[Cost_Centers:27]MHRlaborSales:4
					[Estimates_Machines:20]OverheadStd:8:=[Cost_Centers:27]MHRburdenSales:5
					[Estimates_Machines:20]OOPStd:17:=[Cost_Centers:27]MHRoopSales:7
					[Estimates_Machines:20]CostCtrName:2:=$_CostCtrName{$zz}
					[Estimates_Machines:20]CostCtrID:4:=$_CostCenterID{$zz}
					[Estimates_Machines:20]Sequence:5:=$_Seq_Num{$zz}
					[Estimates_Machines:20]CalcScrapFlg:11:=$_CalcScrapFlag{$zz}
					[Estimates_Machines:20]EstimateNo:14:=$estimateNumber
					[Estimates_Machines:20]EstimateType:16:="PROD"
					[Estimates_Machines:20]FormChangeHere:9:=$_formChangeHere{$zz}
					[Estimates_Machines:20]Flex_field1:18:=$_Flex_Field1{$zz}
					[Estimates_Machines:20]Flex_Field2:19:=$_Flex_Field2{$zz}
					[Estimates_Machines:20]Flex_Field3:20:=$_Flex_Field3{$zz}
					[Estimates_Machines:20]Flex_Field4:21:=$_Flex_Field4{$zz}
					[Estimates_Machines:20]Flex_Field5:25:=$_Flex_Field5{$zz}
					[Estimates_Machines:20]Flex_field6:37:=$_Flex_Field6{$zz}
					[Estimates_Machines:20]Flex_Field7:38:=$_Flex_Field7{$zz}
					[Estimates_Machines:20]MR_Override:26:=$_MR_Override{$zz}
					[Estimates_Machines:20]Run_Override:27:=$_Run_Override{$zz}
					[Estimates_Machines:20]WasteAdj_Percen:40:=$_WasteAdj_Percen{$zz}
					[Estimates_Machines:20]Comment:29:=$_Comment{$zz}
					[Estimates_Machines:20]OutSideService:33:=$_OutsideService{$zz}
					SAVE RECORD:C53([Estimates_Machines:20])
				End for 
				
			End if   // END 4D Professional Services : January 2019 
			
			//zwStatusMsg ("Adding Diff";String($numberInCollection))
			//zwStatusMsg ("Adding Diff";" Mat'ls = ")
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				PSpecEstimateLd(""; "Materials")
				$numberInCollection:=Records in selection:C76([Process_Specs_Materials:56])
				
				For ($zz; 1; $numberInCollection)
					CREATE RECORD:C68([Estimates_Materials:29])
					[Estimates_Materials:29]DiffFormID:1:=$EstimateDifferenctialForm
					[Estimates_Materials:29]CostCtrID:2:=[Process_Specs_Materials:56]CostCtrID:3
					[Estimates_Materials:29]Raw_Matl_Code:4:=[Process_Specs_Materials:56]Raw_Matl_Code:13
					[Estimates_Materials:29]Commodity_Key:6:=[Process_Specs_Materials:56]Commodity_Key:8
					[Estimates_Materials:29]EstimateNo:5:=$estimateNumber
					[Estimates_Materials:29]EstimateType:7:="PROD"
					[Estimates_Materials:29]UOM:8:=[Process_Specs_Materials:56]UOM:9
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
				
				
			Else 
				PSpecEstimateLd(""; "Materials")
				$numberInCollection:=Records in selection:C76([Process_Specs_Materials:56])
				
				ARRAY TEXT:C222($_CostCtrID; 0)
				ARRAY TEXT:C222($_Raw_Matl_Code; 0)
				ARRAY TEXT:C222($_Commodity_Key; 0)
				ARRAY TEXT:C222($_UOM; 0)
				ARRAY TEXT:C222($_RMName; 0)
				ARRAY INTEGER:C220($_Sequence; 0)
				ARRAY TEXT:C222($_Comments; 0)
				ARRAY REAL:C219($_Real1; 0)
				ARRAY REAL:C219($_Real2; 0)
				ARRAY REAL:C219($_Real3; 0)
				ARRAY REAL:C219($_Real4; 0)
				ARRAY TEXT:C222($_alpha20_2; 0)
				ARRAY TEXT:C222($_alpha20_3; 0)
				
				SELECTION TO ARRAY:C260([Process_Specs_Materials:56]CostCtrID:3; $_CostCtrID; [Process_Specs_Materials:56]Raw_Matl_Code:13; $_Raw_Matl_Code; [Process_Specs_Materials:56]Commodity_Key:8; $_Commodity_Key; [Process_Specs_Materials:56]UOM:9; $_UOM; [Process_Specs_Materials:56]RMName:6; $_RMName; [Process_Specs_Materials:56]Sequence:4; $_Sequence; [Process_Specs_Materials:56]Comments:7; $_Comments; [Process_Specs_Materials:56]Real1:14; $_Real1; [Process_Specs_Materials:56]Real2:15; $_Real2; [Process_Specs_Materials:56]Real3:16; $_Real3; [Process_Specs_Materials:56]Real4:17; $_Real4; [Process_Specs_Materials:56]alpha20_2:18; $_alpha20_2; [Process_Specs_Materials:56]alpha20_3:19; $_alpha20_3)
				
				
				For ($zz; 1; $numberInCollection; 1)
					CREATE RECORD:C68([Estimates_Materials:29])
					[Estimates_Materials:29]DiffFormID:1:=$EstimateDifferenctialForm
					[Estimates_Materials:29]CostCtrID:2:=$_CostCtrID{$zz}  //$_CostCtrName{$zz}// Modified by: Mel Bohince (4/8/19)
					[Estimates_Materials:29]Raw_Matl_Code:4:=$_Raw_Matl_Code{$zz}
					[Estimates_Materials:29]Commodity_Key:6:=$_Commodity_Key{$zz}
					[Estimates_Materials:29]EstimateNo:5:=$estimateNumber
					[Estimates_Materials:29]EstimateType:7:="PROD"
					[Estimates_Materials:29]UOM:8:=$_UOM{$zz}
					[Estimates_Materials:29]RMName:10:=$_RMName{$zz}
					[Estimates_Materials:29]Sequence:12:=$_Sequence{$zz}
					[Estimates_Materials:29]Comments:13:=$_Comments{$zz}
					[Estimates_Materials:29]Real1:14:=$_Real1{$zz}
					[Estimates_Materials:29]Real2:15:=$_Real2{$zz}
					[Estimates_Materials:29]Real3:16:=$_Real3{$zz}
					[Estimates_Materials:29]Real4:17:=$_Real4{$zz}
					[Estimates_Materials:29]alpha20_2:18:=$_alpha20_2{$zz}
					[Estimates_Materials:29]alpha20_3:19:=$_alpha20_3{$zz}
					
					SAVE RECORD:C53([Estimates_Materials:29])
				End for 
				
				
			End if   // END 4D Professional Services : January 2019 
			
			//zwStatusMsg ("Adding Diff";String($numberInCollection))
		End if   //id bulleted
		
		uThermoUpdate($pSpec)
	End for   //get next bulleted Differential
	uThermoClose
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
		
		USE NAMED SELECTION:C332("CSpecSelect")
		CLEAR NAMED SELECTION:C333("CSpecSelect")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Estimates_Carton_Specs:19]; $_CSpecSelect)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

zwStatusMsg("Adding Diff"; "Finished")

QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)
ORDER BY:C49([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1; >)

BEEP:C151
MESSAGES ON:C181