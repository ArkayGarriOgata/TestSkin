//%attributes = {"publishedWeb":true}
//(P) gDsgnEntry: Entry procedure for designer

READ WRITE:C146([zz_control:1])
READ WRITE:C146([z_administrators:2])

fDelete:=False:C215

If (Records in table:C83([zz_control:1])=0)
	NewWindow(500; 300; 0; 8; "Enter Control Data")  //•3/11/97 cs added for empty data
	CREATE RECORD:C68([zz_control:1])
	[zz_control:1]ApplicationName:1:=<>sAPPNAME
	[zz_control:1]Active_API:11:=False:C215
	SAVE RECORD:C53([zz_control:1])
	
	CREATE RECORD:C68([z_administrators:2])
	[z_administrators:2]Administrator:1:="not avail"
	[z_administrators:2]CompanyName:2:="arkay"
	[z_administrators:2]AppVersion:3:=<>sVERSION
	[z_administrators:2]LastUpdate:4:=<>dLASTUPDATE
	SAVE RECORD:C53([z_administrators:2])
	
	CREATE RECORD:C68([Users:5])
	[Users:5]Initials:1:="MLB"
	[Users:5]LastName:2:="Bohince"
	[Users:5]FirstName:3:="Mel"
	[Users:5]MI:4:="L."
	[Users:5]BusTitle:5:="Pjt.Mgr."
	[Users:5]UserName:11:="Designer"
	SAVE RECORD:C53([Users:5])
	
	CREATE RECORD:C68([Users:5])
	[Users:5]Initials:1:="mlb_"
	[Users:5]LastName:2:="Bohince"
	[Users:5]FirstName:3:="Mel"
	[Users:5]MI:4:="L."
	[Users:5]BusTitle:5:="Pjt.Mgr."
	[Users:5]UserName:11:="Administrator"
	SAVE RECORD:C53([Users:5])
	
	CLOSE WINDOW:C154  //•3/11/97 cs added for empty data
End if 

READ ONLY:C145([zz_control:1])