//%attributes = {"publishedWeb":true}
//(p) doPurgeEstCmpnt
//$1 pointer - to file to work with
//$2 Text - file path also a flag to actually do the archive/deletion
//saves then deletes the various tables related to an estimate
//• 3/30/98 cs clear sets

C_POINTER:C301($1; $File)
C_TEXT:C284($2)
C_LONGINT:C283($i; $Count)

$file:=$1
$Count:=Records in selection:C76($File->)

If (Count parameters:C259=2)  //doing deletions etc
	USE SET:C118(Table name:C256($File))
	$Count:=Records in selection:C76($File->)
	MESSAGE:C88(Char:C90(13)+" removing "+String:C10($Count)+" from "+Table name:C256($File))
	CLEAR SET:C117(Table name:C256($File))
	SET CHANNEL:C77(10; $2+Table name:C256($File)+"_"+String:C10(4D_Current_date)+"_"+String:C10($Count))
	FIRST RECORD:C50($File->)
	
	For ($i; 1; $Count)  //send records to disk
		SEND RECORD:C78($File->)
		NEXT RECORD:C51($File->)
	End for 
	SET CHANNEL:C77(11)
	DELETE SELECTION:C66($File->)  //delete them
	FLUSH CACHE:C297
	CLEAR SET:C117(Table name:C256($File))  //• 3/30/98 cs
	REDUCE SELECTION:C351($File->; 0)
	
Else 
	CREATE SET:C116($File->; "Temp")
	UNION:C120(Table name:C256($File); "Temp"; Table name:C256($File))
	CLEAR SET:C117("Temp")
End if 