//%attributes = {}
//Method:  Core_Color_GetRGBValueN(nColorConstant)=>rColorDecimalValue
//Description:  This method will return the decimal value of a color

//    4D Constant           Decimal

//    White           0     16777215
//    Yellow          1     16776960
//    Orange          2     16753920
//    Red             3     16711680
//    Purple          4      8388736
//    Dark Blue       5          139
//    Blue            6          255
//    Light Blue      7      8900346
//    Green           8        65280
//    Dark Green      9        25600
//    Dark Brown     10      9127187
//    Dark Grey      11     11119017
//    Light Grey     12     13882323
//    Brown          13     13808780
//    Grey           14      8421504
//    Black          15            0

//.   CoreknColorLightSteelBlue   16      11650269 

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nColorConstant)
	C_LONGINT:C283($0; $nColorDecimalValue)
	
	$nColorConstant:=$1
	$nColorDecimalValue:=0
	
End if   //Done Initialize

//Choose starts at 0
$nColorDecimalValue:=Choose:C955($nColorConstant; \
16777215; \
16776960; \
16753920; \
16711680; \
8388736; \
139; \
255; \
8900346; \
65280; \
25600; \
9127187; \
11119017; \
13882323; \
13808780; \
8421504; \
0; \
11650269)

$0:=$nColorDecimalValue