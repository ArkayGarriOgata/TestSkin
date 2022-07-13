//%attributes = {}
//Method:  Core_Prompt_EntrySetting
//Description:  This method will assign entry setting properties

If (True:C214)  //Initialize
	
	C_TEXT:C284($tEntryFilter)
	C_TEXT:C284($tEntryFormat)
	
	ARRAY TEXT:C222($atProperty; 0)
	ARRAY LONGINT:C221($anType; 0)
	
	OB GET PROPERTY NAMES:C1232(Form:C1466; $atProperty; $anType)
	
	$tEntryFilter:=Choose:C955(\
		(Find in array:C230($atProperty; "tEntryFilter")>0); \
		Form:C1466.tEntryFilter; \
		CorektBlank)
	
	$tEntryFormat:=Choose:C955(\
		(Find in array:C230($atProperty; "tEntryFormat")>0); \
		Form:C1466.tEntryFormat; \
		CorektBlank)
	
End if   //Done Initialize

If ($tEntryFilter#CorektBlank)  //Entry filter
	OBJECT SET FILTER:C235(Form:C1466.tValue; $tEntryFilter)
End if   //Done entry filter

If ($tEntryFormat#CorektBlank)  //Entry format
	OBJECT SET FORMAT:C236(Form:C1466.tValue; $tEntryFormat)
End if   //Done entry format
