//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/16/11, 16:02:52
// ----------------------------------------------------
// Method: PSG_UI_SetRowStyles
// Description:
// After making a selection, use this to fill the listbox
// Called by PS_Gluers
// ----------------------------------------------------
// RGB color picker:   http://www.psyclops.com/tools/rgb/
// Set up some colors for the big customers, used as backgrnd on rows

C_LONGINT:C283(rb1; rb2; rb3)
ARRAY TEXT:C222($aCustColor; 10)
ARRAY LONGINT:C221($aCustColorValue; 10)

$aCustColor{1}:="00199"  //png
$aCustColorValue{1}:=0x00FFDFFF

$aCustColor{2}:="00050"  //clin
$aCustColorValue{2}:=0x00E2FFDF

$aCustColor{3}:="00121"  //len
$aCustColorValue{3}:=0x00DFFFFF

$aCustColor{4}:="00074"  //earden
$aCustColorValue{4}:=0x00FFFFDF

$aCustColor{5}:="01401"  //origins
$aCustColorValue{5}:=0x00D0FFC9

$aCustColor{6}:="01547"  //intr-parfums
$aCustColorValue{6}:=0x00FFE0E0

$aCustColor{7}:="00015"  //arimas
$aCustColorValue{7}:=0x00D0FFC9

$aCustColor{8}:="01467"  //beauty bank
$aCustColorValue{8}:=0x0045A7EC

$aCustColor{9}:="01039"  //mac cosm
$aCustColorValue{9}:=0x0056CCCC

$aCustColor{10}:="01806"  //Stephen Gould
$aCustColorValue{10}:=0x00FF9999

//Arrays to format the listbox
//Bkgd is for customer color
//Style is bold for late or original
//Color is dk red for late, pinkish for original 
ARRAY LONGINT:C221(aRowStyle; 0)
ARRAY LONGINT:C221(axlRowColor; 0)
ARRAY LONGINT:C221(axlRowBkgd; 0)

ARRAY BOOLEAN:C223(aGlueListBox; 0)
ARRAY LONGINT:C221(aRecNum; 0)
//Arrays loaded from the jobit table
ARRAY TEXT:C222(aGluer; 0)
ARRAY LONGINT:C221(aPrior; 0)
ARRAY TEXT:C222(aJobit; 0)
ARRAY LONGINT:C221(aSubForm; 0)
ARRAY TEXT:C222(aCustID; 0)
ARRAY TEXT:C222(aCPN; 0)
ARRAY LONGINT:C221(aQtyPlnd; 0)
ARRAY DATE:C224(aHRD; 0)
ARRAY TEXT:C222(aOutline; 0)
ARRAY TEXT:C222(aSeparate; 0)
ARRAY TEXT:C222(aComment; 0)
ARRAY TEXT:C222(aStyle; 0)

//Arrays from fg and release tables
ARRAY TEXT:C222(aCustLine; 0)
ARRAY LONGINT:C221(aQtyReleased; 0)
ARRAY DATE:C224(aReleased; 0)

//Array from the jobmaster log
ARRAY TEXT:C222(aPrinted; 0)
ARRAY TEXT:C222(aDieCut; 0)
ARRAY PICTURE:C279(apPrinted; 0)  // Added by: Mark Zinke (8/29/13) 
ARRAY PICTURE:C279(apDieCut; 0)  // Added by: Mark Zinke (8/29/13) 

//Switch to Expediated view.
OBJECT SET ENABLED:C1123(bSort; False:C215)

SELECTION TO ARRAY:C260([Job_Forms_Items:44]; aRecNum; [Job_Forms_Items:44]Gluer:47; aGluer; [Job_Forms_Items:44]Priority:48; aPrior; [Job_Forms_Items:44]Jobit:4; aJobit; [Job_Forms_Items:44]SubFormNumber:32; aSubForm; [Job_Forms_Items:44]CustId:15; aCustID; [Job_Forms_Items:44]ProductCode:3; aCPN; [Job_Forms_Items:44]Qty_Yield:9; aQtyPlnd; [Job_Forms_Items:44]MAD:37; aHRD; [Job_Forms_Items:44]OutlineNumber:43; aOutline; [Job_Forms_Items:44]Separate:49; aSeparate; [Job_Forms_Items:44]GluerComment:50; aComment; [Job_Forms_Items:44]GlueStyle:51; aStyle)
$numJobits:=Size of array:C274(aJobit)
//consolidate subforms
SORT ARRAY:C229(aJobit; aRecNum; aGluer; aPrior; aSubForm; aCustID; aCPN; aQtyPlnd; aHRD; aOutline; aSeparate; aComment; aStyle; >)
$lastJobit:="start"
$checksum:=0

