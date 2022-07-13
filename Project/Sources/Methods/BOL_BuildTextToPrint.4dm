//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/03/07, 15:43:22
// ----------------------------------------------------
// Method: BOL_BuildTextToPrint
// Description
// build a text block for the printout
// ----------------------------------------------------

C_BOOLEAN:C305($suppressPO; isBillandHold)
C_LONGINT:C283($i; $numItems; $numLines; $pageWidth; $pages; $linesPerPage; $numCopies; invoiceNum; $line)
C_LONGINT:C283($posItem; $posCustPO; $posCustRel; $posArkayRel; $posCPN; $posRmk)  //detail line 1
C_LONGINT:C283($posNumCase; $posCaseWt; $posTotWt; $posPackCnt; $posTotCnt; $posRelAmt)  //detail line 2
C_LONGINT:C283($posSubLabel; $posSubTotAm; $posSubTotRe; $posPartial)  //detail subtotal
C_LONGINT:C283($posGrandCnt; $posGrandWgt; $posDeclVal; $posPageNo)  //footer
C_REAL:C285(declaredVal)

Case of 
	: (ELC_isEsteeLauderCompany([Customers_Bills_of_Lading:49]CustID:2))  //•071696 MLB Lauder cant deal with normal manifest
		$suppressPO:=True:C214
		
	: ([Customers_Bills_of_Lading:49]CustID:2="00074")
		$suppressPO:=True:C214
		
	Else   //note that Loreal blanks out release CustomerRefer
		$suppressPO:=False:C215
End case 

$pageWidth:=73
$blankLine:=($pageWidth*" ")
$linesPerPage:=25  //28
$numCopies:=1  //• mlb - 11/22/02  11:14 go with 1 copy instead of 5
$posItem:=2
$posCustPO:=5
$posCustRel:=22
//$posArkayRel:=34
$posCPN:=43
$posRmk:=58
$posNumCase:=5
$posCaseWt:=12
$posTotWt:=19
$posPackCnt:=26
$posTotCnt:=30
$posRelAmt:=41
$posPartial:=53
$posSubLabel:=1
declaredVal:=0  //ORD_getPricePerM(orderline) 

//* Load all that data into an array for printing
RELATE MANY:C262([Customers_Bills_of_Lading:49]Manifest:16)
$numItems:=Records in selection:C76([Customers_Bills_of_Lading_Manif:181])
ORDER BY:C49([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]Arkay_Release:4; >)  //subtotaled by release  
//FIRST SUBRECORD([Customers_Bills_of_Lading]Manifest)
//init loop accumulators
$qtyCartonsTTL:=0
$qtyCasesTTL:=0
$qtyPoundsTTL:=0
//init for new release
$qtyShippedThisRel:=0  // reset per release qty
$qtyTotalReleased:=0
$currRel:=[Customers_Bills_of_Lading_Manif:181]Arkay_Release:4  //FG_ShipItemBeforeProcess (->invoiceNum)
invoiceNum:=-3

