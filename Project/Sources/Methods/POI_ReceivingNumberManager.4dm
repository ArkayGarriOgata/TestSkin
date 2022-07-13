//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/12/06, 14:12:30
// ----------------------------------------------------
// Method: POI_ReceivingNumberManager
// ----------------------------------------------------
// Modified by: Mel Bohince (3/2/16) stop using the Roanoke group for stamper id
// note that the prefix isn't saved into the rmx record, why?

C_TEXT:C284($0; $1; $prefix)
C_LONGINT:C283($table; $2; $incrementBy)

Case of 
	: ($1="getNext")
		Case of 
			: (User in group:C338(Current user:C182; "ReceiverStamp1"))
				$prefix:="C"
				$table:=8000
				
			: (User in group:C338(Current user:C182; "ReceiverStamp2"))  //(User in group(Current user;"RoanokeWarehouse"))
				$prefix:="V"
				$table:=8004
				
			: (User in group:C338(Current user:C182; "ReceiverStamp3"))  //(User in group(Current user;"Roanoke"))
				$prefix:="R"
				$table:=8002
				
			Else   //ReceiverStamp4
				$prefix:="A"
				$table:=8001
		End case 
		$nextID:=fGetNextIDandHold($table)
		$0:=$prefix+String:C10($nextID)
		
	: ($1="setNext")
		$incrementBy:=$2
		$nextID:=fGetNextIDandHold($table; $incrementBy)
		$0:=""
		
End case 