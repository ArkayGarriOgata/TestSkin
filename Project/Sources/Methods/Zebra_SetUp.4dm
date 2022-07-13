//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/17/05, 10:59:51
// ----------------------------------------------------
// Method: Zebra_SetUp
// Description
// set some para on the printer
//
// Parameters
// ----------------------------------------------------
C_BOOLEAN:C305(zebraPrint; $0)
C_LONGINT:C283(tcpID; $1)  //base pid
C_LONGINT:C283(tcpPort)
C_TEXT:C284(tcpAddress)
C_TEXT:C284(zebraSpeed; zebraOffsetX; zebraOffsetY)
Case of 
	: (Count parameters:C259=0)  //init
		If (Current user:C182="Designer")
			uConfirm("Print to PDF?"; "PDF"; "Zebra")
			If (ok=1)
				$prefs:=""
			Else 
				$prefs:=User_ZebraPreferences("FLB")
			End if 
			
		Else 
			$prefs:=User_ZebraPreferences(<>zResp)
		End if 
		
		If (Length:C16($prefs)>0)
			zebraPrint:=True:C214
			tcpID:=0
			tcpPort:=Num:C11(Substring:C12($prefs; 19; 5))  //9100
			//tcpAddress:="192.168.3.39"
			//tcpAddress:=Request("Printer's IP Address:";tcpAddress;"Set";"Use Laser")
			tcpAddress:=Substring:C12($prefs; 4; 15)  //"192.168.3.39xxx"
			tcpAddress:=Replace string:C233(tcpAddress; "x"; "")
			tcpAddress:=Replace string:C233(tcpAddress; " "; "")
			zebraSpeed:=Substring:C12($prefs; 24; 2)  //"2"
			zebraOffsetX:=Substring:C12($prefs; 26; 2)  //"0"
			zebraOffsetY:=Substring:C12($prefs; 28; 2)  //"13"
			
			//If (ok=1)
			//tcpPort:=Num(Request("Printer's IP Port:";String(tcpPort);"Set";"Ignor"))
			//CONFIRM("Speed="+zebraSpeed+", X="+zebraOffsetX+", Y="+zebraOffsetY;"Great!";"Change")
			//If (ok=0)
			//zebraSpeed:=Request("Speed= ";zebraSpeed)
			//zebraOffsetX:=Request("X offset= ";zebraOffsetX)
			//zebraOffsetY:=Request("Y offset= ";zebraOffsetY)
			//End if 
			//Else 
			//zebraPrint:=False
			//End if 
			
		Else 
			zebraPrint:=False:C215
		End if 
		$0:=zebraPrint
		
	: (Count parameters:C259=1)
		GET PROCESS VARIABLE:C371($1; zebraPrint; zebraPrint; tcpAddress; tcpAddress; tcpPort; tcpPort; zebraSpeed; zebraSpeed; zebraOffsetX; zebraOffsetX; zebraOffsetY; zebraOffsetY)
		$0:=zebraPrint
		
	: (Count parameters:C259=6)
		zebraPrint:=True:C214
		tcpID:=$1
		tcpAddress:=$2
		tcpPort:=$3
		zebraSpeed:=$4
		zebraOffsetX:=$5
		zebraOffsetY:=$6
		$0:=zebraPrint
End case 