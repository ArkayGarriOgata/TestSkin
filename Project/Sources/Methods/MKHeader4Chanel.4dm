//%attributes = {"publishedWeb":true}
//PM:  MKHeader4Chanel  5/12/00  mlb
//based on: MkHeaderPrint3($Print2Disk;$CurrentBill;$Path)
//$1 - boolean - are we saving report to disk (y/n)
//$2 - string - Customer Id of current report
//$3 - text (optional) - path to folder to save disk reports in
//prints the header of the marykay report
//• 1/15/98 cs created
//• 5/20/98 cs  allow save of reports to disk in a specified directory
//•091198  MLB  

C_TEXT:C284($2; $CustID)
C_TEXT:C284($T; $Cr)
C_TEXT:C284($File)
C_BOOLEAN:C305($0; $1; $Print2Disk)
C_TIME:C306(vDoc)

$Print2disk:=$1
dDateEnd:=4D_Current_date
tCust:=[Customers:16]Name:2
t2:=tCust+" Order Summary"
t2b:="Bill to: "+$2

If ($Print2Disk)  //if this report is being printed to disk
	$T:=Char:C90(9)
	$Cr:=Char:C90(13)
	$CustId:=$2
	vDoc:=?00:00:00?
	
	If (Count parameters:C259=3)  //• 5/20/98 cs there was a folder path specified
		$File:=$3  //+":"
	Else 
		$File:=""
	End if 
	$File:=$File+$CustID+" Order Summary, "+fYYMMDD(4D_Current_date)
	vDoc:=Create document:C266($File; "TEXT")
	$0:=(vDoc#?00:00:00?)
	
	If ($0)
		xText:=String:C10(dDateEnd; "00/00/00")+$T+String:C10(4d_Current_time; "00:00:00")+($T*6)+t2+$Cr
		xText:=xText+t2b+$Cr
		xText:=xText+"Release"+$T+"Release"+($T*4)+"Price"+$T+"Qty"+$T+"Qty"+$T+"Qty"+$T+"Qty"+$T+"QA"+$T+"B&H"+$t+"Qty"+$T+"Calc'ed Avail"+$T+"Actual"+$T+"Bal Due"+$T+"Customer"+$T+"Customer"+$T+"Excess"+$T+"Calc'ed"+$T+"Last Ship"+$T+"Production"+$Cr
		xText:=xText+"Now"+$T+"______"+$T+"P.O. #"+$T+"Item #"+$T+"Description"+$t+"per 1000"+$T+"Ordered"+$T+"W % Over"+$T+"Prod"+$T+"Shipped"+$T+"Hold"+$t+"Qty"+$T+"Pay Use"+$T+"to Ship"+$T+"On Hand"+$T+"w/ Overage"+$T+"Resp"+$T+"Resp $"+$T+""+$T+"Excess"+$T+"Date"+$T+"Date"+$Cr
		SEND PACKET:C103(vDoc; xText)
	End if 
	
Else 
	$0:=True:C214
	iPage:=1
	Print form:C5([Finished_Goods:26]; "rMaryKay.h")
End if 