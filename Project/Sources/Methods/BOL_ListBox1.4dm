//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/13/07, 16:11:34
// ----------------------------------------------------
// Method: BOL_ListBox1(msg)  --> 
// Description:
// Facade to the listbox1 arrays
// ----------------------------------------------------

C_TEXT:C284($1)  //switch
C_LONGINT:C283($offset; $i; $0; $others)
C_TEXT:C284(xMemo; $rtnText)

$0:=0

Case of 
	: ($1="sort-by-location")
		SORT ARRAY:C229(aLocation2; aReleases; aCPN2; aNumCases2; aPackQty2; aTotalPicked2; aWgt2; aRecNo2; aPallet2; aJobit2; arValues; aPricePerM; >)
		
	: ($1="sort-by-release")
		SORT ARRAY:C229(aReleases; aLocation2; aCPN2; aNumCases2; aPackQty2; aTotalPicked2; aWgt2; aRecNo2; aPallet2; aJobit2; arValues; aPricePerM; >)
		
	: ($1="create-manifest")
		BOL_create_manifest
		If (Not:C34(bol_manifest_manual_edit))
			BOL_BuildTextToPrint
		End if 
		
	: ($1="straddle-inventory")  //requires listbox2 involvement
		For ($i; 1; Size of array:C274(aLocation2))
			$hit:=Find in array:C230(aRecNo; aRecNo2{$i})
			If ($hit>-1)  //deduct inventory
				aQty{$hit}:=aQty{$hit}-aTotalPicked2{$i}
			End if 
		End for 
		
	: ($1="add-to-bol")
		C_LONGINT:C283($i; $weight)
		bol_manifest_refresh_required:=True:C214
		
		For ($i; 1; Size of array:C274(aLocation))
			If (aTotalPicked{$i}>0)
				If (std_cases_skid#0)
					If (aNumCases{$i}=std_cases_skid)
						[Customers_Bills_of_Lading:49]Total_Skids:17:=[Customers_Bills_of_Lading:49]Total_Skids:17+1
					End if 
				Else   //don't increment
					//[Customers_Bills_of_Lading]Total_Skids:=[Customers_Bills_of_Lading]Total_Skids+1  `tickles the on_validate
				End if 
				
				APPEND TO ARRAY:C911(aReleases; release_number)
				APPEND TO ARRAY:C911(aCPN2; aCPN{$i})
				APPEND TO ARRAY:C911(aLocation2; aLocation{$i})
				APPEND TO ARRAY:C911(aRecNo2; aRecNo{$i})
				APPEND TO ARRAY:C911(aNumCases2; aNumCases{$i})
				APPEND TO ARRAY:C911(aPackQty2; aPackQty{$i})
				APPEND TO ARRAY:C911(aTotalPicked2; aTotalPicked{$i})
				APPEND TO ARRAY:C911(aPallet2; aPallet{$i})
				APPEND TO ARRAY:C911(aJobit2; aJobit{$i})
				APPEND TO ARRAY:C911(aPricePerM; pricePerM)
				
				xMemo:=""  //pack up a bundle of reference info
				$rtnText:=util_TaggedText("put"; "orderline"; [Customers_ReleaseSchedules:46]OrderLine:4; ->xMemo)
				$rtnText:=util_TaggedText("put"; "remark1"; [Customers_ReleaseSchedules:46]RemarkLine1:25; ->xMemo)
				$rtnText:=util_TaggedText("put"; "remark2"; [Customers_ReleaseSchedules:46]RemarkLine2:26; ->xMemo)
				$rtnText:=util_TaggedText("put"; "sch-qty"; String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6); ->xMemo)
				$rtnText:=util_TaggedText("put"; "cust-refer"; [Customers_ReleaseSchedules:46]CustomerRefer:3; ->xMemo)
				
				RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
				If (Records in selection:C76([Customers_Order_Lines:41])>0)
					$rtnText:=util_TaggedText("put"; "cust-po"; [Customers_Order_Lines:41]PONumber:21; ->xMemo)
				Else 
					$rtnText:=util_TaggedText("put"; "cust-po"; "OL:"+[Customers_ReleaseSchedules:46]OrderLine:4+"N/F"; ->xMemo)
				End if 
				$rtnText:=util_TaggedText("put"; "cust-id"; [Customers_ReleaseSchedules:46]CustID:12; ->xMemo)
				APPEND TO ARRAY:C911(arValues; xMemo)
				
				If (aWgt{$i}<=0)
					aWgt{$i}:=30
					//BEEP
					//$weight_as_string:=Request("Enter CASE WEIGHT for pack quantity of "+String(aPackQty{$i});"30";"OK";"Use Zero")
					//If (OK=1)
					//aWgt{$i}:=Num($weight_as_string)
					//Else 
					//aWgt{$i}:=0
					//End if 
				End if 
				$weight:=aWgt{$i}*aNumCases{$i}
				APPEND TO ARRAY:C911(aWgt2; $weight)
				
				If (Length:C16([Customers_Bills_of_Lading:49]ChainOfCustody:30)=0)  //only test until found, this is expensive
					[Customers_Bills_of_Lading:49]ChainOfCustody:30:=RM_isCertified_FSC_orSFI("jobit"; aJobit{$i})
				End if 
				
			End if   //something picked
			
		End for 
		
	: ($1="wms-to-bol")
		//populate the release based on the current state of the wms.cases table for that release, need to restore to
		//orginal state in case there were multiple pick agains this release, only the last one counts
		$numReleasesOnBOL:=BOL_ListBox1_revert_release(release_number)
		//build a key for release# and packqty used to find a slot
		ARRAY TEXT:C222($aLookUpKey; $numReleasesOnBOL)
		For ($i; 1; $numReleasesOnBOL)
			$aLookUpKey{$i}:=String:C10(aReleases{$i})+String:C10(aPackQty2{$i})+aJobit2{$i}
		End for 
		
		//insert the pick into the correct row, make new rows if multiple case counts
		For ($i; 1; Size of array:C274(aLocation))  //for each tuple found in wms
			If (aTotalPicked{$i}>0)  //don't bother with empties
				$lookUp:=String:C10(release_number)+String:C10(aPackQty{$i})+aJobit{$i}  //look for an identical match
				$hit:=Find in array:C230($aLookUpKey; $lookUp)
				If ($hit=-1)  //look for a virgin
					$lookForUnused:=String:C10(release_number)+String:C10(0)+"T.B.D."  //aJobit{$i}
					$hit:=Find in array:C230($aLookUpKey; $lookForUnused)
					If ($hit=-1)  //make a new row
						$hit:=Find in array:C230(aReleases; release_number)  //carry over so values from an existing
						If ($hit>-1)
							$cpn:=aCPN2{$hit}
							$memo:=arValues{$hit}
						Else 
							$cpn:="ERROR"
							$memo:="COULDN'T CLONE RELEASE"
						End if 
						APPEND TO ARRAY:C911(aReleases; release_number)
						APPEND TO ARRAY:C911(aCPN2; $cpn)
						APPEND TO ARRAY:C911(aLocation2; "")
						APPEND TO ARRAY:C911(aRecNo2; 0)
						APPEND TO ARRAY:C911(aNumCases2; 0)
						APPEND TO ARRAY:C911(aPackQty2; 0)
						APPEND TO ARRAY:C911(aTotalPicked2; 0)
						APPEND TO ARRAY:C911(aPallet2; "")
						APPEND TO ARRAY:C911(aJobit2; "")
						APPEND TO ARRAY:C911(arValues; $memo)
						APPEND TO ARRAY:C911(aWgt2; 0)
						$hit:=Size of array:C274(aReleases)
					End if   //found unused
				End if 
				If ($hit>-1)  //do overlay since sql query was by release
					aLocation2{$hit}:=aLocation{$i}
					aRecNo2{$hit}:=aRecNo{$i}
					aNumCases2{$hit}:=aNumCases{$i}+aNumCases2{$hit}
					aPackQty2{$hit}:=aPackQty{$i}
					aTotalPicked2{$hit}:=aTotalPicked{$i}+aTotalPicked2{$hit}
					If (Length:C16(aPallet2{$hit})=0)
						aPallet2{$hit}:=aPallet{$i}
					Else 
						If (Position:C15("skids"; aPallet2{$hit})=0)  //one skid so far
							aPallet2{$hit}:="2  skids"
						Else 
							aPallet2{$hit}:=String:C10(Num:C11(Substring:C12(aPallet2{$hit}; 1; 3))+1)+"  skids"
						End if 
					End if 
					aJobit2{$hit}:=aJobit{$i}
					aWgt2{$hit}:=aWgt{$i}*aNumCases2{$hit}
				End if 
			End if   //empties
		End for   //each picked location
		
	: ($1="get-totals")
		BOL_TallyShipment
		
	: ($1="restore-from-blob")
		BOL_ListBox1("init")
		//utl_Logfile ("shipping.log";"BOL# "+String([Customers_Bills_of_Lading]ShippersNo)+";blobsize: "+String(util_BlobSize (->[Customers_Bills_of_Lading]BinPicks)))
		
		If (util_BlobSize(->[Customers_Bills_of_Lading:49]BinPicks:27)>0)
			$offset:=0
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aReleases; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aCPN2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aLocation2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aRecNo2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aNumCases2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aPackQty2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aTotalPicked2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aWgt2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aPallet2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aJobit2; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; arValues; $offset)
			BLOB TO VARIABLE:C533([Customers_Bills_of_Lading:49]BinPicks:27; aPricePerM; $offset)
		End if 
		
	: ($1="init")
		ARRAY BOOLEAN:C223(ListBox1; 0)
		ARRAY LONGINT:C221(aReleases; 0)
		ARRAY TEXT:C222(aCPN2; 0)
		ARRAY LONGINT:C221(aNumCases2; 0)
		ARRAY LONGINT:C221(aPackQty2; 0)
		ARRAY LONGINT:C221(aTotalPicked2; 0)
		ARRAY LONGINT:C221(aWgt2; 0)
		ARRAY TEXT:C222(aLocation2; 0)
		ARRAY LONGINT:C221(aRecNo2; 0)
		ARRAY TEXT:C222(aPallet2; 0)
		ARRAY TEXT:C222(aJobit2; 0)
		ARRAY TEXT:C222(arValues; 0)
		ARRAY REAL:C219(aPricePerM; 0)
		bol_manifest_refresh_required:=True:C214
		
	: ($1="stage-inventory")
		$0:=BOL_StageInventory
		
	: ($1="save-to-blob")
		//put picks into blob
		//trigger will stage inventory
		//utl_Logfile ("debug.log";"  Saving BLOB")
		SET BLOB SIZE:C606([Customers_Bills_of_Lading:49]BinPicks:27; 0)
		If (Size of array:C274(aReleases)>0)
			//utl_Logfile ("debug.log";"  Saving BLOB "+String(Size of array(aReleases))+" releases")
			//utl_Logfile ("shipping.log";"BOL# "+String(Size of array(aReleases))+" releases")
			VARIABLE TO BLOB:C532(aReleases; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aCPN2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aLocation2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aRecNo2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aNumCases2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aPackQty2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aTotalPicked2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aWgt2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aPallet2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aJobit2; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(arValues; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			VARIABLE TO BLOB:C532(aPricePerM; [Customers_Bills_of_Lading:49]BinPicks:27; *)
			//utl_Logfile ("shipping.log";"BOL# "+String([Customers_Bills_of_Lading]ShippersNo)+";blobsize saved: "+String(util_BlobSize (->[Customers_Bills_of_Lading]BinPicks)))
			
		End if 
		
	: ($1="remove-item")
		uConfirm("Remove selected row from the shipment?"; "Remove"; "Keep")
		If (OK=1)
			bol_manifest_refresh_required:=True:C214
			$0:=BOL_PutAwayInventory(aLocation2{ListBox1}; aJobit2{ListBox1}; aPallet2{ListBox1})  // (aRecNo2{ListBox1};$stageBin;aTotalPicked2{ListBox1})
			
			//decide whether to clear the release or not
			$releaseToClear:=aReleases{ListBox1}
			$others:=0
			For ($i; 1; Size of array:C274(aReleases))
				If (aReleases{$i}=$releaseToClear)
					$others:=$others+1
				End if 
			End for 
			
			If ($others=1)  //release doesn't have other entries against it, then release the pending tag
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$releaseToClear)
				If (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
					If (fLockNLoad(->[Customers_ReleaseSchedules:46]))
						[Customers_ReleaseSchedules:46]B_O_L_pending:45:=0  //•020596  MLB 
						If ([Customers_ReleaseSchedules:46]Expedite:35="wms")
							[Customers_ReleaseSchedules:46]Expedite:35:=""
						End if 
						SAVE RECORD:C53([Customers_ReleaseSchedules:46])
						UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
					End if   // `release locked 
				End if 
			End if 
			
			DELETE FROM ARRAY:C228(aReleases; ListBox1; 1)
			DELETE FROM ARRAY:C228(aCPN2; ListBox1; 1)
			DELETE FROM ARRAY:C228(aLocation2; ListBox1; 1)
			DELETE FROM ARRAY:C228(aRecNo2; ListBox1; 1)
			DELETE FROM ARRAY:C228(aNumCases2; ListBox1; 1)
			DELETE FROM ARRAY:C228(aPackQty2; ListBox1; 1)
			DELETE FROM ARRAY:C228(aTotalPicked2; ListBox1; 1)
			DELETE FROM ARRAY:C228(aWgt2; ListBox1; 1)
			DELETE FROM ARRAY:C228(aPallet2; ListBox1; 1)
			DELETE FROM ARRAY:C228(aJobit2; ListBox1; 1)
			DELETE FROM ARRAY:C228(arValues; ListBox1; 1)
			DELETE FROM ARRAY:C228(ListBox1; ListBox1; 1)
			DELETE FROM ARRAY:C228(aPricePerM; ListBox1; 1)
			
			If ([Customers_Bills_of_Lading:49]Total_Skids:17>0)
				uConfirm("Reduce number of Skids by 1?"; "Yes"; "No")
				If (OK=1)
					[Customers_Bills_of_Lading:49]Total_Skids:17:=[Customers_Bills_of_Lading:49]Total_Skids:17-1  //tickles the on_validate
				Else 
					[Customers_Bills_of_Lading:49]Total_Skids:17:=[Customers_Bills_of_Lading:49]Total_Skids:17+0  //tickles the on_validate
				End if 
			Else 
				[Customers_Bills_of_Lading:49]Total_Skids:17:=[Customers_Bills_of_Lading:49]Total_Skids:17+0  //tickles the on_validate
			End if 
			
			BOL_ListBox1("save-to-blob")
			
			BOL_TallyShipment
			
			BOL_setControls
			
		End if   //confirm
		
	: ($1="enter-weight")
		$caseWgt:=Request:C163("Enter the weight for one case:"; "30"; "Add Weight"; "Cancel")
		If (OK=1)
			aWgt2{ListBox1}:=Num:C11($caseWgt)*aNumCases2{ListBox1}
			bol_manifest_refresh_required:=True:C214
			BOL_TallyShipment
		End if 
		
		
End case 