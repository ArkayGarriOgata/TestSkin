//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/29/08, 13:31:54
// ----------------------------------------------------
// Method: eServerErrorCall
// Description
// error handler for server
// ----------------------------------------------------


If (error>-15000) | (error<-32000)  //4D error
	utl_Logfile("on_err_call.log"; "ERROR CODE "+String:C10(error)+" ENCOUNTERED by 4D")
	
Else   //aMs error
	//error:=-30000-Table(->[Customers_Bills_of_Lading])
	$error_number:=Abs:C99(error)
	Case of 
		: ($error_number>30000)  //record locking problem in trigger
			$error_string:=String:C10($error_number)
			$action:=Substring:C12($error_string; Length:C16($error_string)-3; 1)
			Case of 
				: ($action="0")
					$action:="Query"
				: ($action="1")
					$action:="Update"
				Else 
					$action:="Other"
			End case 
			
			$table_number:=Num:C11(Substring:C12($error_string; Length:C16($error_string)-2))
			utl_Logfile("on_err_call.log"; "ERROR CODE: "+String:C10(error)+" Table: "+Table name:C256($table_number)+" Doing: "+$action)
			
		: ($error_number>20000)
			utl_Logfile("on_err_call.log"; "ERROR CODE "+String:C10(error)+" ENCOUNTERED by aMs")
			
	End case 
	
End if 