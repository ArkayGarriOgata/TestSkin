//%attributes = {"publishedWeb":true}
//(p) gSelectSeqItem
//•2/13/97 added code for tracking company cs onsite
//• 12/17/97 cs added code to track Comodity Code of item to issue to
//• 1/20/98 cs cursor placement
//• 1/22/98 cs clear jobform.seq num, and RM code if a blank line was selected
//• 1/23/98c cs ompany id array not sorted occasionally causing incorrect assignme
//   of Company ID
//• 2/4/98 cs if a budgetitem was selected and the RM on it did not exist. The Job
//  cleared and could not be entered. stopping issung.

C_TEXT:C284(sRMCommCode)  //• 12/17/97 cs 
C_LONGINT:C283($i)  //(P) gSelectSeqItem: Select Fields in array.

If (aBudgetItem>0)  //user clicked on array element, not blank line
	sRMCode:=aPOPartNo{aPOPartNo}
	sPONumber:=sJFNumber
	lSeqNumber:=aBudgetItem{aBudgetItem}
	lRecordNo:=alRecNo{aPOPartNo}
	sRmCommCode:=Substring:C12(aCommCode{aCommCode}; 1; 2)
	ARRAY TEXT:C222(asBin; 0)
	ARRAY TEXT:C222(asPONo; 0)
	ARRAY REAL:C219(asQty; 0)
	ARRAY REAL:C219($aConsignment; 0)
	ARRAY REAL:C219(arActCost; 0)
	ARRAY TEXT:C222(asBinPO; 0)
	ARRAY TEXT:C222(asPOBin; 0)
	ARRAY TEXT:C222(aCompany; 0)  //• 2/13/97
	
	If (sRMCode#"")
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sRMCode)
		If (Records in selection:C76([Raw_Materials:21])>0)
			rPOPrice:=aPOPrice{aPOPrice}
			rActPrice:=0  //[RAW_MATERIALS]ActCost
			sRMCode:=[Raw_Materials:21]Raw_Matl_Code:1
			sBinNo:=""
			sPONo:=""
			rQty:=0
			GOTO OBJECT:C206(sBinNo)
			SetObjectProperties(""; ->rQty; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sRMCode)
			//If (User in group(Current user;"Roanoke"))
			//QUERY SELECTION([RM_BINS];[RM_BINS]Location#"Arkay")
			//End if 
			If (Records in selection:C76([Raw_Materials_Locations:25])>0)
				//SORT SELECTION([RM_BINS];[RM_BINS]PO_No;>)
				//• 2/13/97added companyid to selection to array
				SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Location:2; asBin; [Raw_Materials_Locations:25]POItemKey:19; asPONo; [Raw_Materials_Locations:25]QtyOH:9; asQty; [Raw_Materials_Locations:25]ActCost:18; arActCost; [Raw_Materials_Locations:25]CompanyID:27; aCompany; [Raw_Materials_Locations:25]ConsignmentQty:26; $aConsignment)
				ARRAY TEXT:C222(asBinPO; Size of array:C274(asBin))
				ARRAY TEXT:C222(asPOBin; Size of array:C274(asBin))
				For ($i; 1; Size of array:C274(asBin))
					asBinPO{$i}:=txt_Pad(asBin{$i}; " "; 1; 11)+asPONo{$i}
					//asBinPO{$i}:=asBin{$i}+(" "*(10-Length(asBin{$i})))+asPONo{$i}
					asPOBin{$i}:=asPONo{$i}+asBin{$i}
					asQty{$i}:=asQty{$i}+$aConsignment{$i}
				End for 
				MULTI SORT ARRAY:C718(asBin; >; asPONo; >; asPOBin; asBinPO; asQty; arActCost; aCompany; $aConsignment)  // Modified by: Mark Zinke (5/23/13) Replaced line below
				//SORT ARRAY(asPOBin;asBinPO;asBin;asPONo;asQty;arActCost;aCompany;$aConsignment;>)  //• 1/23/98 cs added sort of companyid
				uChkQtyBin
			End if 
		Else 
			ALERT:C41("Raw Material Code "+sRMCode+" was not found.")
			gClrRMFields
			lSeqNumber:=aBudgetItem{aBudgetItem}  //• 2/4/98 cs 
			sPONumber:=[Job_Forms:42]JobFormID:5  //• 2/4/98 cs 
			GOTO OBJECT:C206(sRmCode)  //• 2/4/98 cs 
		End if 
	Else 
		ALERT:C41("A Raw Material Code must be entered!")
		
		If (aBudgetItem{aBudgetItem}=0)  //• 1/20/98 cs put cursor in seq number field
			GOTO OBJECT:C206(lSeqNumber)
		Else 
			GOTO OBJECT:C206(sRMCode)
		End if 
	End if 
Else 
	gClrRMFields  //• 1/22/98 cs clear jobform.seq num, and RM code if a blank line was selected
	GOTO OBJECT:C206(sPONumber)
End if 
aBudgetItem:=0