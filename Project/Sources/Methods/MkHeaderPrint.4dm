//%attributes = {"publishedWeb":true}
//(p) MkHeaderPrint
//$1 - boolean - are we saving report to disk (y/n)
//$2 - string - Customer Id of current report
//$3 - text (optional) - path to folder to save disk reports in
//prints the header of the marykay report
//• 1/15/98 cs created
//• 5/20/98 cs  allow save of reports to disk in a specified directory

C_TEXT:C284($2; $CustID)
C_TEXT:C284($T; $Cr)
C_TEXT:C284($File; $Message)
C_BOOLEAN:C305($0; $1; $Print2Disk)
C_TIME:C306(vDoc)

$Print2disk:=$1
rMonth:=0
dDateEnd:=4D_Current_date
tCust:=[Customers:16]Name:2
t2:=tCust+" Order Summary"
t2b:=""

If ($Print2Disk)  //if this report is being printed to disk
	$T:=Char:C90(9)
	$Cr:=Char:C90(13)
	$CustId:=$2
	C_TIME:C306(vDoc)
	vDoc:=?00:00:00?
	
	If (Count parameters:C259=3)  //• 5/20/98 cs there was a folder path specified
		$File:=$3+":"
	Else 
		$File:=""
	End if 
	$File:=$File+$CustID+" Order Summary, "+String:C10(4D_Current_date; "00/00/00")
	docName:=$File
	vDoc:=util_putFileName(->docName)
	
	//vDoc:=Create document($File;"TEXT")
	
	$0:=(vDoc#?00:00:00?)
	
	If ($0)
		xText:=String:C10(4D_Current_date; "00/00/00")+$T+String:C10(4d_Current_time; "00:00:00")+($T*6)+t2+$Cr
		xText:=xText+t2b+$Cr
		xText:=xText+"Release"+$T+"Release"+($T*4)+"Price"+$T+"Qty"+$T+"Qty"+$T+"Qty"+$T+"Qty"+$T+"QA"+$T+"Qty"+$T+"Qty Avail"+$T+"Bal Due"+$T+"Customer"+$T+"Customer"+$T+"Arkay"+$T+"Last Ship"+$Cr
		xText:=xText+"Now"+$T+"______"+$T+"P.O. #"+$T+"Item #"+$T+"Description"+$t+"per 1000"+$T+"Ordered"+$T+"W % Over"+$T+"Prod"+$T+"Shipped"+$T+"Hold"+$T+"Pay Use"+$T+"to Ship"+$T+"w/ Overage"+$T+"Resp"+$T+"Resp $"+$T+"Resp"+$T+"Date"+$Cr
		SEND PACKET:C103(vDoc; xText)
	End if 
Else 
	util_PAGE_SETUP(->[Finished_Goods:26]; "rMaryKay.h")
	PRINT SETTINGS:C106
	$0:=(OK=1)
	
	If ($0)
		NewWindow(600; 400; 0; 8; "Printing report")
		Print form:C5([Finished_Goods:26]; "rMaryKay.h")
	End if 
End if 

If ($0)
	NewWindow(400; 75; 5; -722; tCust+" Order/Inv Summary Rpt")
	
	If ($Print2Disk)
		$Message:="Saving report to file:"+Char:C90(13)
		
		If (Count parameters:C259<3)
			$Message:=$Message+GetDefaultPath
		End if 
		$Message:=$Message+$File+Char:C90(13)+Char:C90(13)
		MESSAGE:C88($Message)
	End if 
End if 