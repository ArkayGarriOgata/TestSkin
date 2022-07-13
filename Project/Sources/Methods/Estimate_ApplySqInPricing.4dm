//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 09/27/06, 16:05:55
// ----------------------------------------------------
// Method: Estimate_ApplySqInPricing
// ----------------------------------------------------
//this procedure takes the OVerAll Differential price
//and prorates that price down to all the cartons of the differential
//this is BOB's button.
//• 4/14/98 cs Nan checking
//C_REAL($price;$totalSqIn;$ppSqIn;$DiffQty;$ppSqInW;$WantQty;$WantSQIN)
//•110899  mlb  UPR use the cspecs alloctionpct field
//•120799  mlb  UPR allow zero price

C_REAL:C285($price; $priceYD; $allocWant; $allocYld)
C_LONGINT:C283($i)

//select target cartons? already done?
If ([Estimates_Differentials:38]OverallPrice:28>0)  //verify a total price has been entered, note: not the $total/total sqIn.  
	$price:=[Estimates_Differentials:38]OverallPrice:28
	$priceYD:=[Estimates_Differentials:38]OverallYldPrice:31
	$allocWant:=0
	$allocYld:=0
	SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]Quantity_Want:27; $aWant; [Estimates_Carton_Specs:19]Quantity_Yield:29; $aYield; [Estimates_Carton_Specs:19]AllocationPercent:58; $aWantAlloc; [Estimates_Carton_Specs:19]AllocationPrctYield:59; $aYieldAlloc)
	$numCartons:=Size of array:C274($aWant)
	ARRAY REAL:C219($aWantPrice; $numCartons)
	ARRAY REAL:C219($aYieldPrice; $numCartons)
	For ($i; 1; $numCartons)
		$allocWant:=$allocWant+$aWantAlloc{$i}
		$allocYld:=$allocYld+$aYieldAlloc{$i}
		If ($aWant{$i}>0)
			$aWantPrice{$i}:=Round:C94($price*$aWantAlloc{$i}/$aWant{$i}*1000; 2)
		Else 
			$aWantPrice{$i}:=0
		End if 
		If ($aYield{$i}>0)
			$aYieldPrice{$i}:=Round:C94($priceYD*$aYieldAlloc{$i}/$aYield{$i}*1000; 2)
		Else 
			$aYieldPrice{$i}:=0
		End if 
	End for 
	ARRAY TO SELECTION:C261($aWantPrice; [Estimates_Carton_Specs:19]PriceWant_Per_M:28; $aYieldPrice; [Estimates_Carton_Specs:19]PriceYield_PerM:30)
	
	If ($allocWant<0.99) | ($allocYld<0.99)
		uConfirm("Not fully allocated. Want at "+String:C10($allocWant*100; "##0")+" Yield at "+String:C10($allocYld*100; "##0"))
	End if 
	
	REDRAW:C174([Estimates_Carton_Specs:19])
	
Else 
	uConfirm("Set the carton prices to zero?"; "Zero"; "Cancel")  //•120799  mlb  UPR 
	If (OK=1)
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]PriceWant_Per_M:28; $aWantPrice; [Estimates_Carton_Specs:19]PriceYield_PerM:30; $aYieldPrice)
		For ($i; 1; Size of array:C274($aWantPrice))
			$aWantPrice{$i}:=0
			$aYieldPrice{$i}:=0
		End for 
		ARRAY TO SELECTION:C261($aWantPrice; [Estimates_Carton_Specs:19]PriceWant_Per_M:28; $aYieldPrice; [Estimates_Carton_Specs:19]PriceYield_PerM:30)
	End if 
End if 