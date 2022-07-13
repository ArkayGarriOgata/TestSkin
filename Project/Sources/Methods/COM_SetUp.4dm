//%attributes = {}
//Method: COM_SetUp("Sterling";timeOut;delay;)  091498  MLB
//init data structure for this communication session
//•120298  MLB  enable PASV mode connections
// Modified by: Mel Bohince (9/9/21) comment unused sections

zwStatusMsg("COM"; "Starting Session: Setup")

C_LONGINT:C283($0; com_controlStream; com_dataStream; com_fileNamePos)  //return 0 for success
C_TEXT:C284($1; $account; com_SessionLog)
C_BLOB:C604(xcom_SessionLog)
C_BOOLEAN:C305(com_Trace; $TimedOut)
C_TEXT:C284(eol)
C_TEXT:C284(com_server; com_user; com_password; com_path; com_LocalAddress; com_PASV_ip)
C_LONGINT:C283(com_PASV_port; com_state)
C_TEXT:C284(ip_Address; ip_SubnetMask)
ARRAY TEXT:C222(com_aReplyBuffer; 0)  //hold multiple line host replies
ARRAY TEXT:C222(com_aMailBag; 0)  //hold filenames to download

SET BLOB SIZE:C606(xcom_SessionLog; 0)

$0:=-1  //fail closed
$account:=$1
com_SessionLog:="LOG:"+Char:C90(13)  //keep track of all host replys on the control stream

//com_Trace:=True
If (com_Trace)
	NewWindow(480; 580; 2; -722; "Communications Trace"; "zCloseWindow")
End if 

$TimedOut:=COM_TimeOut(0; 1; com_delay)  //reset counter to 0, wait to 5 sec, and delay to 60 ticks
eol:=Char:C90(13)+Char:C90(10)  //CR +LF
com_controlStream:=0
com_dataStream:=0

$err:=IT_MyTCPAddr(ip_Address; ip_SubnetMask)
com_LocalAddress:=Replace string:C233(ip_Address; "."; ",")  // get local IP address (separated by ",")

QUERY:C277([edi_COM_Account:156]; [edi_COM_Account:156]Name:1=$account)
If (Records in selection:C76([edi_COM_Account:156])=1)
	com_server:=[edi_COM_Account:156]Server:2
	com_user:=[edi_COM_Account:156]User:3
	com_password:=[edi_COM_Account:156]Password:4
	com_path:=[edi_COM_Account:156]Path:5
	com_DirData:=[edi_COM_Account:156]DirData:6
	com_DirRpts:=[edi_COM_Account:156]DirReports:7
	com_fileNamePos:=[edi_COM_Account:156]FileNamePos:8  //for LIST result
	com_account_id:="@"  //default to all accounts, as there really is only one as of 12/11/14
	$0:=0
	
Else 
	com_server:=""
	com_user:=""
	com_password:=""
	com_path:=""
	com_DirData:=""
	com_DirRpts:=""
	com_fileNamePos:=0  //for LIST result
	$0:=-15000
	COM_ErrorEncountered(2; $0; "Communication Setup failed, check your account information.")
End if 

If (False:C215)
	//Case of 
	//: ($account="Arkay")
	//com_server:="209.73.211.3"
	//com_user:="anonymous"
	//com_password:="EDI"
	//com_path:="/"
	//com_DirData:="/FTD"
	//com_DirRpts:="/FTR"
	//com_fileNamePos:=55  //for LIST result
	//$0:=0
	
	//: ($account="Sterling")
	//com_server:="sciftp.commerce.stercomm.com"
	//com_user:="SZLWXFTD"
	//com_password:="1418595"
	//com_path:="/"
	//com_DirData:="/SZLWXFTD"
	//com_DirRpts:="/SZLWXFTR"
	//com_fileNamePos:=25  //for LIST result
	//$0:=0
	
	//: ($account="Sterling Test")
	//com_server:="sciftpgw.commerce.stercomm.com"
	//com_user:="SZLWXFTD"
	//com_password:="1418595"
	//com_path:="/"
	//com_DirRpts:="/SZLWXFTR"
	//com_fileNamePos:=25  //for LIST result
	//$0:=0
	
	//: ($account="Sterling Sniffed")
	//com_server:="209.95.224.135"
	//com_user:="SZLWXFTD"
	//com_password:="1418595"
	//com_path:="/"
	//com_DirData:="/SZLWXFTD"
	//com_DirRpts:="/SZLWXFTR"
	//com_fileNamePos:=25  //for LIST result
	//$0:=0
	
	//: ($account="Sterling Reports")
	//com_server:="sciftp.commerce.stercomm.com"
	//com_user:="SZLWXFTR"
	//com_password:="1418595"
	//com_path:="/"
	//com_DirData:="/SZLWXFTD"
	//com_DirRpts:="/SZLWXFTR"
	//com_fileNamePos:=25  //for LIST result
	//$0:=0
	
	//: ($account="e-Com")
	//com_server:="ecomint.ecomtoday.com"  // or 216.127.135.91"
	//com_user:="arkaypac"
	//com_password:="E021811C"
	//com_path:="/arkaypac"
	//com_DirData:="//arkaypac/snd"
	//com_DirRpts:="/arkaypac/rcv"
	//com_fileNamePos:=40  //for LIST result
	//$0:=0
	
	//: ($account="ExpanDrive")
	//com_server:="ecomint.ecomtoday.com"  // or 216.127.135.91"
	//com_user:="arkaypac"
	//com_password:="E021811C"
	//com_path:="/arkaypac"
	//com_DirData:="snddatarch"
	//com_DirRpts:="rcv"
	//com_fileNamePos:=40  //for LIST result
	//com_account_id:="@"
	//$0:=0
	
	//Else 
	//com_server:=""
	//com_user:=""
	//com_password:=""
	//com_path:=""
	//com_DirData:=""
	//com_DirRpts:=""
	//com_fileNamePos:=0  //for LIST result
	//$0:=-15000
	//COM_ErrorEncountered (2;$0;"Communication Setup failed, check your account information.")
	//End case 
End if 