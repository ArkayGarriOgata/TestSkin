C_LONGINT:C283($itemSelected)
C_TEXT:C284($itemValue)
$itemSelected:=aReports
$itemValue:=aReports{aReports}

Case of 
	: ($itemSelected<3)
		//do nothing
		
	: ($itemValue="RFQ")
		SAVE RECORD:C53([Estimates:17])
		rRpt_1_RFQ(1)
		
	: ($itemValue="Cost & Quantity")
		SAVE RECORD:C53([Estimates:17])  //• 3/2/98 cs 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			COPY NAMED SELECTION:C331([Estimates:17]; "ToPrint")  //• 1/21/98 cs 
			COPY NAMED SELECTION:C331([Estimates_Differentials:38]; "printing")
			ONE RECORD SELECT:C189([Estimates:17])  //• 4/13/98 cs 
			rRptEstimate
			USE NAMED SELECTION:C332("printing")
			CLEAR NAMED SELECTION:C333("printing")
			USE NAMED SELECTION:C332("ToPrint")  //• 1/21/98 cs  
			CLEAR NAMED SELECTION:C333("ToPrint")  //• 1/21/98 cs 
			
		Else 
			
			ARRAY LONGINT:C221($_ToPrint; 0)
			ARRAY LONGINT:C221($_printing; 0)
			LONGINT ARRAY FROM SELECTION:C647([Estimates:17]; $_ToPrint)
			LONGINT ARRAY FROM SELECTION:C647([Estimates_Differentials:38]; $_printing)
			
			ONE RECORD SELECT:C189([Estimates:17])  //• 4/13/98 cs 
			rRptEstimate
			
			CREATE SELECTION FROM ARRAY:C640([Estimates:17]; $_ToPrint)
			CREATE SELECTION FROM ARRAY:C640([Estimates_Differentials:38]; $_printing)
			
		End if   // END 4D Professional Services : January 2019 
		
	: ($itemValue="Quote...")
		rRptCOQuote
		
	: ($itemValue="Quote Detail")
		$estRec:=Record number:C243([Estimates:17])
		CUT NAMED SELECTION:C334([Estimates:17]; "holdWhileQuote")
		GOTO RECORD:C242([Estimates:17]; $estRec)
		rRpt_1_Quote
		USE NAMED SELECTION:C332("holdWhileQuote")
		
	: ($itemValue="Quote Letter")
		$estRec:=Record number:C243([Estimates:17])
		CUT NAMED SELECTION:C334([Estimates:17]; "holdWhileQuote")
		GOTO RECORD:C242([Estimates:17]; $estRec)
		rRptCOQuote("*")
		USE NAMED SELECTION:C332("holdWhileQuote")
End case 

aReports:=1