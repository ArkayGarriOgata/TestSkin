//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/16/13, 14:17:10
// ----------------------------------------------------
// Method: TrainingVideoPath
// ----------------------------------------------------

ALL RECORDS:C47([zz_control:1])
If ([zz_control:1]aMsTrainingVidsPath:61="")
	[zz_control:1]aMsTrainingVidsPath:61:="Macintosh HD:Library:WebServer:Documents:ams1:"
	SAVE RECORD:C53([zz_control:1])
End if 
UNLOAD RECORD:C212([zz_control:1])