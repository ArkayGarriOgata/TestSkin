//%attributes = {}
// Method: Est_Markup ("msg";conversionCost;materialCost;commissionRate) -> 
// ----------------------------------------------------
// by: mel: 05/02/05, 16:09:16
// ----------------------------------------------------
// Description:
// create an structure of bens mark-up
//and rtn text for the c&q (rRptEstimate) report
//commission different than fSalesCommission
// ----------------------------------------------------

C_TEXT:C284($1)
C_REAL:C285(CONVERSION_MARKUP; MATERIAL_MARKUP)
C_REAL:C285(conversionCost; $2; materialCost; $3; commissionRate; $4; targetConversion; targetMaterial; targetTotal; targetContribution)
C_TEXT:C284($0; $format; $fraction)

$format:="##,###,##0 ;(#,###,##0);  ~ "
$fraction:="#,##0.000;-#,##0.000;  ~"

Case of 
	: ($1="init")
		CONVERSION_MARKUP:=$6
		If (CONVERSION_MARKUP=0)
			CONVERSION_MARKUP:=1.49071
		End if 
		MATERIAL_MARKUP:=$5
		If (MATERIAL_MARKUP=0)
			MATERIAL_MARKUP:=0.1
		End if 
		commissionRate:=$4
		conversionCost:=$2
		targetConversion:=Round:C94(conversionCost*(1+CONVERSION_MARKUP); 0)
		materialCost:=$3
		targetMaterial:=Round:C94(materialCost*(1+MATERIAL_MARKUP); 0)
		targetSales:=targetConversion+targetMaterial
		estimatedCommission:=Round:C94(targetSales*commissionRate; 0)
		targetSales:=targetSales+estimatedCommission
		targetContribution:=targetSales-(conversionCost+materialCost+estimatedCommission)
		targetCF:=Round:C94(targetContribution/targetSales; 3)
		$0:=""
		
	: ($1="printTabbed")
		$t:=Char:C90(9)
		$r:=Char:C90(13)
		
		$0:=""+$t+"OOP"+$t+"MARK_UP"+$t+"TARGET"+$r
		$0:=$0+"Material"+$t+String:C10(materialCost)+$t+String:C10(MATERIAL_MARKUP)+$t+String:C10(targetMaterial)+$r
		$0:=$0+"Conversion"+$t+String:C10(conversionCost)+$t+String:C10(CONVERSION_MARKUP)+$t+String:C10(targetConversion)+$r
		$0:=$0+"Comm "+String:C10(commissionRate*100)+"%"+$t+String:C10(estimatedCommission)+$t+""+$t+String:C10(estimatedCommission)+$r
		$0:=$0+"TOTALS"+$t+String:C10(materialCost+conversionCost+estimatedCommission)+$t+""+$t+String:C10(targetMaterial+targetConversion+estimatedCommission)+$r+$r
		
		$0:=$0+"TARGET PRICE"+$t+String:C10(targetSales)+$r
		$0:=$0+"Contribution"+$t+String:C10(targetContribution)+$t+String:C10(targetCF)+$r
		
	: ($1="materialCost")
		$0:=String:C10(materialCost; $format)
	: ($1="conversionCost")
		$0:=String:C10(conversionCost; $format)
	: ($1="targetMaterial")
		$0:=String:C10(targetMaterial; $format)
	: ($1="targetConversion")
		$0:=String:C10(targetConversion; $format)
	: ($1="targetSales")
		$0:=String:C10(targetSales; $format)
	: ($1="commissionRate")
		$0:=String:C10(commissionRate; $fraction)
	: ($1="estimatedCommission")
		$0:=String:C10(estimatedCommission; $format)
	: ($1="targetContribution")
		$0:=String:C10(targetContribution; $format)
	: ($1="targetCF")
		$0:=String:C10(targetCF; $fraction)
	: ($1="MATERIAL_MARKUP")
		$0:=String:C10(MATERIAL_MARKUP; $fraction)
	: ($1="CONVERSION_MARKUP")
		$0:=String:C10(CONVERSION_MARKUP; $fraction)
	: ($1="totalCost")
		$0:=String:C10(conversionCost+materialCost+estimatedCommission; $format)
End case 