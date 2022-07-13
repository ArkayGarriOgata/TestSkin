//%attributes = {"publishedWeb":true}
//PM: CAR_BuildReasonList() -> 
//@author mlb - 7/18/01  14:35
//RM_BuildStockList("msg"{;->textRtnvalu;->numericRtnVal})-> handle 1/26/00  mlb
//create a hier-list of available QA reasons
//trying for a list like:
// >SBS
//     18
//     20
//     22
//     24
// >PVC
//     16
//     18.22.24
// >INVERCOTE
//     16
//     18

C_TEXT:C284($1)
C_LONGINT:C283($0; $i; $numReasons; hlCategoryTypes; $reasonList; $itemPosition; $refNum)
C_POINTER:C301($2)  //text return value

Case of 
	: ($1="pick")
		$itemPosition:=Selected list items:C379(hlCategoryTypes)
		$0:=$itemPosition
		If ($itemPosition>0)
			GET LIST ITEM:C378(hlCategoryTypes; $itemPosition; $refNum; $reason)
			GOTO RECORD:C242([QA_Corrective_ActionsReason:106]; $refNum)
			$2->:=[QA_Corrective_ActionsReason:106]Category:2+"-"+[QA_Corrective_ActionsReason:106]Reason:3
			$3->:=[QA_Corrective_ActionsReason:106]id:1
		Else 
			$2->:=""
			$3->:=""
		End if 
		REDUCE SELECTION:C351([QA_Corrective_ActionsReason:106]; 0)
		
	: ($1="init")
		//*Get list of reasons
		ALL RECORDS:C47([QA_Corrective_ActionsReason:106])
		ORDER BY:C49([QA_Corrective_ActionsReason:106]; [QA_Corrective_ActionsReason:106]Category:2; >; [QA_Corrective_ActionsReason:106]Reason:3; >)
		//*Create the hierarchical list
		ARRAY LONGINT:C221(aListRefStack; 0)
		utl_ListReplace(->hlCategoryTypes; 0)
		//hlCategoryTypes:=utl_ListNew 
		hlStockCount:=0
		
		If (Records in selection:C76([QA_Corrective_ActionsReason:106])>0)
			SELECTION TO ARRAY:C260([QA_Corrective_ActionsReason:106]; $aRecNo; [QA_Corrective_ActionsReason:106]Category:2; $aCategory; [QA_Corrective_ActionsReason:106]Reason:3; $aReason)
			$numReasons:=Size of array:C274($aCategory)
			$reasonList:=0
			$currentType:=$aCategory{1}
			$lastType:=""
			For ($i; 1; $numReasons)
				hlStockCount:=hlStockCount+1
				If ($aCategory{$i}#$lastType)  //start a new parent
					If (Is a list:C621($reasonList))
						APPEND TO LIST:C376(hlCategoryTypes; $aCategory{$i-1}; -$aRecNo{$i-1}; $reasonList; True:C214)
					End if 
					$reasonList:=utl_ListNew
					$lastType:=$aCategory{$i}
				End if 
				APPEND TO LIST:C376($reasonList; $aReason{$i}; $aRecNo{$i})  //add a new leaf      
			End for 
			
			If (Is a list:C621($reasonList))
				APPEND TO LIST:C376(hlCategoryTypes; $aCategory{$i-1}; -$aRecNo{$i-1}; $reasonList; True:C214)
			End if 
			
		End if   //records      
		
		$0:=hlCategoryTypes
		
	: ($1="kill")
		utl_ListClear  //*tear down the list
		hlCategoryTypes:=0
		$0:=hlCategoryTypes
End case 