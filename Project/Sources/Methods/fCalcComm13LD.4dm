//%attributes = {"publishedWeb":true}
//fCalcComm13LD($stdCost;$Flex2;$Flex3;$Flex4;$FormSqIn)
//•062796  MLB  add repeat form for 462 and 468
//• 062300 mlb chg to dies 

C_BOOLEAN:C305($repeatForm)

$stdCost:=$1
$Flex2:=$2
$Flex3:=$3
$Flex4:=$4
$FormSqIn:=$5
$ruleinches:=[Estimates_Materials:29]Real1:14  //rule inches
[Estimates_Materials:29]Qty:9:=1

If ($ruleinches<=0)
	Est_LogIt(<>sCr+"WARNING WARNING WARNING Rule*Inches have not been specifed.")
End if 

If ([Estimates_Materials:29]Real2:15=0)  //not blanking
	[Estimates_Materials:29]Cost:11:=($ruleinches*$stdCost)+$Flex2
	[Estimates_Materials:29]CalcDetails:24:="Not Blanking, "+String:C10($ruleinches)+" total rule inches"
Else 
	[Estimates_Materials:29]Cost:11:=($ruleinches*$Flex3)+$Flex4
	[Estimates_Materials:29]CalcDetails:24:="Blanking, "+String:C10($ruleinches)+" total rule inches"
End if 

If ([Estimates_Materials:29]Cost:11<500)
	Est_LogIt(<>sCr+"WARNING WARNING WARNING Check your 13-Laser Die set up, cost can't be <$500 ")
End if 