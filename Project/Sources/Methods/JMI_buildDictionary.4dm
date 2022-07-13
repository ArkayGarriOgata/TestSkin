//%attributes = {"executedOnServer":true}
// _______
// Method: JMI_buildDictionary   ( dictionaryObject; jobit collection to add; property path) ->
// By: MelvinBohince @ 05/03/22, 15:03:08
// Description
// Build a key value pair object for jobit's requested attribute
// ----------------------------------------------------
C_OBJECT:C1216($jobit_o; $0; $dictionary_o)
C_COLLECTION:C1488($2; $jobitCosts_c)
C_TEXT:C284($property; $3)  //needs to be an property path in the collection argument

If (Count parameters:C259>0)
	$dictionary_o:=$1
	$jobitCosts_c:=$2
	$property:=$3
	
Else 
	$dictionary_o:=New object:C1471
	$jobitCosts_c:=New collection:C1472(New object:C1471("Jobit"; "1"; "Cost_Mat"; 1.98); New object:C1471("Jobit"; "2"; "Cost_Mat"; 3.98); New object:C1471("Jobit"; "1"; "Cost_Mat"; 1.02))
	$property:="Cost_Mat"
End if 


If ($jobitCosts_c.length>0)
	
	If ($dictionary_o=Null:C1517)
		$dictionary_o:=New object:C1471
	End if 
	
	For each ($jobit_o; $jobitCosts_c)  //build the dictionary for later use
		//If (OB Is defined($dictionary_o;$jobit_o.Jobit))
		//$dictionary_o[$jobit_o.Jobit]:=$dictionary_o[$jobit_o.Jobit]+$jobit_o[$property]  //.Cost_Mat
		//Else 
		$dictionary_o[$jobit_o.Jobit]:=$jobit_o[$property]
		//End if 
	End for each 
End if 

$0:=$dictionary_o
