//%attributes = {"publishedWeb":true}
//fCalcComm07($stdCost)
//•072696  MLB 
//• 4/9/98 cs nan checking/removal

$stdCost:=$1

If ([Estimates_Materials:29]Real1:14=0)
	[Estimates_Materials:29]Real1:14:=100
End if 
[Estimates_Materials:29]Qty:9:=1
[Estimates_Materials:29]Cost:11:=uNANCheck([Estimates_Materials:29]Qty:9*$stdCost*([Estimates_Materials:29]Real1:14/100))
[Estimates_Materials:29]CalcDetails:24:=" Percent consumption: "+String:C10([Estimates_Materials:29]Real1:14)+"% of 1 cutting die"
[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24