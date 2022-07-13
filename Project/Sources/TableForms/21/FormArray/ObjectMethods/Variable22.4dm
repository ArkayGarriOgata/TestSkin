//(S) [RAW_MATERIALS]FormArray'bRemove
//upr 103 11/2/94
//•2/13/97 cs onsite allow user to hange locatoin without company change
C_LONGINT:C283($Pos; $i; $j; $seq)
C_TEXT:C284($job)
C_TEXT:C284($rm)
C_REAL:C285($qty)
$Pos:=aRMJFNum
If ($Pos<1)
	uRejectAlert("You must first select an item from the 'Issues to Post' section!")
Else 
	$rm:=aRMCode{$Pos}
	$seq:=aRMBudItem{$Pos}
	$job:=aRMJFNum{$Pos}
	$qty:=aRMPOQty{$Pos}
	DELETE FROM ARRAY:C228(aRMJFNum; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMBudItem; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMCode; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMPOQty; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMPOPrice; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMStdPrice; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMBinNo; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMType; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMRefNo; $Pos; 1)
	DELETE FROM ARRAY:C228(aRMBinPO; $Pos; 1)
	DELETE FROM ARRAY:C228(adRMDate; $Pos; 1)
	DELETE FROM ARRAY:C228(aRmCompany; $Pos; 1)  //•2/13/97
	arraynum:=Size of array:C274(aRMJFNum)
	
	If (sRMCode=$rm)  //refreash bin arrays
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sRMCode)
		If (Records in selection:C76([Raw_Materials_Locations:25])>0)
			//SORT SELECTION([RM_BINS];[RM_BINS]PO_No;>)
			SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Location:2; asBin; [Raw_Materials_Locations:25]POItemKey:19; asPONo; [Raw_Materials_Locations:25]QtyOH:9; asQty; [Raw_Materials_Locations:25]ActCost:18; arActCost)
			ARRAY TEXT:C222(asBinPO; Size of array:C274(asBin))
			ARRAY TEXT:C222(asPOBin; Size of array:C274(asBin))
			For ($i; 1; Size of array:C274(asBin))
				asBinPO{$i}:=txt_Pad(asBin{$i}; " "; 1; 11)+asPONo{$i}
				//asBinPO{$i}:=asBin{$i}+(" "*(10-Length(asBin{$i})))+asPONo{$i}
				asPOBin{$i}:=asPONo{$i}+asBin{$i}
			End for 
			SORT ARRAY:C229(asPOBin; asBinPO; asBin; asPONo; asQty; arActCost; >)
			uChkQtyBin
		End if 
		
	End if   //still on that rm
	
	If (sPONumber=$job)  //refresh budget array
		$hit:=0
		For ($j; 1; Size of array:C274(aBudgetItem))
			If ((aBudgetItem{$j}=$seq) & (aPOPartNo{$j}=$rm))
				aQtyAvl{$j}:=aQtyAvl{$j}-$Qty
				$j:=$j+Size of array:C274(aBudgetItem)  //break
			End if 
		End for 
		
	End if   //still on that job
	
End if   //non selected
//EOP