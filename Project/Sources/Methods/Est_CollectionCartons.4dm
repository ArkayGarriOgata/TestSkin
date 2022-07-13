//%attributes = {"publishedWeb":true}
//PM:  Est_CollectionCartons  092199  mlb
//manage the carton arrays

C_REAL:C285($0; $4; TotalSqIn; $wantQty; TotalSqInYD)
C_TEXT:C284($1; $2)
C_LONGINT:C283($hit)
C_POINTER:C301($5)

Case of 
	: ($1="Load")
		If (Count parameters:C259>1)
			$estimate:=$2
			$differential:=$3
		Else 
			$estimate:=[Estimates:17]EstimateNo:1
			$differential:=[Estimates_Differentials:38]diffNum:3
		End if 
		
		READ WRITE:C146([Estimates_Carton_Specs:19])
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate; *)  //find Estimate Qty worksheet
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=$differential)
		ARRAY TEXT:C222(aCartonSpec; 0)
		ARRAY REAL:C219(aSqIn; 0)
		ARRAY LONGINT:C221(aCustWntQty; 0)
		ARRAY TEXT:C222(aItemNumber; 0)
		ARRAY REAL:C219(aAllocPct; 0)
		ARRAY REAL:C219(aAllocPctYld; 0)
		ARRAY LONGINT:C221(aYieldQty; 0)
		SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]CartonSpecKey:7; aCartonSpec; [Estimates_Carton_Specs:19]SquareInches:16; aSqIn; [Estimates_Carton_Specs:19]Quantity_Want:27; aCustWntQty; [Estimates_Carton_Specs:19]Item:1; aItemNumber; [Estimates_Carton_Specs:19]AllocationPrctYield:59; aAllocPctYld; [Estimates_Carton_Specs:19]Quantity_Yield:29; aYieldQty; [Estimates_Carton_Specs:19]AllocationPercent:58; aAllocPct)
		$0:=Size of array:C274(aCartonSpec)
		COPY NAMED SELECTION:C331([Estimates_Carton_Specs:19]; "CartonSpecRecords")
		
	: ($1="SquareInches")
		$hit:=Find in array:C230(aCartonSpec; $2)
		If ($hit>-1)  //is it on the order?
			If (aSqIn{$hit}>0)  //manditory for this calculation
				If (aCustWntQty{$hit}>0)  //upr 1250 don't include fill-ins  
					$0:=aSqIn{$hit}
				Else 
					$0:=0
				End if   //not fillin
			Else 
				$0:=-1
			End if   //sqin 
		Else 
			$0:=0
		End if 
		
	: ($1="Set")
		Case of 
			: ($2="AllocPct")
				$hit:=Find in array:C230(aCartonSpec; $3)
				If ($hit>-1)
					If (aCustWntQty{$hit}#0)  //not fillin            
						aCustWntQty{$hit}:=$4
						If (TotalSqIn>0)
							aAllocPct{$hit}:=(aSqIn{$hit}*aCustWntQty{$hit})/TotalSqIn
						Else 
							aAllocPct{$hit}:=0
						End if 
					Else 
						If (TotalSqIn>0)
							aAllocPct{$hit}:=(aSqIn{$hit}*$4)/TotalSqIn
						Else 
							aAllocPct{$hit}:=0
						End if 
					End if 
				End if 
				$0:=$hit
				
			: ($2="AllocPctYld")
				//TRACE
				$hit:=Find in array:C230(aCartonSpec; $3)
				If ($hit>-1)
					If (aCustWntQty{$hit}#0)  //not fillin            
						aYieldQty{$hit}:=$4
						If (TotalSqInYD>0)
							aAllocPctYld{$hit}:=(aSqIn{$hit}*$4)/TotalSqInYD
						Else 
							aAllocPctYld{$hit}:=0
						End if 
					Else 
						If (TotalSqInYD>0)
							aAllocPctYld{$hit}:=(aSqIn{$hit}*$4)/TotalSqInYD
						Else 
							aAllocPctYld{$hit}:=0
						End if 
					End if 
				End if 
				$0:=$hit
				
			: ($2="TotalSqIn")
				TotalSqIn:=$4
				$0:=0
				
			: ($2="TotalSqInYld")
				TotalSqInYD:=$4
				$0:=0
		End case 
		
	: ($1="Store")
		USE NAMED SELECTION:C332("CartonSpecRecords")
		Case of 
			: ($2="AllocPct")
				ARRAY TO SELECTION:C261(aAllocPct; [Estimates_Carton_Specs:19]AllocationPercent:58; aCustWntQty; [Estimates_Carton_Specs:19]Quantity_Want:27; aCustWntQty; [Estimates_Carton_Specs:19]Qty1Temp:52; aAllocPctYld; [Estimates_Carton_Specs:19]AllocationPrctYield:59; aYieldQty; [Estimates_Carton_Specs:19]Quantity_Yield:29; aYieldQty; [Estimates_Carton_Specs:19]Qty2Temp:53)
				UNLOAD RECORD:C212([Estimates_Carton_Specs:19])
				$0:=Records in selection:C76([Estimates_Carton_Specs:19])
				
			: ($2="Cost")
				ARRAY REAL:C219($aDollarsPerM; Size of array:C274(aCartonSpec))
				For ($hit; 1; Size of array:C274(aCartonSpec))
					If (aCustWntQty{$hit}>0)
						$aDollarsPerM{$hit}:=Round:C94(((aAllocPct{$hit}*$4)/aCustWntQty{$hit})*1000; 2)
					Else 
						$aDollarsPerM{$hit}:=0
					End if 
				End for 
				ARRAY TO SELECTION:C261($aDollarsPerM; $5->)
		End case 
		
	: ($1="Clear")
		ARRAY TEXT:C222(aCartonSpec; 0)
		ARRAY REAL:C219(aSqIn; 0)
		ARRAY LONGINT:C221(aCustWntQty; 0)
		ARRAY TEXT:C222(aItemNumber; 0)
		ARRAY REAL:C219(aAllocPct; 0)
		ARRAY REAL:C219(aAllocPctYld; 0)
		ARRAY LONGINT:C221(aYieldQty; 0)
		$0:=Size of array:C274(aCartonSpec)
		CLEAR NAMED SELECTION:C333("CartonSpecRecords")
End case 