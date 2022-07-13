//%attributes = {"publishedWeb":true}
//Est_Transit
//add a transit operation if there is a intercompany move 
//anticipated
//•9/19/00  mlb  don't put in 2nd time, remove if not required
//•9/20/00  mlb  make sure there is an arrya

C_BOOLEAN:C305($operationsInRoanoke; $operationsInHauppauge)
ARRAY TEXT:C222($aCC; 0)  //•9/20/00  mlb  make sure there is an arrya
ARRAY INTEGER:C220($aSeq; 0)  //•9/20/00  mlb  make sure there is an arrya

$operationsInRoanoke:=False:C215
$operationsInHauppauge:=False:C215
Case of   //clear out any existing 888
	: (vSetupWhat="Form")
		READ WRITE:C146([Estimates_Machines:20])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CREATE SET:C116([Estimates_Machines:20]; "machines")
			
		Else 
			ARRAY LONGINT:C221($_record_machines; 0)
			LONGINT ARRAY FROM SELECTION:C647([Estimates_Machines:20]; $_record_machines)
			
		End if   // END 4D Professional Services : January 2019 
		
		QUERY SELECTION:C341([Estimates_Machines:20]; [Estimates_Machines:20]CostCtrID:4="888")
		If (Records in selection:C76([Estimates_Machines:20])>0)
			DELETE SELECTION:C66([Estimates_Machines:20])
		End if 
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("machines")
			CLEAR SET:C117("machines")
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Estimates_Machines:20]; $_record_machines)
			
		End if   // END 4D Professional Services : January 2019 
		SELECTION TO ARRAY:C260([Estimates_Machines:20]CostCtrID:4; $aCC; [Estimates_Machines:20]Sequence:5; $aSeq)
		
	: (vSetupWhat="Process")
		READ WRITE:C146([Process_Specs_Machines:28])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CREATE SET:C116([Process_Specs_Machines:28]; "machines")
			
			
		Else 
			
			ARRAY LONGINT:C221($_record_machines1; 0)
			LONGINT ARRAY FROM SELECTION:C647([Process_Specs_Machines:28]; $_record_machines1)
			
		End if   // END 4D Professional Services : January 2019 
		QUERY SELECTION:C341([Process_Specs_Machines:28]; [Process_Specs_Machines:28]CostCenterID:4="888")
		If (Records in selection:C76([Process_Specs_Machines:28])>0)
			DELETE SELECTION:C66([Process_Specs_Machines:28])
		End if 
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			USE SET:C118("machines")
			CLEAR SET:C117("machines")
			
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Process_Specs_Machines:28]; $_record_machines1)
			
			
		End if   // END 4D Professional Services : January 2019 
		SELECTION TO ARRAY:C260([Process_Specs_Machines:28]CostCenterID:4; $aCC; [Process_Specs_Machines:28]Seq_Num:3; $aSeq)
End case 

SORT ARRAY:C229($aSeq; $aCC; >)
$seq:=0
For ($i; 1; Size of array:C274($aCC))
	If (Position:C15($aCC{$i}; <>ROANOKE_WC)>0)
		$operationsInRoanoke:=True:C214
	Else 
		$operationsInHauppauge:=True:C214
	End if 
	
	If (Position:C15($aCC{$i}; <>PRESSES)>0)
		$seq:=$aSeq{$i}
	End if 
End for 

If ($operationsInRoanoke & $operationsInHauppauge)
	$found:=qryCostCenter("888")
	If ($found>0)
		Case of 
			: (vSetupWhat="Form")
				CREATE RECORD:C68([Estimates_Machines:20])
				[Estimates_Machines:20]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
				[Estimates_Machines:20]CostCtrID:4:=[Cost_Centers:27]ID:1
				[Estimates_Machines:20]CostCtrName:2:=[Cost_Centers:27]Description:3
				[Estimates_Machines:20]LaborStd:7:=[Cost_Centers:27]MHRlaborSales:4
				[Estimates_Machines:20]OverheadStd:8:=[Cost_Centers:27]MHRburdenSales:5
				[Estimates_Machines:20]CalcScrapFlg:11:=[Cost_Centers:27]AddScrapExcess:25
				[Estimates_Machines:20]OOPStd:17:=[Estimates_Machines:20]LaborStd:7+[Estimates_Machines:20]OverheadStd:8  //[COST_CENTER]OOPMachRate`•071296  MLB 
				[Estimates_Machines:20]Effectivity:6:=!2000-09-11!
				[Estimates_Machines:20]TempSeq:10:=$seq+8
				[Estimates_Machines:20]Sequence:5:=$seq+8
				[Estimates_Machines:20]SequenceID:3:="0"
				[Estimates_Machines:20]zCount:34:=1
				[Estimates_Machines:20]ModDate:35:=4D_Current_date
				[Estimates_Machines:20]ModWho:36:=<>zResp
				If ([Estimates_DifferentialsForms:47]CalcOvertimeFlg:26)  //•041498  MLB  UPR 1941
					[Estimates_Machines:20]CalcOvertimeFlg:42:=True:C214
				End if 
				SAVE RECORD:C53([Estimates_Machines:20])
				
			: (vSetupWhat="Process")
				CREATE RECORD:C68([Process_Specs_Machines:28])
				[Process_Specs_Machines:28]CustID:2:=[Process_Specs:18]Cust_ID:4
				[Process_Specs_Machines:28]ProcessSpec:1:=[Process_Specs:18]ID:1
				[Process_Specs_Machines:28]ModDate:7:=4D_Current_date
				[Process_Specs_Machines:28]ModWho:8:=<>zResp
				[Process_Specs_Machines:28]zCount:6:=1
				[Process_Specs_Machines:28]CostCenterID:4:=[Cost_Centers:27]ID:1
				[Process_Specs_Machines:28]CostCtrName:5:=[Cost_Centers:27]Description:3
				[Process_Specs_Machines:28]CalcScrapFlag:11:=[Cost_Centers:27]AddScrapExcess:25
				[Process_Specs_Machines:28]TempSeq:10:=$seq+8
				[Process_Specs_Machines:28]Seq_Num:3:=$seq+8
				SAVE RECORD:C53([Process_Specs_Machines:28])
		End case 
	End if 
End if 