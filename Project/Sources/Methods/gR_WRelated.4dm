//%attributes = {"publishedWeb":true}
//(P) gR_WRelated: Sets related (subordinate) files to READ WRITE mode
//************* (max of 5) ****************

C_LONGINT:C283($i)
C_POINTER:C301($1; $2; $3; $4; $5)  //pointers to related files

For ($i; 1; Count parameters:C259)
	READ WRITE:C146(${$i}->)  //set file to read only
End for 