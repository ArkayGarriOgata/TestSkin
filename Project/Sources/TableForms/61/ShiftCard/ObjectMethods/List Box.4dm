
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		// Modified by: Mel Bohince (4/14/17) onclick moved from form method to here
		C_BOOLEAN:C305($areRowsSelected)
		$rowsHilited:=Records in set:C195("$ListboxSet0")
		$areRowsSelected:=($rowsHilited>0)
		
		//$msg:=Change string("    ";<>zResp;1)+" - "+"Shift Card "+"END--Rows selected: "+String($rowsHilited)
		//$pid:=Execute on server("utl_Logfile";0;"rpc:utl_Logfile";"wiretap.log";$msg)
		
		OBJECT SET ENABLED:C1123(*; "Bless"; $areRowsSelected)
		
		//If ($areRowsSelected)
		//$msg:=Change string("    ";<>zResp;1)+" - "+"Shift Card "+"END--Approve Btn enabled"
		//Else 
		//$msg:=Change string("    ";<>zResp;1)+" - "+"Shift Card "+"END--Approve Btn disabled"
		//End if 
		//$pid:=Execute on server("utl_Logfile";0;"rpc:utl_Logfile";"wiretap.log";$msg)
		
	: (Form event code:C388=On Before Data Entry:K2:39)
		If ((Position:C15("√"; [Job_Forms_Machine_Tickets:61]Comment:25)>0))  //checked means approved by line mgr
			If (User in group:C338(Current user:C182; "RoleLineManager"))  //line mgr can still change
				$0:=0
			Else   //too late
				$0:=-1
			End if 
			
		Else   //ok to change
			$0:=0
		End if   //checked
		
End case 
