//%attributes = {}
// Method: QA_CustNewTestStd () -> 
// ----------------------------------------------------
// by: mel: 10/19/04, 15:53:14
// ----------------------------------------------------
// Description:
// Create a test group for a customer that can be applied when needed
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	$pid:=New process:C317("QA_CustNewTestStd"; <>lMinMemPart; "Creating Customer Testing Standard"; "00000")
	If (False:C215)
		QA_CustNewTestStd
	End if 
	
Else 
	zwStatusMsg("NEW STD TEST"; "A test group that can be set as ")
	If ($1="00000")
		$custid:=Request:C163("Enter the Customer's Id for the Test Std."; "00000"; "Make Test Std"; "Cancel")
	Else 
		$custid:=$1
		OK:=1
	End if 
	
	If (Length:C16($custId)=5) & (OK=1)
		$custName:=CUST_getName($custid)
		If (Length:C16($custName)>0)
			$testGroupName:=Request:C163("Name for this test battery?"; "COA - Default"; "Continue"; "Cancel")
			If (OK=1)
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					CREATE EMPTY SET:C140([QA_CustomerTestStandards:135]; "newOnes")
					
				Else 
					
					ARRAY LONGINT:C221($_newOnes; 0)
					
				End if   // END 4D Professional Services : January 2019 
				
				ALL RECORDS:C47([QA_Tests:134])
				ORDER BY:C49([QA_Tests:134]; [QA_Tests:134]DisplayOrder:6; >)
				While (Not:C34(End selection:C36([QA_Tests:134])))
					CONFIRM:C162("Include "+[QA_Tests:134]DisplayName:3+" in "+$testGroupName+"?"; "Yes"; "No")
					If (OK=1)
						CREATE RECORD:C68([QA_CustomerTestStandards:135])
						[QA_CustomerTestStandards:135]StdID:1:=QA_CustGetNextID
						[QA_CustomerTestStandards:135]CustID:2:=$custId
						[QA_CustomerTestStandards:135]StdsGroup:3:=$testGroupName
						[QA_CustomerTestStandards:135]TestID:4:=[QA_Tests:134]TestID:1
						[QA_CustomerTestStandards:135]LowerLimit:6:=0
						[QA_CustomerTestStandards:135]Nominal:7:=0
						[QA_CustomerTestStandards:135]UpperLimit:5:=0
						SAVE RECORD:C53([QA_CustomerTestStandards:135])
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
							
							ADD TO SET:C119([QA_CustomerTestStandards:135]; "newOnes")
							
						Else 
							
							APPEND TO ARRAY:C911($_newOnes; Record number:C243([QA_CustomerTestStandards:135]))
							
						End if   // END 4D Professional Services : January 2019 
						
					End if 
					NEXT RECORD:C51([QA_Tests:134])
				End while 
				
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					
					USE SET:C118("newOnes")
					CLEAR SET:C117("newOnes")
					
				Else 
					
					CREATE SELECTION FROM ARRAY:C640([QA_CustomerTestStandards:135]; $_newOnes)
					
				End if   // END 4D Professional Services : January 2019 
				
				ORDER BY:C49([QA_CustomerTestStandards:135]; [QA_CustomerTestStandards:135]StdID:1; >)
				$winRef:=Open form window:C675([QA_CustomerTestStandards:135]; "input"; 8)
				FORM SET INPUT:C55([QA_CustomerTestStandards:135]; "input")
				FORM SET OUTPUT:C54([QA_CustomerTestStandards:135]; "output")
				MODIFY SELECTION:C204([QA_CustomerTestStandards:135]; *)
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41($custId+" was not found.")
		End if 
		
	End if 
End if 