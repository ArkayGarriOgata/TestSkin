//%attributes = {}
//Method: EDI_VerifyIntegrity_X12(ptr:blob)  100198  MLB
//analyze the content of the envelope to see if it follows prescribed structure
//look for interchange errors before reading the entire message
//return 0 for success

//typical structure  
//ISA*****0000001****!
//     GS*1
//          ST*1
//             ...
//          SE*23*1
//          ST*2
//             ...
//          SE*23*2
//     GE*2*1
//     GS*2
//          ST*3
//             ...
//          SE*23*3
//          ST*4
//             ...
//          SE*20*4
//          ST*5
//             ...
//          SE*20*5
//     GE*3*2
//IEA*2*0000001!

C_POINTER:C301($theEnvelope; $1)
C_LONGINT:C283($0; $position; $length; $charNumber; $endOfISA; $beginOfIEA; $numberOfGroups; $numberOfTranactionSets; $numberOfSegments; $i)
C_TEXT:C284($groupControlNumber; $transControlNumber; $exceptions; $errMsg)
ARRAY TEXT:C222(aISA; 0)  //clear last values array
ARRAY TEXT:C222(aISA; 16)  //store the components of the interchange header

$theEnvelope:=$1
$length:=BLOB size:C605($theEnvelope->)-1
$0:=-20003  //fail closed

zwStatusMsg("EDI"; "Mapping X12")
//*Determine what delimitors are used
//*   Element
iElementDelimitor:=$theEnvelope->{3}  //expect ISA*
sElementDelimitor:=Char:C90(iElementDelimitor)  //an '*'

//note:  ISA06 = Sender,ISA13 = Control Number
utl_Trace
$iElementNumber:=0  //start with ISA tag
For ($position; 3; 109)  //suppose tobe 106 chars
	$charNumber:=$theEnvelope->{$position}
	If ($charNumber=iElementDelimitor)
		$iElementNumber:=$iElementNumber+1
	Else 
		aISA{$iElementNumber}:=aISA{$iElementNumber}+Char:C90($charNumber)
		If ($iElementNumber=16)  //just got the one character subelement marker
			$position:=$position+1
			iSegmentDelimitor:=$theEnvelope->{$position}
			sSegmentDelimitor:=Char:C90(iSegmentDelimitor)
			Repeat 
				$position:=$position+1
				$endOfISA:=$position
			Until ($theEnvelope->{$position}>13)  //lose the CRLF
			$position:=999  //break
		End if 
	End if 