For ($i; 1; $numJobits)  //Consolidate subforms and set up hashtable for cache of related tables
	$checksum:=$checksum+aQtyPlnd{$i}
	If (aJobit{$i}=$lastJobit)
		aQtyPlnd{$i-1}:=aQtyPlnd{$i-1}+aQtyPlnd{$i}
		aQtyPlnd{$i}:=0
	Else 
		$lastJobit:=aJobit{$i}
	End if 
	
	If (<>gluer_cache_empty)  //Need to close sched and reopen to refresh the cache
		$jobform:=Substring:C12(aJobit{$i}; 1; 8)
		$hit:=Find in array:C230(aJML_jobform; $jobform)
		If ($hit=-1)
			APPEND TO ARRAY:C911(aJML_jobform; $jobform)  //Will use this next for query with array
		End if 
		
		$hit:=Find in array:C230(aCustomer; aCustID{$i})
		If ($hit=-1)
			APPEND TO ARRAY:C911(aCustomer; aCustID{$i})  //Will use this next for query with array
		End if 
		
		$fgkey:=aCustID{$i}+":"+aCPN{$i}
		$hit:=Find in array:C230(aFinishedGoodKey; $fgkey)
		If ($hit=-1)
			APPEND TO ARRAY:C911(aFinishedGoodKey; $fgkey)  //Will use this next for query with array
		End if 
	End if 
End for 

