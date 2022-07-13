//%attributes = {"publishedWeb":true}
//(P) mCopyPo({"dupReq"})
//$1 - (optional) string - anything - flag this is being called to dup for a requi
//Based loosly on gCopyLoop
//• 7/11/97 cs rewritten
//• 6/13/97 cs  created especially for requisitions
//• 7/9/97 cs clear ordered flags
//• 7/11/97 cs modifided to also do POs
//• 4/9/98 cs mods for new fields
//• 4/16/98 cs more fields to clear on copy
//• 4/29/98 cs do not dup job item links
//• 011999 MLB leave marker
//•012799  MLB  try to eliminate kidnapping behavior

C_LONGINT:C283($i; $NumRecs)
C_TEXT:C284($newPOnumber; $PoItemKey; $1)
C_DATE:C307($today)
C_TEXT:C284($msg)

$today:=4D_Current_date
$msg:=""
<>filePtr:=->[Purchase_Orders:11]
<>iMode:=5
uSetUp(1; 1)  //•012799  MLB  set defaults

sCriterion1:=""
sCriterion2:=""
fAutoID:=True:C214

If (Count parameters:C259=1)
	sMessage1:="[Requistions]"
Else 
	sMessage1:="[Purchase_Orders]"
End if 

//NewWindow (320;150;6;5;"Enter an Id number to Copy")
winTitle:="Enter an Id number to Copy"
$winRef:=OpenFormWindow(->[zz_control:1]; "Copy_D"; ->winTitle; winTitle)
DIALOG:C40([zz_control:1]; "Copy_D")

