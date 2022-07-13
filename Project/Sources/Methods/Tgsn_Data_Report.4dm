//%attributes = {}
//Method: Tgsn_Data_Report()
//Description:  This method will print out properties by row

If (True:C214)  //Intialization
	
	C_TEXT:C284($tPropertyByRow)
	C_TEXT:C284($tPathname; $tMessage)
	
	$tPropertyByRow:=CorektBlank
	$tPathname:=CorektBlank
	
	$tMessage:="Select folder to place TungstenColumn"
	
	OB GET PROPERTY NAMES:C1232(TgsnoColumn; $atProperty)
	
End if   //Done Initialize

For ($nProperty; 1; Size of array:C274($atProperty))  //Loop thru properties
	
	$tPropertyByRow:=$tPropertyByRow+$atProperty{$nProperty}+CorektCR
	
End for   //Done looping thru properties

$tPathname:=Select folder:C670($tMessage)

TEXT TO DOCUMENT:C1237($tPathname+"TungstenColumn.txt"; $tPropertyByRow)