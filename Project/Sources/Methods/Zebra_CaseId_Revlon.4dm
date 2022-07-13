//%attributes = {}
//Method:  Zebra_CaseId_Revlon({oCase})
//Description:  This method will print case ID labels for Revlon.
//   This will only create the case label and update the label count.
//   When it is scanned in it will create the information needed for WMS.
//   This calls Zebra_CaseNumberManager which updates using[Job_Forms_Items_Labels]Jobit

//Example:  

//.   C_OBJECT($oCase)
//.   $oCase:=New object()

//.   $oCase.tJobNumber:=sJMI
//.   $oCase.nHowMany:=iCnt
//.   $oCase.nCaseQuantity:=wmsCaseQty

//.   Zebra_CaseId_Revlon ($oCase)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oCase)
	C_OBJECT:C1216($oAsk)
	C_OBJECT:C1216(Labl_oBarcode)
	
	C_LONGINT:C283($nLabel)
	C_LONGINT:C283($nCase; $nPrinted)
	C_LONGINT:C283($nStartCase; $nLastCase; $nPages)
	
	C_TEXT:C284($tLabel; $tPage)
	
	C_TEXT:C284($tCaseID)
	C_TEXT:C284($tBarcodeCaseID; $tBarcodeSeeIt)
	
	$oCase:=New object:C1471()
	$oAsk:=New object:C1471()
	Labl_oBarcode:=New object:C1471()
	
	$oCase:=$1
	
	$nLabel:=0
	$nCase:=0
	$nPrinted:=0
	
	$nStartCase:=Zebra_CaseNumberManager("find"; $oCase.tJobNumber)
	$nLastCase:=Zebra_CaseNumberManager("update"; $oCase.tJobNumber; $nStartCase; $oCase.nHowMany)
	
	If ($nLastCase<0)
		$nLastCase:=-1*$nLastCase
	End if 
	
	$nPages:=(1*(Num:C11(Mod:C98($oCase.nHowMany; 30)>0)))  //add 1 for partial page
	$nPages:=$nPages+Int:C8($oCase.nHowMany/30)  //
	
	$tLabel:=Core_PluralizeT("label"; $oCase.nHowMany)
	
	$tPage:=Core_PluralizeT("page"; $nPages)
	
	$oAsk.tMessage:="Please print the Arkay case ID "+$tLabel+CorektPeriod+CorektCR+CorektCR
	
	$oAsk.tMessage:=$oAsk.tMessage+\
		"You will need "+String:C10($nPages)+CorektSpace+$tPage+\
		" to print "+String:C10($oCase.nHowMany)+" Arkay case ID "+$tLabel+CorektPeriod+CorektCR+CorektCR
	$oAsk.tMessage:=$oAsk.tMessage+"Make sure to use Avery 5160/8160 labels [(1 x 2 5/8) (3x10)]."
	
	$tLabel[[1]]:=Uppercase:C13($tLabel[[1]])
	$oAsk.tDefault:="Print "+$tLabel
	
	$tCaseID:=CorektBlank
	
End if   //Done initialize

If (Core_Dialog_ConfirmN($oAsk)=CoreknDefault)  //Print now
	
	PRINT SETTINGS:C106(Page setup dialog:K47:16)
	PRINT SETTINGS:C106(Print dialog:K47:17)
	
	OPEN PRINTING JOB:C995
	
	For ($nCase; $nStartCase; $nLastCase)  //Cases
		
		$tCaseID:=Replace string:C233($oCase.tJobNumber; CorektPeriod; CorektBlank)  //Remove .'s
		$tCaseID:=$tCaseID+(9-Length:C16($tCaseID)*"0")  //Pad with 0's to make first 9 characters
		$tCaseID:=$tCaseID+String:C10($nCase; "0000000")  //Next 7 characters
		$tCaseID:=$tCaseID+String:C10($oCase.nCaseQuantity; "000000")  //Last 6 characters for total of 22
		
		$tBarcodeCaseID:=WMS_CaseId($tCaseID; "barcode")
		$tBarcodeSeeIt:=WMS_CaseId($tCaseID; "human")
		
		$nLabel:=$nLabel+1
		
		OB SET:C1220(Labl_oBarcode; "tCaseID"+String:C10($nLabel); $tBarcodeCaseID)
		OB SET:C1220(Labl_oBarcode; "tSeeIt"+String:C10($nLabel); $tBarcodeSeeIt)
		
		If ((Mod:C98($nLabel; 30)=0) & ($nCase#$nLastCase))  //Print label
			
			$nPrinted:=Print form:C5("Label_3x10")
			
			PAGE BREAK:C6
			
			Labl_oBarcode:=New object:C1471()  //Clear object
			$nLabel:=0  //Clear count
			
		End if   //Done print labels
		
	End for   //Done cases
	
	$nPrinted:=Print form:C5("Label_3x10")
	
	CLOSE PRINTING JOB:C996
	
	Labl_oBarcode:=New object:C1471()  //Clear object
	
End if   //Done print now