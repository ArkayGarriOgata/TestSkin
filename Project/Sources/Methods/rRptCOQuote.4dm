//%attributes = {"publishedWeb":true}
//rRptCOQuote: [ESTIMATE] Quote
//upr 1143 7/28/94
//upr 1161 8/9/94
//10/12/94 upr 1136
//upr 1458 4/5/95
//•072795  MLB  UPR 216
//•081595  MLB  remove text2array2

If (Est_OkToQuote([Estimates:17]EstimateNo:1))  //•3/21/00  mlb 
	C_TEXT:C284($1)  //`no dialogs
	C_BOOLEAN:C305($chgStatus)
	C_LONGINT:C283($numDiffs)
	READ ONLY:C145([Customers:16])
	//*Dialog for which differentials and what style of quote
	OpenSheetWindow(->[zz_control:1]; "QuoteSelect")  //;"wCloseOption")
	If (Count parameters:C259=1)  //•072795  MLB  UPR 216
		rbAvon:=0
		rbPrint:=0
		rbCopy:=1
		ARRAY TEXT:C222(asBull; 0)
		ARRAY TEXT:C222(asDiff; 0)
		ARRAY TEXT:C222(asCaseID; 0)
		MESSAGE:C88("Gathering all differentials...")
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)  //get case scenarios, carton specs
		SELECTION TO ARRAY:C260([Estimates_Differentials:38]diffNum:3; asCaseID; [Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff)
		$numDiffs:=Size of array:C274(asDiff)
		SORT ARRAY:C229(asCaseID; asDiff; >)
		ARRAY TEXT:C222(asBull; $numDiffs)
		If ($1="*")  //•081495  MLB  
			For ($i; 1; $numDiffs)
				asBull{$i}:="•"
			End for 
		Else 
			For ($i; 1; $numDiffs)
				If (asCaseID{$i}=$1)
					asBull{$i}:="•"
				End if 
			End for 
		End if 
		
		OK:=1
		
	Else 
		DIALOG:C40([zz_control:1]; "QuoteSelect")
	End if 
	CLOSE WINDOW:C154
	
	If (ok=1)
		If ([Customers:16]ID:1#[Estimates:17]Cust_ID:2)
			//MESSAGE(Char(13)+" Searching for Customer...")
			QUERY:C277([Customers:16]; [Customers:16]ID:1=[Estimates:17]Cust_ID:2)
		End if 
		//*See if estimate status should be later set to quoted
		$continue:=True:C214
		Case of 
			: (Position:C15("Priced"; [Estimates:17]Status:30)#0)
				uConfirm("Change the Estimate status to Quoted?"; "Yes"; "No")
				If (ok=1)
					//MESSAGE(Char(13)+" Estimate will be set to the Quoted status.")
					$chgStatus:=True:C214
				Else 
					//MESSAGE(Char(13)+" Estimate will not be set to the Quoted status.")
					$chgStatus:=False:C215
				End if 
				
			: ([Estimates:17]Status:30="Quoted")
				//MESSAGE(Char(13)+" Estimate is already in Quoted status.")
				$chgStatus:=False:C215
				
			: (Position:C15("Hold"; [Estimates:17]Status:30)#0)
				uConfirm("This Estimate is on Hold and may not be Quoted at this time."; "OK"; "Help")
				$chgStatus:=False:C215
				$continue:=False:C215
				
			Else 
				uConfirm("Note: this printing cannot change the status to quoted at this time."; "OK"; "Help")
				MESSAGE:C88(Char:C90(13)+" Estimate is not ready to be placed in the Quoted status.")
				$chgStatus:=False:C215
		End case 
		
		If ($continue)
			If (rbAvon=1)
				//*If this is an avon style quote    
				PRINT SETTINGS:C106
				If (ok=1)
					//*.   for each selected differential      
					For ($i; 1; Size of array:C274(asBull))
						If (asBull{$i}="•")
							//*.      Get the caseScen, p-spec, forms, and cartons          
							QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=[Estimates:17]EstimateNo:1+asCaseID{$i})
							QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_Differentials:38]ProcessSpec:5)  //assume 1 pspec /diff
							gPresswork  //this proc looks alittle sketchy - I won't take that personally
							QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3=[Estimates_Differentials:38]Id:1)  //assume 1 form
							QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
							QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=asCaseID{$i})
							If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
								
								ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
								FIRST RECORD:C50([Estimates_Carton_Specs:19])
								
								
							Else 
								
								ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
								
							End if   // END 4D Professional Services : January 2019 First record
							// 4D Professional Services : after Order by , query or any query type you don't need First record  
							//*.         For each carton print a one page report
							While (Not:C34(End selection:C36([Estimates_Carton_Specs:19])))  //print one for each            
								Print form:C5([Estimates:17]; "RptQuoteAvon")
								PAGE BREAK:C6(>)
								NEXT RECORD:C51([Estimates_Carton_Specs:19])
							End while 
							
							PAGE BREAK:C6
						End if 
					End for 
				End if 
				
			Else   //build the text block 
				//*If this is an reqular letter style quote    
				t1:=""
				//*.   for each selected differential   
				For ($i; 1; Size of array:C274(asBull))
					If (asBull{$i}="•")
						//*.      Get the caseScen, p-spec, forms  
						QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=[Estimates:17]EstimateNo:1+asCaseID{$i})
						QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_Differentials:38]ProcessSpec:5)  //assume 1 pspec /diff
						t1:=t1+Char:C90(13)+Char:C90(13)+String:C10(4D_Current_date; 5)+Char:C90(13)+Char:C90(13)
						t1:=t1+fGetAddressText([Estimates:17]z_Bill_To_ID:5)+Char:C90(13)+Char:C90(13)
						t1:=t1+"Dear "+[Addresses:30]Name:2+":"+Char:C90(13)+Char:C90(13)
						t1:=t1+"We are pleased to submit our proposal based upon our understanding of your "
						t1:=t1+"specifications and our terms which appear on the reverse of this proposal."+Char:C90(13)+Char:C90(13)
						xText2:="Committed to Excellence through Price Effectiveness, Quality, Dependability,"
						xText2:=xText2+" Flexibility and Innovation."+Char:C90(13)+Char:C90(13)
						//*.      build the body of the letter by listing all the cartons and their detial
						gRptQuoteBody($i)
						t1:=t1+sIntro+Char:C90(13)+Char:C90(13)
					End if 
				End for 
				
				If (rbPrint=1)
					//*.      Either print the letter or display in a dialog box copy|pasted
					util_PAGE_SETUP(->[Estimates:17]; "RptQuoteH1")
					PRINT SETTINGS:C106
					If (ok=1)
						pixels:=0
						maxPixels:=700
						iPage:=1
						sIntro:=""
						For ($i; 1; 10)
							uChk4RoomQD(55; 15; "RptQuoteD")
						End for 
						
						ARRAY TEXT:C222(axText; 0)
						uText2Array2(t1; axText; 530; "Helvetica"; 10; 0)
						For ($i; 1; Size of array:C274(axText))
							sStr255:=axText{$i}
							sIntro:=sStr255
							uChk4RoomQD(55; 15; "RptQuoteD")
						End for 
						PAGE BREAK:C6
					End if 
					
				Else   //rbCopy=1   
					OpenSheetWindow(->[zz_control:1]; "text2_dio")
					DIALOG:C40([zz_control:1]; "text2_dio")
					CLOSE WINDOW:C154
				End if 
				
			End if 
			//*Change status on estimate to quoted  
			If ($chgStatus)
				<>EstStatus:="Quoted"
				<>EstNo:=[Estimates:17]EstimateNo:1
				$id:=New process:C317("uChgEstStatus"; <>lMinMemPart; "Estimate Status Change")
			End if 
		End if 
	End if 
	
	If (Count parameters:C259#1)
		gEstimateLDWkSh("Wksht")
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)
		QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=[Estimates:17]EstimateNo:1)
		
	Else 
		UNLOAD RECORD:C212([Estimates:17])
	End if 
	xText:=""
	xText2:=""
End if 