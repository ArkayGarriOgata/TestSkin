//%attributes = {}
// Method: RM_inventoryBackTest () -> 
// ----------------------------------------------------
// by: mel: 03/17/04, 10:09:23
// ----------------------------------------------------
// Description:
// test if transaction match on hand
// ----------------------------------------------------
//RT Printkote.18.56
C_LONGINT:C283($onhand; $stocked; $relieved; $adjusted; $error)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)

MESSAGES OFF:C175

READ ONLY:C145([Raw_Materials_Transactions:23])
READ ONLY:C145([Raw_Materials_Locations:25])
READ ONLY:C145([Raw_Materials:21])

xText:="RMcode"+$t+"Onhand"+$t+"Adjustments"+$t+"Stocked"+$t+"Relieved"+$t+"Error"+$cr
docName:="RM_inventoryBackTest.xls"
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	QUERY:C277([Raw_Materials:21])
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) create empty set
		
		CREATE EMPTY SET:C140([Raw_Materials:21]; "hasProblem")
		
	Else 
		
		ARRAY LONGINT:C221($_hasProblem; 0)
		
		
	End if   // END 4D Professional Services : January 2019 
	
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Raw_Materials:21])
	If ($numRecs>0)
		xTitle:="RM_inventoryBackTest as of "+String:C10(4D_Current_date; System date short:K1:1)+" for "+String:C10($numRecs)+" records "
		SEND PACKET:C103($docRef; xTitle+Char:C90(13)+Char:C90(13))
		ORDER BY:C49([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1; >)
		
		uThermoInit($numRecs; "Inventory Back Test for R/M")
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; $numRecs)
				If ($break)
					$i:=$i+$numRecs
				End if 
				
				RELATE MANY:C262([Raw_Materials:21]Raw_Matl_Code:1)
				If (Records in selection:C76([Raw_Materials_Locations:25])>0)
					$onhand:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)
				Else 
					$onhand:=0
				End if 
				REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
				
				CREATE SET:C116([Raw_Materials_Transactions:23]; "all_xfers")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					$stocked:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				Else 
					$stocked:=0
				End if 
				
				USE SET:C118("all_xfers")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					$relieved:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				Else 
					$relieved:=0
				End if 
				
				USE SET:C118("all_xfers")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Adjust"; *)
				QUERY SELECTION:C341([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3>!2003-05-01!)
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					$adjusted:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				Else 
					$adjusted:=0
				End if 
				
				$error:=($onhand+$adjusted)-($stocked+$relieved)
				If ($error#0)
					ADD TO SET:C119([Raw_Materials:21]; "hasProblem")
					If (Length:C16(xText)>20000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
					xText:=xText+[Raw_Materials:21]Raw_Matl_Code:1+$t+String:C10($onhand)+$t+String:C10($adjusted)+$t+String:C10($stocked)+$t+String:C10($relieved)+$t+String:C10($error)+$cr
				End if 
				
				CLEAR SET:C117("all_xfers")
				
				NEXT RECORD:C51([Raw_Materials:21])
				uThermoUpdate($i)
			End for 
			
			
		Else 
			
			//remove next and  CREATE SET([Raw_Materials_Transactions];"all_xfers") ADD TO SET([Raw_Materials];"hasProblem")
			ARRAY TEXT:C222($_Raw_Matl_Code; 0)
			ARRAY LONGINT:C221($_record_number; 0)
			
			
			SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; $_Raw_Matl_Code; \
				[Raw_Materials:21]; $_record_number)
			
			For ($i; 1; $numRecs)
				If ($break)
					$i:=$i+$numRecs
				End if 
				QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$_Raw_Matl_Code{$i})
				
				If (Records in selection:C76([Raw_Materials_Locations:25])>0)
					$onhand:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)
				Else 
					$onhand:=0
				End if 
				REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
				
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=$_Raw_Matl_Code{$i}; *)
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					$stocked:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				Else 
					$stocked:=0
				End if 
				
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=$_Raw_Matl_Code{$i}; *)
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				
				
				
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					$relieved:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				Else 
					$relieved:=0
				End if 
				
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=$_Raw_Matl_Code{$i}; *)
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Adjust"; *)
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>!2003-05-01!)
				
				
				
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					$adjusted:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				Else 
					$adjusted:=0
				End if 
				
				$error:=($onhand+$adjusted)-($stocked+$relieved)
				If ($error#0)
					APPEND TO ARRAY:C911($_hasProblem; $_record_number{$i})
					
					If (Length:C16(xText)>20000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
					xText:=xText+$_Raw_Matl_Code{$i}+$t+String:C10($onhand)+$t+String:C10($adjusted)+$t+String:C10($stocked)+$t+String:C10($relieved)+$t+String:C10($error)+$cr
				End if 
				
				
				uThermoUpdate($i)
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 
		uThermoClose
		
		SEND PACKET:C103($docRef; xText)
		SEND PACKET:C103($docRef; $cr+$cr+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
		$err:=util_Launch_External_App(docName)
		
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) create empty set
			USE SET:C118("hasProblem")
			CLEAR SET:C117("hasProblem")
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Raw_Materials:21]; $_hasProblem)
			
		End if   // END 4D Professional Services : January 2019 
		
		
	Else 
		BEEP:C151
	End if 
End if 