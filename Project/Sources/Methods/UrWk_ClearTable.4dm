//%attributes = {}
//Method:  UrWk_ClearTable
//Description:  This method will delete all the [User_Workstation] records
//   It is called from the Database Methods:On Server Startup

If (True:C214)
	
	C_OBJECT:C1216($esUserWorkstation)
	C_OBJECT:C1216($esNotDropped)
	
	$esUserWorkstation:=New object:C1471()
	$esNotDropped:=New object:C1471()
	
End if 

$esUserWorkstation:=ds:C1482.User_Workstation.all()

$esNotDropped:=$esUserWorkstation.drop()
