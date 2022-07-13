//%attributes = {}
//PM: EDI_VerifyIntegrity_EDIFACT(ptr:blob) -> 
//@author mlb - 3/4/03  16:34
// Modified by: Mel Bohince (5/12/16) suppress del msg
// Modified by: Mel Bohince (4/24/20) Add ELC Testing acct

//analyze the content of the envelope to see if it follows prescribed structure
//typical structure  
//UNB+UNOA:1+BEESL.ESL001:ZZ+001635622:01+030224:0148+001751++DELFOR’
//     UNH+0000001+DELFOR:D:95A:UN’
//          BGM+241+0000133+26’
//             DTM...
//             NAD+BY...
//             NAD+SE...
//             UNS+D'
//             NAD+DP...
//                LIN...
//                IMD...
//                  QTY...
//                  SCC...
//                  DTM...  
//                  REF...  
//          UNS+S’
//     UNT+9304+0000001’ (numb of segmen including UNH and UNT plus section number
//     ''''''
//UNZ+3+001751’

C_TEXT:C284(tICN)
C_POINTER:C301($theEnvelope; $1)
C_LONGINT:C283($0; $position; $length; $charNumber; $buyer)  //return 0 for success
C_TEXT:C284($tBlobText)

$theEnvelope:=$1
$length:=BLOB size:C605($theEnvelope->)-1
$0:=-30003  //fail closed

zwStatusMsg("EDI"; "Mapping UN/EDIFACT")

//first we need to figure out which sender this is from before we can get delimiters
$tBlobText:=BLOB to text:C555($theEnvelope->; Mac text without length:K22:10)
Case of 
	: (Position:C15("BEESL.ESL001"; $tBlobText)>0)
		Senders_ID:="BEESL.ESL001"
	: (Position:C15("5164547103"; $tBlobText)>0)
		Senders_ID:="5164547103"
	: (Position:C15("6315311578"; $tBlobText)>0)
		Senders_ID:="6315311578"
	: (Position:C15("6314547000Q"; $tBlobText)>0)  // Modified by: Mel Bohince (4/24/20) Add ELC Testing acct
		Senders_ID:="6314547000Q"
	Else 
		Senders_ID:="BEESL.ESL001"
End case 

//*Determine what the segment and element delimitors are used
//iElementDelimitor:=$theEnvelope->{3}  `expect UNB+
iElementDelimitor:=Num:C11(EDI_AccountInfo("getEleDelim"; Senders_ID))
sElementDelimitor:=Char:C90(iElementDelimitor)
//sSubElementDelimitor:=":"
iSubElementDelimitor:=Num:C11(EDI_AccountInfo("getSubDelim"; Senders_ID))
sSubElementDelimitor:=Char:C90(iSubElementDelimitor)
//sSegmentDelimitor:="'"
iSegmentDelimitor:=Num:C11(EDI_AccountInfo("getSegDelim"; Senders_ID))
sSegmentDelimitor:=Char:C90(iSegmentDelimitor)
$supportedVersions:=EDI_AccountInfo("getSTD_VER"; Senders_ID)
C_TEXT:C284(tInternational; tPartnerName)
tInternational:=""
tInternational:=EDI_AccountInfo("getIntl"; Senders_ID)
C_BOOLEAN:C305(bInternational)
If (tInternational="YES")
	bInternational:=True:C214
Else 
	bInternational:=False:C215
End if 
tPartnerName:=""
tPartnerName:=EDI_AccountInfo("getAcctName"; Senders_ID)

