//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/22/08, 10:22:57
// ----------------------------------------------------
// Method: FG_wms_move
// Description
// based on uFGMove but avoid locking problems
//`2/18/09 don't save SC bins
//4/14/09 don't process a sc to sc transaction
//5/21/12 include pallet id's in search

// Modified by: Mel Bohince (9/18/12) added +"Jasmin.Gonzalez@arkay.com"+Char(9) to qa notices
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (4/17/15) don't make a from bin if from is blank, as from wms_api_Send_Case
// Modified by: Mel Bohince (4/13/17) dont create negative bins on 'after-the-fact' ship staging
// Modified by: Mel Bohince (12/6/17) dont process Move without a from bin
// Modified by: Mel Bohince (11/29/18) handle mixed skid SSCC special

// ha, to cheap to make local vars, thus the reminders
//sCriterion1 is 'cpn'
//sCriterion3 is 'from';
//sCriterion4 is 'to'
//sCriter10 is 'skid_number'


READ WRITE:C146([Finished_Goods_Locations:35])
C_LONGINT:C283($numFGs; $numFGL)
C_BOOLEAN:C305($successful_transaction; $0; $fFromExists; $fToExists; $fg_not_found; $fg_To_locked; $fg_From_locked; $scrapping; $was_scrapped; $shippingMove; $mixedSkid)
$successful_transaction:=True:C214
$fFromExists:=True:C214
$fToExists:=True:C214
$fg_not_found:=False:C215
$shippingMove:=False:C215  // Modified by: Mel Bohince (4/13/17) dont create negative bins on 'after-the-fact' ship staging
$creationMove:=False:C215  // Modified by: Mel Bohince (4/15/19) dont create negative bins on "created" 

$mixedSkid:=(Substring:C12(sCriter10; 1; 3)="005")  // Modified by: Mel Bohince (11/29/18) mixed skid SSCC begin with 005
If ($mixedSkid)  //
	$successful_transaction:=FG_wms_move_mixed(sCriter10; sCriterion3)
	If ($successful_transaction)
		$emailBody:="mixed skid SUCCESS "
	Else 
		$emailBody:="mixed skid FAIL "
	End if 
	EMAIL_Sender("aMs_EXPORTS MIXED SKID"; ""; $emailBody+String:C10([WMS_aMs_Exports:153]id:1))
	utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+" MIXED SKID MOVE "+sCriterion1+" "+sCriterion3+" "+sCriterion4)
	
