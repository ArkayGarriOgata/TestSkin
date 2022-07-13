//%attributes = {"publishedWeb":true}
//Procedure: excess:=uAgeDemand($lastCPN;$qtyAccum;$numCusts)  031496  MLB
//this is called only by rRptCustAgeInv3
//and operates on global arrays, sorry for the kluge
//• 1/20/97 -cs- modifed procedure removing all refrences to 
//  orderline reecords and replaceing them with array reeferences
//  the array are filled in the previous procedure call (rRptCUstAgeInv3)
//  following is a legend for the arrays used inplace of orderline feilds:

// [OrderLines]ProductCode -> aCPN 
// [OrderLines]CustID -> aCustID 
// [OrderLines]DateOpened -> aDate 
// [OrderLines]Qty_Open -> aQty 
// [OrderLines]Quantity -> aQty2 
// [OrderLines]OverRun -> aPoQty 
// [OrderLines]Price_Per_M -> aPoPrice
C_TEXT:C284($1; $lastCPN)
$lastCPN:=$1
C_LONGINT:C283($orders; $bucket; $openDemand; $qtyAccum; $2; $numCusts; $3)
$qtyAccum:=$2
$numCusts:=$3

//• 1/20/97 -cs- removed for attempted speed increase

//USE SET("opens")
//SEARCH SELECTION([OrderLines];[OrderLines]ProductCode=Substring($lastCPN;7
//«);*)
//SEARCH SELECTION([OrderLines]; & [OrderLines]CustID=Substring($lastCPN;1;5
//«))  `•031496  MLB add cust id
//$orders:=Records in selection([OrderLines])

//end removal
$Orders:=Find in array:C230(aCPN; Substring:C12($lastCPN; 7))  //•1/20/97 locate product in array

//• 1/20/97 speed mods
If ($Orders>0)  //validate index before accessing array
	If (aCustId{$Orders}#Substring:C12($lastCPN; 1; 5))  //•1/20/97 test that cust id matches
		$Orders:=-1  //if id does not match - this is excess
	End if 
End if 
//end speed mods

If ($orders>0)
	
	//SORT SELECTION([OrderLines];[OrderLines]DateOpened;<)  `fill the newest
	//« demand first?  
	
	//   For ($j;1;$orders)`•1/20/97 removed for speed increase
	//*       Consume and price the orderlines
	
	//•1/20/97 -cs- speed increease mods
	//  all references to [orderlines] have been replaced
	//  with references to the arrays of the orderline field values    
	
	$LineCount:=0
	While ($Orders>0)  //while there is data for this customer/cpn continue
		$LineCount:=$LineCount+1  //increment line counter
		$openDemand:=aQty{$Orders}+(aQty2{$Orders}*(aPoQty{$Orders}/100))  //add the %overrun in 
		If ($qtyAccum<=$openDemand)  //all goes in to that bucket
			$bucket:=$qtyAccum
		Else 
			$bucket:=$openDemand
		End if 
		
		Case of 
			: (aDate{$Orders}>=Under03)
				aL0{$numCusts}:=aL0{$numCusts}+$bucket
				rGroup0{$numCusts}:=rGroup0{$numCusts}+Round:C94((($bucket/1000)*aPoPrice{$Orders}); 0)
				
			: (aDate{$Orders}>=Under06)
				aL1{$numCusts}:=aL1{$numCusts}+$bucket
				rGroup1{$numCusts}:=rGroup1{$numCusts}+Round:C94((($bucket/1000)*aPoPrice{$Orders}); 0)
				
			: (aDate{$Orders}>=Under09)
				aL2{$numCusts}:=aL2{$numCusts}+$bucket
				rGroup2{$numCusts}:=rGroup2{$numCusts}+Round:C94((($bucket/1000)*aPoPrice{$Orders}); 0)
				
			: (aDate{$Orders}>=Under12)
				aL3{$numCusts}:=aL3{$numCusts}+$bucket  //•031496  MLB was:$qtyAccum
				rGroup3{$numCusts}:=rGroup3{$numCusts}+Round:C94((($bucket/1000)*aPoPrice{$Orders}); 0)
				
			Else 
				aL4{$numCusts}:=aL4{$numCusts}+$bucket
				rGroup4{$numCusts}:=rGroup4{$numCusts}+Round:C94((($bucket/1000)*aPoPrice{$Orders}); 0)
		End case 
		
		$qtyAccum:=$qtyAccum-$bucket
		
		If ($qtyAccum<=0)
			//  $j:=$j+$orders  `break
			$Orders:=0
		Else 
			$Orders:=Find in array:C230(aCPN; Substring:C12($lastCPN; 7); $Orders+1)  //•1/20/97 locate NEXT product in array,(should be $orders + 1)
			If ($orders>0)
				If (aCustId{$Orders}#Substring:C12($lastCPN; 1; 5))  //•1/20/97 test that cust id matches      
					$Orders:=0
				End if 
			End if 
			//  NEXT RECORD([OrderLines])
		End if 
	End while 
	//   End for   `each ordelrine
	
	//end replacements
	
	//*       Tally the excess      
	If ($qtyAccum>0)
		aL5{$numCusts}:=aL5{$numCusts}+$qtyAccum
	End if 
	
Else   //all excess stock
	If ($qtyAccum>0)
		aL5{$numCusts}:=aL5{$numCusts}+$qtyAccum
	End if 
End if   //there are open orders
//