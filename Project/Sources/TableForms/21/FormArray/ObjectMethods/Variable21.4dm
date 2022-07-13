// ----------------------------------------------------
// Object Method: [Raw_Materials].FormArray.Variable21
// Description:
// 2/13/97 added code to allow user to change location with out affecting compayid
//  on site cs
//• 4/23/97 cs Request from Mellisa - place some code in the 
//  "Add" button that test that something is in each of these 
//   fields (except the one that says Ref.)
//• 5/29/98 cs made ref no required - for later tracking
// ----------------------------------------------------

C_LONGINT:C283($j)

Case of   //• 4/23/97 cs start
	: (sPoNumber="")
		ALERT:C41("You must include a Job Form Number.")
	: (lSeqNumber=0)
		ALERT:C41("You must include a Sequence Number.")
	: (sRmCode="")
		ALERT:C41("You must include a Raw Material Code.")
	: (sBinNo="")
		ALERT:C41("You must include a Location.")
	: (sPoNo="")
		ALERT:C41("You must include a Purchase Order Number.")
	: (rQty=0)
		ALERT:C41("You must indicate a Quantity to Issue.")
	: (sIssType="")
		ALERT:C41("You must include a Type.")
	: (dRmDate=!00-00-00!)
		ALERT:C41("You must indicate the Date.")
		//end `• 4/23/97 cs 
	: (sRefNo="")
		ALERT:C41("You must enter a refernce number, or code.")  //• 5/29/98 cs 
	Else 
		If (Num:C11(sPONo)>0) & (rQty#0) & (lSeqNumber#0)  //(sBinNo#"") &
			arraynum:=arraynum+1
			INSERT IN ARRAY:C227(aRMJFNum; arraynum; 1)  //job
			INSERT IN ARRAY:C227(aRMBudItem; arraynum; 1)  //seq
			INSERT IN ARRAY:C227(aRMCode; arraynum; 1)  //rm item
			INSERT IN ARRAY:C227(aRMPOQty; arraynum; 1)  //qty
			INSERT IN ARRAY:C227(aRMPOPrice; arraynum; 1)
			INSERT IN ARRAY:C227(aRMStdPrice; arraynum; 1)  //cost
			INSERT IN ARRAY:C227(aRMBinNo; arraynum; 1)  //location
			INSERT IN ARRAY:C227(aRMType; arraynum; 1)
			INSERT IN ARRAY:C227(aRMRefNo; arraynum; 1)
			INSERT IN ARRAY:C227(aRMBinPO; arraynum; 1)
			INSERT IN ARRAY:C227(adRMDate; arraynum; 1)
			INSERT IN ARRAY:C227(aRmCompany; arraynum; 1)  //•2/13/97 add element for company id
			//ALERT("1")
			
			aRMJFNum{arraynum}:=sPONumber
			aRMBudItem{arraynum}:=lSeqNumber
			aRMCode{arraynum}:=sRMCode
			aRMPOQty{arraynum}:=uNANCheck(rQty)
			aRmCompany{ArrayNum}:=sCompany  //•2/13/97 assign company id
			// aRMPOPrice{arraynum}:=rPOPrice
			//aRMStdPrice{arraynum}:=rActPrice
			aRMStdPrice{arraynum}:=rActCost
			aRMBinNo{arraynum}:=sBinNo
			aRMType{arraynum}:=sIssType
			aRMRefNo{arraynum}:=sRefNo
			//aRMBinPO{arraynum}:=sPONo
			aRMBinPO{arraynum}:=txt_Pad(sBinNo; " "; 1; 11)+sPONo
			//aRMBinPO{arraynum}:=sBinNo+(" "*(11-Length(sBinNo)))+sPONo
			adRMDate{arraynum}:=dRMDate
			//ALERT("2")
			$j:=Find in array:C230(aBudgetItem; lSeqNumber)
			If ($j>0)
				If (aPOPartNo{$j}#"")  //just do it if no r/m code is in budget.
					//BAK 8/31/94 Modified below three lines - will now work with Non-budgeted Items  
					While ($j<=Size of array:C274(aBudgetItem))  //make sure you got it
						If (aPOPartNo{$j}=sRMCode)
							aQtyAvl{$j}:=aQtyAvl{$j}+rQty
							//$j:=$j+1
						End if 
						$j:=$j+1
					End while 
				Else 
					aQtyAvl{$j}:=aQtyAvl{$j}+rQty
				End if 
				//aQtyAvl{$j}:=aQtyAvl{$j}+rQty
			End if 
			OBJECT SET ENABLED:C1123(bPost; True:C214)
			//ALERT("3")
			$j:=Find in array:C230(asBinPO; aRMBinPO{arraynum})
			If ($j>0)
				asQty{$j}:=asQty{$j}-rQty
			End if 
			sBinNo:=""
			sPONo:="0"*9
			rQty:=0
			GOTO OBJECT:C206(sBinNo)
			SetObjectProperties(""; ->rQty; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		Else 
			BEEP:C151
			Case of 
				: (lSeqNumber=0)
					ALERT:C41("A Budget Item must be selected.")
					//: (sBinNo="")
					//  ALERT("Bin No. must be entered ")
				: (sPONo="")
					ALERT:C41("PO No. must be entered ")
				: (rQty=0)
					ALERT:C41("A Quantity Issued must be entered.")
			End case 
		End if 
End case 