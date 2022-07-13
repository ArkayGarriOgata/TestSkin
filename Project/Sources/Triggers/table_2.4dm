//don't sync this table
C_LONGINT:C283($0)
$0:=0
If (Trigger event:C369=On Saving Existing Record Event:K3:2)
	<>TEST_VERSION:=[z_administrators:2]TestMode:30
	//utl_Logfile ("server.log";"Admin Rec Chg:")
	If (<>TEST_VERSION)
		utl_Logfile("server.log"; "Running in TEST_VERSION mode ")
	Else 
		//utl_Logfile ("server.log";"Running in PRODUCTION mode ")
	End if 
	
End if 