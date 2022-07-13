//%attributes = {"publishedWeb":true}
//PM: ELC_query(->custid fld{;READWRITE?}) -> numFound
//@author mlb - 10/5/01  09:29

C_POINTER:C301($1; $fieldPtr; $tablePtr)
C_LONGINT:C283($0; $2)

$fieldPtr:=$1
$tablePtr:=Table:C252(Table:C252($fieldPtr))

ARRAY TEXT:C222($aEsteeCompany; 0)
QUERY:C277([Customers:16]; [Customers:16]ParentCorp:19="Estée Lauder Companies")
SELECTION TO ARRAY:C260([Customers:16]ID:1; $aEsteeCompany)
REDUCE SELECTION:C351([Customers:16]; 0)

If (Count parameters:C259=1)
	READ ONLY:C145($tablePtr->)
Else 
	READ WRITE:C146($tablePtr->)
End if 
QUERY WITH ARRAY:C644($fieldPtr->; $aEsteeCompany)

//QUERY($tablePtr->;$fieldPtr->=$aEsteeCompany{1};*)
//For ($i;2;Size of array($aEsteeCompany))
//QUERY($tablePtr->; | ;$fieldPtr->=$aEsteeCompany{$i};*)
//End for 
//QUERY($tablePtr->)

$0:=Records in selection:C76($tablePtr->)