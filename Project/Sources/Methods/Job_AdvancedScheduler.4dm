//%attributes = {}
// Method: Job_AdvancedScheduler
// User name (OS): Philip Keth
// Date and time: 12/16/15, 13:28:00
PS_JustInTime  // Modified by: Mel Bohince (6/3/21) 

C_LONGINT:C283($xlWin)
SET MENU BAR:C67("Scheduling_full")
app_Log_Usage("log"; "AdvancedScheduler"; "open")
$xlWin:=Open form window:C675("AdvancedScheduler"; Has full screen mode Mac:K34:20)
SET WINDOW TITLE:C213("Advanced Job Scheduler"; $xlWin)
DIALOG:C40("AdvancedScheduler")

CLOSE WINDOW:C154($xlWin)
app_Log_Usage("log"; "AdvancedScheduler"; "close")
