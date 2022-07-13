// Method: Object Method: bCalc () -> 
// ----------------------------------------------------
// by: mel: 04/01/05, 14:49:06
// ----------------------------------------------------
// Updates:
// • mel (4/8/05, 14:49:18) don't show costs in price text
// ----------------------------------------------------

C_REAL:C285($cost; $price)
If ([Estimates_Differentials:38]PVtoolingIncluded:37=0)
	[Estimates_Differentials:38]PVtoolingIncluded:37:=0.4
	uConfirm("'PV ToolingIncluded' was 0, 0.40 being used."; "OK"; "Help")
End if 

If ([Estimates_Differentials:38]PVtoolingSeparate:38=0)
	[Estimates_Differentials:38]PVtoolingSeparate:38:=0.4
	uConfirm("'PV ToolingSeparate' was 0, 0.40 being used."; "OK"; "Help")
End if 

$cost:=Round:C94([Estimates_Differentials:38]CostTTL:14-([Estimates_Differentials:38]Cost_Dies:21+[Estimates_Differentials:38]Cost_Dups:19+[Estimates_Differentials:38]Cost_Plates:20); 0)
$price_separate:=Round:C94(fProfitVariable("price"; $cost; 0; [Estimates_Differentials:38]PVtoolingSeparate:38); 2)
$separate:="A price of $"+String:C10(Round:C94($price_separate; 0); "##,###,###")+" on omitting tooling results in a "+String:C10([Estimates_Differentials:38]PVtoolingSeparate:38*100)+" PV."
$cost:=Round:C94(([Estimates_Differentials:38]CostTTL:14+[Estimates_Differentials:38]Cost_Yield_Adds:30)-([Estimates_Differentials:38]Cost_Dies:21+[Estimates_Differentials:38]Cost_Dups:19+[Estimates_Differentials:38]Cost_Plates:20); 0)
$price_separate_yield:=Round:C94(fProfitVariable("price"; $cost; 0; [Estimates_Differentials:38]PVtoolingSeparate:38); 2)

$cost:=Round:C94([Estimates_Differentials:38]CostTTL:14; 0)
$price_included:=Round:C94(fProfitVariable("price"; $cost; 0; [Estimates_Differentials:38]PVtoolingIncluded:37); 2)
$included:="A price of $"+String:C10(Round:C94($price_included; 0); "##,###,###")+" on including tooling results in a "+String:C10([Estimates_Differentials:38]PVtoolingIncluded:37*100)+" PV."
$cost:=Round:C94(([Estimates_Differentials:38]CostTTL:14+[Estimates_Differentials:38]Cost_Yield_Adds:30); 0)
$price_included_yield:=Round:C94(fProfitVariable("price"; $cost; 0; [Estimates_Differentials:38]PVtoolingIncluded:37); 2)

uConfirm("Included("+String:C10([Estimates_Differentials:38]PVtoolingIncluded:37; "0.00")+"PV)="+String:C10($price_included)+Char:C90(13)+"Separate("+String:C10([Estimates_Differentials:38]PVtoolingSeparate:38; "0.00")+"PV)="+String:C10($price_separate); "Included"; "Separate")
If (ok=1)
	[Estimates_Differentials:38]PriceDetails:29:=$included  //+Char(13)+[Estimates_Differentials]PriceDetails
	[Estimates_Differentials:38]OverallPrice:28:=$price_included
	[Estimates_Differentials:38]OverallYldPrice:31:=$price_included_yield
Else 
	[Estimates_Differentials:38]PriceDetails:29:=$separate
	[Estimates_Differentials:38]OverallPrice:28:=$price_separate
	[Estimates_Differentials:38]OverallYldPrice:31:=$price_separate_yield
End if 

uConfirm("Apply Square Inch pricing to the items now?"; "Price"; "Later")
If (ok=1)
	Estimate_ApplySqInPricing
End if 