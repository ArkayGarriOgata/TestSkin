//(S) [CONTROL]RMTransfer'bPost
//•061295  MLB  UPR 1640 tweak for B&H

Case of 
	: (sCriterion1="")
		BEEP:C151
		ALERT:C41("A customer product number is required to proceed.")
	: (sCriterion2="") | (sCriterion2="00000")
		BEEP:C151
		ALERT:C41("A customer number is required to proceed.")
	: (sCriterion3="")
		BEEP:C151
		ALERT:C41("A 'from' location is required to proceed.")
	: (sCriterion4="")
		BEEP:C151
		ALERT:C41("A 'to' location is  required to proceed.")
	: (sCriterion5="")
		BEEP:C151
		ALERT:C41("A job number is required to proceed.")
	: (i1=0) & (iMode#5)  //•061295  MLB  UPR 1640
		BEEP:C151
		ALERT:C41("A job item is required to proceed.")
	: (sCriterion6="")
		BEEP:C151
		ALERT:C41("An order number is required to proceed.")
	: (rReal1=0)
		BEEP:C151
		ALERT:C41("A quantity is required to proceed.")
		
	Else 
		uMsgWindow("Posting. Please Wait...")
		Case of 
			: (iMode=1)  //Return
				If (Num:C11(sCriter12)=0)
					BEEP:C151
					ALERT:C41("An Arkay Release number  or RGA is required to process a return.")
					REJECT:C38
				End if 
				FG_return
				//reset skid#
				sCriter10:=<>zResp+fYYMMDD(Current date:C33; 4)+"-"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")  //""  //   skid ticket
				
				GOTO OBJECT:C206(rReal1)
		End case 
		rReal1:=0
End case 