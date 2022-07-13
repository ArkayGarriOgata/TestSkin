//%attributes = {"publishedWeb":true}
//uEstRptTotal 
//                          modified 1/10/94 to add rounding and 2 dec precision o
//                          modified 2/10/94 change yield calculation
//                          mod 2/22/94 rTotal was an array, not a varible
//mod 11/30/94 upr 1132 chip
//mod 2/9/95 UPR 1132 
//4/25/95 upr 1480 chip
//• 8/6/98 cs add material percentage - howards request
// • mel (12/8/04, 11:34:13) add Prep and Additional charges, Marty's request
// • mel (5/3/05, 15:50:54) refactor and add Est_Markup

C_REAL:C285($MRh; $1; $Rh; $2; $matlCost; $3; $4; $5; $MatAdds; $CostAdds; $Temp)  //4/25/95 upr 1480 chip

$MRh:=Round:C94($1; 0)
$Rh:=Round:C94($2; 0)
$matlCost:=Round:C94($3; 0)
$MatAdds:=$5  //4/25/95 upr 1480 chip
$CostAdds:=$4  //4/25/95 upr 1480 chip

rLabor:=Round:C94([Estimates_Differentials:38]CostTtlLabor:11; 0)  //ignore & override any accumalted rLabor
rOH:=Round:C94([Estimates_Differentials:38]CostTtlOH:12; 0)
rOT:=Round:C94([Estimates_Differentials:38]Cost_Overtime:17; 0)  //estimate
rSur:=Round:C94([Estimates_Differentials:38]Cost_Scrap:15; 0)  //from estimate
rSubTotal:=rLabor+rOH+rSur+rOT
$text:=Est_Markup("init"; rSubTotal; $MatlCost; [Estimates_Differentials:38]CommissionRate:42; [Estimates_Differentials:38]MarkupMaterial:41; [Estimates_Differentials:38]MarkupConversion:40)
rTotalCost:=rSubtotal+$matlCost  //+rRD+rPR+rWH  `-rSD+rPA
//rTotalBook:=rTotalCost+[Differential]Cost_Yield_Adds+([Differential]Cost_Yield_Adds*([ESTIMATE]WhseAdjFactor/100))  `-rSD+rPA

$dots:="."*60

Print form:C5([zz_control:1]; "BlankPix8")  //blank line
t10:=""  //uEstRptTotal called by uRptEstimate
t11:="DIFFERENTIAL "+t7+"'s RECAPITULATION:"
t12:=""
t13:=""
t14:=""
t17:=""
t18:=""
Print form:C5([Estimates:17]; "Est.D6")

t11:=""
t12:=""
t13:="MATERIAL"  //"WANT"
If (rOT>0)
	t14:="LABOR + OT"  //"YIELD"
Else 
	t14:="LABOR"
End if 
t17:="BURDEN"
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15


t13:=String:C10($matlCost; "$###,###,##0")
If (rOT>0)
	t14:=String:C10(rLabor+rOT; "$###,###,##0")
Else 
	t14:=String:C10(rLabor; "$###,###,##0")
End if 
t17:=String:C10(rOH; "$###,###,##0")
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:=""
t13:=""
t14:=""
t17:=""
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="_"*40
t13:="_"*40
t14:="_"*40
t17:="_"*40
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="PRICING"
t13:="OOP"
t14:="MARK_UP"
t17:="TARGET"
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="Material @ "+String:C10(Round:C94($matlCost*100/rTotalCost; 0))+" %"+$dots
t13:=Est_Markup("materialCost")
t14:=Est_Markup("MATERIAL_MARKUP")
t17:=Est_Markup("targetMaterial")
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="Conversion"+$dots
t13:=Est_Markup("conversionCost")
t14:=Est_Markup("CONVERSION_MARKUP")
t17:=Est_Markup("targetConversion")
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="Commission @ "+Est_Markup("commissionRate")+$dots
t13:=Est_Markup("estimatedCommission")
t14:=""
t17:=Est_Markup("estimatedCommission")
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="TOTALS"+$dots
t13:=Est_Markup("totalCost")
t14:=""
t17:=Est_Markup("targetSales")
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="TARGET PRICE"+$dots
t13:=Est_Markup("targetSales")
t14:=""
t17:=""
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="Contribution"+$dots
t13:=Est_Markup("targetContribution")
t14:=Est_Markup("targetCF")
t17:=""
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="_"*40
t13:="_"*40
t14:="_"*40
t17:="_"*40
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15
t12:=""
t13:=""
t14:=""
t17:=""


