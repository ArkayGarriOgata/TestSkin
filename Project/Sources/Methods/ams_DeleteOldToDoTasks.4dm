//%attributes = {}

// Method: ams_DeleteOldToDoTasks ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 06/19/14, 14:30:20
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

C_DATE:C307($yearAgo)
C_LONGINT:C283($days)


$days:=(Day of:C23(Current date:C33)-1)*-1

$yearAgo:=Add to date:C393(Current date:C33; -1; -1; $days)

READ WRITE:C146([To_Do_Tasks:100])
QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]DateDone:6#!00-00-00!; *)
QUERY:C277([To_Do_Tasks:100];  & ; [To_Do_Tasks:100]DateDone:6<$yearAgo)

util_DeleteSelection(->[To_Do_Tasks:100])