If (<>gluer_cache_empty)  //Cache the glue ready and printed data
	QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]JobForm:4; aJML_jobform)
	ARRAY TEXT:C222(aJML_jobform; 0)  //reset to match select2array
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; aJML_jobform; [Job_Forms_Master_Schedule:67]GlueReady:28; aJML_glue_ready; [Job_Forms_Master_Schedule:67]Printed:32; aJML_printed)
	SORT ARRAY:C229(aJML_jobform; aJML_glue_ready; aJML_printed; >)
	$numJML:=Size of array:C274(aJML_jobform)
	ARRAY TEXT:C222(aJML_glue_readyYN; $numJML)
	ARRAY TEXT:C222(aJML_printedYN; $numJML)
	For ($i; 1; $numJML)  //convert date to yes or blank for glue ready and printed
		If (aJML_glue_ready{$i}#!00-00-00!)
			aJML_glue_readyYN{$i}:="YES"
		Else 
			aJML_glue_readyYN{$i}:=""
		End if 
		If (aJML_printed{$i}#!00-00-00!)
			aJML_printedYN{$i}:="YES"
		Else 
			aJML_printedYN{$i}:=""
		End if 
	End for 
	
	//Cache the customer name
	QUERY WITH ARRAY:C644([Customers:16]ID:1; aCustomer)
	ARRAY TEXT:C222(aCustomer; 0)  //Reset to match select2array
	SELECTION TO ARRAY:C260([Customers:16]ID:1; aCustomer; [Customers:16]Name:2; aCustomerName)
	SORT ARRAY:C229(aCustomer; aCustomerName; >)
	
	//Cache the fg data
	QUERY WITH ARRAY:C644([Finished_Goods:26]FG_KEY:47; aFinishedGoodKey)
	ARRAY TEXT:C222(aFinishedGoodKey; 0)  //Reset to match select2array
	SELECTION TO ARRAY:C260([Finished_Goods:26]FG_KEY:47; aFinishedGoodKey; [Finished_Goods:26]GlueType:34; aFinishedGoodGlueType; [Finished_Goods:26]Line_Brand:15; aFinishedGoodLine; [Finished_Goods:26]OriginalOrRepeat:71; aFinishedGoodOR; [Finished_Goods:26]Gluer_NextRelease:112; aFinishedGoodNextRel; [Finished_Goods:26]Gluer_ReleaseQty:113; aFinishedGoodNextQty)
	SORT ARRAY:C229(aFinishedGoodKey; aFinishedGoodGlueType; aFinishedGoodLine; aFinishedGoodOR; aFinishedGoodNextRel; aFinishedGoodNextQty; >)
	<>gluer_cache_empty:=False:C215
End if 

//Get the zeros to the bottom of the array to remove the now un-needed subform tuple
SORT ARRAY:C229(aQtyPlnd; aJobit; aRecNum; aGluer; aPrior; aSubForm; aCustID; aCPN; aHRD; aOutline; aSeparate; aComment; aStyle; <)
//$hit:=Find in array(aQtyPlnd;0)
//If ($hit>-1)
//ARRAY BOOLEAN(aGlueListBox;$hit-1)
//ARRAY LONGINT(aRecNum;$hit-1)
//ARRAY TEXT(aGluer;$hit-1)
//ARRAY LONGINT(aPrior;$hit-1)
//ARRAY TEXT(aJobit;$hit-1)
//ARRAY LONGINT(aSubForm;$hit-1)
//ARRAY TEXT(aCustID;$hit-1)
//ARRAY TEXT(aCPN;$hit-1)
//ARRAY LONGINT(aQtyPlnd;$hit-1)
//ARRAY DATE(aHRD;$hit-1)
//ARRAY TEXT(aOutline;$hit-1)
//ARRAY TEXT(aSeparate;$hit-1)
//ARRAY TEXT(aComment;$hit-1)
//ARRAY TEXT(aStyle;$hit-1)

$numJobits:=Size of array:C274(aJobit)
//$checksum2:=0
//For ($i;1;$numJobits)  //Check if consolidated subforms has same qty as before consolidating
//$checksum2:=$checksum2+aQtyPlnd{$i}
//End for 
//
//If ($checksum2#$checksum)
//  //uConfirm ("Problem consolidating subforms")
//Else 
//  //zwStatusMsg ("PS_Gluers";"Qty Checksum OK.")
//End if 
//End if 

//populate arrays with the related data
ARRAY TEXT:C222(aCustLine; $numJobits)
ARRAY LONGINT:C221(aQtyReleased; $numJobits)
ARRAY DATE:C224(aReleased; $numJobits)
ARRAY TEXT:C222(aPrinted; $numJobits)
ARRAY TEXT:C222(aDieCut; $numJobits)
ARRAY PICTURE:C279(apPrinted; $numJobits)  // Added by: Mark Zinke (8/29/13) 
ARRAY PICTURE:C279(apDieCut; $numJobits)  // Added by: Mark Zinke (8/29/13) 
ARRAY LONGINT:C221(aRowStyle; $numJobits)
ARRAY LONGINT:C221(axlRowColor; $numJobits)
ARRAY LONGINT:C221(axlRowBkgd; $numJobits)

For ($i; 1; $numJobits)
	//Set base row color based on customer
	$hit:=Find in array:C230($aCustColor; aCustID{$i})
	If ($hit>-1)
		axlRowBkgd{$i}:=$aCustColorValue{$hit}
	Else 
		axlRowBkgd{$i}:=0x00FFFFF0  //ivory
	End if 
	
	//Get custname prefix
	$hit:=Find in array:C230(aCustomer; aCustID{$i})
	If ($hit>-1)
		$cust_name:=Substring:C12(aCustomerName{$hit}; 1; 4)
	Else 
		$cust_name:="n/f_"
	End if 
	
	//Get fg rec data
	$fgkey:=aCustID{$i}+":"+aCPN{$i}
	$hit:=Find in array:C230(aFinishedGoodKey; $fgkey)
	If ($hit>-1)
		If (Length:C16(aStyle{$i})=0)  //not already set
			aStyle{$i}:=aFinishedGoodGlueType{$hit}
		End if 
		aCustLine{$i}:=$cust_name+"-"+aFinishedGoodLine{$hit}
		If (aFinishedGoodOR{$hit}="Original")
			aRowStyle{$i}:=Bold:K14:2
			axlRowColor{$i}:=0x00FF00FF
		End if 
		aReleased{$i}:=JMI_getNextReleaseDate(aCPN{$i}; 1)  // Modified by: Mark Zinke (11/6/13)   //aFinishedGoodNextRel{$hit}
		If (aReleased{$i}=!00-00-00!)
			aReleased{$i}:=<>MAGIC_DATE  //Move way out so they don't screw up the sorting
		End if 
		If (aReleased{$i}<Current date:C33)
			aRowStyle{$i}:=Bold:K14:2
			axlRowColor{$i}:=0x00880000
		End if 
		aQtyReleased{$i}:=aFinishedGoodNextQty{$hit}
		
	Else 
		If (Length:C16(aStyle{$i})=0)  //Not already set
			aStyle{$i}:="n/f"
		End if 
		aCustLine{$i}:=$cust_name+"n/f"
		aReleased{$i}:=<>MAGIC_DATE  //Move way out so they don't screw up the sorting
		aQtyReleased{$i}:=0
	End if 
	
	If (aHRD{$i}=!00-00-00!)
		aHRD{$i}:=<>MAGIC_DATE  //Move way out so they don't screw up the sorting
	End if 
	
	If (Length:C16(aSeparate{$i})=0)  //not yet determined
		//look to see if other items are on the same form
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numOthers)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=Substring:C12(aJobit{$i}; 1; 8); *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3#aCPN{$i})
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		If ($numOthers>0)
			aSeparate{$i}:="YES"
		End if 
	End if 
	
	$jobform:=Substring:C12(aJobit{$i}; 1; 8)
	$hit:=Find in array:C230(aJML_jobform; $jobform)
	If ($hit>-1)
		aPrinted{$i}:=aJML_printedYN{$hit}
		aDieCut{$i}:=aJML_glue_readyYN{$hit}
	Else 
		aPrinted{$i}:="n/f"
		aDieCut{$i}:="n/f"
	End if 
	
	If (aPrinted{$i}="Yes")
		apPrinted{$i}:=pPrintPic
	Else 
		apPrinted{$i}:=pDieCutPic
	End if 
	If (aDieCut{$i}="Yes")
		apDieCut{$i}:=pPrintPic
	Else 
		apDieCut{$i}:=pDieCutPic
	End if 
	
End for 

//Now apply the radio box controlled filters for what to display
//Case of 
//: (rb1=1)  //Unfiltered
//$hit:=-1
//  //zwStatusMsg ("PS_Gluers";"Applying ALL filter")
//
//: (rb2=1)  //Filter to only show if diecut
//  //zwStatusMsg ("PS_Gluers";"Applying DIE-CUT filter")
//SORT ARRAY(aDieCut;apPrinted;apDieCut;aReleased;aJobit;aRecNum;aCustLine;aGluer;aPrior;aSubForm;aCustID;aCPN;aQtyPlnd;aHRD;aOutline;aQtyReleased;aStyle;aSeparate;aPrinted;aComment;aRowStyle;axlRowColor;axlRowBkgd;<)
//$hit:=Find in array(aDieCut;"")  //find the first blank and set the hit cursor
//
//: (rb3=1)  //Filter to only show if printed
//  //zwStatusMsg ("PS_Gluers";"Applying PRINTED filter")
//SORT ARRAY(aPrinted;apPrinted;apDieCut;aReleased;aJobit;aRecNum;aCustLine;aGluer;aPrior;aSubForm;aCustID;aCPN;aQtyPlnd;aHRD;aOutline;aQtyReleased;aStyle;aSeparate;aDieCut;aComment;aRowStyle;axlRowColor;axlRowBkgd;<)
//$hit:=Find in array(aPrinted;"")  //find the first blank and set the hit cursor
//
//End case 

//If ($hit>-1)  //Cursor has been set, so truncate the arrays
//ARRAY BOOLEAN(aGlueListBox;$hit-1)
//ARRAY LONGINT(aRecNum;$hit-1)
//ARRAY TEXT(aGluer;$hit-1)
//ARRAY LONGINT(aPrior;$hit-1)
//ARRAY TEXT(aJobit;$hit-1)
//ARRAY LONGINT(aSubForm;$hit-1)
//ARRAY TEXT(aCustID;$hit-1)
//ARRAY TEXT(aCPN;$hit-1)
//ARRAY LONGINT(aQtyPlnd;$hit-1)
//ARRAY DATE(aHRD;$hit-1)
//ARRAY TEXT(aOutline;$hit-1)
//ARRAY TEXT(aComment;$hit-1)
//ARRAY TEXT(aStyle;$hit-1)
//
//ARRAY TEXT(aCustLine;$hit-1)
//ARRAY LONGINT(aQtyReleased;$hit-1)
//ARRAY DATE(aReleased;$hit-1)
//ARRAY TEXT(aSeparate;$hit-1)
//ARRAY TEXT(aPrinted;$hit-1)
//ARRAY TEXT(aDieCut;$hit-1)
//ARRAY PICTURE(apPrinted;$hit-1)  // Added by: Mark Zinke (8/29/13) 
//ARRAY PICTURE(apDieCut;$hit-1)  // Added by: Mark Zinke (8/29/13) 
//
//ARRAY LONGINT(aRowStyle;$hit-1)
//ARRAY LONGINT(axlRowColor;$hit-1)
//ARRAY LONGINT(axlRowBkgd;$hit-1)
//End if 

numRecs:=Size of array:C274(aJobit)
MULTI SORT ARRAY:C718(aPrior; >; aJobit; >; aRecNum; aCustLine; aGluer; aReleased; aSubForm; aCustID; aCPN; aQtyPlnd; aHRD; aOutline; aQtyReleased; aStyle; aSeparate; aPrinted; aDieCut; apPrinted; apDieCut; aComment; aRowStyle; axlRowColor; axlRowBkgd)