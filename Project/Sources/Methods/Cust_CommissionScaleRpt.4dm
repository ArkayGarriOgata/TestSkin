//%attributes = {}
// Method: Cust_CommissionScaleRpt () -> 
// ----------------------------------------------------
// by: mel: 08/18/05, 09:07:52
// ----------------------------------------------------

C_TEXT:C284($t; $r)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$r:=Char:C90(13)

xTitle:="CUSTOMER COMMISSION SCALE SETTINGS"
xText:="SALESMAN"+$t+"CUSTOMER"+$t+"DEFAULT"+$t+"PROJECT"+$t+"TYPE"+$r
docName:="NameOfDocument.txt"
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$r+$r)
	
	QUERY:C277([Customers:16]; [Customers:16]Active:15=True:C214)
	ORDER BY:C49([Customers:16]; [Customers:16]SalesmanID:3; >; [Customers:16]Name:2; >)
	
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Customers:16])
	
	uThermoInit($numRecs; "Updating Records")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			xText:=xText+[Customers:16]SalesmanID:3+$t+[Customers:16]Name:2+$t+[Customers:16]CustomerType:54+$t+"-------"+$t+"----"+$r
			
			QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]Customerid:3=[Customers:16]ID:1)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record 
				
				ORDER BY:C49([Customers_Projects:9]; [Customers_Projects:9]Name:2; >)
				While (Not:C34(End selection:C36([Customers_Projects:9])))
					If ([Customers_Projects:9]PromotionalPjt:8)
						xText:=xText+""+$t+""+$t+""+$t+[Customers_Projects:9]Name:2+$t+"Promotional"+$r
					Else 
						If (Length:C16([Customers_Projects:9]CommissionType:14)>0)
							xText:=xText+""+$t+""+$t+""+$t+[Customers_Projects:9]Name:2+$t+[Customers_Projects:9]CommissionType:14+$r
						Else 
							xText:=xText+""+$t+""+$t+""+$t+[Customers_Projects:9]Name:2+$t+"Default To Customer"+$r
						End if 
					End if 
					NEXT RECORD:C51([Customers_Projects:9])
				End while 
				
			Else 
				
				ARRAY TEXT:C222($_Name; 0)
				ARRAY BOOLEAN:C223($_PromotionalPjt; 0)
				ARRAY TEXT:C222($_CommissionType; 0)
				
				SELECTION TO ARRAY:C260([Customers_Projects:9]Name:2; $_Name; [Customers_Projects:9]PromotionalPjt:8; $_PromotionalPjt; [Customers_Projects:9]CommissionType:14; $_CommissionType)
				
				SORT ARRAY:C229($_Name; $_PromotionalPjt; $_CommissionType; >)
				
				For ($Iter; 1; Size of array:C274($_Name); 1)
					
					If ($_PromotionalPjt{$Iter})
						
						xText:=xText+""+$t+""+$t+""+$t+$_Name{$Iter}+$t+"Promotional"+$r
						
					Else 
						If (Length:C16($_CommissionType{$Iter})>0)
							
							xText:=xText+""+$t+""+$t+""+$t+$_Name{$Iter}+$t+$_CommissionType{$Iter}+$r
							
						Else 
							
							xText:=xText+""+$t+""+$t+""+$t+$_Name{$Iter}+$t+"Default To Customer"+$r
							
						End if 
					End if 
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			NEXT RECORD:C51([Customers:16])
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		ARRAY TEXT:C222($_ID; 0)
		ARRAY TEXT:C222($_SalesmanID; 0)
		ARRAY TEXT:C222($_customerName; 0)
		ARRAY TEXT:C222($_CustomerType; 0)
		
		SELECTION TO ARRAY:C260([Customers:16]ID:1; $_ID; \
			[Customers:16]SalesmanID:3; $_SalesmanID; \
			[Customers:16]Name:2; $_customerName; \
			[Customers:16]CustomerType:54; $_CustomerType)
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			xText:=xText+$_SalesmanID{$i}+$t+$_customerName{$i}+$t+$_CustomerType{$i}+$t+"-------"+$t+"----"+$r
			
			QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]Customerid:3=$_ID{$i})
			ARRAY TEXT:C222($_Name; 0)
			ARRAY BOOLEAN:C223($_PromotionalPjt; 0)
			ARRAY TEXT:C222($_CommissionType; 0)
			
			SELECTION TO ARRAY:C260([Customers_Projects:9]Name:2; $_Name; [Customers_Projects:9]PromotionalPjt:8; $_PromotionalPjt; [Customers_Projects:9]CommissionType:14; $_CommissionType)
			
			SORT ARRAY:C229($_Name; $_PromotionalPjt; $_CommissionType; >)
			
			For ($Iter; 1; Size of array:C274($_Name); 1)
				
				If ($_PromotionalPjt{$Iter})
					
					xText:=xText+""+$t+""+$t+""+$t+$_Name{$Iter}+$t+"Promotional"+$r
					
				Else 
					If (Length:C16($_CommissionType{$Iter})>0)
						
						xText:=xText+""+$t+""+$t+""+$t+$_Name{$Iter}+$t+$_CommissionType{$Iter}+$r
						
					Else 
						
						xText:=xText+""+$t+""+$t+""+$t+$_Name{$Iter}+$t+"Default To Customer"+$r
						
					End if 
				End if 
			End for 
			
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	uThermoClose
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
	$err:=util_Launch_External_App(docName)
End if 