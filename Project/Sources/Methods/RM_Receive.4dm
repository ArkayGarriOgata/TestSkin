//%attributes = {"publishedWeb":true}
//(P) gReceiveRM: Receive Raw Materials

windowTitle:="Receiving Purchased Items"
$winRef:=OpenFormWindow(->[Raw_Materials:21]; "POArray"; ->windowTitle; windowTitle)
SET MENU BAR:C67(<>DefaultMenu)
startFresh:=True:C214
sReceiveNum:=""
Repeat 
	DIALOG:C40([Raw_Materials:21]; "POArray")
Until (bCancel=1)  //until canceled
CLOSE WINDOW:C154
uWinListCleanup