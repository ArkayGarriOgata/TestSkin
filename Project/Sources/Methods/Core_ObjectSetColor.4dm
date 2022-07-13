//%attributes = {}
//Method:  Core_ObjectSetColor({*;tObjectName}/pObject ; nColor ; bNoBackground)
//Description:  This replaces the OBJECT SET COLOR command that will be obsolete in v18
// Modified by: MelvinBohince (6/9/22) chg background color to none when using object name
// Modified by: Garri Ogata (6/30/22) Pass in bNoBackground this fixes the issue

// This can be called to replace OBJECT SET COLOR with Core_ObjectSetColor provided
//      colors are from the 4D constant family this is gauranteed to work other color combinations
//      may not work so those will have to be completely changed.

//  bNoBackground Allows us to account for objects that have the Background and border-fill color set to None.
//      Need a function Get Fill Color and then will not need to pass in.

//    4D Constant    4D    Decimal(RGB)

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

If (True:C214)  //Initialize
	
	C_VARIANT:C1683($1; $2)
	C_VARIANT:C1683($3)
	C_BOOLEAN:C305($4; $bNoBackground)
	
	C_BOOLEAN:C305($bUseObjectName)
	
	C_LONGINT:C283($nColor)
	C_LONGINT:C283($n4DForeground; $n4DBackground)  //4D color constants
	C_LONGINT:C283($nRBGForeground; $nRBGBackground)
	C_TEXT:C284($tObjectName)
	
	$bUseObjectName:=False:C215
	$bNoBackground:=False:C215
	
	Case of   //*
			
		: (Value type:C1509($1)=Is pointer:K8:14)
			
			$pObject:=$1
			$nColor:=$2
			
			If (Count parameters:C259>=3)  //Core_ObjectSetColor( pObject ; nColor ; bNoBackground )
				$bNoBackground:=$3
			End if 
			
		: ($1="*")
			
			$tObjectName:=$2
			$nColor:=$3
			
			$bUseObjectName:=True:C214
			
			If (Count parameters:C259>=4)  //Core_ObjectSetColor( * ; tObjectName ; nColor ; bNoBackground )
				$bNoBackground:=$4
			End if 
			
	End case   //Done *
	
	$n4DForeground:=-$nColor & 0x00FF
	$n4DBackground:=-$nColor >> 8 & 0x00FF
	
	$nRBGForeground:=Core_Color_GetRGBValueN($n4DForeground)
	$nRBGBackground:=Core_Color_GetRGBValueN($n4DBackground)
	
End if   //Done Initialize

Case of   //Name 
		
	: ($bUseObjectName & $bNoBackground)  //Name no background
		
		OBJECT SET RGB COLORS:C628(*; $tObjectName; $nRBGForeground; Background color none:K23:10)
		
	: ($bUseObjectName & Not:C34($bNoBackground))  //Name background
		
		OBJECT SET RGB COLORS:C628(*; $tObjectName; $nRBGForeground; $nRBGBackground)
		
	: (Not:C34($bUseObjectName) & $bNoBackground)  //Pointer no background
		
		OBJECT SET RGB COLORS:C628($pObject->; $nRBGForeground; Background color none:K23:10)
		
	: (Not:C34($bUseObjectName) & Not:C34($bNoBackground))  //Pointer background
		
		OBJECT SET RGB COLORS:C628($pObject->; $nRBGForeground; $nRBGBackground)
		
End case   //Done name
