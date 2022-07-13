//%attributes = {"publishedWeb":true}
//• 10/27/97 cs added code to track when  p-spec is last used
C_LONGINT:C283($temp; $recNo)  //(P) zoomPSpec
$temp:=iMode
iMode:=2
fromZoom:=True:C214
READ WRITE:C146([Process_Specs:18])
If ([Estimates_Carton_Specs:19]ProcessSpec:3#"")
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_Carton_Specs:19]ProcessSpec:3)
	MODIFY RECORD:C57([Process_Specs:18]; *)
	If (OK=1)  //• 10/27/97 cs 
		[Process_Specs:18]LastUsed:5:=4D_Current_date
		SAVE RECORD:C53([Process_Specs:18])
	End if   //• 10/27/97 cs  end
	READ ONLY:C145([Process_Specs:18])
	UNLOAD RECORD:C212([Process_Specs:18])
Else 
	$recNo:=fPickList(->[Process_Specs:18]ID:1; ->[Process_Specs:18]Cust_ID:4; ->[Process_Specs:18]Description:3)
	If ($recNo#-1)
		uClearSelection(->[Process_Specs:18])  //• 10/27/97 cs ,start
		READ WRITE:C146([Process_Specs:18])
		GOTO RECORD:C242([Process_Specs:18]; $recNo)
		gQuickLockTest(->[Process_Specs:18])
		If (<>fContinue)  //user did not cancel
			[Process_Specs:18]LastUsed:5:=4D_Current_date
			SAVE RECORD:C53([Process_Specs:18])
			READ ONLY:C145([Process_Specs:18])
			UNLOAD RECORD:C212([Process_Specs:18])
		End if   //• 10/27/97 cs end
		[Estimates_Carton_Specs:19]ProcessSpec:3:=[Process_Specs:18]ID:1
	Else 
		CONFIRM:C162("Create a new Process Specification?")
		If (ok=1)
			iMode:=1
			ADD RECORD:C56([Process_Specs:18]; *)
			[Estimates_Carton_Specs:19]ProcessSpec:3:=[Process_Specs:18]ID:1
		End if 
	End if 
End if 
iMode:=$temp
fromZoom:=False:C215
RELATE ONE:C42([Estimates_Carton_Specs:19]ProcessSpec:3)
//