//%attributes = {"publishedWeb":true}
//PM: PSpec_likeForm() -> 
//@author mlb - 8/2/01  14:46

C_DATE:C307($today)
C_LONGINT:C283($i)

uConfirm("Overwrite the Process Spec "+[Estimates_DifferentialsForms:47]ProcessSpec:23+" with the machine and material on this form?"; "Continue"; "Cancel")
If (ok=1)
	uConfirm("WARNING: If any jobs are already in production or inventory exists, they will"+" no longer be accurately represented by the name "+[Estimates_DifferentialsForms:47]ProcessSpec:23; "Continue"; "Cancel")
	If (ok=1)
		$today:=4D_Current_date
		READ WRITE:C146([Process_Specs:18])
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]PSpecKey:106=([Estimates:17]Cust_ID:2+":"+[Estimates_DifferentialsForms:47]ProcessSpec:23))
		[Process_Specs:18]formWidth:96:=[Estimates_DifferentialsForms:47]Width:5
		[Process_Specs:18]formLength:97:=[Estimates_DifferentialsForms:47]Lenth:6
		
		SAVE RECORD:C53([Process_Specs:18])
		PSpecEstimateLd("Machines"; "Materials")
		zwStatusMsg("UPDATE PSPEC"; "Overwriting old machinces")
		DELETE SELECTION:C66([Process_Specs_Machines:28])
		
		FIRST RECORD:C50([Estimates_Machines:20])
		For ($i; 1; Records in selection:C76([Estimates_Machines:20]))
			CREATE RECORD:C68([Process_Specs_Machines:28])
			[Process_Specs_Machines:28]ProcessSpec:1:=[Estimates_DifferentialsForms:47]ProcessSpec:23
			[Process_Specs_Machines:28]CustID:2:=[Estimates:17]Cust_ID:2
			[Process_Specs_Machines:28]Seq_Num:3:=[Estimates_Machines:20]Sequence:5
			[Process_Specs_Machines:28]CostCenterID:4:=[Estimates_Machines:20]CostCtrID:4
			[Process_Specs_Machines:28]CostCtrName:5:=[Estimates_Machines:20]CostCtrName:2
			[Process_Specs_Machines:28]zCount:6:=1
			[Process_Specs_Machines:28]ModDate:7:=$today
			[Process_Specs_Machines:28]ModWho:8:=<>zResp
			[Process_Specs_Machines:28]formChangeHere:9:=[Estimates_Machines:20]FormChangeHere:9
			
			[Process_Specs_Machines:28]CalcScrapFlag:11:=[Estimates_Machines:20]CalcScrapFlg:11
			[Process_Specs_Machines:28]Flex_Field1:12:=[Estimates_Machines:20]Flex_field1:18
			[Process_Specs_Machines:28]Flex_Field2:13:=[Estimates_Machines:20]Flex_Field2:19
			[Process_Specs_Machines:28]Flex_Field3:14:=[Estimates_Machines:20]Flex_Field3:20
			[Process_Specs_Machines:28]Flex_Field4:15:=[Estimates_Machines:20]Flex_Field4:21
			[Process_Specs_Machines:28]Flex_Field5:16:=[Estimates_Machines:20]Flex_Field5:25
			[Process_Specs_Machines:28]Flex_Field6:17:=[Estimates_Machines:20]Flex_field6:37
			[Process_Specs_Machines:28]Flex_Field7:18:=[Estimates_Machines:20]Flex_Field7:38
			[Process_Specs_Machines:28]MR_Override:19:=[Estimates_Machines:20]MR_Override:26
			[Process_Specs_Machines:28]Run_Override:20:=[Estimates_Machines:20]Run_Override:27
			[Process_Specs_Machines:28]Comment:21:=[Estimates_Machines:20]Comment:29
			[Process_Specs_Machines:28]WasteAdj_Percen:22:=[Estimates_Machines:20]WasteAdj_Percen:40
			[Process_Specs_Machines:28]OutsideService:23:=[Estimates_Machines:20]OutSideService:33
			SAVE RECORD:C53([Process_Specs_Machines:28])
			
			NEXT RECORD:C51([Estimates_Machines:20])
		End for 
		
		zwStatusMsg("UPDATE PSPEC"; "Overwriting old materials")
		DELETE SELECTION:C66([Process_Specs_Materials:56])
		
		FIRST RECORD:C50([Estimates_Materials:29])
		For ($i; 1; Records in selection:C76([Estimates_Materials:29]))
			CREATE RECORD:C68([Process_Specs_Materials:56])
			[Process_Specs_Materials:56]ProcessSpec:1:=[Estimates_DifferentialsForms:47]ProcessSpec:23
			[Process_Specs_Materials:56]CustID:2:=[Estimates:17]Cust_ID:2
			[Process_Specs_Materials:56]CostCtrID:3:=[Estimates_Materials:29]CostCtrID:2
			[Process_Specs_Materials:56]Sequence:4:=[Estimates_Materials:29]Sequence:12
			[Process_Specs_Materials:56]RMName:6:=[Estimates_Materials:29]RMName:10
			[Process_Specs_Materials:56]Comments:7:=[Estimates_Materials:29]Comments:13
			[Process_Specs_Materials:56]Commodity_Key:8:=[Estimates_Materials:29]Commodity_Key:6
			[Process_Specs_Materials:56]UOM:9:=[Estimates_Materials:29]UOM:8
			[Process_Specs_Materials:56]ModWho:10:=<>zResp
			[Process_Specs_Materials:56]ModDate:11:=$today
			[Process_Specs_Materials:56]zCount:12:=1
			[Process_Specs_Materials:56]Raw_Matl_Code:13:=[Estimates_Materials:29]Raw_Matl_Code:4
			If (Position:C15("06"; [Process_Specs_Materials:56]Commodity_Key:8)=0)  // Modified by: Mel Bohince (11/10/15) don't add qty info
				[Process_Specs_Materials:56]Real1:14:=[Estimates_Materials:29]Real1:14
				[Process_Specs_Materials:56]Real2:15:=[Estimates_Materials:29]Real2:15
				[Process_Specs_Materials:56]Real3:16:=[Estimates_Materials:29]Real3:16
				[Process_Specs_Materials:56]Real4:17:=[Estimates_Materials:29]Real4:17
				[Process_Specs_Materials:56]alpha20_2:18:=[Estimates_Materials:29]alpha20_2:18
				[Process_Specs_Materials:56]alpha20_3:19:=[Estimates_Materials:29]alpha20_3:19
			End if 
			SAVE RECORD:C53([Process_Specs_Materials:56])
			
			NEXT RECORD:C51([Estimates_Materials:29])
		End for 
		
		zwStatusMsg("UPDATE PSPEC"; "Finished")
		
		uConfirm("You are responsible for updating the ProcessSpec page one description to "+"accurately describes the new operations and materials."; "OK"; "Help")
	End if 
End if 