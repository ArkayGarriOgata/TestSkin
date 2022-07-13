$tag:=Num:C11(sCriterion5)
Case of 
	: ($tag<lowTag)
		BEEP:C151
		ALERT:C41("Check your tag number, range = "+String:C10(lowTag)+" to "+String:C10(highTag))
		//GOTO AREA(sCriterion5)
	: ($tag>highTag)
		BEEP:C151
		ALERT:C41("Check your tag number, range = "+String:C10(lowTag)+" to "+String:C10(highTag))
		
	Else 
		C_LONGINT:C283($dupTags)
		$dupTags:=0
		SET QUERY DESTINATION:C396(Into variable:K19:4; $dupTags)
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Adjust"; *)  //don't get a receiver
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3>=(Current date:C33-5); *)  //don't get from prior year
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=(Current date:C33+5); *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]ReceivingNum:23=(String:C10($tag)))  //strip out leading zeros
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		If ($dupTags>0)
			BEEP:C151
			ALERT:C41("Check your tag number, "+sCriterion5+", it looks like a duplicate.")
		End if 
		//GOTO AREA(sCriterion5)
End case 
//