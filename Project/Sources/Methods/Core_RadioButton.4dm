//%attributes = {}
//Method: Core_RadioButton({tRadioButton})
//Description: This method handles a group of radio buttons
//  provided the first 4 characters of the object name is the same and unique
//  for that radio button group.

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tRadioButton)
	
	C_LONGINT:C283($nNumberOfObjects)
	C_POINTER:C301($pRadioButtonSet; $pRadioButton)
	C_TEXT:C284($tRadioButtonGroup)
	
	ARRAY TEXT:C222($atObjectName; 0)
	
	FORM GET OBJECTS:C898($atObjectName)
	SORT ARRAY:C229($atObjectName; >)
	
	$nNumberOfObjects:=Size of array:C274($atObjectName)
	
	If (Count parameters:C259=1)  //Parameters
		
		$pRadioButtonSet:=OBJECT Get pointer:C1124(Object named:K67:5; $1)
		
	Else 
		
		$pRadioButtonSet:=OBJECT Get pointer:C1124(Object current:K67:2)
		
	End if   //Done parameters
	
	$tRadioButtonGroup:=Substring:C12(OBJECT Get name:C1087(Object current:K67:2); 1; 4)
	
	$nStart:=Find in array:C230($atObjectName; $tRadioButtonGroup+"@")
	
End if   //Done initialize

While ($nStart#CoreknNoMatchFound)  //Clear
	
	$pRadioButton:=OBJECT Get pointer:C1124(Object named:K67:5; $atObjectName{$nStart})
	$pRadioButton->:=0
	
	$nStart:=$nStart+1
	
	If ($nStart<=$nNumberOfObjects)  //Objects
		
		$nStart:=Choose:C955(\
			(Position:C15($tRadioButtonGroup; $atObjectName{$nStart})=1); \
			$nStart; \
			CoreknNoMatchFound)  //Radio Button?
		
	End if   //Done objects
	
End while   //Done clear

$pRadioButtonSet->:=1
