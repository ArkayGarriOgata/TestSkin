//%attributes = {"publishedWeb":true}
//gSetupDo() 7/93   
//JML   8/20/93, 
//mod 2/8/94 mlb
//upr 1211 10/5/94
//•041498  MLB  UPR 1941, honar the OvertimeFlag at the form level
//attached to the OK button of the [process_Spec];"OperSeqSetup" dialog
//allows user to manipulate Materials, & mchines for Prep & production estimating
//TRACE
//alRelTemp{$i}:=-3
//MESSAGES OFF
//•053095  MLB  UPR 1501 ;also add std qryC/C and qryRMgroup calls
//•071296  MLB  make sure the standards add correctly
//•071699  mlb  hidden dialog

C_LONGINT:C283($T; $X; $i)

Case of 
	: (vSetupWhat="Process")
		//delete old machine sequences
		//chug thru machine est, find in array acust{} the value of [machine_est]sequence
		//if not there, "Tag it for delete.
		//then, delete tagged records delete this record and corresponding material record
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			FIRST RECORD:C50([Process_Specs_Machines:28])
			$T:=Records in selection:C76([Process_Specs_Machines:28])
			CREATE EMPTY SET:C140([Process_Specs_Machines:28]; "DeleteSet")
			For ($X; 1; $T)
				$i:=Find in array:C230(alRelTemp; Record number:C243([Process_Specs_Machines:28]))
				If ($i=-1)
					ADD TO SET:C119([Process_Specs_Machines:28]; "DeleteSet")
					
					QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]CustID:2=[Process_Specs_Machines:28]CustID:2; *)
					QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs_Machines:28]ProcessSpec:1; *)
					QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]CostCtrID:3=[Process_Specs_Machines:28]CostCenterID:4)
					DELETE SELECTION:C66([Process_Specs_Materials:56])
					
				End if 
				NEXT RECORD:C51([Process_Specs_Machines:28])
			End for 
			USE SET:C118("DeleteSet")
			CLEAR SET:C117("DeleteSet")
			DELETE SELECTION:C66([Process_Specs_Machines:28])
			
			
		Else 
			
			$T:=Records in selection:C76([Process_Specs_Machines:28])
			
			ARRAY LONGINT:C221($_Record_courant; 0)
			ARRAY LONGINT:C221($_Record_courant_todel; 0)
			ARRAY TEXT:C222($_CustID; 0)
			ARRAY TEXT:C222($_ProcessSpec; 0)
			ARRAY TEXT:C222($_CostCenterID; 0)
			
			SELECTION TO ARRAY:C260([Process_Specs_Machines:28]; $_Record_courant; [Process_Specs_Machines:28]CustID:2; $_CustID; [Process_Specs_Machines:28]ProcessSpec:1; $_ProcessSpec; [Process_Specs_Machines:28]CostCenterID:4; $_CostCenterID)
			
			For ($X; 1; $T)
				$i:=Find in array:C230(alRelTemp; $_Record_courant{$x})
				If ($i=-1)
					
					APPEND TO ARRAY:C911($_Record_courant_todel; $_Record_courant{$x})
					QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]CustID:2=$_CustID{$X}; *)
					QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]ProcessSpec:1=$_ProcessSpec{$X}; *)
					QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]CostCtrID:3=$_CostCenterID{$X})
					DELETE SELECTION:C66([Process_Specs_Materials:56])
					
				End if 
				
			End for 
			
			CREATE SELECTION FROM ARRAY:C640([Process_Specs_Machines:28]; $_Record_courant_todel)
			
			DELETE SELECTION:C66([Process_Specs_Machines:28])
			
		End if   // END 4D Professional Services : January 2019 First record
		//update existing sequences(just Sequence field)  must do
		//chug thru array, if sequenceNumb #0, then find & modify [machine_est] record.
		//put new sequence # in New_seq field.
		//then, chug thru records and serquence := newSeq
		//•053095  MLB  UPR 1501
		//•071699  mlb  hidden dialog
		CONFIRM:C162("Add the default materials for the selected cost centers?"; "Defaults"; "Don't Add")
		C_BOOLEAN:C305($defaultMatl)
		$defaultMatl:=(OK=1)
		
		$T:=Size of array:C274(aiSeq)
		For ($x; 1; $T)
			If (alRelTemp{$X}#-3)  //if this is existing record, this value is non-zero &=aiSeq{$X}
				GOTO RECORD:C242([Process_Specs_Machines:28]; alRelTemp{$X})
				If (iResequence=1)
					[Process_Specs_Machines:28]TempSeq:10:=aiSeq{$x}  //update this record to it's new sequence location
				Else 
					[Process_Specs_Machines:28]TempSeq:10:=[Process_Specs_Machines:28]Seq_Num:3  //same sequence location
				End if   //reseq
				SAVE RECORD:C53([Process_Specs_Machines:28])
			Else   //this is a new record
				qryCostCenter(asCC{$x})
				CREATE RECORD:C68([Process_Specs_Machines:28])
				[Process_Specs_Machines:28]CustID:2:=[Process_Specs:18]Cust_ID:4
				[Process_Specs_Machines:28]ProcessSpec:1:=[Process_Specs:18]ID:1
				[Process_Specs_Machines:28]CalcScrapFlag:11:=[Cost_Centers:27]AddScrapExcess:25
				[Process_Specs_Machines:28]ModDate:7:=4D_Current_date
				[Process_Specs_Machines:28]ModWho:8:=<>zResp
				[Process_Specs_Machines:28]zCount:6:=1
				[Process_Specs_Machines:28]CostCenterID:4:=[Cost_Centers:27]ID:1
				[Process_Specs_Machines:28]CostCtrName:5:=[Cost_Centers:27]Description:3
				[Process_Specs_Machines:28]TempSeq:10:=aiSeq{$X}
				SAVE RECORD:C53([Process_Specs_Machines:28])
				
				If ($defaultMatl)  //•053095  MLB  UPR 1501
					uDefaultMatls($X)  //upr 1211
				End if 
			End if 
		End for 
		PSpecEstimateLd("Machines")
		APPLY TO SELECTION:C70([Process_Specs_Machines:28]; [Process_Specs_Machines:28]Seq_Num:3:=[Process_Specs_Machines:28]TempSeq:10)
		
	: (vSetupWhat="Prep")
		//delete old machine sequences
		//chug thru machine est, find in array acust{} the value of [machine_est]sequence
		//if not there, "Tag it for delete.
		//then, delete tagged records delete this record and corresponding material record
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			FIRST RECORD:C50([Estimates_Machines:20])
			$T:=Records in selection:C76([Estimates_Machines:20])
			CREATE EMPTY SET:C140([Estimates_Machines:20]; "DeleteSet")
			For ($X; 1; $T)
				$i:=Find in array:C230(alRelTemp; Record number:C243([Estimates_Machines:20]))
				If ($i=-1)
					ADD TO SET:C119([Estimates_Machines:20]; "DeleteSet")
				End if 
				NEXT RECORD:C51([Estimates_Machines:20])
			End for 
			USE SET:C118("DeleteSet")
			CLEAR SET:C117("DeleteSet")
			DELETE SELECTION:C66([Estimates_Machines:20])
			
		Else 
			
			
			ARRAY LONGINT:C221($_Record_courant; 0)
			ARRAY LONGINT:C221($_Record_courant_todel; 0)
			
			SELECTION TO ARRAY:C260([Estimates_Machines:20]; $_Record_courant)
			
			$T:=Records in selection:C76([Estimates_Machines:20])
			
			For ($X; 1; $T; 1)
				$i:=Find in array:C230(alRelTemp; $_Record_courant{$x})
				If ($i=-1)
					APPEND TO ARRAY:C911($_Record_courant_todel; $_Record_courant{$x})
				End if 
				
			End for 
			CREATE SELECTION FROM ARRAY:C640([Estimates_Machines:20]; $_Record_courant_todel)
			
			DELETE SELECTION:C66([Estimates_Machines:20])
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		//update existing sequences(just Sequence field)  must do
		//chug thru array, if sequenceNumb #0, then find & modify [machine_est] record.
		//put new sequence # in New_seq field.
		//then, apply to selection( sequence := newSeq)
		$T:=Size of array:C274(aiSeq)
		For ($x; 1; $T)
			If (alRelTemp{$X}#-3)  //if this is existing record, this value is non-zero &=aiSeq{$X}
				GOTO RECORD:C242([Estimates_Machines:20]; alRelTemp{$X})
				If (iResequence=1)
					[Estimates_Machines:20]TempSeq:10:=aiSeq{$x}  //update this record to it's new sequence location          
				Else 
					[Estimates_Machines:20]TempSeq:10:=[Estimates_Machines:20]Sequence:5  //same sequence location
				End if   //reseq  
				SAVE RECORD:C53([Estimates_Machines:20])
			Else   //this is a new record
				//create new machine_est records
				//if seq=0, create the record.
				//fill in additional fields & other field with default values.
				qryCostCenter(asCC{$x})
				CREATE RECORD:C68([Estimates_Machines:20])
				[Estimates_Machines:20]EstimateNo:14:=[Estimates:17]EstimateNo:1
				[Estimates_Machines:20]EstimateType:16:="Prep"
				// [Machine_Est]CaseFormID:="N/A"
				[Estimates_Machines:20]CostCtrID:4:=[Cost_Centers:27]ID:1
				[Estimates_Machines:20]CostCtrName:2:=[Cost_Centers:27]Description:3
				[Estimates_Machines:20]LaborStd:7:=[Cost_Centers:27]MHRlaborSales:4  //these Std fields really shouldn't be here-redundant with no purpsoe
				[Estimates_Machines:20]OverheadStd:8:=[Cost_Centers:27]MHRburdenSales:5
				[Estimates_Machines:20]OOPStd:17:=[Estimates_Machines:20]LaborStd:7+[Estimates_Machines:20]OverheadStd:8  //[COST_CENTER]OOPMachRate`•071296  MLB 
				[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13
				[Estimates_Machines:20]TempSeq:10:=aiSeq{$X}
				[Estimates_Machines:20]CalcScrapFlg:11:=[Cost_Centers:27]AddScrapExcess:25
				[Estimates_Machines:20]SequenceID:3:=app_GetPrimaryKey  //String(app_AutoIncrement (->[Estimates_Machines]))
				[Estimates_Machines:20]zCount:34:=1
				[Estimates_Machines:20]ModDate:35:=4D_Current_date
				[Estimates_Machines:20]ModWho:36:=<>zResp
				
				SAVE RECORD:C53([Estimates_Machines:20])
			End if 
		End for 
		PrepEstimateLd("Machines")
		APPLY TO SELECTION:C70([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5:=[Estimates_Machines:20]TempSeq:10)
		
	: (vSetupWhat="Form")
		//delete old machine sequences
		//chug thru machine est, find in array acust{} the value of [machine_est]sequence
		//if not there, "Tag it for delete.
		//then, delete tagged records delete this record and corresponding material record
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			FIRST RECORD:C50([Estimates_Machines:20])
			$T:=Records in selection:C76([Estimates_Machines:20])
			CREATE EMPTY SET:C140([Estimates_Machines:20]; "DeleteSet")
			For ($X; 1; $T)
				$i:=Find in array:C230(alRelTemp; Record number:C243([Estimates_Machines:20]))
				If ($i=-1)
					ADD TO SET:C119([Estimates_Machines:20]; "DeleteSet")
					QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_Machines:20]DiffFormID:1; *)
					QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]CostCtrID:2=[Estimates_Machines:20]CostCtrID:4)
					DELETE SELECTION:C66([Estimates_Materials:29])
				End if 
				NEXT RECORD:C51([Estimates_Machines:20])
			End for 
			USE SET:C118("DeleteSet")
			CLEAR SET:C117("DeleteSet")
			DELETE SELECTION:C66([Estimates_Machines:20])
			
			
		Else 
			
			
			
			ARRAY LONGINT:C221($_Record_courant; 0)
			ARRAY LONGINT:C221($_Record_courant_todel; 0)
			ARRAY TEXT:C222($_DiffFormID; 0)
			ARRAY TEXT:C222($_CostCtrID; 0)
			
			SELECTION TO ARRAY:C260([Estimates_Machines:20]; $_Record_courant; [Estimates_Machines:20]DiffFormID:1; $_DiffFormID; [Estimates_Machines:20]CostCtrID:4; $_CostCtrID)
			
			$T:=Records in selection:C76([Estimates_Machines:20])
			
			For ($X; 1; $T; 1)
				$i:=Find in array:C230(alRelTemp; $_Record_courant{$x})
				If ($i=-1)
					APPEND TO ARRAY:C911($_Record_courant_todel; $_Record_courant{$X})
					QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=$_DiffFormID{$X}; *)
					QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]CostCtrID:2=$_CostCtrID{$X})
					DELETE SELECTION:C66([Estimates_Materials:29])
				End if 
				
			End for 
			CREATE SELECTION FROM ARRAY:C640([Estimates_Machines:20]; $_Record_courant_todel)
			
			DELETE SELECTION:C66([Estimates_Machines:20])
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		//update existing sequences(just Sequence field)  must do
		//chug thru array, if sequenceNumb #0, then find & modify [machine_est] record.
		//put new sequence # in New_seq field.
		//then, chug thru records and serquence := newSeq
		$T:=Size of array:C274(aiSeq)
		For ($x; 1; $T)
			If (alRelTemp{$X}#-3)  //if this is existing record, this value is non-zero &=aiSeq{$X}
				GOTO RECORD:C242([Estimates_Machines:20]; alRelTemp{$X})
				If (iResequence=1)
					[Estimates_Machines:20]TempSeq:10:=aiSeq{$x}  //update this record to it's new sequence location              
				Else 
					[Estimates_Machines:20]TempSeq:10:=[Estimates_Machines:20]Sequence:5  //same sequence location
				End if   //reseq            
				SAVE RECORD:C53([Estimates_Machines:20])
			Else   //this is a new record
				//create new machine_est records
				//if seq=0, create the record.
				//fill in additional fields & other field with default values.
				qryCostCenter(asCC{$x})
				CREATE RECORD:C68([Estimates_Machines:20])
				[Estimates_Machines:20]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
				[Estimates_Machines:20]CostCtrID:4:=[Cost_Centers:27]ID:1
				[Estimates_Machines:20]CostCtrName:2:=[Cost_Centers:27]Description:3
				[Estimates_Machines:20]LaborStd:7:=[Cost_Centers:27]MHRlaborSales:4
				[Estimates_Machines:20]OverheadStd:8:=[Cost_Centers:27]MHRburdenSales:5
				[Estimates_Machines:20]OOPStd:17:=[Estimates_Machines:20]LaborStd:7+[Estimates_Machines:20]OverheadStd:8  //[COST_CENTER]OOPMachRate`•071296  MLB 
				[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13
				[Estimates_Machines:20]TempSeq:10:=aiSeq{$X}
				[Estimates_Machines:20]SequenceID:3:=app_GetPrimaryKey  //String(app_AutoIncrement (->[Estimates_Machines]))
				[Estimates_Machines:20]CalcScrapFlg:11:=[Cost_Centers:27]AddScrapExcess:25
				[Estimates_Machines:20]zCount:34:=1
				[Estimates_Machines:20]ModDate:35:=4D_Current_date
				[Estimates_Machines:20]ModWho:36:=<>zResp
				
				If ([Estimates_DifferentialsForms:47]CalcOvertimeFlg:26)  //•041498  MLB  UPR 1941
					[Estimates_Machines:20]CalcOvertimeFlg:42:=True:C214
				End if 
				//since this # changes when the operational sequence changes, we also need a basic
				//seq ID # to link materials.
				
				SAVE RECORD:C53([Estimates_Machines:20])
			End if 
		End for 
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
		APPLY TO SELECTION:C70([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5:=[Estimates_Machines:20]TempSeq:10)
		
	: (vSetupWhat="Material-Prep")
		//delete old machine sequences
		//chug thru machine est, find in array acust{} the value of [machine_est]sequence
		//if not there, "Tag it for delete.
		//then, delete tagged records delete this record and corresponding material record
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			FIRST RECORD:C50([Estimates_Materials:29])
			$T:=Records in selection:C76([Estimates_Materials:29])
			CREATE EMPTY SET:C140([Estimates_Materials:29]; "DeleteSet")
			For ($X; 1; $T)
				$i:=Find in array:C230(alRelTemp; Record number:C243([Estimates_Materials:29]))
				If ($i=-1)
					ADD TO SET:C119([Estimates_Materials:29]; "DeleteSet")
				End if 
				NEXT RECORD:C51([Estimates_Materials:29])
			End for 
			USE SET:C118("DeleteSet")
			CLEAR SET:C117("DeleteSet")
			DELETE SELECTION:C66([Estimates_Materials:29])
			
		Else 
			
			ARRAY LONGINT:C221($_Record_courant; 0)
			ARRAY LONGINT:C221($_Record_courant_todel; 0)
			
			SELECTION TO ARRAY:C260([Estimates_Materials:29]; $_Record_courant)
			
			$T:=Records in selection:C76([Estimates_Materials:29])
			
			For ($X; 1; $T; 1)
				$i:=Find in array:C230(alRelTemp; $_Record_courant{$x})
				If ($i=-1)
					APPEND TO ARRAY:C911($_Record_courant_todel; $_Record_courant{$x})
				End if 
				
			End for 
			CREATE SELECTION FROM ARRAY:C640([Estimates_Materials:29]; $_Record_courant_todel)
			
			DELETE SELECTION:C66([Estimates_Materials:29])
			
		End if   // END 4D Professional Services : January 2019 First record
		
		//update existing sequences(just Sequence field)  must do
		//chug thru array, if sequenceNumb #0, then find & modify [machine_est] record.
		//put new sequence # in New_seq field.
		//then, apply to selection( sequence := newSeq)
		$T:=Size of array:C274(aiSeq)
		For ($x; 1; $T)
			If (alRelTemp{$X}#-3)  //if this is existing record, this value is non-zero &=aiSeq{$X}
				GOTO RECORD:C242([Estimates_Materials:29]; alRelTemp{$X})
				If (iResequence=1)
					[Estimates_Materials:29]TempSeq:20:=aiSeq{$x}  //update this record to it's new sequence location          
				Else 
					[Estimates_Materials:29]TempSeq:20:=[Estimates_Materials:29]Sequence:12  //same sequence location
				End if   //reseq          
				SAVE RECORD:C53([Estimates_Materials:29])
			Else   //this is a new record
				//create new machine_est records
				//if seq=0, create the record.
				//fill in additional fields & other field with default values.
				qryRMgroup(asCC{$X}; !00-00-00!)  //•053095  MLB  UPR 1501        
				CREATE RECORD:C68([Estimates_Materials:29])
				// [Material_Est]CaseFormID:=[Machine_Est]CaseFormID
				[Estimates_Materials:29]CostCtrID:2:=[Raw_Materials_Groups:22]PrepCC:9
				[Estimates_Materials:29]EstimateNo:5:=[Estimates:17]EstimateNo:1
				[Estimates_Materials:29]EstimateType:7:="Prep"
				[Estimates_Materials:29]RMName:10:=[Raw_Materials_Groups:22]Description:2
				[Estimates_Materials:29]Comments:13:="Effectivity:"+String:C10([Raw_Materials_Groups:22]EffectivityDate:15; 1)
				[Estimates_Materials:29]Commodity_Key:6:=[Raw_Materials_Groups:22]Commodity_Key:3
				[Estimates_Materials:29]UOM:8:=[Raw_Materials_Groups:22]UOM:8
				[Estimates_Materials:29]Qty:9:=0
				[Estimates_Materials:29]ModWho:21:=<>zResp
				[Estimates_Materials:29]ModDate:22:=4D_Current_date
				[Estimates_Materials:29]zCount:23:=1
				[Estimates_Materials:29]TempSeq:20:=aiSeq{$X}
				SAVE RECORD:C53([Estimates_Materials:29])
			End if 
		End for 
		PrepEstimateLd(""; "Materials")
		APPLY TO SELECTION:C70([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12:=[Estimates_Materials:29]TempSeq:20)
		
	: (vSetupWhat="Material-Prod")
		//delete old machine sequences
		//chug thru machine est, find in array acust{} the value of [machine_est]sequence
		//if not there, "Tag it for delete.
		//then, delete tagged records delete this record and corresponding material record
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			FIRST RECORD:C50([Estimates_Materials:29])
			$T:=Records in selection:C76([Estimates_Materials:29])
			CREATE EMPTY SET:C140([Estimates_Materials:29]; "DeleteSet")
			For ($X; 1; $T)
				$i:=Find in array:C230(alRelTemp; Record number:C243([Estimates_Materials:29]))
				If ($i=-1)
					ADD TO SET:C119([Estimates_Materials:29]; "DeleteSet")
				End if 
				NEXT RECORD:C51([Estimates_Materials:29])
			End for 
			USE SET:C118("DeleteSet")
			CLEAR SET:C117("DeleteSet")
			DELETE SELECTION:C66([Estimates_Materials:29])
			
			
		Else 
			
			ARRAY LONGINT:C221($_Record_courant; 0)
			ARRAY LONGINT:C221($_Record_courant_todel; 0)
			
			SELECTION TO ARRAY:C260([Estimates_Materials:29]; $_Record_courant)
			
			$T:=Records in selection:C76([Estimates_Materials:29])
			
			For ($X; 1; $T; 1)
				$i:=Find in array:C230(alRelTemp; $_Record_courant{$x})
				If ($i=-1)
					APPEND TO ARRAY:C911($_Record_courant_todel; $_Record_courant{$x})
				End if 
				
			End for 
			CREATE SELECTION FROM ARRAY:C640([Estimates_Materials:29]; $_Record_courant_todel)
			
			DELETE SELECTION:C66([Estimates_Materials:29])
			
			
		End if   // END 4D Professional Services : January 2019 First record
		//update existing sequences(just Sequence field)  must do
		//chug thru array, if sequenceNumb #0, then find & modify [machine_est] record.
		//put new sequence # in New_seq field.
		//then, apply to selection( sequence := newSeq)
		$T:=Size of array:C274(aiSeq)
		For ($x; 1; $T)
			If (alRelTemp{$X}#-3)  //if this is existing record, this value is non-zero &=aiSeq{$X}
				GOTO RECORD:C242([Estimates_Materials:29]; alRelTemp{$X})
				If (iResequence=1)
					[Estimates_Materials:29]TempSeq:20:=aiSeq{$x}  //update this record to it's new sequence location          
				Else 
					[Estimates_Materials:29]TempSeq:20:=[Estimates_Materials:29]Sequence:12  //sane sequence location
				End if   //reseq         
				SAVE RECORD:C53([Estimates_Materials:29])
			Else   //this is a new record
				//create new machine_est records
				//if seq=0, create the record.
				//fill in additional fields & other field with default values.
				qryRMgroup(asCC{$X}; !00-00-00!)  //•053095  MLB  UPR 1501        
				CREATE RECORD:C68([Estimates_Materials:29])
				[Estimates_Materials:29]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
				[Estimates_Materials:29]CostCtrID:2:=""  //[Machine_Est]CostCtrID
				[Estimates_Materials:29]RMName:10:=[Raw_Materials_Groups:22]Description:2
				[Estimates_Materials:29]Comments:13:=""  //"Effectivity:"+String([RM_GROUP]EffectivityDate;1)
				[Estimates_Materials:29]Commodity_Key:6:=[Raw_Materials_Groups:22]Commodity_Key:3
				[Estimates_Materials:29]UOM:8:=[Raw_Materials_Groups:22]UOM:8
				[Estimates_Materials:29]Qty:9:=0
				[Estimates_Materials:29]Cost:11:=0
				[Estimates_Materials:29]ModWho:21:=<>zResp
				[Estimates_Materials:29]ModDate:22:=4D_Current_date
				[Estimates_Materials:29]zCount:23:=1
				[Estimates_Materials:29]TempSeq:20:=aiSeq{$X}
				[Estimates_Materials:29]EstimateType:7:="Prod"
				SAVE RECORD:C53([Estimates_Materials:29])
			End if 
		End for 
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
		APPLY TO SELECTION:C70([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12:=[Estimates_Materials:29]TempSeq:20)
		
	: (vSetupWhat="Material-Process")
		//delete old machine sequences
		//chug thru machine est, find in array acust{} the value of [machine_est]sequence
		//if not there, "Tag it for delete.
		//then, delete tagged records delete this record and corresponding material record
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			FIRST RECORD:C50([Process_Specs_Materials:56])
			$T:=Records in selection:C76([Process_Specs_Materials:56])
			CREATE EMPTY SET:C140([Process_Specs_Materials:56]; "DeleteSet")
			For ($X; 1; $T)
				$i:=Find in array:C230(alRelTemp; Record number:C243([Process_Specs_Materials:56]))
				If ($i=-1)
					ADD TO SET:C119([Process_Specs_Materials:56]; "DeleteSet")
				End if 
				NEXT RECORD:C51([Process_Specs_Materials:56])
			End for 
			USE SET:C118("DeleteSet")
			CLEAR SET:C117("DeleteSet")
			DELETE SELECTION:C66([Process_Specs_Materials:56])
			
			
		Else 
			
			ARRAY LONGINT:C221($_Record_courant; 0)
			ARRAY LONGINT:C221($_Record_courant_todel; 0)
			
			SELECTION TO ARRAY:C260([Process_Specs_Materials:56]; $_Record_courant); 
			
			$T:=Records in selection:C76([Process_Specs_Materials:56])
			
			For ($X; 1; $T; 1)
				$i:=Find in array:C230(alRelTemp; $_Record_courant{$X})
				If ($i=-1)
					APPEND TO ARRAY:C911($_Record_courant_todel; $_Record_courant{$X})
				End if 
			End for 
			
			CREATE SELECTION FROM ARRAY:C640([Process_Specs_Materials:56]; $_Record_courant_todel)
			
			DELETE SELECTION:C66([Process_Specs_Materials:56])
			
			
		End if   // END 4D Professional Services : January 2019 First record
		//update existing sequences(just Sequence field)  must do
		//chug thru array, if sequenceNumb #0, then find & modify [machine_est] record.
		//put new sequence # in New_seq field.
		//then, apply to selection( sequence := newSeq)
		$T:=Size of array:C274(aiSeq)
		For ($x; 1; $T)
			If (alRelTemp{$X}#-3)  //if this is existing record, this value is non-zero &=aiSeq{$X}
				GOTO RECORD:C242([Process_Specs_Materials:56]; alRelTemp{$X})
				If (iResequence=1)
					[Process_Specs_Materials:56]TempSeq:5:=aiSeq{$x}  //update this record to it's new sequence location          
				Else 
					If (iCCseq=0)  //•053095  MLB  UPR 1501
						[Process_Specs_Materials:56]TempSeq:5:=[Process_Specs_Materials:56]Sequence:4  //update this record to it's new sequence location
					Else 
						[Process_Specs_Materials:56]TempSeq:5:=iCCseq
					End if 
				End if   //reseq          
				SAVE RECORD:C53([Process_Specs_Materials:56])
			Else   //this is a new record
				//create new machine_est records
				//if seq=0, create the record.
				//fill in additional fields & other field with default values. 
				qryRMgroup(asCC{$X}; !00-00-00!)  //•053095  MLB  UPR 1501       
				CREATE RECORD:C68([Process_Specs_Materials:56])
				[Process_Specs_Materials:56]ProcessSpec:1:=[Process_Specs:18]ID:1
				[Process_Specs_Materials:56]CustID:2:=[Process_Specs:18]Cust_ID:4
				[Process_Specs_Materials:56]CostCtrID:3:=sCC  //•053095  MLB  UPR 1501`""
				[Process_Specs_Materials:56]RMName:6:=[Raw_Materials_Groups:22]Description:2
				[Process_Specs_Materials:56]Comments:7:="Effectivity:"+String:C10([Raw_Materials_Groups:22]EffectivityDate:15; 1)
				[Process_Specs_Materials:56]Commodity_Key:8:=[Raw_Materials_Groups:22]Commodity_Key:3
				[Process_Specs_Materials:56]UOM:9:=[Raw_Materials_Groups:22]UOM:8
				//   [material_pspec]Qty :=1
				[Process_Specs_Materials:56]ModWho:10:=<>zResp
				[Process_Specs_Materials:56]ModDate:11:=4D_Current_date
				[Process_Specs_Materials:56]zCount:12:=1
				If (iCCseq=0)  //•053095  MLB  UPR 1501
					[Process_Specs_Materials:56]TempSeq:5:=aiSeq{$X}
				Else 
					[Process_Specs_Materials:56]TempSeq:5:=iCCseq
				End if 
				
				SAVE RECORD:C53([Process_Specs_Materials:56])
			End if 
		End for 
		
		If ((sCC="") | (iCCseq=0))  //•053095  MLB  UPR 1501
			PSpecEstimateLd(""; "Materials")
		Else   //just get the existing matl for this sequence number
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1; *)
			QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]TempSeq:5=iCCseq)
		End if 
		APPLY TO SELECTION:C70([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Sequence:4:=[Process_Specs_Materials:56]TempSeq:5)
		
End case 