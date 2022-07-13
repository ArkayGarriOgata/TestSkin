// _______
// Method: [zz_control].FGTranfers.PostFGTransfer   ( ) ->
//•061295  MLB  UPR 1640 tweak for B&H
// Modified by: Mel Bohince (7/30/19) remove hardcoded email addressess
$successful:=True:C214
$valid_inputs:=False:C215
Case of   //do some validation first
	: (sCriterion1="")
		BEEP:C151
		zwStatusMsg("ALERT"; "A customer product number is required to proceed.")
		GOTO OBJECT:C206(sCriterion1)
		
	: (sCriterion2="") | (sCriterion2="00000")
		BEEP:C151
		zwStatusMsg("ALERT"; "A customer number is required to proceed.")
		GOTO OBJECT:C206(sCriterion2)
		
	: (sCriterion3="")
		BEEP:C151
		zwStatusMsg("ALERT"; "A 'from' location is required to proceed.")
		GOTO OBJECT:C206(sCriterion3)
		
	: (sCriterion4="")
		BEEP:C151
		zwStatusMsg("ALERT"; "A 'to' location is  required to proceed.")
		GOTO OBJECT:C206(sCriterion4)
		
	: (wms_locationsRequiringReason(sCriterion4)) & (Length:C16(sCriterion7)=0)
		BEEP:C151
		zwStatusMsg("ALERT"; "A Reason Explanation is required to proceed.")
		GOTO OBJECT:C206(sCriterion7)
		
	: (sCriterion5="")
		BEEP:C151
		zwStatusMsg("ALERT"; "A job number is required to proceed.")
		GOTO OBJECT:C206(sCriterion5)
		
	: (i1=0) & (iMode#5)  //•061295  MLB  UPR 1640
		BEEP:C151
		zwStatusMsg("ALERT"; "A job item is required to proceed.")
		GOTO OBJECT:C206(i1)
		
	: (Length:C16(sCriter10)=0) & (iMode=2)
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
		
	: (iMode=5) & (Not:C34(ADDR_isValid([Customers_Order_Lines:41]defaultBillto:23)))
		uConfirm([Customers_Order_Lines:41]OrderLine:3+" does not appear to have a valid bill-to"; "Ok"; "Help")
		sCriterion6:=""
		EDIT ITEM:C870(sCriterion6)
		UNLOAD RECORD:C212([Customers_Order_Lines:41])
		
	: (iMode=5) & (Not:C34(ADDR_isValid([Customers_Order_Lines:41]defaultShipTo:17)))
		uConfirm([Customers_Order_Lines:41]OrderLine:3+" does not appear to have a valid ship-to"; "Ok"; "Help")
		sCriterion6:=""
		EDIT ITEM:C870(sCriterion6)
		UNLOAD RECORD:C212([Customers_Order_Lines:41])
		
		
	Else 
		$valid_inputs:=True:C214
End case 

zwStatusMsg("Posting #"+sCriter10; " Please Wait...")
Case of 
	: (Not:C34($valid_inputs))
		$successful:=False:C215
		
	: (iMode=0)  //Move        
		$continue:=True:C214
		$noticeTo:="brian.hopkins@arkay.com"+Char:C90(9)
		
		
		If (Substring:C12(sCriterion4; 1; 2)="EX")
			$noticeTo:=Batch_GetDistributionList(""; "QA_MOVE")  // Modified by: Mel Bohince (7/30/19) remove hardcode
			EMAIL_Sender("Move to "+sCriterion4+" - "+sCriterion1; ""; sCriterion1+" was moved into an Examining location."; $noticeTo)
		End if 
		
		If (Substring:C12(sCriterion4; 1; 2)="XC")
			$noticeTo:=Batch_GetDistributionList(""; "QA_MOVE")  // Modified by: Mel Bohince (7/30/19) remove hardcode
			EMAIL_Sender("Move to "+sCriterion4+" - "+sCriterion1; ""; sCriterion1+" was moved into an ReCertification location."; $noticeTo)
		End if 
		
		If ($continue)
			FG_Move
			zwStatusMsg("Posted"; " Enter the next skid")
		Else 
			BEEP:C151
			zwStatusMsg("Cancelled"; " Enter the next skid")
		End if 
		sCriterion9:=""
		sCriterion7:=""
		GOTO OBJECT:C206(rReal1)
		
	: (iMode=1)  //Return
		If (Num:C11(sCriter12)=0)
			BEEP:C151
			ALERT:C41("An Arkay Release number is required to process a return.")
			REJECT:C38
		End if 
		FG_return
		GOTO OBJECT:C206(rReal1)
		
	: (iMode=2)  //Receive
		$successful:=FG_receive_from_WIP
		If ($successful)
			GOTO OBJECT:C206(rReal1)
		End if 
		
	: (iMode=3)  //Labels
		//uFGlabels 
		GOTO OBJECT:C206(rReal1)
		
	: (iMode=4)  //Destroy
		FG_DestroyIfNotReferenced
		//sCriterion3:=""
		GOTO OBJECT:C206(sCriterion3)
		
	: (iMode=5)  //bill and hold
		$successful:=FG_BillAndHold
		sCriterion1:=""  //        cpn
		sCriterion5:="00000.00"
		sCriterion6:="00000.00"
		sCriterion7:=""
		sCriterion9:=""
		sJobit:=""
		EDIT ITEM:C870(sJobit)
End case 

If ($successful)  //reset
	rReal1:=0
	bLastSkid1:=1
	bLastSkid2:=0
	
	zwStatusMsg("Posted #"+sCriter10; " Enter the next skid")
	sCriter10:=<>zResp+fYYMMDD(Current date:C33; 4)+"-"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")
	
Else 
	BEEP:C151
	uConfirm("A record was locked or invalid date"; "Try Again"; "Help")
	zwStatusMsg("FAILED #"+sCriter10; " Try again later")
End if 
