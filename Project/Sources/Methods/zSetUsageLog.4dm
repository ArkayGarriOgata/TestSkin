//%attributes = {}
// see replacement:
If (True:C214)
	app_Log_Usage("log"; $2; $3)
End if 
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/01/06, 11:30:14
// ----------------------------------------------------
// Method: zSetUsageLog(->table;what;desc{;recordnumber})
// Description
// see also zSetUsageStat
// 
// Parameters
// ----------------------------------------------------

//C_POINTER($1)
//C_TEXT($2)
//C_TEXT($3)
//C_LONGINT($4)
//If (False)  `◊monitor_usage
//CREATE RECORD([x_Usage_Stats])
//[x_Usage_Stats]id:=Current user
//[x_Usage_Stats]who:=TSDateTime 
//[x_Usage_Stats]tablenumber:=Table($1)
//[x_Usage_Stats]when:=Table name($1)
//[x_Usage_Stats]what:=$2
//[x_Usage_Stats]description:=$3
//If (Count parameters>3)
//[x_Usage_Stats]recordnumber:=$4
//End if 
//SAVE RECORD([x_Usage_Stats])
//UNLOAD RECORD([x_Usage_Stats])
//End if 
