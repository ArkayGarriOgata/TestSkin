//%attributes = {"publishedWeb":true}
//(P) gUnlockRelated: Unloads and unlocks related (subordinate) files
//************* (max of 5) ****************

C_POINTER:C301($1; $2; $3; $4; $5)  //pointers to related files

If (Count parameters:C259>0)
	UNLOAD RECORD:C212($1->)  //Unload from memory
	READ ONLY:C145($1->)  //set file to read only
	LOAD RECORD:C52($1->)  //load back into memory as read only
End if 

If (Count parameters:C259>1)
	UNLOAD RECORD:C212($2->)  //Unload from memory
	READ ONLY:C145($2->)  //set file to read only
	LOAD RECORD:C52($2->)  //load back into memory as read only
End if 

If (Count parameters:C259>2)
	UNLOAD RECORD:C212($3->)  //Unload from memory
	READ ONLY:C145($3->)  //set file to read only
	LOAD RECORD:C52($3->)  //load back into memory as read only
End if 

If (Count parameters:C259>3)
	UNLOAD RECORD:C212($4->)  //Unload from memory
	READ ONLY:C145($4->)  //set file to read only
	LOAD RECORD:C52($4->)  //load back into memory as read only
End if 

If (Count parameters:C259>4)
	UNLOAD RECORD:C212($5->)  //Unload from memory
	READ ONLY:C145($5->)  //set file to read only
	LOAD RECORD:C52($5->)  //load back into memory as read only
End if 