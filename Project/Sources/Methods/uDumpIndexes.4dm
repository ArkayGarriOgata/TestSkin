//%attributes = {"publishedWeb":true}
//(P) uDumpIndexes: dumps list of indexes to disk file

C_LONGINT:C283($FileNo; $FieldNo; $Type; $Length)
C_BOOLEAN:C305($Index)

util_deleteDocument("Indexes")
SET CHANNEL:C77(10; "Indexes")
SEND PACKET:C103("Indexed fields in "+<>sSTRUCNAME+Char:C90(13))
For ($FileNo; 1; Get last table number:C254)
	If (Is table number valid:C999($FileNo))
		For ($FieldNo; 1; Get last field number:C255(Table:C252($FileNo)))
			GET FIELD PROPERTIES:C258($FileNo; $FieldNo; $Type; $Length; $Index)
			If ($Index)
				SEND PACKET:C103("["+Table name:C256($FIleNo)+"]"+Field name:C257(Field:C253($FileNo; $FieldNo))+Char:C90(13))
			End if 
		End for 
	End if 
End for 
SET CHANNEL:C77(11)