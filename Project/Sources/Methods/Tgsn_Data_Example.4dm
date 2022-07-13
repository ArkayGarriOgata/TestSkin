//%attributes = {}
//Method: Tgsn_Data_Example()
//Description:  This method will print out properties with piping

If (True:C214)  //Intialization
	
	C_TEXT:C284($tPipedExample)
	C_TEXT:C284($tPathname; $tMessage)
	
	C_LONGINT:C283($nProperty; $nNumberOfProperties)
	
	$tPipedExample:=CorektBlank
	$tPathname:=CorektBlank
	
	$tMessage:="Select folder to place ArkayExample"
	
	OB GET PROPERTY NAMES:C1232(TgsnoColumn; $atProperty)
	
	$nNumberOfProperties:=Size of array:C274($atProperty)
	
End if   //Done Initialize

For ($nProperty; 1; $nNumberOfProperties)  //Loop thru properties
	
	$tPipedExample:=$tPipedExample+$atProperty{$nProperty}+CorektPipe
	
End for   //Done looping thru properties

$tPathname:=Select folder:C670($tMessage)

TEXT TO DOCUMENT:C1237($tPathname+"ArkayExample"; $tPipedExample)
