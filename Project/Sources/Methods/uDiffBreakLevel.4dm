//%attributes = {"publishedWeb":true}
//Procedure: uDiffBreakLevel ($iQty1;$iQty2;$iQty3;$iQty4;$case) 051195
//      unify the breaklevel processing on the Quote Detial report
//• 4/15/97 cs upr 1820 Quote detail report, total lines price/M 
//does not match line item price/M even when all lines are the same $/M
//• 11/13/97 cs added some var defining comments
//C_LONGINT($1;$iQty1;$2;$iQty2;$3;$iQty3;$4;$iQty4;$j;$numComments)`• 4/15/97 cs 
// • mel (12/8/04, 11:34:13) add Prep and Additional charges, Marty's request
// • mel (4/8/05, 14:51:27) don't show add'l's, such as warehousing
C_REAL:C285($1; $iQty1; $2; $iQty2; $3; $iQty3; $4; $iQty4; $j; $numComments)  //• 4/15/97 cs Long int above was truncating decimals in $ & qty
$iQty1:=$1  //• 11/13/97 cs want qty (count)
$iQty2:=$2  //yld qty
$iQty3:=$3  //Want qty value ($)
$iQty4:=$4  //`yld qty value ($)
C_TEXT:C284($5; $Diff)
$Diff:=$5
//*.            Print quantity totals   
uChk4Room(20; 30; "Est.H1")
total1:="Differential "+t5a+" Total:"
total2:=String:C10($iQty1; "###,###,##0")
total2b:=String:C10((($iQty3*1000)/$iQty1); "$###,###,##0.00;-###,###,##0.00; ")
total3:=String:C10($iQty2; "###,###,##0")
total3b:=String:C10((($iQty4*1000)/$iQty2); "$###,###,##0.00;-###,###,##0.00; ")
Print form:C5([Estimates:17]; "Quote.T1")
pixels:=pixels+20
//*.            Print price detail comments
If ([Estimates_Differentials:38]Id:1#([Estimates:17]EstimateNo:1+$Diff))
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=([Estimates:17]EstimateNo:1+$Diff))
End if 

ARRAY TEXT:C222(axText; 0)
uText2Array2([Estimates_Differentials:38]PriceDetails:29; axText; 250; "Helvetica"; 9; 0)
$numComments:=Size of array:C274(axText)
uChk4Room((27+(12*$numComments)); 60; "Est.H1"; "Quote.H3")
pixels:=pixels+27

For ($j; 1; $numComments)
	t12:=axText{$j}
	Print form:C5([Estimates:17]; "RFQ.D2")
	pixels:=pixels+12
End for 
ARRAY TEXT:C222(axText; 0)

//*.            Print Break out prices 
If ([Estimates_Differentials:38]BreakOutSpls:18)  //4/3/95 upr 1135 bring to diff level              
	ARRAY TEXT:C222(axText; 0)
	tSpl:="Plates: "+String:C10([Estimates_Differentials:38]Prc_Plates:23; "$##,##0.00")+Char:C90(13)
	tSpl:=tSpl+"Dies: "+String:C10([Estimates_Differentials:38]Prc_Dies:22; "$##,##0.00")+Char:C90(13)  //upr 1302 was showing cost
	tSpl:=tSpl+"Dupes: "+String:C10([Estimates_Differentials:38]Prc_Dups:24; "$##,##0.00")+Char:C90(13)
	tSpl:=tSpl+"Prep Charge: "+String:C10([Estimates_Differentials:38]PrepCharges:34; "$##,##0.00")+Char:C90(13)
	// • mel (4/8/05, 14:51:27) don't show add'l's, such as warehousing
	//tSpl:=tSpl+"Additional Chg: "+String([Differential]AdditionalCharges;"$##,##0.00")+Char(13)
	tSpl:=tSpl+"Repeat Prep Chg: "+String:C10([Estimates_Differentials:38]PrepRepeatCharges:36; "$##,##0.00")+Char:C90(13)
	uText2Array2(tSpl; axText; 250; "Helvetica"; 9; 0)
	$numComments:=Size of array:C274(axText)
	uChk4Room((27+(12*$numComments)); 60; "Est.H1"; "Quote.H3")
	pixels:=pixels+27
	
	For ($j; 1; $numComments)
		t12:=axText{$j}
		Print form:C5([Estimates:17]; "RFQ.D2")
		pixels:=pixels+12
	End for 
	ARRAY TEXT:C222(axText; 0)
End if   //upr 1135 
//