Print form:C5([zz_control:1]; "BlankPix4")  //blank line
pixels:=pixels+4

Print form:C5([zz_control:1]; "BlankPix4")  //blank line
pixels:=pixels+4

t12:="                Per Thousand"+$dots
$tc:=Num:C11(Est_Markup("totalCost"))
t13:=String:C10(Round:C94(($tc*1000/iWant); 3); "$###,###,##0.000")
t14:=""  //String(Round((rTotalBook/iYield*1000);2);"$###,###,##0.00")
$tc:=Num:C11(Est_Markup("targetSales"))
t17:=String:C10(Round:C94(($tc*1000/iWant); 3); "$###,###,##0.000")
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15
t14:=""
t17:=""

Print form:C5([zz_control:1]; "BlankPix4")  //blank line
pixels:=pixels+4

If ([Estimates_Differentials:38]BreakOutSpls:18)
	t12:="_"*40
	t13:="_"*40
	t14:="_"*40
	t17:="_"*40
	Print form:C5([Estimates:17]; "Est.D5")
	t14:=""
	t17:=""
	pixels:=pixels+15
	t12:="Cost Breakout—Plates"+$dots
	rOH:=Round:C94([Estimates_Differentials:38]Cost_Plates:20; 0)
	t13:=String:C10(rOH; "$###,###,##0")
	Print form:C5([Estimates:17]; "Est.D5")
	pixels:=pixels+15
	t12:="Cost Breakout—Dies"+$dots
	rOH:=Round:C94([Estimates_Differentials:38]Cost_Dies:21; 0)
	t13:=String:C10(rOH; "$###,###,##0")
	Print form:C5([Estimates:17]; "Est.D5")
	pixels:=pixels+15
	t12:="Cost Breakout—Dupes"+$dots
	rOH:=Round:C94([Estimates_Differentials:38]Cost_Dups:19; 0)
	t13:=String:C10(rOH; "$###,###,##0")
	Print form:C5([Estimates:17]; "Est.D5")
	pixels:=pixels+15
	Print form:C5([zz_control:1]; "BlankPix4")  //blank line
	pixels:=pixels+4
End if 

t12:="_"*40
t13:="_"*40
t14:="_"*40
t17:="_"*40
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15
t12:=""
t13:=""
t14:=""
t17:=""
//If ([Differential]PrepCharges#0)  ` • mel (12/8/04, 11:34:13)
pixels:=pixels+15
t12:="••ADD-IN PREPARTORY CHARGES"+$dots
t13:=String:C10([Estimates_Differentials:38]PrepCharges:34)
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15
//End if 

//If ([Differential]AdditionalCharges#0)  ` • mel (12/8/04, 11:34:13)
//pixels:=pixels+15
//t12:="••ADD-IN ADDITIONAL CHARGES"+$dots
//t13:=String([Differential]AdditionalCharges)
//Print form([ESTIMATE];"Est.D5")
//pixels:=pixels+15
//End if 


t12:="_"*40
t13:="_"*40
t14:="_"*40
t17:="_"*40
Print form:C5([Estimates:17]; "Est.D5")
t14:=""
pixels:=pixels+15
t12:="Duration"+$dots
t13:=String:C10($MRh; "###,###,##0 Hrs MR")
t14:=String:C10($Rh; "###,###,##0 Hrs RUN")
t17:=String:C10(($MRh+$Rh); "###,###,##0 Hrs TTL")
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15

t12:="Through-put (cost)"+$dots
t13:=String:C10(Round:C94((iWant/($MRh+$Rh)); 0); "###,###,##0 C/Hr")
t14:=String:C10(Round:C94((rTotalCost/($MRh+$Rh)); 0); "###,###,##0 $/Hr")
t17:=String:C10(Round:C94((iWant/rTotalCost); 3); "###,###,##0.000 C/$")
Print form:C5([Estimates:17]; "Est.D5")
pixels:=pixels+15