Else   //original code
	$scrapping:=(Substring:C12(sCriterion4; 1; 2)="SC")
	$was_scrapped:=(Substring:C12(sCriterion3; 1; 2)="SC")
	$shippingMove:=(Position:C15("ship"; sCriterion4)>0)  // Modified by: Mel Bohince (4/13/17) 
	$creationMove:=(Position:C15("creat"; sCriterion3)>0)  // Modified by: Mel Bohince (4/15/19) 
	
	C_DATE:C307(date_certified; $xactionDate)
	date_certified:=!00-00-00!
	C_TIME:C306($xactionTime)
	$xactionDate:=dDate
	$xactionTime:=tTime
	If (sCriterion4#sCriterion3)  //actually moving it
		If (Length:C16(sCriterion3)<4)  // Modified by: Mel Bohince (12/6/17) dont process Move without a from bin
			$msg:=String:C10([WMS_aMs_Exports:153]id:1)+" WARNING: "+"'From bin not specified: "+sCriterion1+" to "+sCriterion4
			utl_Logfile("wms_api.log"; $msg)
			//EMAIL_Sender ("WMS: No From-bin";"";$msg)
		End if 
		
		//search for valid fg material
		$numFGs:=qryFinishedGood(sCriterion2; sCriterion1)
		If ($numFGs=0)
			$fg_not_found:=True:C214
			$successful_transaction:=False:C215
		End if 
		
		//search for TO bin
		$numFGL:=FGL_qryBin(sJobit; sCriterion4; sCriter10)
		If ($numFGL>0)
			If (Locked:C147([Finished_Goods_Locations:35]))  //locked, can't continue
				$fg_To_locked:=True:C214
				$successful_transaction:=False:C215
				$fToExists:=False:C215  //don't try to pop
			Else 
				PUSH RECORD:C176([Finished_Goods_Locations:35])  //push to lock it
			End if 
			
		Else 
			$fToExists:=False:C215
		End if 
		
		//search for 'FROM bin
		If (Length:C16(sCriterion3)>0)  //from is not blank, don't make a blank
			$numFGL:=FGL_qryBin(sJobit; sCriterion3; sCriter10; <>Last_skid_referenced)
			If ($numFGL>0)
				If (Locked:C147([Finished_Goods_Locations:35]))  //locked, can't continue
					$fg_From_locked:=True:C214
					$successful_transaction:=False:C215
					If ($fToExists)  //release the TO record if the FROM record is a fail
						POP RECORD:C177([Finished_Goods_Locations:35])
						UNLOAD RECORD:C212([Finished_Goods_Locations:35])
					End if 
				End if 
				
			Else 
				$fFromExists:=False:C215
			End if 
		End if 
		
		Case of 
			: ($successful_transaction)  //so far at least
				If (Length:C16(sCriterion3)>0)  // Modified by: Mel Bohince (4/17/15)
					
					If (Not:C34($fFromExists))  //create it
						If (Not:C34($shippingMove))  // Modified by: Mel Bohince (4/13/17) //maybe
							If (Not:C34($creationMove))  // Modified by: Mel Bohince (4/15/19) 
								$temp:=sCriterion4
								sCriterion4:=sCriterion3
								FG_makeLocation
								$fFromExists:=True:C214
								sCriterion4:=$temp
								date_certified:=!00-00-00!
							Else   //creation 
								utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Creation Ignored "+String:C10(rReal1)+" of "+sCriterion1+" from "+sCriterion3+" to "+sCriterion4)
							End if   //not shipping move
						Else   //shipping staging
							utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Staging Ignored "+String:C10(rReal1)+" of "+sCriterion1+" from "+sCriterion3+" to "+sCriterion4)
						End if   //not shipping move
						
					Else 
						date_certified:=[Finished_Goods_Locations:35]Certified:41
					End if   //already exists
					
					If ($fFromExists)  //something to subtract from
						[Finished_Goods_Locations:35]Cases:24:=[Finished_Goods_Locations:35]Cases:24-wms_number_cases
						uChgFGqty(-1)
						If (Not:C34($was_scrapped))
							FG_SaveBinLocation($xactionDate)
						Else 
							UNLOAD RECORD:C212([Finished_Goods_Locations:35])
							utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Scrapped "+String:C10(rReal1)+" of "+sCriterion1+" from "+sCriterion3)
						End if 
						
					End if   //from exists
					
				End if   //from specified
				
				//next create/add to new location
				If (Not:C34($fToExists))  //if it exists
					If (Not:C34($shippingMove))  // Modified by: Mel Bohince (4/13/17)  proceed normally
						FG_makeLocation
						$fToExists:=True:C214
					Else   //further test needed
						If ($fFromExists)  //if from existed, proceed normally, else make it stand out
							FG_makeLocation
							$fToExists:=True:C214
						Else 
							utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+" WARNING: "+"Staging Ignored "+String:C10(rReal1)+" of "+sCriterion1+" from "+sCriterion3+" to "+sCriterion4)
						End if 
					End if   //shipping move
					
				Else 
					POP RECORD:C177([Finished_Goods_Locations:35])  //get the to location
				End if 
				
				If ($fToExists)  // Modified by: Mel Bohince (4/13/17)
					[Finished_Goods_Locations:35]Reason:42:=sCriterion7
					[Finished_Goods_Locations:35]Cases:24:=[Finished_Goods_Locations:35]Cases:24+wms_number_cases
					uChgFGqty(1)
					If (Not:C34($scrapping))
						FG_SaveBinLocation($xactionDate)
					Else 
						UNLOAD RECORD:C212([Finished_Goods_Locations:35])
						utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Scrapped "+String:C10(rReal1)+" of "+sCriterion1+" to "+sCriterion4)
					End if 
				End if 
				
				
				///Bins taken care of, now just note the transaction, even if staging ignored
				FG_loadJobAndOrder  //position the cursor on some files
				//next create transfer OUT&in records
				If (Not:C34($scrapping))
					FGX_post_transaction($xactionDate; 1; "Move"; $xactionTime)
				Else 
					FGX_post_transaction($xactionDate; 1; "Scrap"; $xactionTime)
				End if 
				
				If (Substring:C12(sCriterion4; 1; 2)="EX")
					$noticeTo:=Batch_GetDistributionList(""; "QA_MOVE")
					EMAIL_Sender("Move to "+sCriterion4+" - "+sCriterion1; ""; sCriterion1+" was moved into an Examining location."; $noticeTo)
				End if 
				
				If (Substring:C12(sCriterion4; 1; 2)="XC")
					$noticeTo:=Batch_GetDistributionList(""; "QA_MOVE")
					EMAIL_Sender("Move to "+sCriterion4+" - "+sCriterion1; ""; sCriterion1+" was moved into an ReCertification location."; $noticeTo)
				End if 
				
			: ($fg_not_found)
				utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Could not find F/G "+sCriterion1)
				
			: ($fg_To_locked)
				utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"'To' bin is locked "+sCriterion1+" "+sCriterion4)
				
			: ($fg_From_locked)
				utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"'From' bin is locked "+sCriterion1+" "+sCriterion3)
				
			Else 
				utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Something else happened during a Move")
		End case 
		
		
		
		UNLOAD RECORD:C212([Finished_Goods:26])
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
		POP RECORD:C177([Finished_Goods_Locations:35])  //upr 1192
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
		UNLOAD RECORD:C212([Job_Forms_Items:44])  // Modified by: Mel Bohince (1/17/20) 
		
		
		
	Else 
		//$successful_transaction:=False`let it get marked as processed
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+" WARNING: "+"'From/To same bin "+sCriterion1+" "+sCriterion3+" "+sCriterion4)
	End if 
	
End if   //($mixedSkid)

$0:=$successful_transaction
//