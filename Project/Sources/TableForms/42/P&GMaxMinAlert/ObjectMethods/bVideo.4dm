// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 05/29/13, 08:26:58
// ----------------------------------------------------
// Method: [Job_Forms].P&GMaxMinAlert.bVideo
// Description:
// Loads and plays the video for the specified section.
// $4 = Video to play. Match the name of the video exactly.
// ----------------------------------------------------

C_LONGINT:C283($xlID)

$xlID:=New process:C317("PlayOneVideo"; <>lMinMemPart; "PlayOneVideo"; "P&GMinMaxEstCheck")