End for 
//TRACE
$continue:=True:C214
$accountid:=txt_Trim(aISA{6})
$iElementDelim:=Num:C11(EDI_AccountInfo("getEleDelim"; $accountid))
If ($iElementDelim#iElementDelimitor)
	uConfirm("Element delimitor does not match the account setup."; "OK"; "Help")
	$continue:=False:C215
End if 

$iSegmentDelim:=Num:C11(EDI_AccountInfo("getSegDelim"; $accountid))
If ($iSegmentDelim#iSegmentDelimitor)
	uConfirm("Segment delimitor does not match the account setup."; "OK"; "Help")
	$continue:=False:C215
End if 

If ($continue)
	//*      make sure its ours 
	If (Position:C15("ARKAY"; aISA{8})#0) | (Position:C15("1635622"; aISA{8})#0)  //oops, not our message
		//*   Get the Interchange trailer info,
		$count:=0
		For ($position; $length; 0; -1)  //*        rewind to IEA tag's beginning
			$charNumber:=$theEnvelope->{$position}
			If ($charNumber=iElementDelimitor)
				$count:=$count+1
				If ($count=2)  //at the next to last segment end     
					$beginOfIEA:=$position  //here is where IEA trailer starts its data IEA*
					$position:=-1  //break
				End if 
			End if 
		End for 
		//*        Load the trailer
		ARRAY TEXT:C222(aIEA; 2)
		$iElementNumber:=0
		For ($position; $beginOfIEA; $length)  //start at the elementDeliminator
			$charNumber:=$theEnvelope->{$position}
			If ($charNumber#iSegmentDelimitor)
				If ($charNumber=iElementDelimitor)
					$iElementNumber:=$iElementNumber+1
				Else 
					aIEA{$iElementNumber}:=aIEA{$iElementNumber}+Char:C90($charNumber)
				End if 
			Else   //break
				$position:=$length+$position
			End if 
		End for 
		
		If (aISA{13}=aIEA{2})  //*Control numbers match, envelope must be intact  
			//*    Load this sucker into an array    
			C_LONGINT:C283($cursor)
			ARRAY TEXT:C222(aEDI_Tag; 200)  //keep the tags in one array,grab a chunk of ram
			ARRAY TEXT:C222(aEDI_Elements; 200)  //and the data in another
			C_BOOLEAN:C305($getTag)  //keep track of state
			C_POINTER:C301($putText)  //marshal the char stream into either array
			$putText:=->aEDI_Tag  //starting on a GS tag
			$cursor:=1
			$getTag:=True:C214  //only interested in first element delimitor
			For ($position; $endOfISA; $beginOfIEA-1)  //begin on hte segment marker
				$charNumber:=$theEnvelope->{$position}
				Case of 
					: ($charNumber=iSegmentDelimitor)  //tag coming next, so prepare
						$getTag:=True:C214
						$putText:=->aEDI_Tag  //redirect to the tag holding array
						$cursor:=$cursor+1
						While ($theEnvelope->{$position+1}<=13)  //absorb CRLF
							$position:=$position+1
						End while 
						
						If ($cursor>Size of array:C274(aEDI_Tag))  //grow the arrays if necessary
							ARRAY TEXT:C222(aEDI_Tag; Size of array:C274(aEDI_Tag)+100)
							ARRAY TEXT:C222(aEDI_Elements; Size of array:C274(aEDI_Elements)+100)
						End if 
						
					: ($charNumber=iElementDelimitor) & ($getTag)  //tag complete
						$getTag:=False:C215
						$putText:=->aEDI_Elements  //redirect flow into the data array
						
					: (Not:C34(Is nil pointer:C315($putText)))  //not a delimitor, so save the data, including some iElementDelimitor's
						$putText->{$cursor}:=$putText->{$cursor}+Char:C90($charNumber)
						
					Else 
						uConfirm("Unknown character "+Char:C90($charNumber)+" "+String:C10($charNumber); "Better Check Results"; "Help")
						TRACE:C157
				End case 
			End for   //load the arrays
			
			If (Length:C16(aEDI_Tag{$cursor})=0)
				$cursor:=$cursor-1  //last char was a segDelimitor
			End if 
			ARRAY TEXT:C222(aEDI_Tag; $cursor)  //shrink to fit
			ARRAY TEXT:C222(aEDI_Elements; $cursor)  //shrink to fit
			
			//*Verify Count of Group Sections
			//need to see if number of groups match the ic trailer, and that the
			//number of trans sets matches the group trailer, and that the
			//number of segments matches the trans trailer
			EDI_Acknowledge997("New"; aISA{6}; aISA{13})  //*    Prepare an acknowledgement
			$numberOfGroups:=0
			$groupType:=""
			$groupControlNumber:=""
			$numberOfSegments:=0  //start on an ST, end on SE
			$transControlNumber:=""
			$numberOfTranactionSets:=0  //STs
			$exceptions:=""
			For ($i; 1; $cursor)  //check the intire array
				//read the tag
				$tag:=aEDI_Tag{$i}
				Case of 
					: ($tag="GS")  //begining of group
						$numberOfGroups:=$numberOfGroups+1
						$errMsg:=util_TextParser(8; aEDI_Elements{$i}; iElementDelimitor; iSegmentDelimitor)
						
						$Type:=util_TextParser(1)
						$groupControlNumber:=util_TextParser(6)
						$errMsg:=util_TextParser  //destroy
						EDI_Acknowledge997("StartGroup"; $Type; $groupControlNumber)
						
					: ($tag="GE")  //end of group
						$errMsg:=util_TextParser(3; aEDI_Elements{$i}; iElementDelimitor; iSegmentDelimitor)
						If ($numberOfTranactionSets#Num:C11(util_TextParser(1)))
							$exceptions:=$exceptions+", missing transaction set"
							$isOK:="R"
						Else 
							$isOK:="A"
						End if 
						
						If (util_TextParser(2)#$groupControlNumber)
							$exceptions:=$exceptions+", group control"
							$isOK:="R"
						End if 
						$errMsg:=util_TextParser  //destroy
						$numberOfTranactionSets:=0  //reinit trans counter
						EDI_Acknowledge997("CloseGroup"; $isOK)
						
					: ($tag="ST")
						$numberOfTranactionSets:=$numberOfTranactionSets+1
						$numberOfSegments:=1  //inclusive
						$errMsg:=util_TextParser(3; aEDI_Elements{$i}; iElementDelimitor; iSegmentDelimitor)
						$Type:=util_TextParser(1)
						$transControlNumber:=util_TextParser(2)
						$errMsg:=util_TextParser  //destroy
						EDI_Acknowledge997("StartXaction"; $Type; $transControlNumber)
						
					: ($tag="SE")
						$numberOfSegments:=$numberOfSegments+1  //inclusive
						$errMsg:=util_TextParser(3; aEDI_Elements{$i}; iElementDelimitor; iSegmentDelimitor)
						If (util_TextParser(2)#$transControlNumber)
							$exceptions:=$exceptions+", trans control"
							$isOK:="R"
						Else 
							$isOK:="A"
						End if 
						If ($numberOfSegments#Num:C11(util_TextParser(1)))
							$exceptions:=$exceptions+", missing segments"
							$isOK:="R"
						End if 
						$numberOfSegments:=0
						$errMsg:=util_TextParser  //destroy
						EDI_Acknowledge997("CloseXaction"; $isOK)
						
					Else   //count the segments
						$numberOfSegments:=$numberOfSegments+1
				End case 
			End for   //each tag
			
			If ($numberOfGroups#Num:C11(aIEA{1}))
				$exceptions:=$exceptions+", missing groups"
				EDI_Acknowledge997("Revise"; "AK9@"; "R"; 0; 2)  //rowoffset;element#
			End if 
			
			If (Length:C16($exceptions)=0)  //*Send message to a Specific Mapper   
				$account:=EDI_AccountInfo("getAcctName"; $accountid)
				tICN:=aISA{13}
				$0:=EDI_Map_X12
				EDI_Acknowledge997("Send")  //put in out box
				
				//finally, add a call to update the new records with AMS
				//EDR_Commit 
			Else 
				uConfirm("Msg corrupt: "+$exceptions; "Abort"; "Help")
				TRACE:C157
				$0:=-20031
			End if 
			
		Else 
			uConfirm("control number failure between header and trailer"+aISA{13}+" v "+aIEA{2}; "Abort"; "Help")
			$0:=-25005
		End if 
		
	Else 
		uConfirm("edi message wasn't for us"; "Abort"; "Help")
		$0:=-25004
	End if 
End if   //proper delimitors  