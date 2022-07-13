//[caseSceninaro]Input.bAddF(S)
// upr 1365 12/21/94
//upr 165 1/4/94

zwStatusMsg("Adding Form"; "")

[Estimates_Differentials:38]NumForms:4:=Records in selection:C76([Estimates_DifferentialsForms:47])+1  //already set to 1 above
[Estimates_Differentials:38]LastFormID:27:=[Estimates_Differentials:38]LastFormID:27+1
SAVE RECORD:C53([Estimates_Differentials:38])


C_LONGINT:C283($TT; $CartonTtl; $Z)

gEstimateLDWkSh("Wksht")  //("Diff") 12/21/94
$CartonTtl:=Records in selection:C76([Estimates_Carton_Specs:19])


CREATE RECORD:C68([Estimates_DifferentialsForms:47])
[Estimates_DifferentialsForms:47]DiffId:1:=[Estimates_Differentials:38]Id:1
[Estimates_DifferentialsForms:47]FormNumber:2:=[Estimates_Differentials:38]LastFormID:27
[Estimates_DifferentialsForms:47]DiffFormId:3:=[Estimates_DifferentialsForms:47]DiffId:1+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")
[Estimates_DifferentialsForms:47]NumItems:8:=0  //Records in selection([CARTON_SPEC])

If ([Estimates:17]EstimateNo:1#(Substring:C12([Estimates_DifferentialsForms:47]DiffFormId:3; 1; 9)))
	READ ONLY:C145([Estimates:17])
	QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=(Substring:C12([Estimates_DifferentialsForms:47]DiffFormId:3; 1; 9)))
End if 
[Estimates_DifferentialsForms:47]DateCustomerWant:7:=[Estimates:17]DateCustomerWant:23
[Estimates_DifferentialsForms:47]JobType:9:=[Estimates:17]JobType:29

[Estimates_DifferentialsForms:47]ProcessSpec:23:=[Estimates_Differentials:38]ProcessSpec:5
READ ONLY:C145([Process_Specs:18])
QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_DifferentialsForms:47]ProcessSpec:23)
[Estimates_DifferentialsForms:47]Width:5:=[Process_Specs:18]formWidth:96
[Estimates_DifferentialsForms:47]Lenth:6:=[Process_Specs:18]formLength:97

SAVE RECORD:C53([Estimates_DifferentialsForms:47])

zwStatusMsg("Adding Form"; "Adding Processes...")
QUERY:C277([Process_Specs_Machines:28]; [Process_Specs_Machines:28]ProcessSpec:1=[Estimates_DifferentialsForms:47]ProcessSpec:23)  //upr 165 1/4/94
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
	SAVE RECORD:C53([Estimates_Machines:20])
	NEXT RECORD:C51([Process_Specs_Machines:28])
End for 

zwStatusMsg("Adding Form"; "Adding Materials...")
QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Estimates_DifferentialsForms:47]ProcessSpec:23)  //upr 165 1/4/94
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
	[Estimates_Materials:29]Qty:9:=1
	[Estimates_Materials:29]RMName:10:=[Process_Specs_Materials:56]RMName:6
	[Estimates_Materials:29]Sequence:12:=[Process_Specs_Materials:56]Sequence:4
	[Estimates_Materials:29]Comments:13:=[Process_Specs_Materials:56]Comments:7
	[Estimates_Materials:29]Real1:14:=[Process_Specs_Materials:56]Real1:14
	[Estimates_Materials:29]Real2:15:=[Process_Specs_Materials:56]Real2:15
	[Estimates_Materials:29]Real3:16:=[Process_Specs_Materials:56]Real3:16
	[Estimates_Materials:29]Real4:17:=[Process_Specs_Materials:56]Real4:17
	[Estimates_Materials:29]alpha20_2:18:=[Process_Specs_Materials:56]alpha20_2:18
	[Estimates_Materials:29]alpha20_3:19:=[Process_Specs_Materials:56]alpha20_3:19
	[Estimates_Materials:29]zCount:23:=1
	
	SAVE RECORD:C53([Estimates_Materials:29])
	NEXT RECORD:C51([Process_Specs_Materials:56])
End for 


QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=[Estimates_Differentials:38]Id:1)
ORDER BY:C49([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3; >)
REDRAW:C174([Estimates_DifferentialsForms:47])  //show all new differentials
Estimate_ReCalcNeeded
zwStatusMsg("Adding Form"; "Done")








