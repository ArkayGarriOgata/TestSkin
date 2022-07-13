//%attributes = {}
//Method:  Core_Pick_0000Explain
//Description:  This method will explain how to use the Core_Pick Object

If (True:C214)  //Initialize
	
	ARRAY TEXT:C222($atSource; 0)
	ARRAY TEXT:C222($atSelected; 0)
	
	C_OBJECT:C1216($oPick)  //Example of pick multiple with 1 and 5 selected when displayed
	$oPick:=New object:C1471()
	
	$oPick.tPicked:="1|5"
	$oPick.bPickMultiple:=True:C214
	$oPick.tFind:="Letter"
	
	C_COLLECTION:C1488($cSelected)
	$cSelected:=New collection:C1472()
	
	APPEND TO ARRAY:C911($atSource; "A")
	APPEND TO ARRAY:C911($atSource; "B")
	APPEND TO ARRAY:C911($atSource; "C")
	APPEND TO ARRAY:C911($atSource; "D")
	APPEND TO ARRAY:C911($atSource; "E")
	APPEND TO ARRAY:C911($atSource; "F")
	APPEND TO ARRAY:C911($atSource; "G")
	APPEND TO ARRAY:C911($atSource; "H")
	APPEND TO ARRAY:C911($atSource; "J")
	APPEND TO ARRAY:C911($atSource; "K")
	APPEND TO ARRAY:C911($atSource; "La")
	APPEND TO ARRAY:C911($atSource; "Lr")
	APPEND TO ARRAY:C911($atSource; "Lz")
	APPEND TO ARRAY:C911($atSource; "M")
	
End if   //Done initialize

//$tSelected:=Core_Dialog_PickT (->$atSource)  //Example of pick only one

$tSelected:=Core_Dialog_PickT(->$atSource; $oPick)  //Example of pick multiple

Core_Text_ParseToArray($tSelected; ->$atSelected; CorektPipe)  //Use either an array

$cSelected:=Split string:C1554($tSelected; CorektPipe; sk trim spaces:K86:2)  //Or a collection

//Then loop thru the array or collection