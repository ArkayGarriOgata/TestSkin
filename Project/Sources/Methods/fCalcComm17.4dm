//%attributes = {"publishedWeb":true}
//fCalcComm17 ($thisUM;$Flex2;$grossWin;$Flex3;$stdCost;$yldWin)
//• 4/9/98 cs nan checking/removal

C_LONGINT:C283($0)
C_TEXT:C284($thisUM; $1)
C_LONGINT:C283($grossWin; $3; $yldWin; $6)
C_REAL:C285($2; $Flex3; $4; $stdCost; $5; $tempQty)

$thisUM:=$1
$Flex2:=$2
$grossWin:=$3
$Flex3:=$4
$stdCost:=$5
$yldWin:=$6

Case of 
	: ($thisUM="LB")  //the old way
		[Estimates_Materials:29]Qty:9:=uNANCheck([Estimates_Materials:29]Real1:14*[Estimates_Materials:29]Real2:15*$Flex2*$grossWin/$Flex3)
		[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$stdCost
		[Estimates_Materials:29]CalcDetails:24:="Patch: "+String:C10([Estimates_Materials:29]Real1:14; "###,##0")+"'' x "+String:C10([Estimates_Materials:29]Real2:15; "###,##0")+"''"
		[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24
		If ($yldWin>0)
			If ($yldWin#$grossWin)
				$tempQty:=uNANCheck([Estimates_Materials:29]Real1:14*[Estimates_Materials:29]Real2:15*$Flex2*($yldWin-$grossWin)/$Flex3)
				[Estimates_Materials:29]Matl_YieldAdds:26:=uNANCheck($tempQty*$stdCost)
				[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+" Yield adds "+String:C10($tempQty; "###,##0")+" units."
			End if 
		End if 
		
	: ($thisUM="LF")
		[Estimates_Materials:29]Qty:9:=uNANCheck([Estimates_Materials:29]Real2:15/12*$Flex2*$grossWin*$Flex3)  //linear feet*waste*#windowed*linearFtperPound
		[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$stdCost
		[Estimates_Materials:29]CalcDetails:24:="Patch: "+String:C10([Estimates_Materials:29]Real1:14; "###,##0")+"'' x "+String:C10([Estimates_Materials:29]Real2:15; "###,##0")+"''"
		[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24
		If ($yldWin>0)
			If ($yldWin#$grossWin)
				$tempQty:=[Estimates_Materials:29]Real2:15*12*$Flex2*($yldWin-$grossWin)*$Flex3
				[Estimates_Materials:29]Matl_YieldAdds:26:=$tempQty*$stdCost
				[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+" Yield adds "+String:C10($tempQty; "###,##0")+" units."
			End if 
		End if 
		
	Else 
		$matlError:=-1701
		$0:=$matlError
End case 

$0:=0