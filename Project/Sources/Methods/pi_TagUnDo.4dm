//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 12/13/06, 14:32:15
// ----------------------------------------------------
// Method: pi_TagUnDo()  --> 
// ----------------------------------------------------

C_TEXT:C284($1; $startTag)  //tag number as a string
C_LONGINT:C283($tagNum)

If (Count parameters:C259=0)
	$pid:=New process:C317("pi_TagUnDo"; <>lMinMemPart; "Undoing Tags"; "init")
	If (False:C215)
		pi_TagUnDo
	End if 
	
Else 
	dDate:=Current date:C33
	READ WRITE:C146([Raw_Materials_Transactions:23])
	READ WRITE:C146([Raw_Materials_Locations:25])
	Repeat 
		$begin:=0
		$end:=0
		zwStatusMsg("UNDO TAG"; "Enter a tag.")
		$startTag:=Request:C163("Enter tag# to UnDo:"; ""; "Continue"; "Cancel")
		If (Length:C16($startTag)>0) & (ok=1)
			$tagNum:=Num:C11($startTag)
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]ReceivingNum:23=$tagNum; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="ADJUST"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3>(Current date:C33-30))
			//$date:=Date(Request("date?"))
			//QUERY([Raw_Materials_Transactions];[Raw_Materials_Transactions]XferDate>$date)
			If (Records in selection:C76([Raw_Materials_Transactions:23])>1)
				//pop a list to pick from
				BEEP:C151
				ARRAY BOOLEAN:C223(ListBox1; 0)
				ARRAY LONGINT:C221(alRecNo; 0)
				ARRAY TEXT:C222(asPrimKey; 0)  //•080596  MLB  make larger, was A10
				ARRAY TEXT:C222(asDesc1; 0)
				ARRAY TEXT:C222(asDesc2; 0)
				ARRAY REAL:C219($aQty; 0)
				SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]; alRecNo; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; asPrimKey; [Raw_Materials_Transactions:23]POItemKey:4; asDesc1; [Raw_Materials_Transactions:23]Qty:6; $aQty)
				ARRAY TEXT:C222(asDesc2; Size of array:C274(alRecNo))
				For ($i; 1; Size of array:C274(alRecNo))
					asDesc2{$i}:=String:C10($aQty{$i}; "##,###,##0.####")
				End for 
				
				tMessage1:="To select, click on the "+"Transaction"+"name below."
				sHead1:="Raw_Matl_Code"
				sHead2:="Purchase Order"
				sHead3:="Quantity"
				windowTitle:="Select a tag from this list"
				$winRef:=OpenFormWindow(->[zz_control:1]; "PickList_dio"; ->windowTitle; windowTitle)
				DIALOG:C40([zz_control:1]; "PickList_dio")
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					GOTO RECORD:C242([Raw_Materials_Transactions:23]; alRecNo{ListBox1})
				Else 
					REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
				End if 
				ARRAY LONGINT:C221(alRecNo; 0)
				ARRAY TEXT:C222(asPrimKey; 0)
				ARRAY TEXT:C222(asDesc1; 0)
				ARRAY TEXT:C222(asDesc2; 0)
				ARRAY REAL:C219($aQty; 0)
				
			End if 
			
			If (Records in selection:C76([Raw_Materials_Transactions:23])=1)
				CONFIRM:C162("Remove tag "+$startTag+" for "+String:C10([Raw_Materials_Transactions:23]Qty:6)+" of "+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+" PO:"+[Raw_Materials_Transactions:23]POItemKey:4)
				If (ok=1)
					$continue:=True:C214
					QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=[Raw_Materials_Transactions:23]POItemKey:4; *)
					QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=[Raw_Materials_Transactions:23]Location:15)
					If (Records in selection:C76([Raw_Materials_Locations:25])>0)
						If (fLockNLoad(->[Raw_Materials_Locations:25]))
							[Raw_Materials_Locations:25]ModWho:22:=<>zResp
							[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
							[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-[Raw_Materials_Transactions:23]Qty:6
							[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyOH:9
							[Raw_Materials_Locations:25]AdjQty:14:=[Raw_Materials_Locations:25]QtyOH:9-[Raw_Materials_Locations:25]PiFreezeQty:23
							[Raw_Materials_Locations:25]AdjDate:17:=dDate
							[Raw_Materials_Locations:25]AdjTo:15:="Phys Inv"
							[Raw_Materials_Locations:25]AdjBy:16:=<>zResp
							SAVE RECORD:C53([Raw_Materials_Locations:25])
							
						Else 
							BEEP:C151
							ALERT:C41("[Raw_Materials_Locations] record was locked, try later. Tag not deleted.")
							$continue:=False:C215
						End if 
						
					Else 
						BEEP:C151
						CONFIRM:C162("[Raw_Materials_Locations] record was not found. Delete tag anyway?"; "Delete"; "Cancel")
						If (ok=1)
							$continue:=True:C214
						Else 
							$continue:=False:C215
						End if 
					End if 
					
					If ($continue)
						util_DeleteSelection(->[Raw_Materials_Transactions:23])
					End if 
					
				End if 
				
			Else 
				BEEP:C151
				ALERT:C41($startTag+" was not found or is not unique.")
			End if 
			
		Else 
			BEEP:C151
			zwStatusMsg("UNDO CANCELLED"; "User cancelled")
		End if 
	Until (OK=0)
End if 