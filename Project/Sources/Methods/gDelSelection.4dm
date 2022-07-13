//%attributes = {"publishedWeb":true}
//gDelSelection:
//$1 pointer to file to delete from

uCancelTran
FIRST RECORD:C50($1->)
CREATE SET:C116($1->; "ToDelete")
If (Not:C34(fCnclTrn))
	For ($i; 1; Records in selection:C76($1->))
		fLockNLoad($1)
		DELETE RECORD:C58($1->)
		USE SET:C118("ToDelete")  //defaults to first record remaining in set
	End for 
End if 