If (invoiceNum#-1)
	$lineCursor:=0
	ARRAY TEXT:C222($aLine; 5*$numItems)  //grap some extra space for subtotals etc.
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; 5*$numItems)
			If ($currRel#[Customers_Bills_of_Lading_Manif:181]Arkay_Release:4)  //get the subtotals
				//FG_ShipItemAfterProcess ($currRel;$qtyShippedThisRel)
				$itemRecord:=$blankLine
				$itemRecord:=Change string:C234($itemRecord; "   ----------"; $posTotCnt)
				$itemRecord:=Change string:C234($itemRecord; "  ---------"; $posRelAmt)
				$aLine{$i}:=$itemRecord
				
				$i:=$i+1  //advance the loop control
				$itemRecord:=$blankLine
				$itemRecord:=Change string:C234($itemRecord; "Rel#"+String:C10($currRel)+" Subtotals:"; $posSubLabel)
				$itemRecord:=Change string:C234($itemRecord; String:C10($qtyShippedThisRel; "^^^,^^^,^^0"); $posTotCnt)
				$itemRecord:=Change string:C234($itemRecord; String:C10($qtyTotalReleased; "^^^,^^^,^^0"); $posRelAmt)
				If ($qtyShippedThisRel<$qtyTotalReleased)
					$itemRecord:=Change string:C234($itemRecord; "Partial"; $posPartial)
				End if 
				$aLine{$i}:=$itemRecord
				//********************************
				$i:=$i+2  //advance the loop control
				//init for new release
				$qtyShippedThisRel:=0  // reset per release qty
				$qtyTotalReleased:=0
				$currRel:=[Customers_Bills_of_Lading_Manif:181]Arkay_Release:4  //FG_ShipItemBeforeProcess (->invoiceNum)
				If (invoiceNum=-1)  //break out
					$lineCursor:=$i+1
					$i:=$i+(15*$numItems)
				End if 
			End if 
			
			If ([Customers_Bills_of_Lading_Manif:181]Item:1#0)  //get the first line 
				$itemRecord:=$blankLine
				$itemRecord:=Change string:C234($itemRecord; String:C10([Customers_Bills_of_Lading_Manif:181]Item:1); $posItem)
				
				If (Not:C34($suppressPO))  //•071696 MLB Lauder cant deal with normal manifest
					$itemRecord:=Change string:C234($itemRecord; [Customers_Bills_of_Lading_Manif:181]Cust_PO:2; $posCustPO)
				Else 
					$itemRecord:=Change string:C234($itemRecord; "         ----->"; $posCustPO)
				End if 
				$itemRecord:=Change string:C234($itemRecord; [Customers_Bills_of_Lading_Manif:181]Cust_Release:3; $posCustRel)
				//$itemRecord:=Change string($itemRecord;String([Customers_Bills_of_Lading]Manifest'Arkay_Release);$posArkayRel)
				$itemRecord:=Change string:C234($itemRecord; [Customers_Bills_of_Lading_Manif:181]CPN:5; $posCPN)
				$itemRecord:=Change string:C234($itemRecord; [Customers_Bills_of_Lading_Manif:181]Remarks1:10; $posRmk)
				
				$aLine{$i}:=$itemRecord
				$i:=$i+1
			End if 
			
			$itemRecord:=$blankLine
			$itemRecord:=Change string:C234($itemRecord; String:C10([Customers_Bills_of_Lading_Manif:181]NumCases:6); $posNumCase)
			$itemRecord:=Change string:C234($itemRecord; String:C10([Customers_Bills_of_Lading_Manif:181]Wt_PerCase:7); $posCaseWt)
			$itemRecord:=Change string:C234($itemRecord; String:C10([Customers_Bills_of_Lading_Manif:181]Total_Wt:11); $posTotWt)
			$itemRecord:=Change string:C234($itemRecord; String:C10([Customers_Bills_of_Lading_Manif:181]Count_PerCase:8); $posPackCnt)
			$itemRecord:=Change string:C234($itemRecord; String:C10([Customers_Bills_of_Lading_Manif:181]Total_Amt:9; "^^^,^^^,^^0"); $posTotCnt)
			$itemRecord:=Change string:C234($itemRecord; [Customers_Bills_of_Lading_Manif:181]Remarks2:14; $posRmk)
			$aLine{$i}:=$itemRecord
			
			$qtyShippedThisRel:=$qtyShippedThisRel+[Customers_Bills_of_Lading_Manif:181]Total_Amt:9
			//$qtyTotalReleased:=$qtyTotalReleased+[Customers_Bills_of_Lading_Manif]Total_Rel  // Commented by: Mark Zinke (6/27/13) Don't add this up.
			$qtyCartonsTTL:=$qtyCartonsTTL+[Customers_Bills_of_Lading_Manif:181]Total_Amt:9
			$qtyCasesTTL:=$qtyCasesTTL+[Customers_Bills_of_Lading_Manif:181]NumCases:6
			$qtyPoundsTTL:=$qtyPoundsTTL+[Customers_Bills_of_Lading_Manif:181]Total_Wt:11
			//[Customers_Bills_of_Lading]Manifest'InvoiceNumber:=invoiceNum
			
			$qtyTotalReleased:=[Customers_Bills_of_Lading_Manif:181]Total_Rel:12  // Added by: Mark Zinke (6/27/13) Field is the same value on all records, we just need to capture it once.
			NEXT RECORD:C51([Customers_Bills_of_Lading_Manif:181])
			If (End selection:C36([Customers_Bills_of_Lading_Manif:181]))
				$lineCursor:=$i+1
				$i:=$i+(15*$numItems)
			End if 
		End for 
		
		
	Else 
		
		//laghzaoui you need to see line 224
		ARRAY LONGINT:C221($_Arkay_Release; 0)
		ARRAY TEXT:C222($_Cust_PO; 0)
		ARRAY TEXT:C222($_Cust_Release; 0)
		ARRAY LONGINT:C221($_Count_PerCase; 0)
		ARRAY TEXT:C222($_CPN; 0)
		ARRAY LONGINT:C221($_Item; 0)
		ARRAY TEXT:C222($_Remarks1; 0)
		ARRAY TEXT:C222($_Remarks2; 0)
		ARRAY LONGINT:C221($_NumCases; 0)
		ARRAY LONGINT:C221($_Wt_PerCase; 0)
		ARRAY LONGINT:C221($_Total_Wt; 0)
		ARRAY LONGINT:C221($_Total_Amt; 0)
		ARRAY LONGINT:C221($_Total_Rel; 0)
		
		SELECTION TO ARRAY:C260([Customers_Bills_of_Lading_Manif:181]Arkay_Release:4; $_Arkay_Release; \
			[Customers_Bills_of_Lading_Manif:181]Cust_PO:2; $_Cust_PO; \
			[Customers_Bills_of_Lading_Manif:181]Cust_Release:3; $_Cust_Release; \
			[Customers_Bills_of_Lading_Manif:181]Count_PerCase:8; $_Count_PerCase; \
			[Customers_Bills_of_Lading_Manif:181]CPN:5; $_CPN; \
			[Customers_Bills_of_Lading_Manif:181]Item:1; $_Item; \
			[Customers_Bills_of_Lading_Manif:181]Remarks1:10; $_Remarks1; \
			[Customers_Bills_of_Lading_Manif:181]Remarks2:14; $_Remarks2; \
			[Customers_Bills_of_Lading_Manif:181]NumCases:6; $_NumCases; \
			[Customers_Bills_of_Lading_Manif:181]Wt_PerCase:7; $_Wt_PerCase; \
			[Customers_Bills_of_Lading_Manif:181]Total_Wt:11; $_Total_Wt; \
			[Customers_Bills_of_Lading_Manif:181]Total_Amt:9; $_Total_Amt; \
			[Customers_Bills_of_Lading_Manif:181]Total_Rel:12; $_Total_Rel)
		
		//Laghzaoui Mel use an other iterator
		
		$Iter:=1
		For ($i; 1; 5*$numItems)
			If ($currRel#$_Arkay_Release{$Iter})  //get the subtotals
				$itemRecord:=$blankLine
				$itemRecord:=Change string:C234($itemRecord; "   ----------"; $posTotCnt)
				$itemRecord:=Change string:C234($itemRecord; "  ---------"; $posRelAmt)
				$aLine{$i}:=$itemRecord
				
				$i:=$i+1  //advance the loop control
				$itemRecord:=$blankLine
				$itemRecord:=Change string:C234($itemRecord; "Rel#"+String:C10($currRel)+" Subtotals:"; $posSubLabel)
				$itemRecord:=Change string:C234($itemRecord; String:C10($qtyShippedThisRel; "^^^,^^^,^^0"); $posTotCnt)
				$itemRecord:=Change string:C234($itemRecord; String:C10($qtyTotalReleased; "^^^,^^^,^^0"); $posRelAmt)
				If ($qtyShippedThisRel<$qtyTotalReleased)
					$itemRecord:=Change string:C234($itemRecord; "Partial"; $posPartial)
				End if 
				$aLine{$i}:=$itemRecord
				//********************************
				$i:=$i+2  //advance the loop control
				//init for new release
				$qtyShippedThisRel:=0  // reset per release qty
				$qtyTotalReleased:=0
				$currRel:=$_Arkay_Release{$Iter}  //FG_ShipItemBeforeProcess (->invoiceNum)
				If (invoiceNum=-1)  //break out
					$lineCursor:=$i+1
					$i:=$i+(15*$numItems)
				End if 
			End if 
			//correction after Mel Bug
			If ($_Item{$Iter}#0)  //get the first line 
				$itemRecord:=$blankLine
				$itemRecord:=Change string:C234($itemRecord; String:C10($_Item{$Iter}); $posItem)
				
				If (Not:C34($suppressPO))  //•071696 MLB Lauder cant deal with normal manifest
					$itemRecord:=Change string:C234($itemRecord; $_Cust_PO{$Iter}; $posCustPO)
				Else 
					$itemRecord:=Change string:C234($itemRecord; "         ----->"; $posCustPO)
				End if 
				$itemRecord:=Change string:C234($itemRecord; $_Cust_Release{$Iter}; $posCustRel)
				$itemRecord:=Change string:C234($itemRecord; $_CPN{$Iter}; $posCPN)
				$itemRecord:=Change string:C234($itemRecord; $_Remarks1{$Iter}; $posRmk)
				
				$aLine{$i}:=$itemRecord
				$i:=$i+1
			End if 
			
			$itemRecord:=$blankLine
			$itemRecord:=Change string:C234($itemRecord; String:C10($_NumCases{$Iter}); $posNumCase)
			$itemRecord:=Change string:C234($itemRecord; String:C10($_Wt_PerCase{$Iter}); $posCaseWt)
			$itemRecord:=Change string:C234($itemRecord; String:C10($_Total_Wt{$Iter}); $posTotWt)
			$itemRecord:=Change string:C234($itemRecord; String:C10($_Count_PerCase{$Iter}); $posPackCnt)
			$itemRecord:=Change string:C234($itemRecord; String:C10($_Total_Amt{$Iter}; "^^^,^^^,^^0"); $posTotCnt)
			$itemRecord:=Change string:C234($itemRecord; $_Remarks2{$Iter}; $posRmk)
			$aLine{$i}:=$itemRecord
			
			$qtyShippedThisRel:=$qtyShippedThisRel+$_Total_Amt{$Iter}
			$qtyCartonsTTL:=$qtyCartonsTTL+$_Total_Amt{$Iter}
			$qtyCasesTTL:=$qtyCasesTTL+$_NumCases{$Iter}
			$qtyPoundsTTL:=$qtyPoundsTTL+$_Total_Wt{$Iter}
			
			$qtyTotalReleased:=$_Total_Rel{$Iter}  // Added by: Mark Zinke (6/27/13) Field is the same value on all records, we just need to capture it once.
			
			$Iter:=$Iter+1
			//correction after Mel Bug
			If ($Iter=(Size of array:C274($_Arkay_Release)+1))
				$lineCursor:=$i+1
				$i:=$i+(15*$numItems)
			End if 
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	//FG_ShipItemAfterProcess ($currRel;$qtyShippedThisRel)
	If ($numItems>0)
		$itemRecord:=$blankLine
		$itemRecord:=Change string:C234($itemRecord; "   ----------"; $posTotCnt)
		$itemRecord:=Change string:C234($itemRecord; "  ---------"; $posRelAmt)
		$aLine{$lineCursor}:=$itemRecord
		
		$lineCursor:=$lineCursor+1
		$itemRecord:=$blankLine
		$itemRecord:=Change string:C234($itemRecord; "Rel#"+String:C10($currRel)+" Subtotals:"; $posSubLabel)
		$itemRecord:=Change string:C234($itemRecord; String:C10($qtyShippedThisRel; "^^^,^^^,^^0"); $posTotCnt)
		$itemRecord:=Change string:C234($itemRecord; String:C10($qtyTotalReleased; "^^^,^^^,^^0"); $posRelAmt)
		If ($qtyShippedThisRel<$qtyTotalReleased)
			$itemRecord:=Change string:C234($itemRecord; "Partial"; $posPartial)
		End if 
		$aLine{$lineCursor}:=$itemRecord
		
		//* Now that the data is loaded we can print
		$numLines:=Size of array:C274($aLine)
		$pages:=$numLines\$linesPerPage
		If (($numLines%$linesPerPage)>0)  //partial page
			$pages:=$pages+1
		End if 
		
	Else 
		$pages:=0
	End if 
	[Customers_Bills_of_Lading:49]Num_of_Pages:19:=$pages
	$line:=1
	C_TEXT:C284($r)
	$r:=Char:C90(13)
	[Customers_Bills_of_Lading:49]PrintedText:28:=""
	For ($i; 1; $pages)
		[Customers_Bills_of_Lading:49]PrintedText:28:=[Customers_Bills_of_Lading:49]PrintedText:28+"<page id="+String:C10($i)+">"+$r
		For ($j; $line; $linesPerPage*$i)
			If ($j<=$numLines)
				[Customers_Bills_of_Lading:49]PrintedText:28:=[Customers_Bills_of_Lading:49]PrintedText:28+$aLine{$j}+$r
			Else   //put in a spacer
				[Customers_Bills_of_Lading:49]PrintedText:28:=[Customers_Bills_of_Lading:49]PrintedText:28+"."+$r
			End if 
		End for   //line
		
		[Customers_Bills_of_Lading:49]PrintedText:28:=[Customers_Bills_of_Lading:49]PrintedText:28+"</page>"+$r
		$line:=$j
	End for   //page
End if   //invoice#

