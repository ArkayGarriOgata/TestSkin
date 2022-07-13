//%attributes = {"publishedWeb":true}
//(P) uMyUnlock: Unloads and unlocks record from selected file

C_POINTER:C301($1)  //pointer to file

UNLOAD RECORD:C212($1->)  //Unload from memory
READ ONLY:C145($1->)  //set file to read only
LOAD RECORD:C52($1->)  //load back into memory as read only