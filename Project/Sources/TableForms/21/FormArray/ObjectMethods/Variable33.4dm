// ----------------------------------------------------
// Object Method: [Raw_Materials].FormArray.Variable33
// Description:
// Search for RM Code
// 2/18/97 cs added code to track companyid
// 12/17/97 cs added code to require that commodity to issue against 
//  matches commodity to be issued 
// ----------------------------------------------------

C_LONGINT:C283(lRMRec)
C_TEXT:C284(sRmCommCode)
ARRAY TEXT:C222(asBin; 0)
ARRAY TEXT:C222(asPONo; 0)
ARRAY REAL:C219(asQty; 0)
ARRAY REAL:C219($aConsignment; 0)
ARRAY REAL:C219(arActCost; 0)
ARRAY TEXT:C222(asBinPO; 0)
ARRAY TEXT:C222(asPOBin; 0)
ARRAY TEXT:C222(aCompany; 0)  //• 2/18/97
$comkey:=""  //02/22/11 mlb, relieve error printing jobbags
If (sRmCommCode#"")
	$CommCode:=sRmCommCode  //• 12/17/97 cs get commodity code of selected Budgeted material
Else 
	$CommCode:=""
End if 
QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sRMCode)
//If (User in group(Current user;"Roanoke"))
//QUERY SELECTION([RM_BINS];[RM_BINS]Location#"Arkay")
//End if 
If (Records in selection:C76([Raw_Materials_Locations:25])>0)
	$BinCommCode:=Substring:C12([Raw_Materials_Locations:25]Commodity_Key:12; 1; 2)
	$comkey:=[Raw_Materials_Locations:25]Commodity_Key:12
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Commodity_Key:12=$CommCode+"@")  //• 12/17/97 cs see if the rm_bin matches the budgeted Material 
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)  //• 12/17/97 cs end 
		
		//• 2/18/97 added companyid to selection to array
		SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Location:2; asBin; [Raw_Materials_Locations:25]POItemKey:19; asPONo; [Raw_Materials_Locations:25]QtyOH:9; asQty; [Raw_Materials_Locations:25]ActCost:18; arActCost; [Raw_Materials_Locations:25]CompanyID:27; aCompany; [Raw_Materials_Locations:25]ConsignmentQty:26; $aConsignment)
		ARRAY TEXT:C222(asBinPO; Size of array:C274(asBin))
		ARRAY TEXT:C222(asPOBin; Size of array:C274(asBin))
		
		For ($i; 1; Size of array:C274(asBin))
			asBinPO{$i}:=txt_Pad(asBin{$i}; " "; 1; 11)+asPONo{$i}
			//asBinPO{$i}:=asBin{$i}+(" "*(10-Length(asBin{$i})))+asPONo{$i}
			asPOBin{$i}:=asPONo{$i}+asBin{$i}
			asQty{$i}:=asQty{$i}+$aConsignment{$i}
		End for 
		MULTI SORT ARRAY:C718(asBin; >; asPONo; >; asPOBin; asBinPO; asQty; arActCost; $aConsignment)  // Modified by: Mark Zinke (5/23/13) Replaced line below
		//SORT ARRAY(asPOBin;asBinPO;asBin;asPONo;asQty;arActCost;$aConsignment;>)
		uChkQtyBin
		
		//BAK 7/6/94:  Update Raw Goods ID in Budget
		If (lRecordNo>0)  //selected a budget item
			lRMRec:=Find in array:C230(alRecNo; lRecordNo)
			
			If (lRMRec>0)
				READ WRITE:C146([Job_Forms_Materials:55])
				GOTO RECORD:C242([Job_Forms_Materials:55]; lRecordNo)
				
				If (Records in selection:C76([Job_Forms_Materials:55])>0)
					If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)=0)
						[Job_Forms_Materials:55]Raw_Matl_Code:7:=sRMCode
						aPOPartNo{lRMRec}:=sRMCode
						[Job_Forms_Materials:55]Sequence:3:=lSeqNumber
						aBudgetItem{lRMRec}:=lSeqNumber
						[Job_Forms_Materials:55]Commodity_Key:12:=$comkey
						aCommCode{lRMRec}:=$comkey
						SAVE RECORD:C53([Job_Forms_Materials:55])
					Else   //mlb 092105
						BEEP:C151
						ALERT:C41("Can't change budgeted R/M. Create new budget item by clicking the 'New Item' butt"+"on.")
						sRMCode:=""
						lSeqNumber:=0
						lRecordNo:=-3
						REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
						GOTO OBJECT:C206(lSeqNumber)
					End if 
					
				End if 
				READ ONLY:C145([Job_Forms_Materials:55])
				UNLOAD RECORD:C212([Job_Forms_Materials:55])
			End if   //recno > 0 
		Else 
			BEEP:C151
			ALERT:C41("Select an item from the budget before entering details.")
			sRMCode:=""
			lSeqNumber:=0
			lRecordNo:=-3
			REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
			GOTO OBJECT:C206(lSeqNumber)
		End if   //selected a budget item
		
	Else   //• 12/17/97 cs 
		$Text:="Budgeted material's commodity code does NOT match"+" entered (issuing) raw material's commodity code."
		$Text:=$Text+Char:C90(13)+Char:C90(13)+"Attempted Issue = "+$BinCommCode+",  Budgeted = "+$CommCode
		$Text:=$Text+Char:C90(13)+Char:C90(13)+"To Issue this material - Click 'New Item' button or select a budgeted item"
		ALERT:C41($Text)
		//• 12/17/97 cs clear as if user had made NO selection in array
		sRMCode:=""
		sPONumber:=""
		lSeqNumber:=0
		lRecordNo:=0
		sRmCommCode:=""
		Self:C308->:=""
		GOTO OBJECT:C206(sPoNumber)
	End if   //commodty codes match
	
Else   //no RM found`• 2/4/98 cs 
	ALERT:C41("Enter Material code ("+sRmCode+") not found in inventory."+Char:C90(13)+"Please check your Material code and try again.")
	sRmCode:=""
	GOTO OBJECT:C206(sRmCode)
End if 
//EOS