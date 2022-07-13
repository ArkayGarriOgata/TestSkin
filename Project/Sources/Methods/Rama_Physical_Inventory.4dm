//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 12/27/12, 11:35:08
// Modified by: Mel Bohince (1/10/13)tag pre consignment adds
// ----------------------------------------------------
// Method: Rama_Physical_Inventory
// Description
// read in file sent from Rama's counters, RGIS,
// 4 columns, SSCC (if avail), ProductCode, Jobit, Qty
// based on pattern_ReadTextDocument
// ----------------------------------------------------

C_LONGINT:C283($1; $id)
C_DATE:C307($today)
C_TEXT:C284($recordDelimitor)
C_TIME:C306($docRef)
C_LONGINT:C283($qty; $i)
C_TEXT:C284($sscc; $cpn; $jobit; row; $tagNum)
C_BOOLEAN:C305($tag_included; $suspect_old_item)

If (Count parameters:C259=0)
	uConfirm("import text as SSCC<tab>CPN<tab>Jobit<tab>qty<cr>?"; "Yes"; "No")
	If (OK=1)
		$id:=New process:C317("Rama_Physical_Inventory"; <>lMinMemPart; "Rama_Import"; 2)
	End if 
	
Else   //init process
	uConfirm("pi Tag number in first column?"; "Yes"; "No")
	If (OK=1)
		$tag_included:=True:C214
	Else 
		$tag_included:=False:C215
	End if 
	
	$docRef:=Open document:C264("")  //open the document
	$document:=Document
	If (OK=1)
		READ WRITE:C146([Finished_Goods_Locations:35])
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:AV=@"; *)  //a little house cleaning
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9=0)
		util_DeleteSelection(->[Finished_Goods_Locations:35])
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:AV=@")
		APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]BeginDate:4:=!00-00-00!)  //so we can tell if its been touched or not
		APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]BeginQty:3:=0)  //count of times touched
		READ ONLY:C145([WMS_SerializedShippingLabels:96])  //for validations
		READ ONLY:C145([Job_Forms_Items:44])  //for validations
		
		$position_sscc:=2
		$position_cpn:=3
		$position_jobit:=4
		$position_qty:=5
		
		CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "modified")
		$recordDelimitor:=Char:C90(13)
		$today:=4D_Current_date
		
		utl_Logfile("Rama_Import.log"; "//////////////")
		utl_Logfile("Rama_Import.log"; "////////////// Reading: "+$document)
		utl_Logfile("Rama_Import.log"; "//////////////")
		RECEIVE PACKET:C104($docRef; row; $recordDelimitor)  //read the document
		$i:=0
		row:=Replace string:C233(row; Char:C90(34); "")
		While (Length:C16(row)>10)  //(ok=1) &
			$i:=$i+1
			zwStatusMsg("Row"+String:C10($i); row)
			
			// Parse the row into vars, and cleanse 
			If (Not:C34($tag_included))
				row:="0000"+Char:C90(9)+row
			End if 
			util_TextParser(5; row)
			
			$tagNum:=util_TextParser(1)
			$sscc:=util_TextParser(2)
			$cpn:=util_TextParser(3)
			$jobit:=util_TextParser(4)
			$qty:=Num:C11(util_TextParser(5))
			util_TextParser
			
			$tagNum:=fStripSpace("B"; $tagNum)
			$sscc:=fStripSpace("B"; $sscc)
			$cpn:=fStripSpace("B"; $cpn)
			$jobit:=fStripSpace("B"; $jobit)
			Case of 
				: (Length:C16($jobit)=11)  //92374.01.01 ideal
					//pass
				: (Length:C16($jobit)=13)  //APRV923740101
					$jobit:=Substring:C12($jobit; 5)
					$jobit:=JMI_makeJobIt($jobit)
			End case 
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$cpn)
			//query([Finished_Goods_Locations];&;[Finished_Goods_Locations]Location#"FG:AV=Rama_PhyInv")
			If (Records in selection:C76([Finished_Goods_Locations:35])=0)
				$suspect_old_item:=True:C214
			Else 
				$suspect_old_item:=False:C215
			End if 
			
			// ######## Condition 1, using SSCC #########
			If (Length:C16($sscc)=20)
				QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=$sscc)  //verify that we made the label
				If (Records in selection:C76([WMS_SerializedShippingLabels:96])=1)
					If ([WMS_SerializedShippingLabels:96]CPN:2#$cpn)
						utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" wrong std CPN.")
					End if 
					
					sCriterion1:=[WMS_SerializedShippingLabels:96]CPN:2
					sCriterion2:="00199"
					sCriterion4:="FG:AV=Rama_PhyInv"
					If ([WMS_SerializedShippingLabels:96]Jobit:3#$jobit)
						utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" wrong std Jobit.")
					End if 
					sCriterion5:=Substring:C12([WMS_SerializedShippingLabels:96]Jobit:3; 1; 8)
					i1:=Num:C11(Substring:C12([WMS_SerializedShippingLabels:96]Jobit:3; 10; 2))
					sCriter10:=$sscc
					If ([WMS_SerializedShippingLabels:96]Quantity:4#$qty)
						utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" wrong std QTY.")
					End if 
				Else   //not looking to valid
					utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" appears to be invalid.")
					sCriterion1:=$cpn
					sCriterion2:="00199"
					sCriterion4:="FG:AV=Rama_PhyInvErr"
					sCriterion5:=Substring:C12($jobit; 1; 8)
					i1:=Num:C11(Substring:C12($jobit; 10; 2))
					sCriter10:=$sscc
				End if 
				
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=$sscc)
				If (Records in selection:C76([Finished_Goods_Locations:35])=1)
					If ([Finished_Goods_Locations:35]QtyOH:9#$qty)
						utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" qty set to "+String:C10($qty))
						[Finished_Goods_Locations:35]QtyOH:9:=$qty
					Else 
						utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" OK")
					End if 
					
					If (Substring:C12([Finished_Goods_Locations:35]Location:2; 1; 6)="FG:AV-")  //marked as in-transit
						[Finished_Goods_Locations:35]Location:2:="FG:AV="+Substring:C12([Finished_Goods_Locations:35]Location:2; 7)
						utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" marked as Received")
					End if 
					
					[Finished_Goods_Locations:35]BeginDate:4:=$today
					[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
					SAVE RECORD:C53([Finished_Goods_Locations:35])
					
				Else 
					Case of 
						: (Records in selection:C76([Finished_Goods_Locations:35])=0)
							If ($suspect_old_item)
								utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" ******* pre-consignment inventory, record skipped.")
							Else 
								utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" was not found, record added.")
								FG_makeLocation
								[Finished_Goods_Locations:35]QtyOH:9:=$qty
								[Finished_Goods_Locations:35]BeginDate:4:=$today
								[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
								SAVE RECORD:C53([Finished_Goods_Locations:35])
							End if 
						: (Records in selection:C76([Finished_Goods_Locations:35])>1)
							utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+", "+$cpn+", "+$jobit+", "+String:C10($qty)+" ignored, SSCC not unique.")
							REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
					End case 
					
				End if 
				
				// ######## Condition 2, attruibute matching #########
			Else   //sscc not provided, test jobit
				If (qryJMI($jobit)>0)
					sCriterion1:=$cpn
					sCriterion2:="00199"
					sCriterion4:="FG:AV=Rama_PhyInv"
					sCriterion5:=Substring:C12($jobit; 1; 8)
					i1:=Num:C11(Substring:C12($jobit; 10; 2))
					sCriter10:=$sscc
					
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$jobit; *)  //get the jobit, that
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]skid_number:43#"00@"; *)  //doesn't have a pallet id, and
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:AV=R@")  //is at the rama warehouse
					
					Case of 
						: (Records in selection:C76([Finished_Goods_Locations:35])=1)  //great, no confusion
							If ([Finished_Goods_Locations:35]QtyOH:9#$qty)
								utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" qty set to "+String:C10($qty))
							Else 
								utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" qty OK")
							End if 
							
							If ([Finished_Goods_Locations:35]BeginDate:4=$today)  //already touched, be additive
								[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$qty
								[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
							Else 
								[Finished_Goods_Locations:35]QtyOH:9:=$qty
								[Finished_Goods_Locations:35]BeginDate:4:=$today
								[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
							End if 
							SAVE RECORD:C53([Finished_Goods_Locations:35])
							
						: (Records in selection:C76([Finished_Goods_Locations:35])>1)  // hmmm, try to hone in on it
							// ******* Verified  - 4D PS - January  2019 ********
							
							QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9=$qty)
							
							
							// ******* Verified  - 4D PS - January 2019 (end) *********
							If (Records in selection:C76([Finished_Goods_Locations:35])=1)  //match found, cool
								utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" OK")
								If ([Finished_Goods_Locations:35]BeginDate:4=$today)  //already touched, be additive
									[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$qty
									[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
									utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" qty increased by "+String:C10($qty))
								Else 
									[Finished_Goods_Locations:35]QtyOH:9:=$qty
									[Finished_Goods_Locations:35]BeginDate:4:=$today
									[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
								End if 
								SAVE RECORD:C53([Finished_Goods_Locations:35])
								
							Else   //too confusing, just create
								If ($suspect_old_item)
									utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" ******* pre-consignment inventory, record skipped.")
								Else 
									utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" multiple found, no qty match, record added.")
									FG_makeLocation
									[Finished_Goods_Locations:35]QtyOH:9:=$qty
									[Finished_Goods_Locations:35]BeginDate:4:=$today
									[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
									SAVE RECORD:C53([Finished_Goods_Locations:35])
								End if 
							End if 
							
						Else   //test the in-transit
							QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$jobit; *)  //get the jobit, that
							QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]skid_number:43#"00@"; *)  //doesn't have a pallet id, and
							QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:AV-R@")
							If (Records in selection:C76([Finished_Goods_Locations:35])=1)
								If ([Finished_Goods_Locations:35]QtyOH:9#$qty)
									utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" qty set to "+String:C10($qty))
								Else 
									utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" qty OK")
								End if 
								utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+"  and marked as Received")
								[Finished_Goods_Locations:35]Location:2:="FG:AV="+Substring:C12([Finished_Goods_Locations:35]Location:2; 7)
								
								If ([Finished_Goods_Locations:35]BeginDate:4=$today)  //already touched, be additive
									[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$qty
									[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
									utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" qty increased by "+String:C10($qty))
								Else 
									[Finished_Goods_Locations:35]QtyOH:9:=$qty
									[Finished_Goods_Locations:35]BeginDate:4:=$today
									[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
								End if 
								SAVE RECORD:C53([Finished_Goods_Locations:35])
								
							Else   //ok, fine, will just create it.
								If ($suspect_old_item)
									utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" ******* pre-consignment inventory, record skipped.")
								Else 
									utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+" was not found, not in-transit either, record added.")
									FG_makeLocation
									[Finished_Goods_Locations:35]QtyOH:9:=$qty
									[Finished_Goods_Locations:35]BeginDate:4:=$today
									[Finished_Goods_Locations:35]BeginQty:3:=[Finished_Goods_Locations:35]BeginQty:3+1
									SAVE RECORD:C53([Finished_Goods_Locations:35])
								End if 
							End if 
					End case 
					
				Else   //bad jobit
					utl_Logfile("Rama_Import.log"; String:C10($i; "0000")+") "+$cpn+" - "+$sscc+", "+$cpn+", "+$jobit+", "+String:C10($qty)+" ignored, jobit not valid.")
				End if   //bad jobit
			End if   //20 char sscc
			
			//tag record
			If (Records in selection:C76([Finished_Goods_Locations:35])>0)
				CREATE SET:C116([Finished_Goods_Locations:35]; "new_cost")
				UNION:C120("modified"; "new_cost"; "modified")
				//APPLY TO SELECTION([Raw_Materials];Ink_Import_Set_Cost ($cost;$sap))
			Else 
				//utl_Logfile ("Rama_Import.log";String($i;"0000")+") "+$sscc+", "+$cpn+", "+$jobit+", "+String($qty)+" ignored, not found.")
			End if 
			
			//Set up for next row to import
			RECEIVE PACKET:C104($docRef; row; $recordDelimitor)
			row:=Replace string:C233(row; Char:C90(34); "")
		End while 
		
		REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
		CLOSE DOCUMENT:C267($docRef)
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:AV=@"; *)  //look for untouched records
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]BeginQty:3=0)
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			utl_Logfile("Rama_Import.log"; String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" location records not reported, BeginQty=0, FG:AV=@")
		End if 
		
		USE SET:C118("modified")
		pattern_PassThru(->[Finished_Goods_Locations:35])
		ViewSetter(2; ->[Finished_Goods_Locations:35])
		
		REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
		CLEAR SET:C117("new_cost")
		CLEAR SET:C117("modified")
		BEEP:C151
	End if 
End if 