//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/11/10, 15:39:10
// ----------------------------------------------------
// Method: Job_price_component
// Description
// calculate either a planned or actual cost
// Parameters
// cpn and type calc needed
// ----------------------------------------------------
// Modified by: Mel Bohince (10/18/16) clear zero qty bins after backflush
// Modified by: Mel Bohince (9/23/19) allow user to select which cost if more htan one jobit

C_TEXT:C284($1; $2; $cpn; $type)
C_LONGINT:C283($3; $qty)
C_REAL:C285($0; $cost)

<>USE_SUBCOMPONENT:=True:C214

If (Count parameters:C259>=3)
	$cpn:=$1
	$type:=$2
	$qty:=$3
	If (Count parameters:C259>=4)
		$used_by:=$4
	Else 
		$used_by:="assembly"
	End if 
Else   //testing
	$cpn:="91263533"  //Request("CPN:";"";"OK";"Cancel") //""//"281799"//
	$type:="planned"  //Request("Type calc:";"Planned";"OK";"Cancel")
	$qty:=1000  //Num(Request("Need Qty:";"2000";"OK";"Cancel"))
End if 

$cost:=0
$0:=$cost

Case of 
	: ($type="planned")
		//query jmi for this cpn and average the planned cost
		If (False:C215)  // Modified by: Mel Bohince (9/23/19) allow user to select which cost if more htan one jobit
			$numJMI:=qryJMI("@"; 0; $cpn)
			If ($numJMI>0)
				$cost:=Max:C3([Job_Forms_Items:44]PldCostTotal:21)  //this can get pretty ugly if it fines a proof run
			Else 
				$cost:=Num:C11(Request:C163("How much per thousand is "+$cpn; "0"; "OK"; "Continue"))
				If (OK=0) | ($cost<=0)
					$cost:=0
				End if 
			End if 
			
		Else 
			C_OBJECT:C1216($jobIts)
			$jobIts:=ds:C1482.Job_Forms_Items.query("ProductCode = :1"; $cpn)  //.orderBy("Jobit asc")
			
			Case of 
				: ($jobIts.length=1)  //slam dunk
					$cost:=$jobIts.first().PldCostTotal
					
				: ($jobIts.length>1)  //user choice from dialog
					C_REAL:C285(jobitCost)
					jobitCost:=0
					
					C_OBJECT:C1216($form_o)  // Erick's Code
					$form_o:=New object:C1471  // Erick's Code
					$form_o.jobItems:=$jobIts.orderBy("Jobit asc")  //end Eric
					
					windowTitle:="Select Jobit for component "+$cpn
					$winRef:=OpenFormWindow(->[Job_Forms_Items:44]; "PickJobitFromList"; ->windowTitle; windowTitle)
					DIALOG:C40([Job_Forms_Items:44]; "PickJobitFromList"; $form_o)
					If (ok=1)
						$cost:=jobitCost
					End if 
					CLOSE WINDOW:C154($winRef)
					
				Else 
					$cost:=Num:C11(Request:C163("How much per thousand is "+$cpn; "0"; "OK"; "Continue"))
					If (OK=0) | ($cost<=0)
						$cost:=0
					End if 
					
			End case 
			
			
		End if 
		
		$0:=$cost*$qty/1000
		
	: ($type="inventoried")
		//query onhand inventory and fifo the cost of qty
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$cpn; *)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@")
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			//uPostFGxaction uses the same variables so make a copy of each
			$tempsCriterion1:=sCriterion1
			$tempsCriterion2:=sCriterion2
			$tempsCriterion3:=sCriterion3
			$tempsCriterion4:=sCriterion4
			$tempsCriterion5:=sCriterion5
			$tempi1:=i1
			$tempsCriterion6:=sCriterion6  //ordernum
			$tempsCriterion7:=sCriterion7  //reason note
			$tempsCriterion8:=sCriterion8  //action taken
			$tempsCriterion9:=sCriterion9  //reason
			$temprReal1:=rReal1
			$tempsCriter10:=sCriter10
			
			ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33; >)  //fifo the qty
			$qtyNeeded:=$qty
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				CREATE EMPTY SET:C140([Finished_Goods_Transactions:33]; "fg_trans_created")
				CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "CompletelyConsumed")  // Modified by: Mel Bohince (10/18/16) 
				
			Else 
				
				ARRAY LONGINT:C221($_fg_trans_created; 0)
				ARRAY LONGINT:C221($_CompletelyConsumed; 0)
				
				
			End if   // END 4D Professional Services : January 2019 
			
			While ($qtyNeeded>0) & (Not:C34(End selection:C36([Finished_Goods_Locations:35])))
				Case of 
					: ($qtyNeeded>=[Finished_Goods_Locations:35]QtyOH:9)
						$qtyNeeded:=$qtyNeeded-[Finished_Goods_Locations:35]QtyOH:9
						//`save transaction
						sCriterion1:=[Finished_Goods_Locations:35]ProductCode:1
						sCriterion2:=[Finished_Goods_Locations:35]CustID:16
						sCriterion3:=[Finished_Goods_Locations:35]Location:2
						sCriterion4:="WIP"
						sCriterion5:=[Finished_Goods_Locations:35]JobForm:19
						i1:=[Finished_Goods_Locations:35]JobFormItem:32
						sCriterion6:=""  //ordernum
						sCriterion7:=""  //reason note
						sCriterion8:=""  //action taken
						sCriterion9:="subassembly"  //reason
						rReal1:=[Finished_Goods_Locations:35]QtyOH:9
						sCriter10:="JOB_"+$used_by
						FGX_post_transaction(Current date:C33; 1; "BACKFLUSH")
						LOAD RECORD:C52([Finished_Goods_Transactions:33])
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
							
							ADD TO SET:C119([Finished_Goods_Transactions:33]; "fg_trans_created")
							
						Else 
							
							APPEND TO ARRAY:C911($_fg_trans_created; Record number:C243([Finished_Goods_Transactions:33]))
							
						End if   // END 4D Professional Services : January 2019 
						
						[Finished_Goods_Locations:35]QtyOH:9:=0
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
							
							ADD TO SET:C119([Finished_Goods_Locations:35]; "CompletelyConsumed")  // Modified by: Mel Bohince (10/18/16) 
							
						Else 
							
							APPEND TO ARRAY:C911($_CompletelyConsumed; Record number:C243([Finished_Goods_Locations:35]))
							
						End if   // END 4D Professional Services : January 2019 
						
					: ($qtyNeeded<[Finished_Goods_Locations:35]QtyOH:9)
						[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9-$qtyNeeded
						//save transaction
						sCriterion1:=[Finished_Goods_Locations:35]ProductCode:1
						sCriterion2:=[Finished_Goods_Locations:35]CustID:16
						sCriterion3:=[Finished_Goods_Locations:35]Location:2
						sCriterion4:="WIP"
						sCriterion5:=[Finished_Goods_Locations:35]JobForm:19
						i1:=[Finished_Goods_Locations:35]JobFormItem:32
						sCriterion6:=""  //ordernum
						sCriterion7:=""  //reason note
						sCriterion8:=""  //action taken
						sCriterion9:="subassembly"  //reason
						rReal1:=$qtyNeeded
						sCriter10:="JOB_"+$used_by
						FGX_post_transaction(Current date:C33; 1; "BACKFLUSH")
						LOAD RECORD:C52([Finished_Goods_Transactions:33])
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
							
							ADD TO SET:C119([Finished_Goods_Transactions:33]; "fg_trans_created")
							
						Else 
							
							APPEND TO ARRAY:C911($_fg_trans_created; Record number:C243([Finished_Goods_Transactions:33]))
							
						End if   // END 4D Professional Services : January 2019 
						
						$qtyNeeded:=0
						
				End case 
				SAVE RECORD:C53([Finished_Goods_Locations:35])
				
				NEXT RECORD:C51([Finished_Goods_Locations:35])
			End while 
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				If (Records in set:C195("CompletelyConsumed")>0)
					USE SET:C118("CompletelyConsumed")
					util_DeleteSelection(->[Finished_Goods_Locations:35]; "no-msg"; "ignore-locked")
				End if 
				CLEAR SET:C117("CompletelyConsumed")  // Modified by: Mel Bohince (10/18/16) 
				
			Else 
				
				If (Size of array:C274($_CompletelyConsumed)>0)
					CREATE SELECTION FROM ARRAY:C640([Finished_Goods_Locations:35]; $_CompletelyConsumed)
					
					util_DeleteSelection(->[Finished_Goods_Locations:35]; "no-msg"; "ignore-locked")
				End if 
				
			End if   // END 4D Professional Services : January 2019 
			
			//restore the variables
			sCriterion1:=$tempsCriterion1
			sCriterion2:=$tempsCriterion2
			sCriterion3:=$tempsCriterion3
			sCriterion4:=$tempsCriterion4
			sCriterion5:=$tempsCriterion5
			i1:=$tempi1
			sCriterion6:=$tempsCriterion6  //ordernum
			sCriterion7:=$tempsCriterion7  //reason note
			sCriterion8:=$tempsCriterion8  //action taken
			sCriterion9:=$tempsCriterion9  //reason
			rReal1:=$temprReal1
			sCriter10:=$tempsCriter10
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				USE SET:C118("fg_trans_created")
				CLEAR SET:C117("fg_trans_created")
				
				
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([Finished_Goods_Transactions:33]; $_fg_trans_created)
				
				
			End if   // END 4D Professional Services : January 2019 
			If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
				$refJob:=[Finished_Goods_Transactions:33]JobForm:5
				$cost:=Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
			Else 
				$cost:=0
			End if 
			REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
			
		Else   //just create an rm transaction
			CUT NAMED SELECTION:C334([Job_Forms_Items_Costs:92]; "jic_before")
			$numJIC:=qryJIC(""; ("@"+$cpn))
			If ($numJIC>0)
				ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; <)  //get the newest
				If ([Job_Forms_Items_Costs:92]AllocatedQuantity:14#0)
					$unitCost:=Round:C94([Job_Forms_Items_Costs:92]AllocatedTotal:7/[Job_Forms_Items_Costs:92]AllocatedQuantity:14; 3)
					$refJob:=[Job_Forms_Items_Costs:92]JobForm:1
				Else 
					$unitCost:=0
				End if 
				$cost:=$unitCost*$qty
				
			Else 
				$cost:=0
			End if 
			USE NAMED SELECTION:C332("jic_before")
		End if 
		
		CREATE RECORD:C68([Raw_Materials_Transactions:23])
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=$cpn
		[Raw_Materials_Transactions:23]Xfer_Type:2:="ISSUE"
		[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
		[Raw_Materials_Transactions:23]POItemKey:4:="A"+$refJob
		[Raw_Materials_Transactions:23]JobForm:12:=$used_by
		[Raw_Materials_Transactions:23]Sequence:13:=10
		[Raw_Materials_Transactions:23]ReferenceNo:14:="subcomponent"
		[Raw_Materials_Transactions:23]Location:15:="WIP"
		[Raw_Materials_Transactions:23]CompanyID:20:="1"
		[Raw_Materials_Transactions:23]DepartmentID:21:="0000"
		[Raw_Materials_Transactions:23]ExpenseCode:26:="0000"
		[Raw_Materials_Transactions:23]viaLocation:11:="FINISHED GOODS"
		[Raw_Materials_Transactions:23]Qty:6:=-$qty
		If ($qty#0)
			[Raw_Materials_Transactions:23]ActCost:9:=Round:C94($cost/$qty; 3)
		Else 
			[Raw_Materials_Transactions:23]ActCost:9:=0
		End if 
		[Raw_Materials_Transactions:23]ActExtCost:10:=-$cost
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]Commodity_Key:22:="33-SubComponentFG"
		[Raw_Materials_Transactions:23]CommodityCode:24:=33
		[Raw_Materials_Transactions:23]Reason:5:="BACKFLUSH"
		[Raw_Materials_Transactions:23]consignment:27:=False:C215
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
		
		$0:=$cost
		
	: ($type="wag")
		$perM:=Request:C163("Wilda$$ guess of per thousand cost:"; "0"; "OK"; "Cancel")
		If (OK=1)
			$0:=Num:C11($perM)
		End if 
End case 