//%attributes = {"publishedWeb":true}
//(P) gMTAccept
//12/19/94
//12/22/94`    don't validate
//upr 1425 2/9/95
//•062695  MLB  UPR 220 add the 487
//•092895  MLB  UPR 1720 add the 488
//050196 TJF
// Modified by: Mel Bohince (5/30/17) fix line 64
C_BOOLEAN:C305($valid)
C_LONGINT:C283($row)

$valid:=True:C214

Case of 
	: (Length:C16(sMAJob)<7)
		ALERT:C41("Invalid Job Number - Please Try Again!!!")
		GOTO OBJECT:C206(sMAJob)
		
	: (Find in array:C230(asChkJob; sMAJob)=-1)
		sMAJob:=""
		ALERT:C41("Invalid Job - Please Try Again!!!")
		GOTO OBJECT:C206(sMAJob)
		
	: (Find in array:C230(aStdCC; sMACC)=-1)
		sMACC:=""
		ALERT:C41("Invalid Cost Center - Please try again!!!")
		GOTO OBJECT:C206(sMACC)
		
	Else 
		//```````````````````````````````````````    
		//BAK 8/23/94 - Find if not Budgeted    
		//``````````````````````````````````````````    
		sCostCenter:=CostCtr_Substitution(sMACC)  //050196 TJF replaces if(false) code above
		//QUERY([Machine_Job];[Machine_Job]JobForm=sMAJob;*)  `validate the budget
		//QUERY([Machine_Job]; & ;[Machine_Job]Sequence=iMASeq)
		Case of 
			: (True:C214)  //12/22/94
				//     melissa does want to validate against the budget.
			: (Records in selection:C76([Job_Forms_Machines:43])=0)
				BEEP:C151
				ALERT:C41("Sequence number "+String:C10(iMASeq)+" not found on Job Form "+sMAJob+"'s budget.")
				$valid:=False:C215
				
			: (sCostCenter=sMACC)
				QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4=sCostCenter)
				If (Records in selection:C76([Job_Forms_Machines:43])=0)
					BEEP:C151
					ALERT:C41("Cost Center "+sCostCenter+" is not on that budget at sequence "+String:C10(iMASeq)+".")
					$valid:=False:C215
				End if 
				
			Else   //their was a substitution
				QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4=sCostCenter; *)
				QUERY SELECTION:C341([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4=sMACC)
				If (Records in selection:C76([Job_Forms_Machines:43])=0)
					BEEP:C151
					ALERT:C41("Neither Cost Center "+sMACC+" or "+sCostCenter+" is not on that budget at sequence "+String:C10(iMASeq)+".")
					$valid:=False:C215
				End if 
		End case 
		
		If ($valid)
			If (fNewMT)
				i:=Size of array:C274(adMADate)+1  // Modified by: Mel Bohince (5/30/17) was //i:=i+1
				gMTsizeArrays(i)
				$row:=i
			Else 
				$row:=adMADate
			End if 
			
			adMADate{$row}:=dMADate
			asMAJob{$row}:=sMAJob
			aiMASeq{$row}:=iMASeq
			asMACC{$row}:=sMACC
			aiMAItemNo{$row}:=iMAItemNo
			arMAMRHours{$row}:=rMAMRHours
			arMARHours{$row}:=rMARHours
			arMADTHours{$row}:=rMADTHours
			asMADTCat{$row}:=sMADTCat
			alMAGood{$row}:=lMAGood
			alMAWaste{$row}:=lMAWaste
			aiShift{$row}:=iShift
			asP_C{$row}:=Substring:C12(sP_C; 1; 1)
			aRecNo{$row}:=0
			aMRcode{$row}:=tMRcode
			gMTsetArrays
			gClearMT(dMADate)
			GOTO OBJECT:C206(sMAJob)
		End if   //valid
		
End case 