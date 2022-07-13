//%attributes = {"publishedWeb":true}
//fCalcComm05($subGroup;$grossSheets;$stdCost;$stdUM;$Flex2;$Flex3;$Flex4)
//• 4/9/98 cs nan checking/removal

C_LONGINT:C283($x; $pullPerRoll; $rowsPerMstr; $numImpress)

$subGroup:=$1
$grossSheets:=$2
$stdUM:=$4
$Flex4:=$7

If (Position:C15("Special"; $subGroup)#0)
	$x:=Position:C15("x"; [Estimates_Materials:29]alpha20_3:19)
	$Flex2:=Num:C11(Substring:C12([Estimates_Materials:29]alpha20_3:19; 1; ($x-1)))
	$Flex3:=Num:C11(Substring:C12([Estimates_Materials:29]alpha20_3:19; ($x+1)))
	$stdCost:=Num:C11([Estimates_Materials:29]alpha20_2:18)
	[Estimates_Materials:29]Comments:13:="••SPL••: "+String:C10($stdCost; "$###,##0.00##")+"/"+$stdUM+<>sCR
Else 
	$Flex2:=$5
	$Flex3:=$6
	$stdCost:=$3
End if 
$numImpress:=uNANCheck(Round:C94($grossSheets/([Estimates_Materials:29]Real1:14+1); 0))  //       denom=number of steps
$pullPerRoll:=uNANCheck(Int:C8(($Flex2*12)/[Estimates_Materials:29]Real4:17))  //                  denom=pull length & 12000 linear inches per master roll
$rowsPerMstr:=uNANCheck(Int:C8($Flex3/[Estimates_Materials:29]Real3:16))  //                            24" width/master roll by total width req'd
$partial:=uNANCheck((($numImpress/$pullPerRoll)*$Flex4)/$rowsPerMstr)
[Estimates_Materials:29]Qty:9:=Int:C8($partial)  //mantissa
If ((Round:C94($partial; 4)-[Estimates_Materials:29]Qty:9)>Round:C94(0; 4))
	[Estimates_Materials:29]Qty:9:=[Estimates_Materials:29]Qty:9+1  //round up
End if 

[Estimates_Materials:29]Cost:11:=uNANCheck([Estimates_Materials:29]Qty:9*$stdCost)
[Estimates_Materials:29]CalcDetails:24:=String:C10($numImpress)+" Impressions  "+String:C10($pullPerRoll)+" Pull/Roll  "+String:C10($rowsPerMstr)+" Rows/Master"
[Estimates_Materials:29]WorkDetails:25:=String:C10($grossSheets)+" Gross Sheets  "+String:C10([Estimates_Materials:29]Real4:17)+" Pull length  "+String:C10([Estimates_Materials:29]Real3:16)+" Rows width"