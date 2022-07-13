//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/28/10, 16:09:42
// ----------------------------------------------------
// Method: pattern_Self_calling_process
// ----------------------------------------------------
If (False:C215)  //old way
	// uncomment lines 21 - 28 and 35 if this is running as daemon
	//C_TEXT($1)
	
	//If (Count parameters=0)
	//<>pid_:=Process number("Process's Name")
	//If (<>pid_=0)  //singleton
	//<>pid_:=New process("pattern_Self_calling_process";<>lMidMemPart;"Process's Name";"init")
	//If (False)
	//pattern_Self_calling_process 
	//End if 
	
	//Else 
	//SHOW PROCESS(<>pid_)
	//BRING TO FRONT(<>pid_)
	//  //If (Not(<>fQuit4D)) 
	//  //uConfirm ("Request-For-Mode is already running on this client.";"Just Checking";"Kill")
	//  //If (ok=0)
	//  //<>run_rfm:=False
	//  //End if 
	//  //Else   //help it die
	//  //<>run_rfm:=False
	//  //End if 
	//End if 
	
	//Else 
	//Case of 
	//: ($1="init")
	//zSetUsageLog (->[zz_control];"1";Current method name;0)
	//  //<>run_rfm:=False
	//SET MENU BAR(<>defaultMenu)
	//C_LONGINT(iBagTabs)
	//$winRef:=OpenFormWindow (->[zz_control];"bagTrack_dio")
	//DIALOG([zz_control];"bagTrack_dio")
	//CLOSE WINDOW($winRef)
	//<>pid_:=0
	//End case 
	//End if 
	
Else   //new way
	
	C_LONGINT:C283($pid)
	
	If (Count parameters:C259=0)
		$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
		SHOW PROCESS:C325($pid)
		
	Else   //init
		//put the work here
		SET MENU BAR:C67(<>defaultMenu)
		//zSetUsageLog (->[zz_control];"1";Current method name;0)
		C_OBJECT:C1216($form_o)
		$form_o:=New object:C1471
		//now customize parameters
		$form_o.masterClass:=ds:C1482.Customers_ReleaseSchedules
		$form_o.masterTable:=Table:C252(->[Customers_ReleaseSchedules:46])  // Modified by: Mel Bohince (4/18/20) can't use a pointer in the attribute
		$form_o.baseForm:="ShipMgmt"  //the two page listbox + detail form
		$form_o.detailForm:="ShipDetail"  //the one page detail form when doing the "Open Multiple"
		$form_o.windowTitle:="ELC Shipping Management"
		//....
		app_form_Open($form_o)
		
		//
		
	End if 
	
End if   //false
