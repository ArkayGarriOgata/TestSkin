// -------
// Method: [Job_Forms_Machine_Tickets].StartSequence   ( ) ->
// By: Mel Bohince @ 12/21/17, 08:13:31
// Description
// 
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Load:K2:1)
		
		If (Is new record:C668([Job_Forms_Machine_Tickets:61]))
			If (iSeq>0)
				[Job_Forms_Machine_Tickets:61]JobForm:1:=sCriterion1
				[Job_Forms_Machine_Tickets:61]Sequence:3:=iSeq
				[Job_Forms_Machine_Tickets:61]DateEntered:5:=dDate
				[Job_Forms_Machine_Tickets:61]Shift:18:=iShift
				[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4:=iItem
				[Job_Forms_Machine_Tickets:61]Operator:27:=iOperator
				[Job_Forms_Machine_Tickets:61]MR_Act:6:=0.0833
				[Job_Forms_Machine_Tickets:61]TimeStampEntered:17:=TSTimeStamp
				
				If (Position:C15(sCC; <>GLUERS)>0)  //use what is on glue schedule
					[Job_Forms_Machine_Tickets:61]CostCenterID:2:=sCC
				Else   //use what is inthe production schedule
					$schdCC:=PS_getCostCenter(sCriterion1+"."+String:C10(iSeq; "000"))
					If (Length:C16($schdCC)=3)
						[Job_Forms_Machine_Tickets:61]CostCenterID:2:=$schdCC
					Else 
						[Job_Forms_Machine_Tickets:61]CostCenterID:2:=sCC
					End if 
				End if 
				
				
				
			End if 
			
		Else   //existing record
			BEEP:C151
			CANCEL:C270
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		zwStatusMsg("SAVED"; [Job_Forms_Machine_Tickets:61]JobForm:1+"."+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3; "000")+" STARTED")
End case 