//%attributes = {"publishedWeb":true}
//(P) StartPI - Start Physical Inventory
//OBJECT SET ENABLED(◊ibPhyInv;False)
<>fPhyInv:=True:C214
<>PIProcess:=New process:C317("gPhyInvEvent"; <>lMinMemPart; "Phy Inv")
If (False:C215)
	gPhyInvEvent
End if 
uWinListCleanup
//