//%attributes = {}
// ----------------------------------------------------
// User name (OS): MZ
// Date and time: 04/24/13, 09:43:31
// ----------------------------------------------------
// Method: SetObjectProperties(name;ptrFieldVar;T|F visable;title;T|F enterable;foregrnd;bkgrnd)
// Description:
// Sets visiual clues when a field or variable is nonenterable.
// $1 = Name, enter "" if using a pointer to a field/text area, Required.
// $2 = Pointer to field or variable, enter -><>NULL if name is used, Required.
// $3 = True/False, Visible, Required.
// $4 = Object Title, Optional, enter "" if not used.
// $5 = True/False, Enterable. Default colors used unless $5 and $6 are used.
// $6 = Optional, Foreground color (LongInt, use the constants).
// $7 = Optional, Background color (LongInt, use the constants).
// ----------------------------------------------------

C_TEXT:C284($tName; $1; $tTitle; $4)
C_POINTER:C301($pArea; $2)
C_BOOLEAN:C305($bVisible; $3; $bEnterable; $5)
C_LONGINT:C283($xlFore; $6; $xlBack; $7)

If ($1="")  //Use the pointer.
	$pArea:=$2
	$bVisible:=$3
	
	OBJECT SET VISIBLE:C603($pArea->; $bVisible)
	
	If (Count parameters:C259>3)
		$tTitle:=$4
		If ($tTitle#"")
			OBJECT SET TITLE:C194($pArea->; $tTitle)
		End if 
	End if 
	
	If (Count parameters:C259=5)  //Enterable or not with default colors, black on white & black on light grey
		$bEnterable:=$5
		
		If ($bEnterable)  //True = enterable
			Core_ObjectSetColor($pArea; -(Black:K11:16+(256*White:K11:1)))
		Else   //Nonenterable
			Core_ObjectSetColor($pArea; -(Black:K11:16+(256*Light grey:K11:13)))
		End if 
		
		OBJECT SET ENTERABLE:C238($pArea->; $bEnterable)
	End if 
	
	If (Count parameters:C259>5)
		$bEnterable:=$5
		$xlFore:=$6
		$xlBack:=$7
		
		OBJECT SET ENTERABLE:C238($pArea->; $bEnterable)
		
		If ($bEnterable)  //True = enterable
			Core_ObjectSetColor($pArea; -($xlFore+(256*$xlBack)))
		Else   //Nonenterable
			Core_ObjectSetColor($pArea; -($xlFore+(256*$xlBack)))
		End if 
	End if 
	
Else   //Use the "name" of the field/var
	$tName:=$1
	$bVisible:=$3
	
	OBJECT SET VISIBLE:C603(*; $tName; $bVisible)
	
	If (Count parameters:C259>3)
		$tTitle:=$4
		If ($tTitle#"")
			OBJECT SET TITLE:C194(*; $tName; $tTitle)
		End if 
	End if 
	
	If (Count parameters:C259=5)  //Enterable or not with default colors, black on white & black on light grey
		$bEnterable:=$5
		
		If ($bEnterable)  //True = enterable
			Core_ObjectSetColor("*"; $tName; -(Black:K11:16+(256*White:K11:1)))
		Else   //Nonenterable
			Core_ObjectSetColor("*"; $tName; -(Black:K11:16+(256*Light grey:K11:13)))
		End if 
		
		OBJECT SET ENTERABLE:C238(*; $tName; $bEnterable)
	End if 
	
	If (Count parameters:C259>5)
		$bEnterable:=$5
		$xlFore:=$6
		$xlBack:=$7
		
		OBJECT SET ENTERABLE:C238(*; $tName; $bEnterable)
		
		If ($bEnterable)  //True = enterable
			Core_ObjectSetColor("*"; $tName; -($xlFore+(256*$xlBack)))
		Else   //Nonenterable
			Core_ObjectSetColor("*"; $tName; -($xlFore+(256*$xlBack)))
		End if 
	End if 
	
End if 