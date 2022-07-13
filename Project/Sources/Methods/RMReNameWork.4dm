//%attributes = {"publishedWeb":true}
//(p)RMReNameWork
//$1 pointer to feild 1
//$2 pointer to feild 2
//$3 pointer to feild 3
//$4 string name of set to use
//$5  string new RM code
//• 10/2/97 cs created

C_POINTER:C301($1; $2; $3; $Field1; $Field2; $Field3; $File)
C_TEXT:C284($4; $Set)
C_TEXT:C284($5)
C_DATE:C307($CDate)

$Field1:=$1
$Field2:=$2
$Field3:=$3
$File:=Table:C252(Table:C252($Field1))
$Set:=$4

If (Records in set:C195($Set)>0)
	USE SET:C118($Set)
	$CDate:=4D_Current_date
	$Size:=Records in set:C195($Set)
	ARRAY TEXT:C222($RM; $Size)
	ARRAY DATE:C224($Date; $Size)
	ARRAY TEXT:C222($Who; $Size)
	SELECTION TO ARRAY:C260($Field1->; $Rm; $Field2->; $Date; $Field3->; $Who)
	For ($i; 1; $Size)
		$Rm{$i}:=$5
		$Date{$i}:=$CDate
		$Who{$i}:=<>zResp
	End for 
	
	Repeat 
		USE SET:C118($Set)
		ARRAY TO SELECTION:C261($Rm; $Field1->; $Date; $Field2->; $Who; $Field3->)
	Until (uChkLockedSet($File; "M"))
	$size:=0
	ARRAY TEXT:C222($RM; $Size)
	ARRAY DATE:C224($Date; $Size)
	ARRAY TEXT:C222($Who; $Size)
End if 

CLEAR SET:C117($Set)
uClearSelection($File)