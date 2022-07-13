//%attributes = {}
// _______
// Method: pattern_ListVersusDictionary   ( ) ->
// By: MelvinBohince @ 06/07/22, 11:40:31
// Description
// 
// ----------------------------------------------------
$names:=ds:C1482.Customers.all().toCollection().extract("Name")

C_COLLECTION:C1488($list; $z)
C_OBJECT:C1216($dict; $y)
C_LONGINT:C283($counter)
C_TEXT:C284($name)
$list:=New collection:C1472
$dict:=New object:C1471
$counter:=0
For each ($name; $names)
	$counter:=$counter+1
	$list.push(New object:C1471("name"; Lowercase:C14($name); "id"; $counter))
	
	$dict[Lowercase:C14($name)]:=$counter
	
End for each 

$x:=$dict["arkay"]
$y:=$list.query("name = :1"; "arka")[0]
$z:=$list.query("name = :1"; "ark@")