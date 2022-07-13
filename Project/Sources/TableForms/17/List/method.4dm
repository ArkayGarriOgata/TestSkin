app_basic_list_form_method

Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		$numFound:=0  // Modified by: Mel Bohince (6/9/21) 
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)  //find Estimate Qty worksheet
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		numMat:=$numFound
		QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=[Estimates:17]EstimateNo:1)
		numProcess:=$numFound
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)
		numDiffs:=$numFound
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
	: (Form event code:C388=On Load:K2:1)
		SET TIMER:C645(60*60*2)  //every 2 minutes
		
	: (Form event code:C388=On Timer:K2:25)
		C_TEXT:C284(thisActivity)  // Added by: Mark Zinke (5/17/13)
		Case of 
			: (thisActivity="estimating")
				BEEP:C151
				zwStatusMsg("Refresh"; "Re-selecting Estimates in the RFQ status at "+TS2String(TSTimeStamp))
				QUERY:C277([Estimates:17]; [Estimates:17]Status:30="RFQ")  //•082802  mlb  UPR
				NumRecs1:=Records in selection:C76([Estimates:17])
				ORDER BY:C49([Estimates:17]; [Estimates:17]DateRFQ:52; >; [Estimates:17]DateRFQTime:53; >)
				
				ACCEPT:C269
				
				CREATE SET:C116([Estimates:17]; "◊LastSelection"+String:C10(Table:C252(->[Estimates:17])))
				SET WINDOW TITLE:C213(fNameWindow(->[Estimates:17]))
				
		End case 
		
End case 

