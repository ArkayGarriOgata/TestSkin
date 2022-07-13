//%attributes = {}
// ----------------------------------------------------
// User name (OS): mlb
// Date and time: 10/05/05, 14:50:42
// ----------------------------------------------------
// Method: FG_FXexcessRpt
// ----------------------------------------------------

READ ONLY:C145([Finished_Goods_Locations:35])

C_TEXT:C284($1)  //email distribution list
C_TEXT:C284($t; $r)
C_DATE:C307($today)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$r:=Char:C90(13)
$today:=4D_Current_date
xTitle:=""
xText:=""
docName:="FX_Rpt_"+fYYMMDD($today; 1)+".xls"
xTitle:=docName

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FX@")
If (Records in selection:C76([Finished_Goods_Locations:35])>0)
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; xTitle+$r+$r)
		xText:="CUSTOMER"+$t+"LINE"+$t+"PRODUCT CODE"+$t+"JOBIT"+$t+"QTY"+$t+"GLUED"+$t+"MTHS_OLD"+$t+"BIN_LOCATION"+$r
		
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]CustID:16; $aCustId; [Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]Jobit:33; $aJobit; [Finished_Goods_Locations:35]QtyOH:9; $aQty; [Finished_Goods_Locations:35]Location:2; $aBin)
		MULTI SORT ARRAY:C718($aCustId; >; $aCPN; >; $aJobit; $aQty; $aBin)
		C_LONGINT:C283($i; $numElements)
		$numElements:=Size of array:C274($aCustId)
		ARRAY TEXT:C222($aCustomer; $numElements)
		ARRAY DATE:C224($aGlued; $numElements)
		ARRAY REAL:C219($aAge; $numElements)
		ARRAY TEXT:C222($aLine; $numElements)
		$total:=0
		uThermoInit($numElements; "Processing Array")
		For ($i; 1; $numElements)
			$aCustomer{$i}:=CUST_getName($aCustId{$i})
			$aGlued{$i}:=JMI_getGlueDate($aJobit{$i})
			$aAge{$i}:=Round:C94(($today-$aGlued{$i})/30; 1)
			$aLine{$i}:=FG_getLine($aCPN{$i})
			
			$total:=$total+$aQty{$i}
			
			If (Length:C16(xText)>25000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			xText:=xText+$aCustomer{$i}+$t+$aLine{$i}+$t+$aCPN{$i}+$t+$aJobit{$i}+$t+String:C10($aQty{$i})+$t+String:C10($aGlued{$i}; System date short:K1:1)+$t+String:C10($aAge{$i})+$t+$aBin{$i}+$r
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		SEND PACKET:C103($docRef; xText)
		SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		If (Count parameters:C259=1)
			xTitle:="Flat eXcess Report FX="+String:C10($total)
			EMAIL_Sender(xTitle; ""; "Open attached spreadsheet with Excel."; $1; docName)
			util_deleteDocument(docName)
		Else 
			$err:=util_Launch_External_App(docName)
		End if 
	End if 
End if 