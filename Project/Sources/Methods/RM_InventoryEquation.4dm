//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/11/10, 11:18:07
// ----------------------------------------------------
// Method: RM_InventoryEquation
// Description
// test the onhand versus the receipts and issues
// ----------------------------------------------------

C_LONGINT:C283($i; $numRecs; $onhand; $receipts; $issues; $others)
C_BOOLEAN:C305($break)
C_TEXT:C284($po)
C_TEXT:C284($t; $r)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)

QUERY:C277([Raw_Materials_Locations:25])
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]QtyOH:9#0)

// ******* Verified  - 4D PS - January 2019 (end) *********

ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >; [Raw_Materials_Locations:25]POItemKey:19; >)

$break:=False:C215
$numRecs:=Records in selection:C76([Raw_Materials_Locations:25])
$t:=Char:C90(9)
$r:=Char:C90(13)
xTitle:="RM Inventory Equation "+String:C10(4D_Current_date; System date short:K1:1)+" at "+String:C10(4d_Current_time; HH MM AM PM:K7:5)
xText:="Raw_Matl_Code"+$t+"PO"+$t+"OnHand"+$t+"Receipts"+$t+"Issues"+$t+"PerptualOnhand"+$t+"Error"+$t+"Adjusts"+$t+"ErrorAftAdj"+$r
docName:="RM_InventoryEquation_"+String:C10(TSTimeStamp)+".xls"
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$r+$r)
	SEND PACKET:C103($docRef; xText)
	xText:=""
	
	uThermoInit($numRecs; "Updating Records")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			$po:=[Raw_Materials_Locations:25]POItemKey:19
			$onhand:=[Raw_Materials_Locations:25]QtyOH:9
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$po)
				CREATE SET:C116([Raw_Materials_Transactions:23]; "forPO")
				
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
				$receipts:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				
				USE SET:C118("forPO")
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
				$issues:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				
				USE SET:C118("forPO")
				
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2#"Receipt"; *)
				QUERY SELECTION:C341([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2#"Issue")
				
				$others:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
				
				CLEAR SET:C117("forPO")
				
			Else 
				
				ARRAY TEXT:C222($_Xfer_Type; 0)
				ARRAY REAL:C219($_Qty; 0)
				
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$po)
				SELECTION TO ARRAY:C260(\
					[Raw_Materials_Transactions:23]Xfer_Type:2; $_Xfer_Type; \
					[Raw_Materials_Transactions:23]Qty:6; $_Qty)
				
				$receipts:=0
				$issues:=0
				$others:=0
				
				For ($Iter; 1; Size of array:C274($_Qty); 1)
					
					Case of 
						: ($_Xfer_Type{$Iter}="Receipt")
							$receipts:=$receipts+$_Qty{$Iter}
						: ($_Xfer_Type{$Iter}="Issue")
							$issues:=$issues+$_Qty{$Iter}
						: ($_Xfer_Type{$Iter}#"Receipt") & ($_Xfer_Type{$Iter}#"Issue")
							$others:=$others+$_Qty{$Iter}
					End case 
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			
			$perptual:=$receipts+$issues
			$error1:=$onhand-$perptual
			$error2:=$onhand-($perptual+$others)
			If ($error1#0)
				xText:=[Raw_Materials_Locations:25]Raw_Matl_Code:1+$t+"P"+$po+$t+String:C10($onhand)+$t+String:C10($receipts)+$t+String:C10($issues)+$t+String:C10($perptual)+$t+String:C10($error1)+$t+String:C10($others)+$t+String:C10($error2)+$r
				SEND PACKET:C103($docRef; xText)
				
				xText:=""
			End if 
			
			NEXT RECORD:C51([Raw_Materials_Locations:25])
			uThermoUpdate($i)
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_POItemKey; 0)
		ARRAY REAL:C219($_QtyOH; 0)
		ARRAY TEXT:C222($_Raw_Matl_Code; 0)
		
		SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]POItemKey:19; $_POItemKey; \
			[Raw_Materials_Locations:25]QtyOH:9; $_QtyOH; \
			[Raw_Materials_Locations:25]Raw_Matl_Code:1; $_Raw_Matl_Code)
		
		For ($i; 1; $numRecs; 1)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			$po:=$_POItemKey{$i}
			$onhand:=$_QtyOH{$i}
			
			ARRAY TEXT:C222($_Xfer_Type; 0)
			ARRAY REAL:C219($_Qty; 0)
			
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$po)
			SELECTION TO ARRAY:C260(\
				[Raw_Materials_Transactions:23]Xfer_Type:2; $_Xfer_Type; \
				[Raw_Materials_Transactions:23]Qty:6; $_Qty)
			
			$receipts:=0
			$issues:=0
			$others:=0
			
			For ($Iter; 1; Size of array:C274($_Qty); 1)
				
				Case of 
					: ($_Xfer_Type{$Iter}="Receipt")
						$receipts:=$receipts+$_Qty{$Iter}
					: ($_Xfer_Type{$Iter}="Issue")
						$issues:=$issues+$_Qty{$Iter}
					: ($_Xfer_Type{$Iter}#"Receipt") & ($_Xfer_Type{$Iter}#"Issue")
						$others:=$others+$_Qty{$Iter}
				End case 
				
			End for 
			
			
			$perptual:=$receipts+$issues
			$error1:=$onhand-$perptual
			$error2:=$onhand-($perptual+$others)
			If ($error1#0)
				xText:=$_Raw_Matl_Code{$i}+$t+"P"+$po+$t+String:C10($onhand)+$t+String:C10($receipts)+$t+String:C10($issues)+$t+String:C10($perptual)+$t+String:C10($error1)+$t+String:C10($others)+$t+String:C10($error2)+$r
				SEND PACKET:C103($docRef; xText)
				
				xText:=""
			End if 
			
			uThermoUpdate($i)
		End for 
		
	End if   // END 4D Professional Services : January 2019 
	
	uThermoClose
	
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	$err:=util_Launch_External_App(docName)
	
Else 
	BEEP:C151
	ALERT:C41("Couldn't open a document for writting.")
End if 