//find the end of the last segment
$continue:=True:C214
$position:=$length
$charNumber:=$theEnvelope->{$position}
While ($charNumber#iSegmentDelimitor) & ($continue)
	$position:=$position-1
	If ($position<($length-200))  //somethings wrong so bail
		$continue:=False:C215
		$0:=-35003
	Else 
		$charNumber:=$theEnvelope->{$position}
	End if 
End while 
$endOfMsg:=$position

//*Load this sucker in the arrays
C_LONGINT:C283($cursor)
ARRAY TEXT:C222(aEDI_Tag; 200)  //keep the tags in one array,grab a chunk of ram
ARRAY TEXT:C222(aEDI_Elements; 200)  //and the data in another
C_BOOLEAN:C305($getTag)  //keep track of state
C_POINTER:C301($putText)  //marshal the char stream into either array
$putText:=->aEDI_Tag  //starting on a tag
$cursor:=1
$getTag:=True:C214  //only interested in first element delimitor
$acceptLength:=3
$escChar:=Character code:C91("?")  //used to embed "'", ":", and "+"

uThermoInit($endOfMsg; "Loading Tags and Elements")
For ($position; 0; $endOfMsg)
	$charNumber:=$theEnvelope->{$position}
	Case of 
		: ($charNumber=$escChar) & (Not:C34($getTag))  //drop it and tread next as regular char
			$position:=$position+1
			$charNumber:=$theEnvelope->{$position}
			$putText->{$cursor}:=$putText->{$cursor}+Char:C90($charNumber)
			
		: ($charNumber=iSegmentDelimitor)  //tag coming next, so prepare
			$getTag:=True:C214
			$putText:=->aEDI_Tag  //redirect to the tag holding array
			$acceptLength:=3
			$cursor:=$cursor+1
			If ($position<$length)
				C_BOOLEAN:C305($bExitLoop)
				$bExitLoop:=False:C215
				While (Not:C34($bExitLoop))  //absorb CRLF
					
					If ($theEnvelope->{$position+1}<=13)
						$position:=$position+1
					Else 
						$bExitLoop:=True:C214
					End if 
					
					If (($position+1)>=(BLOB size:C605($theEnvelope->)-1))
						$bExitLoop:=True:C214
					End if 
				End while 
			End if 
			
			If ($cursor>Size of array:C274(aEDI_Tag))  //grow the arrays if necessary
				ARRAY TEXT:C222(aEDI_Tag; Size of array:C274(aEDI_Tag)+100)
				ARRAY TEXT:C222(aEDI_Elements; Size of array:C274(aEDI_Elements)+100)
			End if 
			
		: ($charNumber=iElementDelimitor) & ($getTag)  //tag complete
			$getTag:=False:C215
			$putText:=->aEDI_Elements  //redirect flow into the data array
			$acceptLength:=32000
			
		: (Not:C34(Is nil pointer:C315($putText)))  //not a delimitor, so save the data, including some iElementDelimitor's
			If (Length:C16($putText->{$cursor})<$acceptLength)  //in case the tag is fucked up
				$putText->{$cursor}:=$putText->{$cursor}+Char:C90($charNumber)
			Else 
				zwStatusMsg("Error"; "Tag overflow")
			End if 
			
		Else 
			//zwAlert ("Unknown character "+Char($charNumber)+" "+String($charNumber);"Better Check Results")
			$exceptions:=$exceptions+("Unknown character "+Char:C90($charNumber)+" "+String:C10($charNumber)+". Better Check Results")+Char:C90(13)
			TRACE:C157
			$position:=$endOfMsg+1
	End case 
	
	uThermoUpdate($position)
	
End for   //load the arrays
uThermoClose

$numberOfSegments:=$cursor-1
ARRAY TEXT:C222(aEDI_Tag; $numberOfSegments)
ARRAY TEXT:C222(aEDI_Elements; $numberOfSegments)

//* verify message structure
$unb:=0
$unz:=0
$unh:=0
$bgm:=0
$unt:=0
$unss:=0
$unsd:=0
$section:=""
$sectionControl:=0
$segmentControl:=0
$msgType:=""

$exceptions:=""

uThermoInit($numberOfSegments; "Verifing Section Controls")
For ($segment; 1; $numberOfSegments)
	$errMsg:=util_TextParser(7; aEDI_Elements{$segment}; iElementDelimitor; iSegmentDelimitor)
	Case of 
			//######################header & trailer       
		: (aEDI_Tag{$segment}="UNH")
			$unh:=$unh+1
			$segmentControl:=0  //reset segment counter
			$section:=util_TextParser(1)
			$sectionControl:=$sectionControl+1
			$version:=util_TextParser(2)
			If (Position:C15($version; $supportedVersions)=0)
				//zwAlert ("Unknown UN/EDIFACT version discovered at segment "+String($segment))
				$exceptions:=$exceptions+("Unknown UN/EDIFACT version discovered at segment "+String:C10($segment))+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			$delim:=Position:C15(sSubElementDelimitor; util_TextParser(2))-1
			If ($msgType#Substring:C12(util_TextParser(2); 1; $delim))
				//zwAlert ("Message in section "+$section+" is a "+Substring(zTextParser (2);1;$delim)+" while the envelop declares "+$msgType)
				$exceptions:=$exceptions+("Message in section "+$section+" is a "+Substring:C12(util_TextParser(2); 1; $delim)+" while the envelop declares "+$msgType)+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
		: (aEDI_Tag{$segment}="UNT")
			$unt:=$unt+1
			$segmentControl:=$segmentControl+1
			If ($segmentControl#Num:C11(util_TextParser(1)))
				//zwAlert ("Missing Segment(s) discovered at segment "+String($segment))
				$exceptions:=$exceptions+("Missing Segment(s) discovered at segment "+String:C10($segment))+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			If ($section#util_TextParser(2))
				//zwAlert ("Section control problem discovered at segment "+String($segment))
				$exceptions:=$exceptions+("Section control problem discovered at segment "+String:C10($segment))+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			//######################message markers 
		: (aEDI_Tag{$segment}="BGM")
			$bgm:=$bgm+1
			
		: (aEDI_Tag{$segment}="UNS")
			If (util_TextParser(1)="D")
				$unsd:=$unsd+1  //data detail (repeating)
			Else   //assumptive
				$unss:=$unss+1  //data detail end
			End if 
			
			//######################envelop begin and end 
		: (aEDI_Tag{$segment}="UNB")
			$unb:=$unb+1
			$interchangeControl:=util_TextParser(5)
			tICN:=$interchangeControl
			ARRAY TEXT:C222(aISA; 6)
			aISA{6}:=$interchangeControl
			
			$msgType:=util_TextParser(7)
			If ($unb>1)
				//zwAlert ("More than one envelop found, started at segment "+String($segment))
				$exceptions:=$exceptions+("More than one envelop found, started at segment "+String:C10($segment))+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			If ($msgType="CONTRL")
				$segment:=$segment+$numberOfSegments
			End if 
			
			//$exceptions:=""
			$section:=""
			$sectionControl:=0
			$segmentControl:=0
			$unh:=0
			$bgm:=0
			$unt:=0
			$unss:=0
			$unsd:=0
			
		: (aEDI_Tag{$segment}="UNZ")
			$unz:=$unz+1
			If ($sectionControl#Num:C11(util_TextParser(1)))
				//zwAlert ("Section control problem discovered at segment "+String($segment))
				$exceptions:=$exceptions+("Section control problem discovered at segment "+String:C10($segment))+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			If ($interchangeControl#util_TextParser(2))
				//zwAlert ("Interchange Control Number does not match on UNB and UNZ at segment "+String($segment))
				$exceptions:=$exceptions+("Interchange Control Number does not match on UNB and UNZ at segment "+String:C10($segment))+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			If ($unh#$sectionControl)
				$exceptions:=$exceptions+" #UNH="+String:C10($unh)+", should be "+String:C10($sectionControl)+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			If ($bgm#$sectionControl)
				$exceptions:=$exceptions+" #BGM="+String:C10($bgm)+", should be "+String:C10($sectionControl)+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			If ($unt#$sectionControl)
				$exceptions:=$exceptions+" #UNT="+String:C10($unt)+", should be "+String:C10($sectionControl)+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			If ($unsd#$sectionControl)
				$exceptions:=$exceptions+" #UNS+D="+String:C10($unsd)+", should be "+String:C10($sectionControl)+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			If ($unss#$sectionControl)
				$exceptions:=$exceptions+" #UNS+S="+String:C10($unss)+", should be "+String:C10($sectionControl)+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
			
			//######################content 
		Else 
			If (Position:C15(aEDI_Tag{$segment}; "~UNA~UNB~UNH~BGM~DTM~NAD~UNS~GIN~LIN~IMD~QTY~SCC~RFF~UNT~UNZ~CTA~CUX~FTX~PAT~TDT~"+"TOD~"+"MOA")<2)
				//zwAlert ("Unknown UN/EDIFACT tag at segment "+String($segment)+" is "+aEDI_Tag{$segment})
				$exceptions:=$exceptions+("Unknown UN/EDIFACT tag at segment "+String:C10($segment)+" is "+aEDI_Tag{$segment})+Char:C90(13)
				$segment:=$numberOfSegments+1
			End if 
	End case 
	
	$segmentControl:=$segmentControl+1
	$errMsg:=util_TextParser
	uThermoUpdate($segment)
End for 
uThermoClose

If (Position:C15($msgType; "~ORDERS~DELFOR~DESADV~CONTRL~")=0)
	$exceptions:=$exceptions+" Unknown Message Type "
	uConfirm("Unknown Message Type '"+$msgType+"'."; "Abort"; "Help")
	$0:=-35026
End if 

If (Length:C16($exceptions)=0)  //*Send message to a Specific Mapper
	Case of 
		: ($msgType="ORDERS")
			$0:=EDI_Map_EDIFACT_Order
			
		: ($msgType="DELFOR")
			uConfirm("DELFOR received, do you want to process it?"; "Process"; "Skip")  // Modified by: Mel Bohince (8/30/18) 
			If (ok=1)
				//C_TEXT($delfor_date;$delfor_buyer)
				ARRAY TEXT:C222($aDelfor_Date; 0)  // this si populated by the DTM segment in the header, expect to have to handle dups
				ARRAY TEXT:C222($aDelfor_Buyer; 0)  // this is populated by the NAD+BY segment in the header, expect to have to handle dup
				$0:=EDI_Map_EDIFACT_Delfor(->$aDelfor_Date; ->$aDelfor_Buyer)
				ARRAY TEXT:C222($aProcessed_Buyer; 0)
				For ($buyer; 1; Size of array:C274($aDelfor_Buyer))
					If (Find in array:C230($aProcessed_Buyer; $aDelfor_Buyer{$buyer})=-1)  // only do a buyer once! else you get cummualtive results
						EDI_Delfor_Reconcile($aDelfor_Date{$buyer}; $aDelfor_Buyer{$buyer})
						APPEND TO ARRAY:C911($aProcessed_Buyer; $aDelfor_Buyer{$buyer})
					End if 
				End for 
				ARRAY TEXT:C222($aDelfor_Date; 0)
				ARRAY TEXT:C222($aDelfor_Buyer; 0)
				ARRAY TEXT:C222($aProcessed_Buyer; 0)
				//get rid of the stale forecasts
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<F@"; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]EDI_Disposition:36="OMIT")
				util_DeleteSelection(->[Customers_ReleaseSchedules:46]; "no-msg")  // Modified by: Mel Bohince (5/12/16) suppress del msg
				
			End if   //process it
			
		: ($msgType="CONTRL")
			$0:=2
		Else 
			$0:=-44000
	End case 
	
Else 
	//zwAlert ("Msg corrupt: "+$exceptions;"Abort")
	[edi_Inbox:154]Mapped:6:=0
	[edi_Inbox:154]Error:8:=$exceptions
	SAVE RECORD:C53([edi_Inbox:154])
	TRACE:C157
	zwStatusMsg("Error"; "Verify Integrity")
	$0:=-34999
End if 