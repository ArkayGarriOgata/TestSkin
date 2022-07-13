//%attributes = {}
// _______
// Method: app_Set_Color   ( objectName;colorScheme) 
// By: Mel Bohince @ 05/11/20, 15:14:09
// Description
// set a standard application based color
//sample calls:
//appObjectSetColor ("categoryName";"good")
//appObjectSetColor ("WorkPhone";"bad")
//appObjectSetColor ("Variable1";"maybe")
//appObjectSetColor   //no params to get picker
// see also util_alternateBackground, use Digital Color Meter.app then r*256^2+g*256+b
// and method util_RGB_to_decimal(r;g;b) -> decimal
// ----------------------------------------------------

C_LONGINT:C283($white; $black; $red; $green; $yellow; $blue; $darkred; $darkgreen; $colorValue)

$white:=16777215
$black:=0
$red:=16468039
$green:=52020

$blue:=275455
$darkyellow:=16630284  //253 194 12 = 16630284
$darkred:=9703680  //204 36 44  = 13378604
$darkgreen:=941062

//describe a palette based on meaning
Case of 
	: (Count parameters:C259=0)  //use the picker for finding a color
		$colorValue:=Select RGB color:C956  //closing dialog rtns the value
		//or util_RGB_to_decimal(r;g;b) if you know what you want
		
	: ($2="good")
		OBJECT SET RGB COLORS:C628(*; $1; $white; $darkgreen)
		
	: ($2="maybe")
		OBJECT SET RGB COLORS:C628(*; $1; $blue; $yellow)
		
	: ($2="bad")
		OBJECT SET RGB COLORS:C628(*; $1; $white; $darkred)
		
	Else 
		OBJECT SET RGB COLORS:C628(*; $1; $black; $white)
End case 


