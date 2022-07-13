//%attributes = {"publishedWeb":true}
//JCOBinUpdate
//$1 - string 'New' or 'Mod' action type to take
//$2 - longint - Issue index 
//$3 - long int - POI index
//$4 - pointer to long int New Record insertion point/RMBin Update index
//• 10/31/97 cs created
//• 3/9/98 cs add tracking of Rm code

C_TEXT:C284($1)
C_LONGINT:C283($2; $3; $ChangePt)
C_POINTER:C301($4)

$ChangePt:=$4->
If ($1="New")
	$4->:=Ni_NewBinHndlr("A"; $ChangePt; $3; $2)
Else 
	aRmQty{$ChangePt}:=aRmQty{$ChangePt}-aIssueQty{$2}
	aRmAvail{$ChangePt}:=aRmAvail{$ChangePt}-aIssueQty{$2}
	aRmCommit{$ChangePt}:=aRmCommit{$ChangePt}+aIssueQty{$2}
	aRMCompId{$ChangePt}:=aPOICompId{$3}
	aRmCode{$ChangePt}:=aPOIRMCode{$3}  //• 3/9/98 cs track RM code - Vf usually does not supply it
End if 