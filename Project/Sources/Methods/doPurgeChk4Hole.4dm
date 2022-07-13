//%attributes = {"publishedWeb":true}
//Procedure: DoPurgeChk4Hole()  040296  MLB
//print out the number of records and holes in each file.
//•040296  MLB  add the current time to the report title & remove print settings c

C_LONGINT:C283($holes; $recs; $RecNum)
C_REAL:C285($pctHoles)
C_POINTER:C301($filePtr)
C_TEXT:C284(xText; xTitle; $text)
C_TEXT:C284($t; $cr)

$t:=","
$cr:="\r"
xTitle:="Address Table Analysis on "+String:C10(4D_Current_date; <>SHORTDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="Data file: "+$t+Data file:C490+$cr
xText:=xText+"RecordCount"+$t+"highRecNum"+$t+"holes"+$t+" % "+$t+"TableNum"+$t+"Table"+$cr

//$filePtr:=File(Num(Request("Enter the file number:")))
uThermoInit(Get last table number:C254; "Table Stats")
For ($i; 1; Get last table number:C254)
	If (Is table number valid:C999($i))
		uThermoUpdate($i)
		$filePtr:=Table:C252($i)
		$recs:=Records in table:C83($filePtr->)
		If ($recs#0)
			ALL RECORDS:C47($filePtr->)
			LAST RECORD:C200($filePtr->)
			$RecNum:=Record number:C243($filePtr->)
			$holes:=$RecNum-$recs+1
			$pctHoles:=Round:C94(($holes/$recs)*100; 0)
		Else 
			$RecNum:=0
			$holes:=0
			$pctHoles:=0
		End if 
		$text:=(String:C10($recs)+$t+String:C10($RecNum)+$t+String:C10($holes)+$t+String:C10($pctholes)+$t+String:C10($i)+$t+Table name:C256($filePtr))+$cr
		xText:=xText+$text
	End if 
End for 
uThermoClose
rPrintText("DoPurgeChk4Holes"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv")
xTitle:=""
xText:=""

zwStatusMsg("Chk4Holes"; "finished "+TS2String(TSTimeStamp))
