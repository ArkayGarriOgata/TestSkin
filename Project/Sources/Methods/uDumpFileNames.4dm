//%attributes = {"publishedWeb":true}
//(P) uDumpFIleNames: dumps list of File Names to disk file

C_LONGINT:C283($FileNo)

util_deleteDocument("FIleNames")
SET CHANNEL:C77(10; "FIleNames")
SEND PACKET:C103("FILE NAMES in "+<>sSTRUCNAME+Char:C90(13))
For ($FileNo; 1; Get last table number:C254)
	If (Is table number valid:C999($FileNo))
		SEND PACKET:C103(String:C10($FileNo)+Char:C90(9)+Table name:C256($FIleNo)+Char:C90(13))
	End if 
End for 
SET CHANNEL:C77(11)