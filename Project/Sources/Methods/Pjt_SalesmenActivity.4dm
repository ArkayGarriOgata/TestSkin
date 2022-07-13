//%attributes = {"publishedWeb":true}
//PM: Pjt_SalesmenActivity() -> 
//@author mlb - 11/7/01  09:43

C_DATE:C307(dDateEnd)
C_TEXT:C284($t; $cr)
C_TIME:C306($docRef)
C_LONGINT:C283($i; $j; $k; $fiscalYear; $numReps; $numBook; $numEst; $numInv; $numRel; $numReq)

MESSAGES OFF:C175
zwStatusMsg("PROJECT"; "Salesmen Activity")
READ ONLY:C145([Salesmen:32])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Bookings:93])
READ ONLY:C145([Estimates:17])
READ ONLY:C145([Customers_Invoices:88])

dDateEnd:=4D_Current_date
$cr:=Char:C90(13)
$t:=Char:C90(9)
$fiscalYear:=Num:C11(FiscalYear("year"; dDateEnd))
$fiscalStart:=Date:C102(FiscalYear("start"; dDateEnd))
xText:=""

ALL RECORDS:C47([Salesmen:32])
ORDER BY:C49([Salesmen:32]; [Salesmen:32]LastName:2; >)
$numReps:=Records in selection:C76([Salesmen:32])
uThermoInit($numReps; "Finding Activity by Salesman")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; $numReps)
		xText:=xText+[Salesmen:32]LastName:2+", "+[Salesmen:32]FirstName:3+$cr
		
		QUERY:C277([Customers:16]; [Customers:16]SalesmanID:3=[Salesmen:32]ID:1; *)
		QUERY:C277([Customers:16];  & ; [Customers:16]Active:15=True:C214)
		ORDER BY:C49([Customers:16]; [Customers:16]Name:2; >)
		
		For ($j; 1; Records in selection:C76([Customers:16]))
			QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2=$fiscalYear; *)
			QUERY:C277([Customers_Bookings:93];  & ; [Customers_Bookings:93]Custid:1=[Customers:16]ID:1)
			$numBook:=Records in selection:C76([Customers_Bookings:93])
			
			QUERY:C277([Estimates:17]; [Estimates:17]Cust_ID:2=[Customers:16]ID:1; *)
			QUERY:C277([Estimates:17];  & ; [Estimates:17]DateOriginated:19>=$fiscalStart; *)
			QUERY:C277([Estimates:17];  & ; [Estimates:17]DateOriginated:19<=dDateEnd; *)
			QUERY:C277([Estimates:17];  & ; [Estimates:17]Status:30#"bud@")
			$numEst:=Records in selection:C76([Estimates:17])
			
			QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]CustomerID:6=[Customers:16]ID:1; *)
			QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7>=$fiscalStart; *)
			QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7<=dDateEnd; *)
			QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Status:22#"HOLD")
			$numInv:=Records in selection:C76([Customers_Invoices:88])
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=[Customers:16]ID:1; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=Current date:C33; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
			$numRel:=Records in selection:C76([Customers_ReleaseSchedules:46])
			
			If (($numBook+$numEst+$numInv+$numRel+$numReq)>0)  //include
				xText:=xText+$t+[Customers:16]Name:2+$t+$t+"Q1"+$t+"Q2"+$t+"Q3"+$t+"Q4"+$t+"TOTAL"+$t+"CostYTD"+$t+"PV_YTD"+$cr
				
				xText:=xText+$t+$t+"FORECAST"+$t+String:C10([Customers:16]Q1_Forcast:29)+$t+String:C10([Customers:16]Q2_Forcast:30)+$t+String:C10([Customers:16]Q3_Forcast:31)+$t+String:C10([Customers:16]Q4_Forcast:32)+$t+String:C10([Customers:16]Q1_Forcast:29+[Customers:16]Q2_Forcast:30+[Customers:16]Q3_Forcast:31+[Customers:16]Q4_Forcast:32)+$cr
				xText:=xText+$t+$t+"BOOKINGS"+$t+String:C10([Customers_Bookings:93]Period1:6+[Customers_Bookings:93]Period2:7+[Customers_Bookings:93]Period3:8)+$t+String:C10([Customers_Bookings:93]Period4:9+[Customers_Bookings:93]Period5:10+[Customers_Bookings:93]Period6:11)+$t+String:C10([Customers_Bookings:93]Period7:12+[Customers_Bookings:93]Period8:13+[Customers_Bookings:93]Period9:14)+$t+String:C10([Customers_Bookings:93]Period10:15+[Customers_Bookings:93]Period11:16+[Customers_Bookings:93]Period12:17)+$t+String:C10([Customers_Bookings:93]BookedYTD:3)+$t+String:C10([Customers_Bookings:93]CostYTD:19)+$t+String:C10([Customers_Bookings:93]PV_YTD:20)+$cr
				
				$q1:=0
				$q2:=0
				$q3:=0
				$q4:=0
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
					
					For ($k; 1; $numEst)
						Case of 
							: ([Estimates:17]DateOriginated:19<Date:C102("07/01/"+String:C10($fiscalYear)))
								$q1:=$q1+1
							: ([Estimates:17]DateOriginated:19<Date:C102("10/01/"+String:C10($fiscalYear)))
								$q2:=$q2+1
							: ([Estimates:17]DateOriginated:19<Date:C102("01/01/"+String:C10($fiscalYear+1)))
								$q3:=$q3+1
							Else 
								$q4:=$q4+1
						End case 
						NEXT RECORD:C51([Estimates:17])
					End for 
					
					
				Else 
					
					ARRAY DATE:C224($_DateOriginated; 0)
					SELECTION TO ARRAY:C260([Estimates:17]DateOriginated:19; $_DateOriginated)
					
					For ($k; 1; $numEst; 1)
						Case of 
							: ($_DateOriginated{$k}<Date:C102("07/01/"+String:C10($fiscalYear)))
								$q1:=$q1+1
							: ($_DateOriginated{$k}<Date:C102("10/01/"+String:C10($fiscalYear)))
								$q2:=$q2+1
							: ($_DateOriginated{$k}<Date:C102("01/01/"+String:C10($fiscalYear+1)))
								$q3:=$q3+1
							Else 
								$q4:=$q4+1
						End case 
						
					End for 
					
					
				End if   // END 4D Professional Services : January 2019 First record
				
				xText:=xText+$t+$t+"ESTIMATES"+$t+String:C10($q1)+$t+String:C10($q2)+$t+String:C10($q3)+$t+String:C10($q4)+$t+String:C10($q1+$q2+$q3+$q4)+$cr
				
				$q1:=0
				$q2:=0
				$q3:=0
				$q4:=0
				$q1a:=0
				$q2a:=0
				$q3a:=0
				$q4a:=0
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
					
					For ($k; 1; $numInv)
						Case of 
							: ([Customers_Invoices:88]Invoice_Date:7<Date:C102("07/01/"+String:C10($fiscalYear)))
								$q1:=$q1+[Customers_Invoices:88]ExtendedPrice:19
								$q1a:=$q1a+[Customers_Invoices:88]CommissionPayable:21
							: ([Customers_Invoices:88]Invoice_Date:7<Date:C102("10/01/"+String:C10($fiscalYear)))
								$q2:=$q2+[Customers_Invoices:88]ExtendedPrice:19
								$q2a:=$q2a+[Customers_Invoices:88]CommissionPayable:21
							: ([Customers_Invoices:88]Invoice_Date:7<Date:C102("01/01/"+String:C10($fiscalYear+1)))
								$q3:=$q3+[Customers_Invoices:88]ExtendedPrice:19
								$q3a:=$q3a+[Customers_Invoices:88]CommissionPayable:21
							Else 
								$q4:=$q4+[Customers_Invoices:88]ExtendedPrice:19
								$q4a:=$q4a+[Customers_Invoices:88]CommissionPayable:21
						End case 
						NEXT RECORD:C51([Customers_Invoices:88])
					End for 
					
				Else 
					
					ARRAY DATE:C224($_Invoice_Date; 0)
					ARRAY REAL:C219($_ExtendedPrice; 0)
					ARRAY REAL:C219($_CommissionPayable; 0)
					
					
					SELECTION TO ARRAY:C260([Customers_Invoices:88]Invoice_Date:7; $_Invoice_Date; [Customers_Invoices:88]ExtendedPrice:19; $_ExtendedPrice; [Customers_Invoices:88]CommissionPayable:21; $_CommissionPayable)
					
					
					For ($k; 1; $numInv; 1)
						Case of 
							: ($_Invoice_Date{$k}<Date:C102("07/01/"+String:C10($fiscalYear)))
								$q1:=$q1+$_ExtendedPrice{$k}
								$q1a:=$q1a+$_CommissionPayable{$k}
							: ($_Invoice_Date{$k}<Date:C102("10/01/"+String:C10($fiscalYear)))
								$q2:=$q2+$_ExtendedPrice{$k}
								$q2a:=$q2a+$_CommissionPayable{$k}
							: ($_Invoice_Date{$k}<Date:C102("01/01/"+String:C10($fiscalYear+1)))
								$q3:=$q3+$_ExtendedPrice{$k}
								$q3a:=$q3a+$_CommissionPayable{$k}
							Else 
								$q4:=$q4+$_ExtendedPrice{$k}
								$q4a:=$q4a+$_CommissionPayable{$k}
						End case 
					End for 
					
				End if   // END 4D Professional Services : January 2019 First record
				
				$q1:=Round:C94($q1; 0)
				$q2:=Round:C94($q2; 0)
				$q3:=Round:C94($q3; 0)
				$q4:=Round:C94($q4; 0)
				$q1a:=Round:C94($q1a; 0)
				$q2a:=Round:C94($q2a; 0)
				$q3a:=Round:C94($q3a; 0)
				$q4a:=Round:C94($q4a; 0)
				xText:=xText+$t+$t+"BILLINGS"+$t+String:C10($q1)+$t+String:C10($q2)+$t+String:C10($q3)+$t+String:C10($q4)+$t+String:C10($q1+$q2+$q3+$q4)+$cr
				xText:=xText+$t+$t+"COMMISSION"+$t+String:C10($q1a)+$t+String:C10($q2a)+$t+String:C10($q3a)+$t+String:C10($q4a)+$t+String:C10($q1a+$q2a+$q3a+$q4a)+$cr
				
				$q1:=0
				$q2:=0
				$q3:=0
				$q4:=0
				
				For ($k; 1; $numRel)
					RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
					If (Records in selection:C76([Customers_Order_Lines:41])>0)
						$rev:=[Customers_ReleaseSchedules:46]Sched_Qty:6/1000*[Customers_Order_Lines:41]Price_Per_M:8
					Else 
						$numFG:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
						If ($numFG>0)
							$rev:=[Customers_ReleaseSchedules:46]Sched_Qty:6/1000*[Finished_Goods:26]RKContractPrice:49
						Else 
							$rev:=0
						End if 
					End if 
					Case of 
						: ([Customers_ReleaseSchedules:46]Sched_Date:5<Date:C102("07/01/"+String:C10($fiscalYear)))
							$q1:=$q1+$rev
						: ([Customers_ReleaseSchedules:46]Sched_Date:5<Date:C102("10/01/"+String:C10($fiscalYear)))
							$q2:=$q2+$rev
						: ([Customers_ReleaseSchedules:46]Sched_Date:5<Date:C102("01/01/"+String:C10($fiscalYear+1)))
							$q3:=$q3+$rev
						Else 
							$q4:=$q4+$rev
					End case 
					NEXT RECORD:C51([Customers_ReleaseSchedules:46])
				End for 
				
				
				$q1:=Round:C94($q1; 0)
				$q2:=Round:C94($q2; 0)
				$q3:=Round:C94($q3; 0)
				$q4:=Round:C94($q4; 0)
				xText:=xText+$t+$t+"PROJECTED"+$t+String:C10($q1)+$t+String:C10($q2)+$t+String:C10($q3)+$t+String:C10($q4)+$t+String:C10($q1+$q2+$q3+$q4)+$cr
				
				$q1:=0
				$q2:=0
				$q3:=0
				$q4:=0
				$q1a:=0
				$q2a:=0
				$q3a:=0
				$q4a:=0
				$q1b:=0
				$q2b:=0
				$q3b:=0
				$q4b:=0
				$q1c:=0
				$q2c:=0
				$q3c:=0
				$q4c:=0
				
				//For ($k;1;$numReq)
				//Case of 
				//: (<Date("07/01/"+String($fiscalYear)))
				//Case of 
				//: (="Prep@")
				//$q1:=$q1+1
				//: (="Ink@")
				//$q1a:=$q1a+1
				//: (="Color Approval@")
				//$q1b:=$q1b+1
				//Else 
				//$q1c:=$q1c+1
				//End case 
				//: (<Date("10/01/"+String($fiscalYear)))
				//Case of 
				//: (="Prep@")
				//$q2:=$q2+1
				//: (="Ink@")
				//$q2a:=$q2a+1
				//: (="Color Approval@")
				//$q2b:=$q2b+1
				//Else 
				//$q2c:=$q2c+1
				//End case 
				//: (<Date("01/01/"+String($fiscalYear+1)))
				//Case of 
				//: (="Prep@")
				//$q3:=$q3+1
				//: (="Ink@")
				//$q3a:=$q3a+1
				//: (="Color Approval@")
				//$q3b:=$q3b+1
				//Else 
				//$q3c:=$q3c+1
				//End case 
				//Else 
				//Case of 
				//: (="Prep@")
				//$q4:=$q4+1
				//: (="Ink@")
				//$q4a:=$q4a+1
				//: (="Color Approval@")
				//$q4b:=$q4b+1
				//Else 
				//$q4c:=$q4c+1
				//End case 
				//End case 
				//NEXT RECORD()
				//End for 
				
				xText:=xText+$t+$t+"PREPS"+$t+String:C10($q1)+$t+String:C10($q2)+$t+String:C10($q3)+$t+String:C10($q4)+$t+String:C10($q1+$q2+$q3+$q4)+$cr
				xText:=xText+$t+$t+"INKS"+$t+String:C10($q1a)+$t+String:C10($q2a)+$t+String:C10($q3a)+$t+String:C10($q4a)+$t+String:C10($q1a+$q2a+$q3a+$q4a)+$cr
				xText:=xText+$t+$t+"COLOR APPRL"+$t+String:C10($q1b)+$t+String:C10($q2b)+$t+String:C10($q3b)+$t+String:C10($q4b)+$t+String:C10($q1b+$q2b+$q3b+$q4b)+$cr
				xText:=xText+$t+$t+"OTHER REQUEST"+$t+String:C10($q1c)+$t+String:C10($q2c)+$t+String:C10($q3c)+$t+String:C10($q4c)+$t+String:C10($q1c+$q2c+$q3c+$q4c)+$cr
				
				xText:=xText+$cr
			End if 
			
			NEXT RECORD:C51([Customers:16])
		End for 
		
		uThermoUpdate($i; 1)
		NEXT RECORD:C51([Salesmen:32])
	End for 
	
	
