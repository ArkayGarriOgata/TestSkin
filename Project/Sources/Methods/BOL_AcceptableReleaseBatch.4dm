//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 06/17/08, 15:50:36
// ----------------------------------------------------
// Method: BOL_AcceptableReleaseBatch
// Description
// `mimic behavior of BOL_AcceptableRelease
// ----------------------------------------------------

C_LONGINT:C283($i; $numRecs; $dest)
C_TEXT:C284($0)

$0:="ReleasesToSend"  //set name of those that pass the tests
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	CREATE SET:C116([Customers_ReleaseSchedules:46]; "ReleasesToSend")
	
	//remove forecasts
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("ReleasesToSend")
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3=("<@"))
		
	Else 
		
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3=("<@"))
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "RemoveThese")
		DIFFERENCE:C122("ReleasesToSend"; "RemoveThese"; "ReleasesToSend")
		uConfirm("Warning: "+String:C10(Records in set:C195("RemoveThese"))+" forecasts were removed from the Picks"; "OK"; "Help")
		CLEAR SET:C117("RemoveThese")
	End if 
	
	//remove already shipped
	USE SET:C118("ReleasesToSend")
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Qty:8>0)
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "RemoveThese")
		DIFFERENCE:C122("ReleasesToSend"; "RemoveThese"; "ReleasesToSend")
		uConfirm("Warning: "+String:C10(Records in set:C195("RemoveThese"))+" previously shipped were removed from the Picks"; "OK"; "Help")
		CLEAR SET:C117("RemoveThese")
	End if 
	
	//remove already shipped
	USE SET:C118("ReleasesToSend")
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="N/A")
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "RemoveThese")
		DIFFERENCE:C122("ReleasesToSend"; "RemoveThese"; "ReleasesToSend")
		uConfirm("Warning: "+String:C10(Records in set:C195("RemoveThese"))+" had a N/A shiptos and were removed from the Picks"; "OK"; "Help")
		CLEAR SET:C117("RemoveThese")
	End if 
	
	//remove on Launch Hold, custid bad, or wrong order status
	USE SET:C118("ReleasesToSend")
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "RemoveThese")
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "OrderProblem")
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "CustProblem")
	$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
	FIRST RECORD:C50([Customers_ReleaseSchedules:46])
	
	For ($i; 1; $numRecs)
		If (FG_LaunchItem("hold"; [Customers_ReleaseSchedules:46]ProductCode:11))
			ADD TO SET:C119([Customers_ReleaseSchedules:46]; "RemoveThese")
			
		Else 
			RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_ReleaseSchedules:46]OrderNumber:2)
			Case of 
				: (Records in selection:C76([Customers_Orders:40])=0)
					ADD TO SET:C119([Customers_ReleaseSchedules:46]; "OrderProblem")
				: ([Customers_Orders:40]Status:10="Hold@")
					ADD TO SET:C119([Customers_ReleaseSchedules:46]; "OrderProblem")
				: ([Customers_Orders:40]Status:10="Accept@")
					//$statusOKToShip:=True
				: ([Customers_Orders:40]Status:10="Budget@")
					//$statusOKToShip:=True
					//: ([Customers_Orders]Status="Contract@")`removed 12/3/07
					//$statusOKToShip:=True
				Else 
					ADD TO SET:C119([Customers_ReleaseSchedules:46]; "OrderProblem")
			End case 
		End if 
		
		If (CUST_getName([Customers_ReleaseSchedules:46]CustID:12)="")
			ADD TO SET:C119([Customers_ReleaseSchedules:46]; "CustProblem")
		End if 
		
		NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	End for 
	
	If (Records in set:C195("RemoveThese")>0)
		DIFFERENCE:C122("ReleasesToSend"; "RemoveThese"; "ReleasesToSend")
		uConfirm("Warning: "+String:C10(Records in set:C195("RemoveThese"))+" Launch Holds were removed from the Picks"; "OK"; "Help")
	End if 
	CLEAR SET:C117("RemoveThese")
	
	If (Records in set:C195("OrderProblem")>0)
		DIFFERENCE:C122("ReleasesToSend"; "OrderProblem"; "ReleasesToSend")
		uConfirm("Warning: "+String:C10(Records in set:C195("OrderProblem"))+" Status not 'Accepted' or 'Budgeted' were removed from the Picks"; "OK"; "Help")
	End if 
	CLEAR SET:C117("OrderProblem")
	
	If (Records in set:C195("CustProblem")>0)
		DIFFERENCE:C122("ReleasesToSend"; "CustProblem"; "ReleasesToSend")
		uConfirm("Warning: "+String:C10(Records in set:C195("CustProblem"))+" had CustomerID problems and were removed"; "OK"; "Help")
	End if 
	CLEAR SET:C117("CustProblem")
	
	USE SET:C118("ReleasesToSend")
	
	
