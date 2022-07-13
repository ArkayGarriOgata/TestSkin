//%attributes = {}
//Method: EDI_OpenEnvelope(»BLOB:the EDI file;inboxId;received{;ack only}) ->err 0
//Open EDI envelop, make sure its not empty, init vars and pass off to a verifier
//before passing it off to a specific mapping strategy

C_LONGINT:C283($0; $position; $length; $charNumber)  //return 0 for success
C_BOOLEAN:C305($save)

$0:=-25000  //fail closed
If (Count parameters:C259<4)
	$save:=True:C214
Else 
	$save:=False:C215
End if 
zwStatusMsg("EDI"; "Opening Envelope")
$errText:=ADDR_CrossIndexLauder
$errText:=EDI_AccountInfo("init")
If (OK=1)
	C_POINTER:C301($theEnvelope; $1)
	$theEnvelope:=$1
	C_LONGINT:C283(iReferenceId; $2; iTimeStamp; $3)
	If (Count parameters:C259>=3)
		iReferenceId:=$2
		iTimeStamp:=$3
	Else 
		iReferenceId:=0
		iTimeStamp:=TSTimeStamp
	End if 
	//*Module variables
	C_TEXT:C284(sElementDelimitor; sSegmentDelimitor; sSubElementDelimitor)  //*  delimitors-e.g. ST*850*0001!
	C_LONGINT:C283(iElementDelimitor; iSegmentDelimitor; iSubElementDelimitor)
	iElementDelimitor:=-1
	iSegmentDelimitor:=-1
	iSubElementDelimitor:=-1
	ARRAY TEXT:C222(aISA; 0)  //*  interchange header
	ARRAY TEXT:C222(aIEA; 0)  //*  interchange trailer
	ARRAY TEXT:C222(aEDI_Tag; 0)  //*  keep the tags in one array
	ARRAY TEXT:C222(aEDI_Elements; 0)  //*  and the data in another
	
	//*Make sure envelop isn't empty
	$length:=BLOB size:C605($theEnvelope->)-1
	If ($length>2)  //arbitrarily small, but not empty
		//*Determine which EDI standard is being used
		//by reading the first 3 bytes, to determine the tag
		C_TEXT:C284($signatureTag; $standardUsed)
		$signatureTag:=""
		$standardUsed:=""
		For ($position; 0; 2)
			$charNumber:=$theEnvelope->{$position}
			$signatureTag:=$signatureTag+Char:C90($charNumber)
		End for 
		
		Case of 
			: ($signatureTag="ISA")
				$standardUsed:="X12"
			: ($signatureTag="UNB")
				$standardUsed:="UN/EDIFACT"
			: ($signatureTag="UNA")
				$standardUsed:="UN/EDIFACT"
			: ($signatureTag="LOG")
				$standardUsed:="Log"
			: ($signatureTag=(Char:C90(12)+"--"))
				$standardUsed:="Report"
			: ($signatureTag="220")
				$standardUsed:="Log"
			: (Position:C15("*"; $signatureTag)>0)
				$standardUsed:="Log"
			: ($signatureTag="ITE")
				$standardUsed:="textFile"
			Else 
				$standardUsed:="Unknown"
		End case 
		//*Dispatch to the apropriate verifier
		utl_Trace
		Case of 
			: ($standardUsed="X12")
				//$0:=EDI_VerifyIntegrity_X12 ($theEnvelope)
				If (True:C214)  //($0=0)
					[edi_Inbox:154]ICN:4:="PnG-997"  //aISA{13}
					[edi_Inbox:154]Mapped:6:=997  //TSTimeStamp 
					REDUCE SELECTION:C351([Customers_Orders:40]; 0)
					REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
					//BEEP
				End if 
				
			: ($standardUsed="UN/EDIFACT")
				$0:=EDI_VerifyIntegrity_EDIFACT($theEnvelope)
				If ($0=0)
					[edi_Inbox:154]ICN:4:=aISA{6}
					[edi_Inbox:154]Mapped:6:=TSTimeStamp
					//BEEP
				End if 
				
			: ($standardUsed="Report")
				$standardUsed:="Rpt:"
				For ($position; 4; $length)
					$charNumber:=$theEnvelope->{$position}
					If ($position<7)
						$standardUsed:=$standardUsed+Char:C90($charNumber)
					End if 
					If ($charNumber=Character code:C91("*"))  //indicates error
						$standardUsed:=$standardUsed+Char:C90($charNumber)
						$position:=$position+$length
					End if 
				End for 
				[edi_Inbox:154]ICN:4:=$standardUsed
				[edi_Inbox:154]Date_Received:9:=Current date:C33
				$0:=1
				
			: ($standardUsed="Log")
				[edi_Inbox:154]ICN:4:="Log"
				[edi_Inbox:154]Date_Received:9:=4D_Current_date
				$0:=2
				
			: ($standardUsed="textFile")
				[edi_Inbox:154]ICN:4:=HFSShortName([edi_Inbox:154]Path:2)
				EDI_TextForecast($theEnvelope; [edi_Inbox:154]ICN:4)
				$0:=33
				
			Else 
				BEEP:C151
				//$sent:=EMAIL_Edit("mel.bohince@arkay.com,";"";"";"";"Unknown standard '"+$signatureTag+"'";$standardUsed+" tag: "+$signatureTag;"")
				$0:=-25002
		End case 
		
	Else 
		$0:=-25001
	End if 
	
	ARRAY TEXT:C222(aISA; 0)  //*  interchange header
	ARRAY TEXT:C222(aIEA; 0)  //*  interchange trailer  
	ARRAY TEXT:C222(aEDI_Tag; 0)  //*  keep the tags in one array
	ARRAY TEXT:C222(aEDI_Elements; 0)  //*  and the data in another
Else 
	uConfirm("Problem loading EDI Trading Partners' account information."; "OK"; "Help")
End if 