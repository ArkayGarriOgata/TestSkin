//%attributes = {"publishedWeb":true}
//PM:  JOB_DisplayForm  2/15/01  mlb
//based on:   `PM:  FG_Display()  2/14/00  mlb
//show a fg record in its own process

C_TEXT:C284($1)
C_LONGINT:C283(fileNum; iTabControl; $winRef)
C_POINTER:C301(filePtr)

windowTitle:="Job Bag Review of "+$1
$winRef:=OpenFormWindow(->[Job_Forms:42]; "Input"; ->windowTitle; windowTitle)
READ ONLY:C145([Jobs:15])  // Added by: Mel Bohince (1/28/20) 
READ ONLY:C145([Job_Forms:42])  // Added by: Mel Bohince (1/28/20) 
READ ONLY:C145([Cost_Centers:27])

QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)

If (Records in selection:C76([Job_Forms:42])>0)
	iMode:=3
	fAdHoc:=False:C215
	filePtr:=->[Job_Forms:42]
	zDefFilePtr:=filePtr
	SET MENU BAR:C67(<>DefaultMenu)  //Apple File Edit Window
	sFile:=Table name:C256(filePtr)
	fileNum:=Table:C252(filePtr)
	CostCtrCurrent("init"; "00/00/00")
	FORM SET INPUT:C55([Job_Forms:42]; "Input")
	FORM SET OUTPUT:C54([Job_Forms:42]; "List")
	DISPLAY SELECTION:C59([Job_Forms:42])
	
Else 
	BEEP:C151
	ALERT:C41($1+" was not found in the [Job_Forms] file.")
End if 
CLOSE WINDOW:C154($winRef)