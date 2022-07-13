//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/04/06, 14:46:02
// ----------------------------------------------------
// Method: Ord_ResequenceCartonsIfGaps
// Description
// •051995  MLB  UPR 177
// ----------------------------------------------------
//Procedure: uReseqCSpecs(estimateNº;differential)  051795  MLB 
//•051795  MLB  UPR 177
//determine if there are gaps in the c-spec item numbers, and fix entire est
// if there are any
//•062695  MLB  UPR 217 turn off alerts when things are cool.

// Modified by: Garri Ogata (9/21/21) added EsCS_SetItemT ()

C_TEXT:C284($1; $estimate)
C_TEXT:C284($2; $diff)
C_TEXT:C284($lastItem)  //for figureing out the new item numbers
C_TEXT:C284($tItemNumber)

C_LONGINT:C283($orderitem)  //to simulate what the item will be when it becomes an order
C_LONGINT:C283($skipSize)
//$numWSitems;$numItems
C_LONGINT:C283($numRecs; $maxWS; $nextItem; $i; $j)  //hold the counts and boundaries of various selections
C_BOOLEAN:C305($contig; $Continue)
C_TEXT:C284($setNameForCartonDiffs; $3)

If (Count parameters:C259>=3)
	$estimate:=$1
	$diff:=$2
	$setNameForCartonDiffs:=$3
	//*Select and sort the carton specs
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate)  //find Estimate Qty worksheet
		CREATE SET:C116([Estimates_Carton_Specs:19]; "Allcartons")
		
		QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		CREATE SET:C116([Estimates_Carton_Specs:19]; "Worksheet")
		
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "Allcartons")
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate)
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "Worksheet")
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate; *)
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	USE SET:C118($setNameForCartonDiffs)
	$numRecs:=Records in selection:C76([Estimates_Carton_Specs:19])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)  //this is the diffcartons only
		FIRST RECORD:C50([Estimates_Carton_Specs:19])
		
		
	Else 
		
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)  //this is the diffcartons only
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	COPY NAMED SELECTION:C331([Estimates_Carton_Specs:19]; "Cartons")
	
	DIFFERENCE:C122("Allcartons"; $setNameForCartonDiffs; "NonDiffCartons")  //&&& wasn't using the correct diff set
	DIFFERENCE:C122("NonDiffCartons"; "Worksheet"; "NonDiffCartons")
	//*Determine if they are currently contiguous
	USE NAMED SELECTION:C332("Cartons")
	$contig:=True:C214
	$nextItem:=1
	SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]Item:1; $itemNumber)
	
	For ($i; 1; $numRecs)
		If (Num:C11($itemNumber{$i})#$nextItem)  //something is suspicious
			If (Num:C11($itemNumber{$i})#($nextItem-1))  //not the same as the last item?
				$contig:=False:C215
				$i:=$i+$numRecs  //break
				uConfirm("WARNING: The Estimate's item numbers are "+"going to be resequenced to match the Order's lines."; "OK"; "Help")
			End if 
		Else 
			$nextItem:=$nextItem+1
		End if 
	End for 
	
	//*If resequencing is required:
	If (Not:C34($contig))
		//*.      Determine highest item number used on the worksheet
		USE SET:C118("Worksheet")
		ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)  //this is the worksheet only 
		LAST RECORD:C200([Estimates_Carton_Specs:19])
		$maxWS:=Num:C11([Estimates_Carton_Specs:19]Item:1)
		//this highestWS will be used as a boundary for items that 
		//were not included in the target differential, it will be incremented
		//as items are shuffled to the end
		
		//*.      Resequence the target differencial c-specs.    
		USE NAMED SELECTION:C332("Cartons")
		//*.         Setup arrays to hold cross refer of the before & after item numbers
		//*MAKE THESE LOCAL ARRAYS AFTER TESTING
		ARRAY TEXT:C222(aItems; 0)
		ARRAY TEXT:C222(acpns; 0)
		ARRAY TEXT:C222(aNewItem; 0)
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]Item:1; aItems; [Estimates_Carton_Specs:19]ProductCode:5; acpns)
		ARRAY TEXT:C222(aNewItem; $numRecs)
		$lastItem:=""  //this keeps track of where we are
		$orderitem:=0  //this is what the item will be on the order see also upr 1458
		For ($i; 1; $numRecs)  //each carton in the differential
			If (aItems{$i}=$lastitem)  //then its the same item, dont increment
				aNewItem{$i}:=String:C10($orderitem; "00")  //assign the same item as the last had
			Else   //different item so increment
				$orderitem:=$orderitem+1
				aNewItem{$i}:=String:C10($orderitem; "00")  //assign the incremented item
				$lastItem:=aItems{$i}  //set up for next pass
			End if 
		End for   //each diff carton
		//*.         See if any diff items are not in the worksheet
		USE SET:C118("Worksheet")
		ARRAY TEXT:C222(aWSitems; 0)
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]Item:1; aWSitems)
		For ($i; 1; $numRecs)
			$j:=Find in array:C230(aWSitems; aItems{$i})
			If ($j=-1)
				uConfirm("WARNING: Item "+aItems{$i}+" was used in the differential but not found in the Worksheet."; "OK"; "Help")
			End if 
		End for 
		
		//*START TRANSACTION
		$Continue:=True:C214
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
			
		Else 
			USE NAMED SELECTION:C332("Cartons")
			ARRAY LONGINT:C221($_Cartons; 0)
			LONGINT ARRAY FROM SELECTION:C647([Estimates_Carton_Specs:19]; $_Cartons)
		End if   // END 4D Professional Services : January 2019 query selection
		
		For ($i; 1; $numRecs)
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
				
				USE NAMED SELECTION:C332("Cartons")
				GOTO SELECTED RECORD:C245([Estimates_Carton_Specs:19]; $i)
				
			Else 
				
				GOTO RECORD:C242([Estimates_Carton_Specs:19]; $_Cartons{$i})
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			If (fLockNLoad(->[Estimates_Carton_Specs:19]))
				If ([Estimates_Carton_Specs:19]ProductCode:5=acpns{$i})  //retentive test 
					[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(aNewItem{$i})
					//[Estimates_Carton_Specs]Item:=aNewItem{$i}
					SAVE RECORD:C53([Estimates_Carton_Specs:19])
					//*.         Update the form cartons as well
					RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)
					APPLY TO SELECTION:C70([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3:=Num:C11(aNewItem{$i}))
					
				Else   //cpn is wrong
					uConfirm("CPN "+acpns{$i}+" seems to be out-o-whack for new item "+aNewItem{$i}+", old item "+aItems{$i}; "OK"; "Help")
				End if 
				
			Else 
				// CANCEL TRANSACTION
				$Continue:=False:C215
				$i:=$i+$numRecs  //break
			End if 
			
		End for 
		
		If ($Continue)
			//*.      Resequence the worksheet c-specs.
			ARRAY TEXT:C222(aSkipped; 0)
			ARRAY TEXT:C222(aNewSkip; 0)
			If ($diff#<>sQtyWorksht)  // the worksheet was not the original target
				//*.         Find which item nº are not used in diff by scaning old sequence 
				
				$lastItem:=""  //this keeps track of where we are
				$orderitem:=0  //this is what the item will be on the order see also upr 1458
				For ($i; 1; $numRecs)  //each carton in the differential
					If (aItems{$i}#$lastitem)  //then its the different item, increment
						
						$orderitem:=$orderitem+1
						While (aItems{$i}#(String:C10($orderitem; "00"))) & ($orderitem<100)  //then the item order item was skipped
							$skipSize:=Size of array:C274(aSkipped)+1
							ARRAY TEXT:C222(aSkipped; $skipSize)
							aSkipped{$skipSize}:=String:C10($orderitem; "00")
							$orderitem:=$orderitem+1
						End while 
						
						$lastItem:=aItems{$i}  //set up for next pass
					End if   //not same as last
					
				End for   //each diff carton              
				
				//*.         then renumber these item in the WS beyond the maxW
				//                             do this so there are no collisions when the 
				//                             worksheet is resequenced like the differential
				ARRAY TEXT:C222(aNewSkip; Size of array:C274(aSkipped))
				For ($i; 1; Size of array:C274(aSkipped))
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						USE SET:C118("Worksheet")
						QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aSkipped{$i})
						
						
					Else 
						
						QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate; *)
						QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht; *)
						QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aSkipped{$i})
						
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					If (Records in selection:C76([Estimates_Carton_Specs:19])=1)
						$maxWS:=$maxWS+1  //This will move all the skipped worksheet records beyond the last
						[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT($maxWS)
						//[Estimates_Carton_Specs]Item:=String($maxWS;"00")
						SAVE RECORD:C53([Estimates_Carton_Specs:19])
						aNewSkip{$i}:=String:C10($maxWS; "00")
					Else 
						aNewSkip{$i}:="00"
					End if 
				End for 
				
				//*.         then renumber worksheet items to match the differential
				For ($i; 1; Size of array:C274(aItems))
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						USE SET:C118("Worksheet")
						QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aItems{$i})
						
					Else 
						
						QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate; *)
						QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht; *)
						QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aItems{$i})
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					Case of 
						: (Records in selection:C76([Estimates_Carton_Specs:19])=1)
							If ([Estimates_Carton_Specs:19]ProductCode:5=acpns{$i})  //retentive test              
								[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(aNewItem{$i})
								//[Estimates_Carton_Specs]Item:=aNewItem{$i}
								SAVE RECORD:C53([Estimates_Carton_Specs:19])
							Else   //cpn is wrong
								uConfirm("CPN "+acpns{$i}+" seems to be out-o-whack for new item "+aNewItem{$i}+", old item "+aItems{$i}+" on the worksheet."; "OK"; "Help")
							End if 
							
						: (Records in selection:C76([Estimates_Carton_Specs:19])>1)
							If ([Estimates_Carton_Specs:19]ProductCode:5=acpns{$i})  //retentive test                   
								[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(aNewItem{$i})
								//[Estimates_Carton_Specs]Item:=aNewItem{$i}
								SAVE RECORD:C53([Estimates_Carton_Specs:19])
								uConfirm("There is more than one item "+aItems{$i}+" on the worksheet, better check the results."; "OK"; "Help")
							Else   //cpn is wrong
								uConfirm("CPN "+acpns{$i}+" seems to be out-o-whack for new item "+aNewItem{$i}+", multiple old item "+aItems{$i}+" on the worksheet."; "OK"; "Help")
							End if 
					End case 
				End for 
				//*.         then renumber worksheet items skipped on the differential
				For ($i; 1; Size of array:C274(aSkipped))
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						USE SET:C118("Worksheet")
						If (aNewSkip{$i}#"00")
							QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aSkipped{$i})
							If (Records in selection:C76([Estimates_Carton_Specs:19])>0)
								$tItemNumber:=EsCS_SetItemT(aNewSkip{$i})
								APPLY TO SELECTION:C70([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1:=$tItemNumber)
								//APPLY TO SELECTION([Estimates_Carton_Specs];[Estimates_Carton_Specs]Item:=aNewSkip{$i})
							End if 
						End if 
						
					Else 
						
						If (aNewSkip{$i}#"00")
							QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate; *)
							QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht; *)
							QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aSkipped{$i})
							If (Records in selection:C76([Estimates_Carton_Specs:19])>0)
								$tItemNumber:=EsCS_SetItemT(aNewSkip{$i})
								APPLY TO SELECTION:C70([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1:=$tItemNumber)
								//APPLY TO SELECTION([Estimates_Carton_Specs];[Estimates_Carton_Specs]Item:=aNewSkip{$i})
							End if 
						End if 
						
					End if   // END 4D Professional Services : January 2019 query selection
					
				End for 
			End if   // the worksheet was the original target
			
			//*.      Resequence the other, if any,  differencials c-specs.
			If (Records in set:C195("NonDiffCartons")>0)
				For ($i; 1; Size of array:C274(aItems))
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
						
						If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
							
							USE SET:C118("NonDiffCartons")
							QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aItems{$i})
							CREATE SET:C116([Estimates_Carton_Specs:19]; "OtherCartons")
							
							
						Else 
							
							USE SET:C118("NonDiffCartons")
							SET QUERY DESTINATION:C396(Into set:K19:2; "OtherCartons")
							QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aItems{$i})
							SET QUERY DESTINATION:C396(Into current selection:K19:1)
							
						End if   // END 4D Professional Services : January 2019 query selection
						
					Else 
						
						ARRAY LONGINT:C221($_OtherCartons; 0)
						USE SET:C118("NonDiffCartons")
						QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aItems{$i})
						LONGINT ARRAY FROM SELECTION:C647([Estimates_Carton_Specs:19]; $_OtherCartons)
						
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					For ($j; 1; Records in selection:C76([Estimates_Carton_Specs:19]))
						If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
							
							USE SET:C118("OtherCartons")
							GOTO SELECTED RECORD:C245([Estimates_Carton_Specs:19]; $j)
							
						Else 
							
							GOTO RECORD:C242([Estimates_Carton_Specs:19]; $_OtherCartons{$j})
							
						End if   // END 4D Professional Services : January 2019 query selection
						[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(aNewItem{$i})
						//[Estimates_Carton_Specs]Item:=aNewItem{$i}
						SAVE RECORD:C53([Estimates_Carton_Specs:19])
						
						//*.            Update the form cartons as well
						RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)
						APPLY TO SELECTION:C70([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3:=Num:C11(aNewItem{$i}))
						
					End for 
				End for 
				//*.         then renumber other items skipped on the differential
				For ($i; 1; Size of array:C274(aSkipped))
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
						
						If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
							
							USE SET:C118("NonDiffCartons")
							QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aSkipped{$i})
							CREATE SET:C116([Estimates_Carton_Specs:19]; "OtherCartons")
							
							
						Else 
							
							USE SET:C118("NonDiffCartons")
							SET QUERY DESTINATION:C396(Into set:K19:2; "OtherCartons")
							QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aSkipped{$i})
							SET QUERY DESTINATION:C396(Into current selection:K19:1)
							
							
						End if   // END 4D Professional Services : January 2019 query selection
						
					Else 
						
						ARRAY LONGINT:C221($_OtherCartons; 0)
						USE SET:C118("NonDiffCartons")
						QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1=aSkipped{$i})
						LONGINT ARRAY FROM SELECTION:C647([Estimates_Carton_Specs:19]; $_OtherCartons)
						
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					For ($j; 1; Records in selection:C76([Estimates_Carton_Specs:19]))
						If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
							
							USE SET:C118("OtherCartons")
							GOTO SELECTED RECORD:C245([Estimates_Carton_Specs:19]; $j)
							
						Else 
							
							GOTO RECORD:C242([Estimates_Carton_Specs:19]; $_OtherCartons{$j})
							
						End if   // END 4D Professional Services : January 2019 query selection
						
						[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(aNewSkip{$i})
						//[Estimates_Carton_Specs]Item:=aNewSkip{$i}
						SAVE RECORD:C53([Estimates_Carton_Specs:19])
						
						//*.            Update the form cartons as well
						RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)
						APPLY TO SELECTION:C70([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3:=Num:C11(aNewSkip{$i}))
						
					End for 
				End for 
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
					
					CLEAR SET:C117("OtherCartons")
					
				Else 
					
				End if   // END 4D Professional Services : January 2019 query selection
				
			End if   //there are other cartons in the estimate
		End if 
		
		//*THIS IS FOR TESTING  
		//uDialog ("debugArrays";475;590) 
		
		If ($Continue)
			//VALIDATE TRANSACTION
		Else 
			//CANCEL TRANSACTION
		End if 
		
	Else 
		BEEP:C151
		MESSAGE:C88($Diff+" is already in sequence.")  //•062695  MLB  UPR 217
	End if   //contiguous
	
	//*Cleanup
	CLEAR SET:C117("Allcartons")
	CLEAR SET:C117("Worksheet")
	CLEAR SET:C117("NonDiffCartons")
	CLEAR NAMED SELECTION:C333("Cartons")
	
	ARRAY TEXT:C222(aItems; 0)
	ARRAY TEXT:C222(acpns; 0)
	ARRAY TEXT:C222(aNewItem; 0)
	ARRAY TEXT:C222(aSkipped; 0)
	ARRAY TEXT:C222(aNewSkip; 0)
	ARRAY TEXT:C222(aWSitems; 0)
	UNLOAD RECORD:C212([Estimates_Carton_Specs:19])
	
Else   //not enough parameters
	uConfirm("Not enough parameters for Procedure: Ord_ResequenceCartonsIfGaps to work."; "OK"; "Help")
End if 