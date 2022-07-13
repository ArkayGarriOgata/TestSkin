//%attributes = {}
// Method: JML_SetDateColors () -> 
// ----------------------------------------------------
// by: mel: 08/20/03, 13:09:00
// ----------------------------------------------------
// Updates:
// • mel (10/7/04, 15:33:41) 
//mlb 4/29/06
// ----------------------------------------------------
// Modified by: Mel Bohince (3/31/15) allow setting DateStockSheeted before job released

If (User in group:C338(Current user:C182; "RoanokeSet_A_Date"))  // • mel (10/7/04, 15:33:41)
	OBJECT SET ENABLED:C1123(*; "jobRoan@"; True:C214)
Else 
	OBJECT SET ENABLED:C1123(*; "jobRoan@"; False:C215)
End if 

JML_SetDateColor(->Lvalue1; ->[Job_Forms_Master_Schedule:67]DateStockRecd:17)
JML_SetDateColor(->Lvalue4; ->[Job_Forms_Master_Schedule:67]Printed:32; "checkReleasedStatus")
JML_SetDateColor(->Lvalue6; ->[Job_Forms_Master_Schedule:67]GlueReady:28; "checkReleasedStatus")
JML_SetDateColor(->Lvalue8; ->[Job_Forms_Master_Schedule:67]DateBagReceived:48; "checkReleasedStatus")
JML_SetDateColor(->Lvalue9; ->[Job_Forms_Master_Schedule:67]DateBagApproved:49; "checkReleasedStatus")
JML_SetDateColor(->Lvalue10; ->[Job_Forms_Master_Schedule:67]DateStockSheeted:47)  // Modified by: Mel Bohince (3/31/15) removed ;"checkReleasedStatus"
JML_SetDateColor(->Lvalue11; ->[Job_Forms_Master_Schedule:67]DateBagReturned:52)
JML_SetDateColor(->Lvalue12; ->[Job_Forms_Master_Schedule:67]DateWIPreceived:53)
JML_SetDateColor(->Lvalue31; ->[Job_Forms_Master_Schedule:67]StockStaged:66; "checkReleasedStatus")  //mlb 4/29/06
JML_SetDateColor(->Lvalue2; ->[ProductionSchedules:110]PlatesReady:18)
JML_SetDateColor(->Lvalue3; ->[ProductionSchedules:110]InkReady:20)
JML_SetDateColor(->Lvalue5; ->[ProductionSchedules:110]StampingDies:28)
JML_SetDateColor(->Lvalue7; ->[ProductionSchedules:110]CyrelsReady:19)
JML_SetDateColor(->Lvalue13; ->[ProductionSchedules:110]DateFilmStampingRcd:43)
JML_SetDateColor(->Lvalue14; ->[ProductionSchedules:110]Leaf:30)
JML_SetDateColor(->Lvalue15; ->[ProductionSchedules:110]EmbossingDies:29)
JML_SetDateColor(->Lvalue16; ->[ProductionSchedules:110]DateFilmEmbossRcd:44)
JML_SetDateColor(->Lvalue17; ->[ProductionSchedules:110]DateCountersRecd:41)
JML_SetDateColor(->Lvalue18; ->[ProductionSchedules:110]DateDieBoardRecd:45)
JML_SetDateColor(->Lvalue19; ->[ProductionSchedules:110]DateBlankerRecd:42)
JML_SetDateColor(->Lvalue20; ->[ProductionSchedules:110]JobLockedUp:27)
JML_SetDateColor(->Lvalue21; ->[ProductionSchedules:110]FemaleStripperBoard:26)
JML_SetDateColor(->Lvalue22; ->[ProductionSchedules:110]NormalizedPDF:82)
JML_SetDateColor(->Lvalue23; ->[ProductionSchedules:110]InHouse:32)
JML_SetDateColor(->Lvalue24; ->[ProductionSchedules:110]ToolingSent:39)
JML_SetDateColor(->Lvalue25; ->[ProductionSchedules:110]StandardsSent:40)
JML_SetDateColor(->Lvalue26; ->[ProductionSchedules:110]DateDieFilesReady:46)
JML_SetDateColor(->Lvalue27; ->[ProductionSchedules:110]DateLatisealed:47)
JML_SetDateColor(->Lvalue28; ->[ProductionSchedules:110]DateWindowsCut:48)
JML_SetDateColor(->Lvalue29; ->[ProductionSchedules:110]DateAdhesiveOK:49)
JML_SetDateColor(->Lvalue30; ->[ProductionSchedules:110]DateLaminateOK:50)
JML_SetDateColor(->Lvalue32; ->[ProductionSchedules:110]DateDyluxChecked:75)
JML_SetDateColor(->Lvalue33; ->[ProductionSchedules:110]PreSheetedStock:81)