//%attributes = {}
// ----------------------------------------------------
// User name (OS): Work
// Date and time: 10/12/06, 12:29:36
// ----------------------------------------------------
// Method: POI_ItemsToPost
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

C_LONGINT:C283($1; numToPost; $element; $size)
C_TEXT:C284($2)

If (Count parameters:C259>=2)
	Case of 
		: ($2="Load")
			numToPost:=Size of array:C274(aRMPONum)+1
			POI_ItemsToPost(numToPost)
			
			aRMPONum{numToPost}:=sPONumber
			aRMPOItem{numToPost}:=sItemNumber
			aRMCode{numToPost}:=sRMCode
			aRMBinNo{numToPost}:=sBinNo
			aRMPOQty{numToPost}:=rQty
			aRMSTKQty{numToPost}:=rQty2
			aRMPOPrice{numToPost}:=rPOPrice
			aRMStdPrice{numToPost}:=rActPrice  // converted units here
			aRMType{numToPost}:=sType
			aRMRecNo{numToPost}:=Num:C11(Substring:C12(sReceiveNum; 2))
			aRmCompany{numToPost}:=ChrgCodeFrmLoc(sCompany)  //• 2/13/97 added so that if location is changed correct company is inserted
			$hit:=Find in array:C230(aPOItem; sItemNumber)
			If ($hit>0)
				aQtyAvl{$hit}:=aQtyAvl{$hit}-rQty
			End if 
			
		: ($2="Delete")
			$element:=$1
			aRMCode{$element}:="VOIDED-RCN"
			aRMSTKQty{$element}:=0
			aRMPOQty{$element}:=0
			aRMPOPrice{$element}:=0
			aRMStdPrice{$element}:=0
			aRMBinNo{$element}:="VOID"
			$size:=RM_XferCreate($element; 4D_Current_date)
			DELETE FROM ARRAY:C228(aRMPONum; $element; 1)
			DELETE FROM ARRAY:C228(aRMPOItem; $element; 1)
			DELETE FROM ARRAY:C228(aRMCode; $element; 1)
			DELETE FROM ARRAY:C228(aRMBinNo; $element; 1)
			DELETE FROM ARRAY:C228(aRMPOQty; $element; 1)
			DELETE FROM ARRAY:C228(aRMSTKQty; $element; 1)
			DELETE FROM ARRAY:C228(aRMPOPrice; $element; 1)
			DELETE FROM ARRAY:C228(aRMStdPrice; $element; 1)
			DELETE FROM ARRAY:C228(aRMType; $element; 1)
			DELETE FROM ARRAY:C228(aRMRecNo; $element; 1)
			DELETE FROM ARRAY:C228(aRmCompany; $element; 1)  //• 2/13/97
	End case 
	
Else 
	$size:=$1
	ARRAY TEXT:C222(aRMPONum; $size)
	ARRAY TEXT:C222(aRMPOItem; $size)
	ARRAY TEXT:C222(aRMCode; $size)
	ARRAY TEXT:C222(aRMBinNo; $size)
	ARRAY REAL:C219(aRMPOQty; $size)
	ARRAY REAL:C219(aRMSTKQty; $size)
	ARRAY REAL:C219(aRMPOPrice; $size)
	ARRAY REAL:C219(aRMStdPrice; $size)
	ARRAY TEXT:C222(aRMType; $size)
	ARRAY LONGINT:C221(aRMRecNo; $size)
	ARRAY TEXT:C222(aRmCompany; $size)
End if 

numToPost:=Size of array:C274(aRMPONum)

If (numToPost>0)
	OBJECT SET ENABLED:C1123(bPost; True:C214)
	OBJECT SET ENABLED:C1123(bRemove; True:C214)
	OBJECT SET ENABLED:C1123(bQuote; True:C214)
	SetObjectProperties(""; ->bCancel; True:C214; "VOID RECEIPTS")
Else 
	OBJECT SET ENABLED:C1123(bPost; False:C215)
	OBJECT SET ENABLED:C1123(bRemove; False:C215)
	OBJECT SET ENABLED:C1123(bQuote; False:C215)
	SetObjectProperties(""; ->bCancel; True:C214; "Done")
End if 