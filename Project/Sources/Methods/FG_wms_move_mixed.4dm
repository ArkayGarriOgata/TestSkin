//%attributes = {}
// -------
// Method: FG_wms_move_mixed   ( ) ->
// By: Mel Bohince @ 11/29/18, 14:43:20
// Description
// explode an ams_export transaction of a 005 (mixed skid) into its component jobits
// based on FG_wms_move
// ----------------------------------------------------
C_BOOLEAN:C305($0; $success; $was_scrapped; $scrapping)  //success
C_TEXT:C284($1; $skid; $2; $location)
C_TIME:C306($xactionTime)
C_DATE:C307($xactionDate)

//query wms for the skid and subtotal the jobits, 
WMS_API_LoginLookup  //login
If (WMS_API_4D_DoLogin)
	
	$skid:=$1
	//BEEP
	//ALERT("debug skid being set")
	//$skid:="00508082920003003325"
	$location:=$2  //be aware it may have moved in the last two minutes, so process sequencially
	$xactionDate:=dDate  //wms_api_load_transaction_variab
	$xactionTime:=tTime  //wms_api_load_transaction_variab
	$was_scrapped:=(Substring:C12(sCriterion3; 1; 2)="SC")  //wms_api_load_transaction_variab
	$scrapping:=(Substring:C12(sCriterion4; 1; 2)="SC")  //wms_api_load_transaction_variab
	
	ARRAY TEXT:C222($aJobit; 0)
	ARRAY LONGINT:C221($aQty; 0)
	ARRAY LONGINT:C221($aNumCases; 0)
	
	Begin SQL
		SELECT jobit, sum(qty_in_case), count(case_id)
		from cases
		where skid_number = :$skid
		group by jobit
		into :$aJobit, :$aQty, :$aNumCases
	End SQL
	WMS_API_4D_DoLogout  //logout
	
	
	C_LONGINT:C283($i; $numElements)
	$numJobits:=Size of array:C274($aJobit)
	If ($numJobits>0)
		START TRANSACTION:C239
		$success:=True:C214
		//preserve the process variables, sCriter... etc so FGX_post_transaction can be used repeatedly
		// see wms_api_load_transaction_variab
		FG_TransactionVariablesExchange("save")
		
		For ($i; 1; $numElements)
			sJobit:=JMI_makeJobIt($aJobit{$i})
			//process move transaction
			//set the fgx vars that are jobit based, not the ones that are common to the whole skid
			sCriterion1:=JMI_getCPN(sJobit)  //        cpn
			sCriterion2:=JMI_getCust(sJobit)  //custid
			rReal1:=$aQty{$i}  //qty
			sCriterion5:=Substring:C12($jobit; 1; 8)  //jobform
			i1:=Num:C11(Substring:C12(sJobit; 10; 2))  //job item
			
			wms_number_cases:=$aNumCases{$i}
			wms_case_id:="mixed"
			
			//validate the product code
			$numFGs:=qryFinishedGood(sCriterion2; sCriterion1)
			If ($numFGs=0)
				$fg_not_found:=True:C214
				$success:=False:C215
			End if 
			
			//check for a TO bin
			$numFGL:=FGL_qryBin(sJobit; sCriterion4; sCriter10)
			If ($numFGL=0)
				FG_makeLocation
			End if 
			
			If (fLockNLoad(->[Finished_Goods_Locations:35]))
				[Finished_Goods_Locations:35]Reason:42:=sCriterion7
				[Finished_Goods_Locations:35]Cases:24:=[Finished_Goods_Locations:35]Cases:24+wms_number_cases
				uChgFGqty(1)
				If (Not:C34($scrapping))
					FG_SaveBinLocation(Current date:C33)
				Else 
					UNLOAD RECORD:C212([Finished_Goods_Locations:35])
					utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Scrapped "+String:C10(rReal1)+" of "+sCriterion1+" to "+sCriterion4)
				End if 
				
			Else 
				$to_locked:=True:C214
				$success:=False:C215
			End if 
			
			//check for a FROM bin
			$numFGL:=FGL_qryBin(sJobit; sCriterion3; sCriter10)
			If ($numFGL=0)
				FG_makeLocation
			End if 
			
			If (fLockNLoad(->[Finished_Goods_Locations:35]))
				[Finished_Goods_Locations:35]Reason:42:=sCriterion7
				[Finished_Goods_Locations:35]Cases:24:=[Finished_Goods_Locations:35]Cases:24+wms_number_cases
				uChgFGqty(-1)
				If (Not:C34($was_scrapped))
					FG_SaveBinLocation($xactionDate)
				Else 
					UNLOAD RECORD:C212([Finished_Goods_Locations:35])
					utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Scrapped "+String:C10(rReal1)+" of "+sCriterion1+" from "+sCriterion3)
				End if 
				
			Else 
				$to_locked:=True:C214
				$success:=False:C215
			End if 
			
			
			If ($success)  //post transaction
				///Bins taken care of, now just note the transaction, even if staging ignored
				FG_loadJobAndOrder  //position the cursor on some files
				//next create transfer OUT&in records
				If (Not:C34($scrapping))
					FGX_post_transaction($xactionDate; 1; "Move"; $xactionTime)
				Else 
					FGX_post_transaction($xactionDate; 1; "Scrap"; $xactionTime)
				End if 
			End if 
			
			
			If (Not:C34($success))  //break
				$i:=$i+$numElements
			End if 
		End for 
		
		FG_TransactionVariablesExchange("restore")  //restore the process variables, sCriter... etc
		
		//restore the process variables, sCriter... etc
		If ($success)
			VALIDATE TRANSACTION:C240
		Else 
			CANCEL TRANSACTION:C241
		End if 
	End if 
	
Else   //login failure
	$success:=False:C215
End if 

$0:=$success
