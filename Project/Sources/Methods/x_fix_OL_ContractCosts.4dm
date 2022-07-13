//%attributes = {}
// Method: x_fix_OL_ContractCosts
// ----------------------------------------------------
// User name (OS): work
// Date and time: 08/16/06, 16:05:28
// ----------------------------------------------------
// contract orderlines should always have the calc'd cost
//this trys to calc it if its zero

// Parameters
// ----------------------------------------------------
READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Customers_Order_Lines:41])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]IsContract:52=True:C214; *)
	QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10="Cancel")
	RELATE MANY SELECTION:C340([Customers_Order_Lines:41]OrderNumber:1)
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel")
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9:="Cancel")
	
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]IsContract:52=True:C214; *)
	QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10#"Cancel")
	RELATE MANY SELECTION:C340([Customers_Order_Lines:41]OrderNumber:1)
	
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Cost_Per_M:7=0; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13>=!2006-03-01!)
	
	
Else 
	
	QUERY BY FORMULA:C48([Customers_Order_Lines:41]; \
		([Customers_Orders:40]IsContract:52=True:C214)\
		 & ([Customers_Orders:40]Status:10="Cancel")\
		 & ([Customers_Order_Lines:41]Status:9#"Cancel")\
		)
	
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9:="Cancel")
	
	
	QUERY BY FORMULA:C48([Customers_Order_Lines:41]; \
		([Customers_Orders:40]IsContract:52=True:C214)\
		 & ([Customers_Orders:40]Status:10#"Cancel")\
		 & ([Customers_Order_Lines:41]Cost_Per_M:7=0)\
		 & ([Customers_Order_Lines:41]SpecialBilling:37=False:C215)\
		 & ([Customers_Order_Lines:41]DateOpened:13>=!2006-03-01!)\
		)
	
	
End if   // END 4D Professional Services : January 2019 query selection

//PM: pattern_LoopRecords() -> 
//@author mlb - 8/27/02  16:30

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
$break:=False:C215
$numRecs:=Records in selection:C76([Customers_Order_Lines:41])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "hadProblem")
	uThermoInit($numRecs; "Updating Records")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		[Customers_Order_Lines:41]Price_Per_M:8:=SetContractCost([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5; ->[Customers_Order_Lines:41]Cost_Per_M:7; ->[Customers_Order_Lines:41]CostMatl_Per_M:32; ->[Customers_Order_Lines:41]CostLabor_Per_M:30; ->[Customers_Order_Lines:41]CostOH_Per_M:31; ->[Customers_Order_Lines:41]CostScrap_Per_M:33)
		If ([Customers_Order_Lines:41]Cost_Per_M:7>0)
			SAVE RECORD:C53([Customers_Order_Lines:41])
		Else 
			ADD TO SET:C119([Customers_Order_Lines:41]; "hadProblem")
		End if 
		
		NEXT RECORD:C51([Customers_Order_Lines:41])
		uThermoUpdate($i)
	End for 
	uThermoClose
	//
	USE SET:C118("hadProblem")
	CLEAR SET:C117("hadProblem")
	
	
	
Else 
	
	// PS 4D :i can optimize more but i'm not sur if Mel do modification before
	
	ARRAY LONGINT:C221($_record_number; 0)
	ARRAY LONGINT:C221($_record_number_Finale; 0)
	
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]; $_record_number)
	FIRST RECORD:C50([Customers_Order_Lines:41])
	
	uThermoInit($numRecs; "Updating Records")
	For ($i; 1; $numRecs; 1)
		[Customers_Order_Lines:41]Price_Per_M:8:=SetContractCost([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5; ->[Customers_Order_Lines:41]Cost_Per_M:7; ->[Customers_Order_Lines:41]CostMatl_Per_M:32; ->[Customers_Order_Lines:41]CostLabor_Per_M:30; ->[Customers_Order_Lines:41]CostOH_Per_M:31; ->[Customers_Order_Lines:41]CostScrap_Per_M:33)
		If ([Customers_Order_Lines:41]Cost_Per_M:7>0)
			SAVE RECORD:C53([Customers_Order_Lines:41])
		Else 
			
			APPEND TO ARRAY:C911($_record_number_Finale; $_record_number{$i})
			
		End if 
		NEXT RECORD:C51([Customers_Order_Lines:41])
		uThermoUpdate($i)
	End for 
	
	uThermoClose
	
	CREATE SELECTION FROM ARRAY:C640([Customers_Order_Lines:41]; $_record_number_Finale)
	
End if   // END 4D Professional Services : January 2019 
