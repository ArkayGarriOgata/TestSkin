//%attributes = {}
//Method: EDI_NewEnvelope(->theEnvelopeText;from;to{;seqNum})  102398  MLB
//create an interchange header
//•021202  MLB $eol:=Char(10)  `else we get an ISA !=106 error for Chanel
//•021202  MLB looks like outgoing seg delim is different than incoming
//****change this to using account prefs, for addrs, delims, sequences

C_LONGINT:C283($0)
C_POINTER:C301($1)  //pointer to the variable which will hold the envelope
C_TEXT:C284($elementDelim; $segmentDelim)
C_TEXT:C284($eol)
C_TEXT:C284($date; $time)
C_TEXT:C284($header; $trailer)
C_TEXT:C284($from; $to)

$0:=-16000
$segmentDelim:=Char:C90(Num:C11(EDI_AccountInfo("getSegDelim"; $3)))
//$segmentDelim:=Char(126)  `•021202  MLB looks like outgoing seg delim is differe
$elementDelim:=Char:C90(Num:C11(EDI_AccountInfo("getEleDelim"; $3)))
If (Position:C15(Char:C90(13); $segmentDelim)=0)
	//$eol:=Char(10)  `else we get an ISA !=106 error for Chanel
	$eol:=""
Else 
	$eol:=Char:C90(13)+Char:C90(10)
End if 

$date:=fYYMMDD(4D_Current_date)
$time:=Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
If (Length:C16($2)>0)
	$from:=" "*15
	$from:=Change string:C234($from; $2; 1)
Else 
	$from:="ARKAYT         "  //default to test
End if 
$to:=" "*15

$to:=Change string:C234($to; $3; 1)
If (Count parameters:C259>=4)
	$sequenceId:=String:C10(Num:C11($4); "000000000")
Else 
	$sequenceId:=String:C10(EDI_GetNextIDfromPreferences($3); "000000000")
End if 

If (Num:C11($sequenceId)>0)
	//*create interchange header  
	$header:="ISA*00*          *00*          *ZZ*"+$from+"*"+EDI_AccountInfo("getQualifier"; $3)+"*"+$to+"*"
	//$header:="ISA*00*          *00*          *ZZ*"+$from+"*"+EDI_AccountInfo
	//« ("getQualifier";$3)+"*"+"ARKAYT         "+"*"
	$version:=Substring:C12(EDI_AccountInfo("getSTD_VER"; edi_ack_to); 1; 5)
	$header:=$header+$date+"*"+$time+"*U*"+$version+"*"+$sequenceId+"*0*P*>"+$segmentDelim+$eol
	//*create the interchange trailer
	$trailer:="IEA*1*"+$sequenceId+$segmentDelim+$eol
	If ($elementDelim#"*")
		$header:=Replace string:C233($header; "*"; $elementDelim)
		$trailer:=Replace string:C233($header; "*"; $elementDelim)
	End if 
	If (Length:C16($header)>=106) & (Length:C16($header)<109)  //some kind of standard thing
		If (Length:C16($1->)=0)  //start freash
			$1->:=$header+"<-- Replace This -->"+$trailer
		Else   //wrap it
			$1->:=$header+$1->+$trailer
		End if 
		$0:=0
		
	Else 
		uConfirm("Interchange control header needs to be 106 characters."; "OK"; "Help")
		$0:=-16002
	End if 
	
Else 
	uConfirm("Interchange control header needs an sequence number."; "OK"; "Help")
	$0:=-16001
End if 