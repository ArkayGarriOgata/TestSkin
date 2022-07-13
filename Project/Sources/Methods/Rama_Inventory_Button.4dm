//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 09/06/12, 13:36:19
// Modified by: Mel Bohince (1/25/13) hide empty gaylords
// Modified by: Mel Bohince (1/31/13) delete empty gaylords
// ----------------------------------------------------
// Method: Rama_Inventory_Button
// ----------------------------------------------------

C_TEXT:C284($test_if_job_completed)

$btn_func:=OBJECT Get title:C1068(bUpdate)
$today:=4D_Current_date
$now:=4d_Current_time
$test_if_job_completed:=""  // see JML_CanThisJobBeMarkedComplete

READ WRITE:C146([Finished_Goods_Locations:35])
GOTO RECORD:C242([Finished_Goods_Locations:35]; aRecNo{InvListBox})
If (fLockNLoad(->[Finished_Goods_Locations:35]))
	Case of 
		: ($btn_func="Receive")
			[Finished_Goods_Locations:35]Location:2:="FG:AV="+Substring:C12(aBin{InvListBox}; 7)
			[Finished_Goods_Locations:35]ModDate:21:=$today
			[Finished_Goods_Locations:35]ModWho:22:=<>zResp
			SAVE RECORD:C53([Finished_Goods_Locations:35])
			
			//create fg move transaction
			sCriterion1:=aCPN{InvListBox}
			sCriterion2:=[Finished_Goods_Locations:35]CustID:16
			sCriterion3:=aBin{InvListBox}
			sCriterion4:=[Finished_Goods_Locations:35]Location:2
			sCriterion5:=[Finished_Goods_Locations:35]JobForm:19
			i1:=[Finished_Goods_Locations:35]JobFormItem:32
			sCriterion6:="RECD"  //order line
			sCriterion7:="RECEIVED"
			sCriterion8:="RECEIVED BOL"+Substring:C12([Finished_Goods_Locations:35]Location:2; 11)
			sCriterion9:="RECEIVED"
			sCriter10:=[Finished_Goods_Locations:35]skid_number:43
			sJobit:=[Finished_Goods_Locations:35]Jobit:33
			rReal1:=[Finished_Goods_Locations:35]QtyOH:9
			FGX_post_transaction($today; 1; "Move"; $now)
			
			aBin{InvListBox}:=[Finished_Goods_Locations:35]Location:2
			//Rama_IssueCostToJob ("freight";[Finished_Goods_Locations]ProductCode;[Finished_Goods_Locations]QtyOH;[Finished_Goods_Locations]Location;[Finished_Goods_Locations]pallet_id;[Finished_Goods_Locations]JobForm)
			
		: ($btn_func="Convert")
			$good:=Num:C11(Request:C163("Glued GOOD count:"; String:C10(aQtyOnHand{InvListBox}); "Continue"; "Cancel"))
			If (ok=1) & ($good>0)
				$waste:=Num:C11(Request:C163("Glued WASTE count:"; "0"; "Continue"; "Cancel"))
				If (ok=1) & ($waste>=0)
					START TRANSACTION:C239  //the "TO" record might be locked
					$qtyRelieved:=$good+$waste
					aQtyOnHand{InvListBox}:=aQtyOnHand{InvListBox}-$qtyRelieved
					
					//create fg move transaction
					sCriterion1:=aCPN{InvListBox}
					sCriterion2:=[Finished_Goods_Locations:35]CustID:16
					sCriterion3:=[Finished_Goods_Locations:35]skid_number:43  //[Finished_Goods_Locations]Location
					If (aState{InvListBox}#"Sleeve")
						sCriterion4:="FG:AV=RAMA GLUED"
					Else 
						sCriterion4:="FG:AV=RAMA SLEEVE"
					End if 
					sCriterion5:=[Finished_Goods_Locations:35]JobForm:19
					i1:=[Finished_Goods_Locations:35]JobFormItem:32
					sCriterion6:="GLUING"  //order line
					sCriterion7:=String:C10($waste; "###,###,##0")
					If (aQtyOnHand{InvListBox}>0)
						sCriterion8:="GLUING"
					Else 
						sCriterion8:="EMPTY "+[Finished_Goods_Locations:35]skid_number:43
					End if 
					sCriterion9:="PULL TO GLUE"
					sCriter10:="CASE"
					sJobit:=[Finished_Goods_Locations:35]Jobit:33
					rReal1:=$qtyRelieved
					FGX_post_transaction($today; 1; "Move"; $now)
					$test_if_job_completed:=sCriterion5
					
					If (aQtyOnHand{InvListBox}>0)
						[Finished_Goods_Locations:35]QtyOH:9:=aQtyOnHand{InvListBox}
						[Finished_Goods_Locations:35]ModDate:21:=$today
						[Finished_Goods_Locations:35]ModWho:22:=<>zResp
						SAVE RECORD:C53([Finished_Goods_Locations:35])
					Else 
						DELETE RECORD:C58([Finished_Goods_Locations:35])
					End if 
					
					$numFGL:=FGL_qryBin(sJobit; sCriterion4; sCriter10)
					If ($numFGL=0)  //create
						FG_makeLocation
						SAVE RECORD:C53([Finished_Goods_Locations:35])
					End if 
					
					If (fLockNLoad(->[Finished_Goods_Locations:35]))
						[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$good
						[Finished_Goods_Locations:35]AdjQty:12:=[Finished_Goods_Locations:35]AdjQty:12+$waste
						[Finished_Goods_Locations:35]ModDate:21:=$today
						[Finished_Goods_Locations:35]ModWho:22:=<>zResp
						SAVE RECORD:C53([Finished_Goods_Locations:35])
						VALIDATE TRANSACTION:C240
						
						//Rama_IssueCostToJob ("gluing";[Finished_Goods_Locations]ProductCode;$good;[Finished_Goods_Locations]Location;[Finished_Goods_Locations]pallet_id;[Finished_Goods_Locations]JobForm)
						
					Else 
						CANCEL TRANSACTION:C241
						$test_if_job_completed:=""
						uConfirm("RECORD IN USE: Changes can not be made for bin "+sCriterion4+", try again later."; "OK"; "Help")
					End if 
					If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
						
						UNLOAD RECORD:C212([Finished_Goods_Locations:35])
						
					Else 
						
						// you have query after and Rama_Find_CPNs
						
					End if   // END 4D Professional Services : January 2019 
					
					If (Length:C16($test_if_job_completed)>0)  // see JML_CanThisJobBeMarkedComplete
						QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19=$test_if_job_completed; *)
						QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]skid_number:43="000@"; *)  //gaylord
						QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9>0)  //not empty
						If (Records in selection:C76([Finished_Goods_Locations:35])=0)  // looks like all glued
							JML_setJobComplete($test_if_job_completed)
						End if 
					End if 
					
					Rama_Find_CPNs("inventory")
					MESSAGE:C88("Please Wait, Loading Inventory...")
					Rama_Load_Inventory
				End if   //waste count entered
			End if   //good count entered
			
	End case 
	
	UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	READ ONLY:C145([Finished_Goods_Locations:35])
	
Else 
	uConfirm("RECORD IN USE: Changes can not be made on "+aPallet{InvListBox}+", try again later."; "OK"; "Help")
End if 

LISTBOX SELECT ROW:C912(InvListBox; InvListBox; 0)