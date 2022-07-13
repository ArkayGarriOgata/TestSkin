//%attributes = {"publishedWeb":true}
//Procedure: uChangeAccess()  090695  MLB
//
//•090695  MLB  UPR 1724
uSpawnProcess("doChangeAccess"; 0; "Changing Login")
If (False:C215)
	doChangeAccess
End if 
//