//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 012799  MLB, 08:59:09
// ----------------------------------------------------
// Method: app_Log_Usage("msg";"what:A(41)";"desc:T"{;tablenum{;recordnum}})
//e.g. app_Log_Usage("log";"jobpalette>Modify";"clicked the modify button")
// Description
// make record of user doing something of interest
// start the process in startup, and keep resident, able to call from local processes
// Parameters
// ----------------------------------------------------
//formerly. zSetUsageStat ("AskMe";"New Rel";sCustID+":"+sCPN)

C_TEXT:C284($1)
C_TEXT:C284($2; <>_Usage_Stats_what)
C_TEXT:C284($3; <>_Usage_Stats_description)
C_LONGINT:C283($4; $5; <>_Usage_Stats_tablenumber; <>_Usage_Stats_recordnumber)

If (Count parameters:C259=0)  //fire this baby up
	If (<>pid_Usage=0)  //singleton
		If (<>LOG_USER_ACTIONS)
			<>pid_Usage:=New process:C317("app_Log_Usage"; <>lMinMemPart; "Log_Usage"; "init")
		End if 
	Else 
		RESUME PROCESS:C320(<>pid_Usage)
		PAUSE PROCESS:C319(<>pid_Usage)
	End if 
	
Else 
	Case of 
		: ($1="init")
			<>_Usage_Stats_what:=""
			<>_Usage_Stats_description:=""
			<>_Usage_Stats_tablenumber:=0
			<>_Usage_Stats_recordnumber:=0
			
			Repeat 
				PAUSE PROCESS:C319(<>pid_Usage)
				//on resume:
				If (Length:C16(<>_Usage_Stats_what)>0)
					CREATE RECORD:C68([x_Usage_Stats:65])
					[x_Usage_Stats:65]id:1:=app_AutoIncrement(->[x_Usage_Stats:65])
					[x_Usage_Stats:65]who:2:=Current user:C182
					[x_Usage_Stats:65]when_:3:=TS_ISO_String_TimeStamp  //TSDateTime //just "when" is SQL reserve word
					[x_Usage_Stats:65]what:4:=<>_Usage_Stats_what
					[x_Usage_Stats:65]description:5:=<>_Usage_Stats_description
					//If (Count parameters>3)
					[x_Usage_Stats:65]tablenumber:6:=<>_Usage_Stats_tablenumber
					//If (Count parameters>4)
					[x_Usage_Stats:65]recordnumber:7:=<>_Usage_Stats_recordnumber
					//End if 
					//End if 
					SAVE RECORD:C53([x_Usage_Stats:65])
					UNLOAD RECORD:C212([x_Usage_Stats:65])
				End if   //payload
				<>_Usage_Stats_what:=""
				<>_Usage_Stats_description:=""
				<>_Usage_Stats_tablenumber:=0
				<>_Usage_Stats_recordnumber:=0
				
			Until (<>fQuit4D)
			
		: ($1="kill")
			<>_Usage_Stats_what:=""
			RESUME PROCESS:C320(<>pid_Usage)
			
		Else 
			If (<>pid_Usage#0)  //is it active
				<>_Usage_Stats_what:=$2
				<>_Usage_Stats_description:=$3
				<>_Usage_Stats_tablenumber:=0
				<>_Usage_Stats_recordnumber:=0
				If (Count parameters:C259>3)
					<>_Usage_Stats_tablenumber:=$4
					If (Count parameters:C259>4)
						<>_Usage_Stats_recordnumber:=$5
					End if 
				End if 
				RESUME PROCESS:C320(<>pid_Usage)
			End if 
	End case 
	
End if 