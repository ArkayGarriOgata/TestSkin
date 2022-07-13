//(S) [CONTROL]RMTransfer'bPost

Case of 
	: (asFrom{0}="")
		BEEP:C151
		zwStatusMsg("ALERT"; "A 'from' location is required to proceed.")
		GOTO OBJECT:C206(asFrom)
		
	: (asMove{0}="")
		BEEP:C151
		zwStatusMsg("ALERT"; "A 'to' location is required to proceed.")
		GOTO OBJECT:C206(asMove)
		
	: (Not:C34(sVerifyLocation(->asMove{0})))
		zwStatusMsg("ALERT"; "The 'to' location is not valid.")
		asMove{0}:=""
		GOTO OBJECT:C206(asMove)
		
	: (wms_locationsRequiringReason(asMove{0})) & (Length:C16(sCriterion7)=0)
		BEEP:C151
		zwStatusMsg("ALERT"; "A Reason Explanation is required to proceed.")
		sCriterion9:="Reject"
		SetObjectProperties("Reason@"; -><>NULL; True:C214)
		GOTO OBJECT:C206(sCriterion7)
		
	: (Length:C16(sJobit)#11)
		BEEP:C151
		zwStatusMsg("ALERT"; "A job item (lot) is required in the format of 12345.12.12 to proceed.")
		GOTO OBJECT:C206(sJobit)
		
	: (Length:C16(sCriter10)=0)
		BEEP:C151
		zwStatusMsg("ALERT"; "A Skid Ticket# is required to proceed.")
		GOTO OBJECT:C206(sCriter10)
		
	: (rReal1=0)
		BEEP:C151
		zwStatusMsg("ALERT"; "A quantity is required to proceed.")
		GOTO OBJECT:C206(rReal1)
		
	: (rReal1>2000000)
		BEEP:C151
		zwStatusMsg("ALERT"; "A quantity must be under 2,000,000.")
		GOTO OBJECT:C206(rReal1)
		
	Else 
		zwStatusMsg("Posting #"+sCriter10; " Please Wait...")
		sCriterion3:=asFrom{0}
		sCriterion4:=asMove{0}
		
		If (Substring:C12(sCriterion4; 1; 2)="EX")
			$noticeTo:=Batch_GetDistributionList(""; "QA_MOVE")
			EMAIL_Sender("Move to "+sCriterion4+" - "+sCriterion1; ""; sCriterion1+" was moved into an Examining location."; $noticeTo)
		End if 
		
		If (Substring:C12(sCriterion4; 1; 2)="XC")
			$noticeTo:=Batch_GetDistributionList(""; "QA_MOVE")
			EMAIL_Sender("Move to "+sCriterion4+" - "+sCriterion1; ""; sCriterion1+" was moved into an ReCertification location."; $noticeTo)
		End if 
		
		FG_Move
		zwStatusMsg("Posted #"+sCriter10; " Enter the next skid")
		
		
		sCriter10:=""
		sCriterion1:=""
		sCriterion2:=""
		sCriterion3:=""
		sCriterion4:=""
		sCriterion5:=""
		sCriterion6:=""
		sCriterion9:=""
		sCriterion7:=""
		i1:=0
		rReal1:=0
		sJobit:=""
		asMove{0}:=""
		asFrom{0}:=""
		SetObjectProperties("Reason@"; -><>NULL; False:C215)
		GOTO OBJECT:C206(sCriter10)
End case 