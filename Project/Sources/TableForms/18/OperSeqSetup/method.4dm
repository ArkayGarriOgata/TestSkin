//(LP)[ProcessSpec].OperSeqSetup 2/9/94
//•053095  MLB  UPR 1501
//•121699  mlb  UPR add option for OnePage
If (Form event code:C388=On Load:K2:1)
	C_TEXT:C284(vListname1; vListname2)  //titles to scrolling lists
	C_LONGINT:C283($i; $NumMach)
	iResequence:=1
	ARRAY LONGINT:C221(alRelTemp; 0)  //Temporary array for RelateSelection and to track orig records
	ARRAY INTEGER:C220(aiSeq; 0)
	ARRAY TEXT:C222(asCC; 0)
	ARRAY TEXT:C222(asCCname; 0)
	Case of 
		: (vSetupWhat="Material-Process")
			iResequence:=0
			vListName1:="Material Sequence"
			vListName2:="Available Materials"
			// ALL RECORDS([RM_GROUP])  `get the raw material group records
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]UseForEst:12=True:C214)
			SELECTION TO ARRAY:C260([Raw_Materials_Groups:22]Commodity_Key:3; asCC2; [Raw_Materials_Groups:22]Description:2; asCCName2; [Raw_Materials_Groups:22]DisplayOrder:18; aiSort)  //[RM_GROUP]Commodity_Group;asCCgroup;
			If ((sCC="") | (iCCseq=0))  //•053095  MLB  UPR 1501
				PSpecEstimateLd(""; "Materials")
			Else   //just get the existing matl for this sequence number
				QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1; *)
				QUERY:C277([Process_Specs_Materials:56];  & ; [Process_Specs_Materials:56]Sequence:4=iCCseq)
			End if 
			
			SELECTION TO ARRAY:C260([Process_Specs_Materials:56]; alRelTemp; [Process_Specs_Materials:56]Sequence:4; aiSeq; [Process_Specs_Materials:56]Commodity_Key:8; asCC; [Process_Specs_Materials:56]RMName:6; asCCname)
			
		: (vSetupWhat="Machine-OnePage")
			iResequence:=0
			vListName1:="Machine Sequence"
			vListName2:="Available Machines"
			// ALL RECORDS([RM_GROUP])  `get the raw material group records
			$numRecs:=qryCostCtrTable("@")
			ARRAY TEXT:C222(asCCName2; 0)
			//DISTINCT VALUES(;asCCName2)
			ARRAY TEXT:C222(asCC2; Size of array:C274(asCCName2))
			ARRAY INTEGER:C220(aiSort; Size of array:C274(asCCName2))
			For ($i; 1; Size of array:C274(asCCName2))
				qryCostCenter(asCCName2{$i})
				asCC2{$i}:=[Cost_Centers:27]Description:3
				aiSort{$i}:=[Cost_Centers:27]DisplayOrder:40
			End for 
			SORT ARRAY:C229(aiSort; asCC2; asCCName2; >)  //asCCgroup
			
			ARRAY LONGINT:C221(alRelTemp; Size of array:C274(aCCseq))
			ARRAY INTEGER:C220(aiSeq; Size of array:C274(aCCseq))
			ARRAY TEXT:C222(asCC; Size of array:C274(aCCseq))
			ARRAY TEXT:C222(asCCname; Size of array:C274(aCCseq))
			For ($i; 1; Size of array:C274(aCCseq))
				aiSeq{$i}:=aCCseq{$i}
				asCC{$i}:=Substring:C12(aCCname{$i}; 1; 3)
				asCCname{$i}:=Substring:C12(aCCname{$i}; 5)
			End for 
			
		: (vSetupWhat="Material-OnePage")
			iResequence:=0
			vListName1:="Material Sequence"
			vListName2:="Available Materials"
			// ALL RECORDS([RM_GROUP])  `get the raw material group records
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]UseForEst:12=True:C214)
			SELECTION TO ARRAY:C260([Raw_Materials_Groups:22]Commodity_Key:3; asCC2; [Raw_Materials_Groups:22]Description:2; asCCName2; [Raw_Materials_Groups:22]DisplayOrder:18; aiSort)  //[RM_GROUP]Commodity_Group;asCCgroup;
			
		: ((vSetupWhat="Material-Prep") | (vSetupWhat="Material-Prod"))
			iResequence:=0
			vListName1:="Material Sequence"
			vListName2:="Available Materials"
			//ALL RECORDS([RM_GROUP])  `get the raw material group records
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]UseForEst:12=True:C214)
			SELECTION TO ARRAY:C260([Raw_Materials_Groups:22]Commodity_Key:3; asCC2; [Raw_Materials_Groups:22]Description:2; asCCName2; [Raw_Materials_Groups:22]DisplayOrder:18; aiSort)  //[RM_GROUP]Commodity_Group;asCCgroup;
			QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
			SELECTION TO ARRAY:C260([Estimates_Materials:29]; alRelTemp; [Estimates_Materials:29]Sequence:12; aiSeq; [Estimates_Materials:29]Commodity_Key:6; asCC; [Estimates_Materials:29]RMName:10; asCCname)  //;[Material_Est]CostCtrID;asCust)  `[Material_Est]CostCtrID;asCCGroup1;[Material_
			
		: (vSetupWhat="Process")
			vListName1:="Operation Sequence"
			vListName2:="Available Cost Centers"
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ProdCC:39=True:C214)
			If (False:C215)
				SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; asCC2; [Cost_Centers:27]Description:3; asCCName2; [Cost_Centers:27]DisplayOrder:40; aiSort)
			Else 
				SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; asCCName2; [Cost_Centers:27]Description:3; asCC2; [Cost_Centers:27]DisplayOrder:40; aiSort)
			End if 
			PSpecEstimateLd("Machines")
			SELECTION TO ARRAY:C260([Process_Specs_Machines:28]; alRelTemp; [Process_Specs_Machines:28]Seq_Num:3; aiSeq; [Process_Specs_Machines:28]CostCenterID:4; asCC; [Process_Specs_Machines:28]CostCtrName:5; asCCname)  //;[Operation_Seqs]CostCenterID;asCust)  `[Operation_Seqs]CCGroup;asCCGroup1;[Oper
			
		: (vSetupWhat="Form")
			vListName1:="Production Sequence"
			vListName2:="Available Cost Centers"
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ProdCC:39=True:C214)
			If (False:C215)
				SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; asCC2; [Cost_Centers:27]Description:3; asCCName2; [Cost_Centers:27]DisplayOrder:40; aiSort)
			Else 
				SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; asCCName2; [Cost_Centers:27]Description:3; asCC2; [Cost_Centers:27]DisplayOrder:40; aiSort)
			End if 
			QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
			
			//SELECTION TO ARRAY([Machine_Est];alRelTemp;[Machine_Est]Sequence;aiSeq;
			//[Machine_Est]CostCtrID;asCC;[Machine_Est]CCName;asCCname)
			//the (split) line above fails, so let revert to 4D version 2 style
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				FIRST RECORD:C50([Estimates_Machines:20])
				$NumMach:=Records in selection:C76([Estimates_Machines:20])
				ARRAY LONGINT:C221(alRelTemp; $NumMach)
				ARRAY INTEGER:C220(aiSeq; $NumMach)
				ARRAY TEXT:C222(asCC; $NumMach)
				ARRAY TEXT:C222(asCCname; $NumMach)
				
				For ($i; 1; $NumMach)
					alRelTemp{$i}:=Record number:C243([Estimates_Machines:20])
					aiSeq{$i}:=[Estimates_Machines:20]Sequence:5
					asCC{$i}:=[Estimates_Machines:20]CostCtrID:4
					asCCname{$i}:=[Estimates_Machines:20]CostCtrName:2
					NEXT RECORD:C51([Estimates_Machines:20])
				End for 
				
				
			Else 
				
				ARRAY LONGINT:C221(alRelTemp; 0)
				ARRAY INTEGER:C220(aiSeq; 0)
				ARRAY TEXT:C222(asCC; 0)
				ARRAY TEXT:C222(asCCname; 0)
				
				SELECTION TO ARRAY:C260([Estimates_Machines:20]; alRelTemp; [Estimates_Machines:20]Sequence:5; aiSeq; [Estimates_Machines:20]CostCtrID:4; asCC; [Estimates_Machines:20]CostCtrName:2; asCCname)
				
				
			End if   // END 4D Professional Services : January 2019 First record
			
		: (vSetupWhat="Prep")
			vListName1:="Prep Sequence"
			vListName2:="Available Cost Centers"
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]PrepCC:38=True:C214)
			If (False:C215)
				SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; asCC2; [Cost_Centers:27]Description:3; asCCName2; [Cost_Centers:27]DisplayOrder:40; aiSort)
			Else 
				SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; asCCName2; [Cost_Centers:27]Description:3; asCC2; [Cost_Centers:27]DisplayOrder:40; aiSort)
			End if 
			SELECTION TO ARRAY:C260([Estimates_Machines:20]; alRelTemp; [Estimates_Machines:20]Sequence:5; aiSeq; [Estimates_Machines:20]CostCtrID:4; asCC; [Estimates_Machines:20]CostCtrName:2; asCCname)  //;[Machine_Est]CostCtrID;asCust)  `[Machine_Est]CostCtrID;asCCGroup1;[Machine_Est
			
	End case 
	
	SORT ARRAY:C229(aiSort; asCC2; asCCName2; >)  //asCCgroup
	//$T:=Size of array(aiseq)  `preserve sequence number for use as a key in updating
	// For ($i;1;$T)`               **now using alRelTemp
	// asCust{$i}:=String(aiSeq{$i})
	// End for 
	SORT ARRAY:C229(aiSeq; asCC; asCCname; alRelTemp; >)  //asCCGroup1;
	// initNum:=Size of array(aiSeq)  `what's this used for?
	If (iResequence=1)
		For ($i; 1; Size of array:C274(aiSeq))  //reorganize sequence #'s
			aiSeq{$i}:=10*$i
		End for 
	End if 
	
End if 

//