If (OK=1)
	ERASE WINDOW:C160
	MESSAGE:C88(" Searching for "+sMessage1+" "+sCriterion1)
	Case of 
		: (Count parameters:C259=1) & (sCriterion1="r@")
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]ReqNo:5=sCriterion1)  //locate requistion    
		: (Count parameters:C259=1)
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=sCriterion1)  //locate requisition via PO        
		Else 
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=sCriterion1)  //locate PO
	End case 
	
	Case of 
		: (Records in selection:C76([Purchase_Orders:11])=1)  //•012799  MLB  not >0 `if found, duplicate it and all related
			MESSAGE:C88(Char:C90(13)+" Getting "+sCriterion1+"'s items")
			RELATE MANY:C262([Purchase_Orders:11]PONo:1)
			
			RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)
			SELECTION TO ARRAY:C260([Purchase_Orders_PO_Clauses:165]id_added_by_converter:7; $fk; [Purchase_Orders_PO_Clauses:165]ClauseID:2; $aId; [Purchase_Orders_PO_Clauses:165]ClauseText:4; $aText; [Purchase_Orders_PO_Clauses:165]ClauseTitle:3; $aTitle; [Purchase_Orders_PO_Clauses:165]ParmEntered:6; $aEntered; [Purchase_Orders_PO_Clauses:165]ParmReqd:5; $aRequired; [Purchase_Orders_PO_Clauses:165]SeqNo:1; $aSeqNo)
			REDUCE SELECTION:C351([Purchase_Orders_PO_Clauses:165]; 0)
			
			$numRecs:=Records in selection:C76([Purchase_Orders_Items:12])
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
				
				CREATE SET:C116([Purchase_Orders_Items:12]; "OldItems")
				
				
			Else 
				
				ARRAY LONGINT:C221($_OldItems; 0)
				LONGINT ARRAY FROM SELECTION:C647([Purchase_Orders_Items:12]; $_OldItems)
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			MESSAGE:C88(Char:C90(13)+" Duplicating "+sCriterion1)
			DUPLICATE RECORD:C225([Purchase_Orders:11])
			[Purchase_Orders:11]pk_id:59:=Generate UUID:C1066
			
			For ($i; 1; Size of array:C274($fk))
				$fk{$i}:=[Purchase_Orders:11]PO_Clauses:33
			End for 
			ARRAY TO SELECTION:C261($fk; [Purchase_Orders_PO_Clauses:165]id_added_by_converter:7; $aId; [Purchase_Orders_PO_Clauses:165]ClauseID:2; $aText; [Purchase_Orders_PO_Clauses:165]ClauseText:4; $aTitle; [Purchase_Orders_PO_Clauses:165]ClauseTitle:3; $aEntered; [Purchase_Orders_PO_Clauses:165]ParmEntered:6; $aRequired; [Purchase_Orders_PO_Clauses:165]ParmReqd:5; $aSeqNo; [Purchase_Orders_PO_Clauses:165]SeqNo:1)
			
			$newPOnumber:=PO_setPONumber
			[Purchase_Orders:11]PONo:1:=$newPOnumber
			[Purchase_Orders:11]ReqNo:5:=Req_setReqNumber  //assign Requisition number too
			[Purchase_Orders:11]Status:15:="New Req"
			[Purchase_Orders:11]ReqBy:6:=<>zResp
			[Purchase_Orders:11]StatusBy:16:=<>zResp
			[Purchase_Orders:11]ModWho:32:=<>zResp
			[Purchase_Orders:11]PODate:4:=$today
			[Purchase_Orders:11]StatusDate:17:=$today
			[Purchase_Orders:11]ModDate:31:=$today
			[Purchase_Orders:11]LastChgOrdNo:18:="00"
			[Purchase_Orders:11]Comments:21:=""  //• 7/9/97 cs clear ordered flags
			[Purchase_Orders:11]Ordered:47:=False:C215
			[Purchase_Orders:11]Required:27:=!00-00-00!
			[Purchase_Orders:11]Printed:49:=""  //• 4/9/98 cs 
			[Purchase_Orders:11]PurchaseApprv:44:=False:C215  //• 4/9/98 cs 
			[Purchase_Orders:11]ApprovedBy:26:=""  //• 4/9/98 cs 
			[Purchase_Orders:11]DefaultJobId:3:=""  //• 4/16/98 cs 
			
			[Purchase_Orders:11]ConfirmingOrder:29:=False:C215  //• 4/16/98 cs 
			[Purchase_Orders:11]ConfirmingDate:24:=!00-00-00!
			[Purchase_Orders:11]ConfirmingBy:23:=""  // • mel (11/24/03, 13:51:34)
			[Purchase_Orders:11]ConfirmingNotes:25:=""  // • mel (11/24/03, 13:51:34)
			[Purchase_Orders:11]ConfirmingTo:22:=""  // • mel (11/24/03, 13:51:34)
			
			[Purchase_Orders:11]StatusTrack:51:="Duplicated from PO#"+sCriterion1  //MLB 011999 
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Purchase_Orders]z_SYNC_ID;->[Purchase_Orders]z_SYNC_DATA)
			
			SAVE RECORD:C53([Purchase_Orders:11])
			
			ONE RECORD SELECT:C189([Purchase_Orders:11])
			
			READ ONLY:C145([Raw_Materials_Groups:22])
			READ ONLY:C145([Raw_Materials:21])
			
			uThermoInit($numRecs; "Duplicating"+sCriterion1+"'s items...")
			For ($i; 1; $numRecs)  //for each item
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
					
					USE SET:C118("OldItems")  //the old items
					GOTO SELECTED RECORD:C245([Purchase_Orders_Items:12]; $i)
					
					
				Else 
					
					GOTO RECORD:C242([Purchase_Orders_Items:12]; $_OldItems{$i})
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				$originalPOClauseKey:=[Purchase_Orders:11]PO_Clauses:33
				$PoItemKey:=$newPOnumber+[Purchase_Orders_Items:12]ItemNo:3
				DUPLICATE RECORD:C225([Purchase_Orders_Items:12])  //now duplicate the PO_Item record
				[Purchase_Orders_Items:12]pk_id:54:=Generate UUID:C1066
				[Purchase_Orders_Items:12]PONo:2:=$newPOnumber
				[Purchase_Orders_Items:12]POItemKey:1:=$PoItemKey
				[Purchase_Orders_Items:12]BudgetBuster:48:=False:C215
				[Purchase_Orders_Items:12]RecvdDate:43:=!00-00-00!
				[Purchase_Orders_Items:12]RecvdCnt:42:=0
				[Purchase_Orders_Items:12]PoItemDate:40:=$today
				[Purchase_Orders_Items:12]Qty_Received:14:=0
				[Purchase_Orders_Items:12]Qty_Open:27:=[Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14
				[Purchase_Orders_Items:12]ReqdDate:8:=!00-00-00!  //clear required dates
				[Purchase_Orders_Items:12]PromiseDate:9:=!00-00-00!
				[Purchase_Orders_Items:12]ModDate:19:=$today
				[Purchase_Orders_Items:12]ModWho:20:=<>zResp
				//mlb 020906 make sure expensecode is correct
				//mlb 060607 just warn if miss-matched
				$Commodity_Key:=RM_getCommodityKey([Purchase_Orders_Items:12]Raw_Matl_Code:15)
				If ($Commodity_Key#[Purchase_Orders_Items:12]Commodity_Key:26)
					//BEEP
					$msg:=$msg+"PO Item "+$PoItemKey+" Commodity ["+[Purchase_Orders_Items:12]Commodity_Key:26+"] does not match the R/M Code ["+$Commodity_Key+"]."+Char:C90(13)
				End if 
				//[Purchase_Orders_Items]:=Num(Substring([Purchase_Orders_Items]Commodity_Key;1;2))
				$ExpenseCode:=RMG_getExpenseCode([Purchase_Orders_Items:12]Commodity_Key:26)
				If ($ExpenseCode#[Purchase_Orders_Items:12]ExpenseCode:47)
					//BEEP
					$msg:=$msg+"PO Item "+$PoItemKey+" Expense Code ["+[Purchase_Orders_Items:12]ExpenseCode:47+"] does not match the Commodity ExpCode ["+$ExpenseCode+"]."+Char:C90(13)
				End if 
				// deleted 5/15/20: gns_ams_clear_sync_fields(->[Purchase_Orders_Items]z_SYNC_ID;->[Purchase_Orders_Items]z_SYNC_DATA)
				
				SAVE RECORD:C53([Purchase_Orders_Items:12])
				
				uThermoUpdate($i)
			End for 
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
				
				CLEAR SET:C117("OldItems")
				
				
			Else 
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			SAVE RECORD:C53([Purchase_Orders:11])  //save any added clauses
			If (Length:C16($msg)>0)
				util_FloatingAlert($msg)
			End if 
			uThermoClose
			fMod:=True:C214
			iMode:=2
			CREATE SET:C116([Purchase_Orders:11]; "◊PassThroughSet")
			UNLOAD RECORD:C212([Purchase_Orders:11])
			<>PassThrough:=True:C214
			
			If (Count parameters:C259=1)
				ViewSetter(2; ->[Purchase_Orders_Requisitions:80])
			Else 
				ViewSetter(2; ->[Purchase_Orders:11])  //doModifyRecord 
			End if 
			
		: (Records in selection:C76([Purchase_Orders:11])=0)
			uConfirm("No record found for "+sMessage1+" using id: "+sCriterion1; "OK"; "Help")
		Else 
			uConfirm(String:C10(Records in selection:C76([Purchase_Orders:11]))+" records found, be more specific."; "OK"; "Help")
	End case 
End if   //canceled

gClearfAuto
gClearFlags
CLOSE WINDOW:C154($winRef)
uSetUp(0; 0)