//%attributes = {}
// _______
// Method: orda_util_EntityLoad   ( ) ->
// By: Mel Bohince @ 08/12/19, 16:45:41
// Description
// from JPR's Invoice example
// ----------------------------------------------------

C_COLLECTION:C1488($collection; $objectsNames)
C_OBJECT:C1216($entity)
C_TEXT:C284($object)

$entity:=$1
$objectsNames:=$2

$isNew:=False:C215
If ($entity#Null:C1517)
	If ($entity.isNew())
		Form:C1466.recordCanBeSaved:=True:C214
		For each ($object; $objectsNames)
			Form:C1466["data_"+$object]:=New collection:C1472
			Form:C1466["cur_"+$object]:=New object:C1471
			Form:C1466["pos_"+$object]:=0
			Form:C1466["sel_"+$object]:=New collection:C1472
		End for each 
		$isNew:=True:C214
	Else 
		For each ($object; $objectsNames)
			If ($entity[$object]=Null:C1517)
				Form:C1466["data_"+$object]:=New collection:C1472
			Else 
				Form:C1466["data_"+$object]:=orda_util_Object2Collection($entity[$object])
			End if 
			Form:C1466["cur_"+$object]:=New object:C1471
			Form:C1466["pos_"+$object]:=0
			Form:C1466["sel_"+$object]:=New collection:C1472
		End for each 
	End if 
Else 
	
End if 

orda_util_EntityLoad_Specific($isNew)

orda_util_HandleButtons($entity)

