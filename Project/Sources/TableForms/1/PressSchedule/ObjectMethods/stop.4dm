//bStop
app_Log_Usage("log"; "PS MR"; "Stop")
PS_MakeReadyTimerJobStop
OBJECT SET ENABLED:C1123(bStop; False:C215)
OBJECT SET ENABLED:C1123(bStart; True:C214)