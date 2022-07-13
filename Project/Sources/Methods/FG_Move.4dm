//%attributes = {"publishedWeb":true}
//(S) FG_Move   mod 3/2/94, 7/19
//upr 1192 8/19/94
//•080395  MLB  UPR 1490
//•121495 MLB UPR 1801
//101800 argument to avoid dialogs
//mlb 060707 preserve date certified if going to an empty bin

C_BOOLEAN:C305($show; $fFromExists; $fToExists)
C_LONGINT:C283($1; $numFGs; $numFGL_to; $numFGL_from)
C_DATE:C307(date_certified; $xactionDate; $2)
C_TIME:C306($3; $xactionTime)

date_certified:=!00-00-00!

If (Count parameters:C259>0)
	$show:=False:C215
Else 
	$show:=True:C214
End if 

If (Count parameters:C259>1)
	$xactionDate:=$2
Else 
	$xactionDate:=4D_Current_date
End if 

If (Count parameters:C259>2)
	$xactionTime:=$3
Else 
	$xactionTime:=4d_Current_time
End if 

$fFromExists:=True:C214
$fToExists:=True:C214
//search for valid fg material
$numFGs:=qryFinishedGood(sCriterion2; sCriterion1)
//SEARCH([Finished_Goods];[Finished_Goods]FG_KEY=sCriterion2+":"+sCriterion1)
If ($numFGs=0)
	If ($show)
		uRejectAlert("Invalid F/G Code!")
	Else 
		zwStatusMsg("FG MOVE ERR"; "Invalid F/G Code!")
	End if 
Else 
	//search for TO bin
	sJobit:=JMI_makeJobIt(sCriterion5; i1)
	$numFGL_to:=FGL_qryBin(sJobit; sCriterion4; sCriter10)
	If (Locked:C147([Finished_Goods_Locations:35]))  //locked, can't continue
		uLockMessage(->[Finished_Goods_Locations:35])
	Else 
		If ($numFGL_to=0)
			$fToExists:=False:C215
		Else 
			PUSH RECORD:C176([Finished_Goods_Locations:35])  //push to lock it
		End if 
		//search for 'FROM bin
		$numFGL_from:=FGL_qryBin(sJobit; sCriterion3; sCriter10)
		If (Locked:C147([Finished_Goods_Locations:35]))  //locked, can't continue
			uLockMessage(->[Finished_Goods_Locations:35])
			If ($fToExists)  //if it exists
				POP RECORD:C177([Finished_Goods_Locations:35])
				UNLOAD RECORD:C212([Finished_Goods_Locations:35])
			End if 
		Else 
			OK:=1
			If ($numFGL_from=0)
				$fFromExists:=False:C215
				If ((iMode=1) | (iMode=4))
					If ($show)
						uRejectAlert("Invalid From Location!")
					End if 
					OK:=0
				Else 
					If ($show)
						BEEP:C151
						uConfirm("'From' Location is not on file. Check skid number."+"Continue?"; "Continue"; "Abort")
					Else 
						OK:=1
					End if 
					
					If (OK=1)
						$temp:=sCriterion4
						sCriterion4:=sCriterion3
						FG_makeLocation
						sCriterion4:=$temp
						$fFromExists:=True:C214
					End if 
					
				End if 
			End if 
			
			If (OK=1)
				If (rReal1>[Finished_Goods_Locations:35]QtyOH:9)
					If ($show)
						uConfirm("ERROR: Quantity specified is GREATER than quantity on hand in "+sCriterion3; "OK"; "Help")
						OK:=0
					Else 
						OK:=1
					End if 
				End if 
				
				If (OK=1)
					//first update old location
					If ($fFromExists)  //if it exists
						date_certified:=[Finished_Goods_Locations:35]Certified:41
						uChgFGqty(-1)
						FG_SaveBinLocation($xactionDate)
					End if 
					FG_loadJobAndOrder  //position the cursor on some files
					
					//next create transfer OUT&in records
					FGX_post_transaction($xactionDate; 1; "Move"; $xactionTime)
					
					//next create/add to new location
					If (Not:C34($fToExists))  //if it exists
						FG_makeLocation
						[Finished_Goods_Locations:35]Certified:41:=date_certified
					Else 
						POP RECORD:C177([Finished_Goods_Locations:35])  //get the to location
					End if 
					
					[Finished_Goods_Locations:35]Reason:42:=sCriterion7
					
					uChgFGqty(1)
					
					If ([Finished_Goods_Locations:35]Location:2="EX:@")  //•121495 MLB UPR 1801
						C_LONGINT:C283($pctYld)
						If ($show)
							$pctYld:=Num:C11(Request:C163("What is the expected percent yield?"; String:C10([Finished_Goods_Locations:35]PercentYield:17)))
							If ($pctYld>=0) & ($pctYld<=100)
								[Finished_Goods_Locations:35]PercentYield:17:=$pctYld
							End if 
						End if 
					End if 
					FG_SaveBinLocation($xactionDate)
					
					
					If (wms_itemExists(sCriter10))
						[WMS_ItemMasters:123]LOCATION:4:=sCriterion4
						[WMS_ItemMasters:123]QTY:7:=rReal1
						SAVE RECORD:C53([WMS_ItemMasters:123])
						UNLOAD RECORD:C212([WMS_ItemMasters:123])
					End if 
					
				End if   // qty is feasible        
			End if   //OK to chg from location
		End if   //from location is locked
	End if   //to location is locked
End if   //its a f/g

UNLOAD RECORD:C212([Finished_Goods:26])
UNLOAD RECORD:C212([Finished_Goods_Locations:35])
POP RECORD:C177([Finished_Goods_Locations:35])  //upr 1192
UNLOAD RECORD:C212([Finished_Goods_Locations:35])
UNLOAD RECORD:C212([Job_Forms_Items:44])