Else 
	
	ARRAY TEXT:C222($_ID_Salesmen; 0)
	ARRAY TEXT:C222($_FirstName; 0)
	ARRAY TEXT:C222($_LastName; 0)
	
	SELECTION TO ARRAY:C260([Salesmen:32]ID:1; $_ID_Salesmen; \
		[Salesmen:32]FirstName:3; $_FirstName; \
		[Salesmen:32]LastName:2; $_LastName)
	
	For ($i; 1; $numReps; 1)
		xText:=xText+$_LastName{$i}+", "+$_FirstName{$i}+$cr
		
		QUERY:C277([Customers:16]; [Customers:16]SalesmanID:3=$_ID_Salesmen{$i}; *)
		QUERY:C277([Customers:16];  & ; [Customers:16]Active:15=True:C214)
		
		ARRAY TEXT:C222($_ID_Customers; 0)
		ARRAY TEXT:C222($_Name_Customers; 0)
		ARRAY LONGINT:C221($_Q1_Forcast; 0)
		ARRAY LONGINT:C221($_Q2_Forcast; 0)
		ARRAY LONGINT:C221($_Q3_Forcast; 0)
		ARRAY LONGINT:C221($_Q4_Forcast; 0)
		
		SELECTION TO ARRAY:C260([Customers:16]ID:1; $_ID_Customers; \
			[Customers:16]Name:2; $_Name_Customers; \
			[Customers:16]Q1_Forcast:29; $_Q1_Forcast; \
			[Customers:16]Q2_Forcast:30; $_Q2_Forcast; \
			[Customers:16]Q3_Forcast:31; $_Q3_Forcast; \
			[Customers:16]Q4_Forcast:32; $_Q4_Forcast)
		
		SORT ARRAY:C229($_Name_Customers; $_Q1_Forcast; $_Q2_Forcast; $_Q3_Forcast; $_Q4_Forcast; $_ID_Customers; >)
		
		
		For ($j; 1; Size of array:C274($_ID_Customers); 1)
			QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2=$fiscalYear; *)
			QUERY:C277([Customers_Bookings:93];  & ; [Customers_Bookings:93]Custid:1=$_ID_Customers{$j})
			$numBook:=Records in selection:C76([Customers_Bookings:93])
			
			QUERY:C277([Estimates:17]; [Estimates:17]Cust_ID:2=$_ID_Customers{$j}; *)
			QUERY:C277([Estimates:17];  & ; [Estimates:17]DateOriginated:19>=$fiscalStart; *)
			QUERY:C277([Estimates:17];  & ; [Estimates:17]DateOriginated:19<=dDateEnd; *)
			QUERY:C277([Estimates:17];  & ; [Estimates:17]Status:30#"bud@")
			$numEst:=Records in selection:C76([Estimates:17])
			
			QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]CustomerID:6=$_ID_Customers{$j}; *)
			QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7>=$fiscalStart; *)
			QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7<=dDateEnd; *)
			QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Status:22#"HOLD")
			$numInv:=Records in selection:C76([Customers_Invoices:88])
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=$_ID_Customers{$j}; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=Current date:C33; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
			$numRel:=Records in selection:C76([Customers_ReleaseSchedules:46])
			
			If (($numBook+$numEst+$numInv+$numRel+$numReq)>0)  //include
				xText:=xText+$t+$_Name_Customers{$j}+$t+$t+"Q1"+$t+"Q2"+$t+"Q3"+$t+"Q4"+$t+"TOTAL"+$t+"CostYTD"+$t+"PV_YTD"+$cr
				
				xText:=xText+$t+$t+"FORECAST"+$t+String:C10($_Q1_Forcast{$j})+$t+String:C10($_Q2_Forcast{$j})+$t+String:C10($_Q3_Forcast{$j})+$t+String:C10($_Q4_Forcast{$j})+$t+String:C10($_Q1_Forcast{$j}+$_Q2_Forcast{$j}+$_Q3_Forcast{$j}+$_Q4_Forcast{$j})+$cr
				xText:=xText+$t+$t+"BOOKINGS"+$t+String:C10([Customers_Bookings:93]Period1:6+[Customers_Bookings:93]Period2:7+[Customers_Bookings:93]Period3:8)+$t+String:C10([Customers_Bookings:93]Period4:9+[Customers_Bookings:93]Period5:10+[Customers_Bookings:93]Period6:11)+$t+String:C10([Customers_Bookings:93]Period7:12+[Customers_Bookings:93]Period8:13+[Customers_Bookings:93]Period9:14)+$t+String:C10([Customers_Bookings:93]Period10:15+[Customers_Bookings:93]Period11:16+[Customers_Bookings:93]Period12:17)+$t+String:C10([Customers_Bookings:93]BookedYTD:3)+$t+String:C10([Customers_Bookings:93]CostYTD:19)+$t+String:C10([Customers_Bookings:93]PV_YTD:20)+$cr
				
				$q1:=0
				$q2:=0
				$q3:=0
				$q4:=0
				
				ARRAY DATE:C224($_DateOriginated; 0)
				SELECTION TO ARRAY:C260([Estimates:17]DateOriginated:19; $_DateOriginated)
				
				For ($k; 1; $numEst; 1)
					Case of 
						: ($_DateOriginated{$k}<Date:C102("07/01/"+String:C10($fiscalYear)))
							$q1:=$q1+1
						: ($_DateOriginated{$k}<Date:C102("10/01/"+String:C10($fiscalYear)))
							$q2:=$q2+1
						: ($_DateOriginated{$k}<Date:C102("01/01/"+String:C10($fiscalYear+1)))
							$q3:=$q3+1
						Else 
							$q4:=$q4+1
					End case 
					
				End for 
				
				
				xText:=xText+$t+$t+"ESTIMATES"+$t+String:C10($q1)+$t+String:C10($q2)+$t+String:C10($q3)+$t+String:C10($q4)+$t+String:C10($q1+$q2+$q3+$q4)+$cr
				
				$q1:=0
				$q2:=0
				$q3:=0
				$q4:=0
				$q1a:=0
				$q2a:=0
				$q3a:=0
				$q4a:=0
				
				ARRAY DATE:C224($_Invoice_Date; 0)
				ARRAY REAL:C219($_ExtendedPrice; 0)
				ARRAY REAL:C219($_CommissionPayable; 0)
				
				
				SELECTION TO ARRAY:C260([Customers_Invoices:88]Invoice_Date:7; $_Invoice_Date; [Customers_Invoices:88]ExtendedPrice:19; $_ExtendedPrice; [Customers_Invoices:88]CommissionPayable:21; $_CommissionPayable)
				
				
				For ($k; 1; $numInv; 1)
					Case of 
						: ($_Invoice_Date{$k}<Date:C102("07/01/"+String:C10($fiscalYear)))
							$q1:=$q1+$_ExtendedPrice{$k}
							$q1a:=$q1a+$_CommissionPayable{$k}
						: ($_Invoice_Date{$k}<Date:C102("10/01/"+String:C10($fiscalYear)))
							$q2:=$q2+$_ExtendedPrice{$k}
							$q2a:=$q2a+$_CommissionPayable{$k}
						: ($_Invoice_Date{$k}<Date:C102("01/01/"+String:C10($fiscalYear+1)))
							$q3:=$q3+$_ExtendedPrice{$k}
							$q3a:=$q3a+$_CommissionPayable{$k}
						Else 
							$q4:=$q4+$_ExtendedPrice{$k}
							$q4a:=$q4a+$_CommissionPayable{$k}
					End case 
				End for 
				
				$q1:=Round:C94($q1; 0)
				$q2:=Round:C94($q2; 0)
				$q3:=Round:C94($q3; 0)
				$q4:=Round:C94($q4; 0)
				$q1a:=Round:C94($q1a; 0)
				$q2a:=Round:C94($q2a; 0)
				$q3a:=Round:C94($q3a; 0)
				$q4a:=Round:C94($q4a; 0)
				xText:=xText+$t+$t+"BILLINGS"+$t+String:C10($q1)+$t+String:C10($q2)+$t+String:C10($q3)+$t+String:C10($q4)+$t+String:C10($q1+$q2+$q3+$q4)+$cr
				xText:=xText+$t+$t+"COMMISSION"+$t+String:C10($q1a)+$t+String:C10($q2a)+$t+String:C10($q3a)+$t+String:C10($q4a)+$t+String:C10($q1a+$q2a+$q3a+$q4a)+$cr
				
				$q1:=0
				$q2:=0
				$q3:=0
				$q4:=0
				
				SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine; \
					[Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
					[Customers_ReleaseSchedules:46]CustID:12; $_CustID; \
					[Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; \
					[Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date)
				
				
				For ($k; 1; $numRel; 1)
					
					QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$_OrderLine{$k})
					
					If (Records in selection:C76([Customers_Order_Lines:41])>0)
						$rev:=$_Sched_Qty{$k}/1000*[Customers_Order_Lines:41]Price_Per_M:8
					Else 
						$numFG:=qryFinishedGood($_CustID{$k}; $_ProductCode{$k})
						If ($numFG>0)
							$rev:=$_Sched_Qty{$k}/1000*[Finished_Goods:26]RKContractPrice:49
						Else 
							$rev:=0
						End if 
					End if 
					Case of 
						: ($_Sched_Date{$k}<Date:C102("07/01/"+String:C10($fiscalYear)))
							$q1:=$q1+$rev
						: ($_Sched_Date{$k}<Date:C102("10/01/"+String:C10($fiscalYear)))
							$q2:=$q2+$rev
						: ($_Sched_Date{$k}<Date:C102("01/01/"+String:C10($fiscalYear+1)))
							$q3:=$q3+$rev
						Else 
							$q4:=$q4+$rev
					End case 
				End for 
				
				$q1:=Round:C94($q1; 0)
				$q2:=Round:C94($q2; 0)
				$q3:=Round:C94($q3; 0)
				$q4:=Round:C94($q4; 0)
				xText:=xText+$t+$t+"PROJECTED"+$t+String:C10($q1)+$t+String:C10($q2)+$t+String:C10($q3)+$t+String:C10($q4)+$t+String:C10($q1+$q2+$q3+$q4)+$cr
				
				$q1:=0
				$q2:=0
				$q3:=0
				$q4:=0
				$q1a:=0
				$q2a:=0
				$q3a:=0
				$q4a:=0
				$q1b:=0
				$q2b:=0
				$q3b:=0
				$q4b:=0
				$q1c:=0
				$q2c:=0
				$q3c:=0
				$q4c:=0
				xText:=xText+$t+$t+"PREPS"+$t+String:C10($q1)+$t+String:C10($q2)+$t+String:C10($q3)+$t+String:C10($q4)+$t+String:C10($q1+$q2+$q3+$q4)+$cr
				xText:=xText+$t+$t+"INKS"+$t+String:C10($q1a)+$t+String:C10($q2a)+$t+String:C10($q3a)+$t+String:C10($q4a)+$t+String:C10($q1a+$q2a+$q3a+$q4a)+$cr
				xText:=xText+$t+$t+"COLOR APPRL"+$t+String:C10($q1b)+$t+String:C10($q2b)+$t+String:C10($q3b)+$t+String:C10($q4b)+$t+String:C10($q1b+$q2b+$q3b+$q4b)+$cr
				xText:=xText+$t+$t+"OTHER REQUEST"+$t+String:C10($q1c)+$t+String:C10($q2c)+$t+String:C10($q3c)+$t+String:C10($q4c)+$t+String:C10($q1c+$q2c+$q3c+$q4c)+$cr
				
				xText:=xText+$cr
			End if 
			
		End for 
		
		uThermoUpdate($i; 1)
		
	End for 
	
	
End if   // END 4D Professional Services : January 2019 
uThermoClose

docName:="Pjt_SalesmenActivity"+fYYMMDD(dDateEnd)+".xls"
$docRef:=util_putFileName(->docName)

xTitle:="ACTIVITY BY SALESMAN"
SEND PACKET:C103($docRef; xTitle+$cr+$cr)
SEND PACKET:C103($docRef; xText)

CLOSE DOCUMENT:C267($docRef)
BEEP:C151
// obsolete call, method deleted 4/28/20 uDocumentSetType 
$err:=util_Launch_External_App(Document)

xText:=""

BEEP:C151
zwStatusMsg("SALESMEN"; "Salesmen Activity Finished see "+docName)