Else 
	//laghzaoui combination between set query into variable and oposite of differnce on the and i change add to append
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
	//uConfirm ("Warning: "+Chaîne($Records)+" forecasts were removed from the Picks";"OK";"Help")
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Qty:8<=0; *)
	//uConfirm ("Warning: "+Chaîne($Records)+" previously shipped were removed from the Picks";"OK";"Help")
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10#"N/A")
	//uConfirm ("Warning: "+Chaîne($Records)+" had a N/A shiptos and were removed from the Picks";"OK";"Help")
	
	
	
	$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
	
	ARRAY LONGINT:C221($_RemoveThese; 0)
	ARRAY LONGINT:C221($_OrderProblem; 0)
	ARRAY LONGINT:C221($_CustProblem; 0)
	
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
		[Customers_ReleaseSchedules:46]OrderNumber:2; $_OrderNumber; \
		[Customers_ReleaseSchedules:46]CustID:12; $_CustID; \
		[Customers_ReleaseSchedules:46]; $_records_numbers)
	
	
	For ($i; 1; $numRecs; 1)
		If (FG_LaunchItem("hold"; $_ProductCode{$i}))
			
			APPEND TO ARRAY:C911($_RemoveThese; $_records_numbers{$i})
			
		Else 
			
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=$_OrderNumber{$i})
			Case of 
				: (Records in selection:C76([Customers_Orders:40])=0)
					APPEND TO ARRAY:C911($_OrderProblem; $_records_numbers{$i})
					
				: ([Customers_Orders:40]Status:10="Hold@")
					APPEND TO ARRAY:C911($_OrderProblem; $_records_numbers{$i})
					
				: ([Customers_Orders:40]Status:10="Accept@")
					
				: ([Customers_Orders:40]Status:10="Budget@")
				Else 
					APPEND TO ARRAY:C911($_OrderProblem; $_records_numbers{$i})
			End case 
		End if 
		
		If (CUST_getName($_CustID{$i})="")
			APPEND TO ARRAY:C911($_CustProblem; $_records_numbers{$i})
		End if 
		
	End for 
	
	LONGINT ARRAY FROM SELECTION:C647([Customers_ReleaseSchedules:46]; $_recordNumbers)
	For ($i; 1; Size of array:C274($_RemoveThese); 1)
		$trouve:=Find in array:C230($_recordNumbers; $_RemoveThese{$i})
		If ($trouve>0)
			DELETE FROM ARRAY:C228($_recordNumbers; $trouve; 1)
		End if 
	End for 
	For ($i; 1; Size of array:C274($_OrderProblem); 1)
		$trouve:=Find in array:C230($_recordNumbers; $_OrderProblem{$i})
		If ($trouve>0)
			DELETE FROM ARRAY:C228($_recordNumbers; $trouve; 1)
		End if 
	End for 
	For ($i; 1; Size of array:C274($_CustProblem); 1)
		$trouve:=Find in array:C230($_recordNumbers; $_CustProblem{$i})
		If ($trouve>0)
			DELETE FROM ARRAY:C228($_recordNumbers; $trouve; 1)
		End if 
	End for 
	
	CREATE SET FROM ARRAY:C641([Customers_ReleaseSchedules:46]; $_recordNumbers; "ReleasesToSend")
	
End if   // END 4D Professional Services : January 2019 
