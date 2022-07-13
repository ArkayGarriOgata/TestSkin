//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/05/13, 08:45:56
// ----------------------------------------------------
// Method: FGPlusMinusPairs
// Description:
// Finds any +/- pairs based on the user input jobit.
// ----------------------------------------------------
// Added by: Mark Zinke (6/18/13) Creates transactions before deleting.
// Modified by: Mel Bohince (3/27/14) make one, not four transactions
// Modified by: Mel Bohince (4/6/16) put in a repeat loop and re-use askme process, re-use the window for stability
//                                   and rework the selecting process and dialog sizing
//                                   and make these dialogs singletons

C_TEXT:C284(tJobIt)
C_LONGINT:C283(vAskMePID; <>pid_plusminus)
C_LONGINT:C283($i; $xlCount; $winRef)
$winRef:=0
C_BOOLEAN:C305($done)
$done:=False:C215
C_TEXT:C284($1)

If (Count parameters:C259=0)
	If (<>pid_plusminus=0)  //singleton
		<>pid_plusminus:=New process:C317("FGPlusMinusPairs"; <>lMidMemPart; "Plus Minus Pairs"; "init")
		If (False:C215)
			FGPlusMinusPairs
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_plusminus)
		BRING TO FRONT:C326(<>pid_plusminus)
	End if 
	
Else 
	
	Case of 
		: ($1="init")
			
			READ WRITE:C146([Finished_Goods_Locations:35])
			
			Repeat 
				
				ARRAY TEXT:C222(atJobIt; 0)
				ARRAY TEXT:C222(atProdCode; 0)
				ARRAY TEXT:C222(atLocation; 0)
				ARRAY TEXT:C222(atSkidNum; 0)  //Pallete ID
				ARRAY LONGINT:C221(axlQuantity; 0)
				ARRAY LONGINT:C221(axlRecNum; 0)
				
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9<0)
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)
					ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1; >)
					SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; atJobIt; [Finished_Goods_Locations:35]ProductCode:1; atProdCode; [Finished_Goods_Locations:35]Location:2; atLocation; [Finished_Goods_Locations:35]skid_number:43; atSkidNum; [Finished_Goods_Locations:35]QtyOH:9; axlQuantity)
					//CenterWindow (730;320;Plain window;"Plus/Minus Check")
					
					tWindowTitle:="FG Locations that are Negative"
					If ($winRef=0)  //first time to the bar
						$winRef:=OpenFormWindow(->[Finished_Goods_Locations:35]; "PlusMinusCheck"; ->tWindowTitle; tWindowTitle)
					Else 
						ERASE WINDOW:C160($winRef)
						SET WINDOW TITLE:C213(tWindowTitle; $winRef)
					End if 
					DIALOG:C40([Finished_Goods_Locations:35]; "PlusMinusCheck")
					ERASE WINDOW:C160($winRef)
					
					If (OK=1)
						ARRAY TEXT:C222(atJobIt; 0)
						ARRAY TEXT:C222(atProdCode; 0)
						ARRAY TEXT:C222(atLocation; 0)
						ARRAY TEXT:C222(atSkidNum; 0)  //Pallete ID
						ARRAY LONGINT:C221(axlQuantity; 0)
						ARRAY LONGINT:C221(axlRecNum; 0)
						
						QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=tJobIt)
						If (Records in selection:C76([Finished_Goods_Locations:35])>0)
							ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43; >)
							SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; atJobIt; [Finished_Goods_Locations:35]ProductCode:1; atProdCode; [Finished_Goods_Locations:35]Location:2; atLocation; [Finished_Goods_Locations:35]skid_number:43; atSkidNum; [Finished_Goods_Locations:35]QtyOH:9; axlQuantity; [Finished_Goods_Locations:35]; axlRecNum)
							ARRAY BOOLEAN:C223(abDelete; Size of array:C274(atJobIt))
							//CenterWindow (750;285;Plain window;"Plus/Minus Delete")
							
							tWindowTitle:="Jobit: "+tJobIt+" Found in FG Locations"
							SET WINDOW TITLE:C213(tWindowTitle; $winRef)
							//$winRef:=OpenFormWindow (->[Finished_Goods_Locations];"PlusMinusDelete";->tWindowTitle;tWindowTitle)
							DIALOG:C40([Finished_Goods_Locations:35]; "PlusMinusDelete")
							ERASE WINDOW:C160($winRef)
							
							$selected:=Count in array:C907(abDelete; True:C214)
							
							Case of 
								: (($selected=0) & (OK=1))
									uConfirm("You didn't select any records to delete."; "Ok"; "Help")
									
								: (OK=1)
									uConfirm("Are you sure you want to delete the "+String:C10($selected)+" checked records?"; "Do It"; "Nope")
									If (OK=1)  //Delete the selected recs.
										For ($i; 1; Size of array:C274(abDelete))
											If (abDelete{$i})
												GOTO RECORD:C242([Finished_Goods_Locations:35]; axlRecNum{$i})
												If (fLockNLoad(->[Finished_Goods_Locations:35]))  // Modified by: Mel Bohince (3/27/14) lock test
													//FGCreateTransaction` removed by: Mel Bohince (3/27/14) make one, not four transactions
													$jobit:=[Finished_Goods_Locations:35]Jobit:33
													$cpn:=[Finished_Goods_Locations:35]ProductCode:1
													$location:=[Finished_Goods_Locations:35]Location:2
													DELETE RECORD:C58([Finished_Goods_Locations:35])
													$success:=True:C214
												Else 
													$success:=False:C215
												End if 
											End if 
										End for 
										
										If ($success)
											FGCreateTransaction($jobit; $cpn; $location)  // Modified by: Mel Bohince (3/27/14) make one, not four transactions
										End if 
									End if 
							End case 
						End if 
						
					Else   //cancel
						$done:=True:C214
					End if 
					
					
					
				Else 
					ALERT:C41("There were no "+util_Quote("+/-")+" pairs found.")
					$done:=True:C214
				End if 
				
			Until ($done)
			
			If ($winRef>0)
				CLOSE WINDOW:C154($winRef)
				$winRef:=0
			End if 
			
			<>pid_plusminus:=0
	End case 
	
End if 
