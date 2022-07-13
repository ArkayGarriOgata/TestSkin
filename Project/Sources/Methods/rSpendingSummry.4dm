//%attributes = {"publishedWeb":true}
//(p) rSpendingSummry
//print a freport summarizing the $ spent with a vendor
//during the time period of a VenSum report
//this report will run after the Vensum which will 
//collect the needed data for this report
//this rept is being created at HTK request
//$1 - boolean - print report to disk(True) paper(false)
//• 2/24/98 cs created
//• 3/a2/98 crs ray out of bounds condition - fix
//•4/10/00  mlb  reduce#lines per page so data doesn't disappear
C_TEXT:C284(tText; $Text; $ThisLine; $File)
C_LONGINT:C283($Count; $i; $Lines; $MaxLines; $End)
C_TIME:C306(vDoc)
C_BOOLEAN:C305($1)  //print to disk T/F

$count:=Size of array:C274(aCustId)  //vendor id
SORT ARRAY:C229(aDesc; aCustid; ayA2; ayA3; ayA4; ayA5; ayA6; ayA7; ayBx; >)  //sort vendors by alpha name

If ($1)  //print to disk
	$T:=Char:C90(9)
	vDoc:=Create document:C266("Spending Summary "+String:C10(4D_Current_date))
	$Text:="Vendor Spending Summary Run on "+String:C10(4D_Current_date)+Char:C90(13)
	$Text:=$Text+txt_Pad("Vendor"; " "; 1; 42)+"$ This Month"+"  "+"$ This Quarter"+"  "+"$ Year to Date"+"  "+"  $ Month, LY"+"  "+"$ Quarter,LY"+"  "+"     $ YTD, LY"+Char:C90(13)+Char:C90(13)
	SEND PACKET:C103(vDoc; $Text)
	uThermoInit($Count; "Saving Spending Summary")
Else 
	$End:=1
	$Start:=-1
	util_PAGE_SETUP(->[zz_control:1]; "BigtextArea")
	$Text:=txt_Pad("Vendor Spending Summary Run on "+String:C10(4D_Current_date); " "; 0; 150)+Char:C90(13)
	$Text:=$Text+txt_Pad("Vendor"; " "; $End; 42)+"$ This Month"+"  "+"$ This Quarter"+"  "+"$ Year to Date"+"     "+"  $ Month, LY"+"  "+"$ Quarter,LY"+"  "+"     $ YTD, LY"+"  "+Char:C90(13)+Char:C90(13)
	tText:=$Text
End if 
ON EVENT CALL:C190("eCancelPrint")
$Format:="$###,###,##0.00"
$Lines:=0
$MaxLines:=40  //•4/10/00  mlb  

utl_Trace

For ($i; 1; $Count)
	If ($Lines>=$MaxLines)  //$Lines only incremented during print to paper
		Print form:C5([zz_control:1]; "BigTextArea")
		PAGE BREAK:C6(>)
		tText:=$Text
		$Lines:=0
	End if 
	
	//If (aCustId{$i}="03778")
	//ALERT(String($i)+" "+aDesc{$i})
	//TRACE
	//End if 
	
	If (Not:C34($1))  //if not printing to disk
		$ThisLine:=txt_Pad(aCustId{$i}+" "+aDesc{$i}; " "; $End; 42)+txt_Pad(String:C10(ayA2{$i}; $Format); " "; $Start; 12)
		$ThisLine:=$ThisLine+txt_Pad(String:C10(ayA3{$i}; $Format); " "; $Start; 12)+"  "+txt_Pad(String:C10(ayBx{$i}; $Format); " "; $Start; 14)+"     "
		$ThisLine:=$ThisLine+txt_Pad(String:C10(ayA4{$i}; $Format); " "; $Start; 12)+"  "+txt_Pad(String:C10(ayA5{$i}; $Format); " "; $Start; 12)+"  "
		$ThisLine:=$ThisLine+txt_Pad(String:C10(ayA6{$i}; $Format); " "; $Start; 12)+"  "+Char:C90(13)  //+uPad (String(ayA7{$i};$Format);" ";$Start;12)+Char(13)
		tText:=tText+$ThisLine
		$Lines:=$Lines+1
	Else 
		$ThisLine:=aDesc{$i}+$t+String:C10(ayA2{$i}; $Format)+$t+String:C10(ayA3{$i}; $Format)+$t+String:C10(ayBx{$i}; $Format)+$t
		$ThisLine:=$ThisLine+String:C10(ayA4{$i}; $Format)+$t+String:C10(ayA5{$i}; $Format)+$t+String:C10(ayA6{$i}; $Format)+$t+Char:C90(13)
		// $ThisLine:=$ThisLine+String(ayA7{$i};$Format)+Char(13)
		SEND PACKET:C103(vDoc; $ThisLine)
		$ThisLine:=""
		uThermoUpdate($i)
	End if 
End for 

If (Not:C34($1))  //if not printing to disk
	Print form:C5([zz_control:1]; "BigTextArea")
	PAGE BREAK:C6
Else 
	$File:=Document  //save documents file path
	CLOSE DOCUMENT:C267(vDoc)
	//$Error:=SetFileType ($File;"TEXT")
	//$Error:=SetFileCreator ($File;"XCEL")
	// obsolete call, method deleted 4/28/20 uDocumentSetType ($File)
	
	uThermoClose
End if 
$count:=0
ARRAY TEXT:C222(aDesc; $count)  //vendor name
ARRAY REAL:C219(ayA2; $count)  //month to date
ARRAY REAL:C219(ayA3; $count)  //quarter to date
ARRAY REAL:C219(ayBx; $count)  //year to date
ARRAY REAL:C219(ayA4; $count)  //last year month to date
ARRAY REAL:C219(ayA5; $count)  //last year quarter to date
ARRAY REAL:C219(ayA6; $count)  //ytd,last year
ARRAY REAL:C219(ayA7; $Count)  //last year
ARRAY TEXT:C222(aCustid; $Count)
ON EVENT CALL:C190("")
uWinListCleanup
//