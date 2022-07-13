//%attributes = {"publishedWeb":true}
//(p) uWinListCleanup
//Calls the process list to update it so that it more likely sshows correct info
//this should be called at the end of every process

If (<>PrcsListPr>0)  //• 7/9/97 cs stop unneeded calls this screws up other proces
	<>aPrcsName:=0
	POST OUTSIDE CALL:C329(<>PrcsListPr)  //update process list
Else 
	uProcessLookup(Current process:C322)
End if 