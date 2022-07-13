//%attributes = {"publishedWeb":true}
//(P) gR_ReadRelated: Sets related (subordinate) files to READ only mode
//• 6/20/97 cs  created based on - gr_WReleated

C_LONGINT:C283($i)

For ($i; 1; Count parameters:C259)
	READ ONLY:C145(${$i}->)  //set file to read only
End for 