//%attributes = {"publishedWeb":true}
//(p) MkSumTrans (Jobit;transType)
//sum and return the amount of material scrapped for this product
//$1 - longint index in to transaction arrrays
//$2 - string -CPN to look for
//returns - Real - number of items scrapped
//• 1/14/98 cs created
//• 6/18/98 cs found that this routine missed some scraps - fixed - changed 
//  array examination routine - to check JF & then cycle until CPN found
//• 8/20/98 cs invert sign on Adjustments NOT scraps
//•091098  MLB  rewrite, switch to jobit instead of cpn

C_LONGINT:C283($hit)
C_REAL:C285($Sum; $0)
C_TEXT:C284($typeWanted; $2; $1; $jobit)

$jobit:=$1
$typeWanted:=$2
$sum:=0
$hit:=Find in array:C230(aTranJobit; $jobit)
While ($hit>-1)
	If (aTranType{$hit}=$typeWanted)
		$Sum:=$Sum+aTranQty{$hit}
	End if 
	$hit:=Find in array:C230(aTranJobit; $jobit; $hit+1)
End while 

If ($typeWanted="Scrap")
	$sum:=$sum*-1
End if 

$0:=$sum