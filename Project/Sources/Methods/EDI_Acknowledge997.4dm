//%attributes = {}
//Method: EDI_Acknowledge997(message{;str_params;optparams;row offset;field}) ->
//returns 0 if no errors 102798 MLB
//•110998  MLB  make sure ST02's length is 4/9
//•021202  MLB $eol:=Char(10)  `else we get an ISA !=106 error for Chanel
//•021202  MLB looks like outgoing seg delim is different than incoming

//build an acknowledgement message, sample:  
//ISA*0**0**ZZ*ARKAYP*ZZ*STPAVON*981014*1710*U*304*000000060*0*P*:!
//              from                 to        date       time   seq      ver
//GS*FA*301906099*STPAVON*981014*1710*32*X*3040!
//ST*997*0001!
//AK1*PO*128!  `   group start
//AK2*850*1407!  `    trans start
//AK5*A!    `accept trans action 1407
//AK2*850*1408!`    trans start
//AK5*A!  `accept transaction 1408
//AK9*A*2*2*2!  `accept group  128, with 2 set, rec'd 2 sets, accepted 2 sets
//SE*8*0001!  
//GE*1*32!
//IEA*1*000000060!

//*997 Acknoledgement
//*   Public Interface

C_TEXT:C284($1; $2; $3)
C_LONGINT:C283($0; $err; edi_ack_cursor; $4; $5; edi_ack_NumbSets; edi_ack_RcvdSets; edi_ack_AcptSets; $params; $row; $i)
C_TEXT:C284(edi_ack_segDelim; edi_ack_eleDelim)
C_TEXT:C284(edi_msg)

$0:=-30000  // return closed
$params:=Count parameters:C259

Case of 
	: ($params=0)
		uConfirm("EDI_Acknowledge997 usage error, parameters are required."; "OK"; "Help")
		$0:=-30000
		
	: ($1="New")  //*      New 997
		If ($params>=3)
			edi_ack_to:=txt_Trim($2)
			edi_ack_ichgNum:=$3
			edi_ack_grpNum:=String:C10(EDI_GetNextIDfromPreferences(edi_ack_to))
			edi_ack_transNumber:=String:C10(EDI_GetNextIDfromPreferences("ST_Trans#"))
			If (Num:C11(edi_ack_transNumber)<1000)  //ST002 must be AN 4/9
				edi_ack_transNumber:=String:C10(Num:C11(edi_ack_transNumber); "0000")
			End if 
			
			edi_ack_segDelim:=Char:C90(Num:C11(EDI_AccountInfo("getSegDelim"; edi_ack_to)))
			//edi_ack_segDelim:=Char(126)  `•021202  MLB looks like outgoing seg delim is diff
			edi_ack_eleDelim:=Char:C90(Num:C11(EDI_AccountInfo("getEleDelim"; edi_ack_to)))
			$version:=EDI_AccountInfo("getSTD_VER"; edi_ack_to)  //004010
			ARRAY TEXT:C222(edi_ack_msg; 0)
			edi_ack_cursor:=Size of array:C274(edi_ack_msg)+2
			INSERT IN ARRAY:C227(edi_ack_msg; edi_ack_cursor; 2)
			edi_ack_msg{edi_ack_cursor-1}:="GS*FA*ARKAYP*"+edi_ack_to+"*"+fYYMMDD(4D_Current_date; 4)+"*"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+"*"+edi_ack_grpNum+"*X*"+$version+edi_ack_segDelim
			edi_ack_msg{edi_ack_cursor}:="ST*997*"+edi_ack_transNumber+edi_ack_segDelim
			edi_ack_segCnt:=1
			$0:=0
		Else 
			uConfirm("EDI_Acknowledge997:"+$1+" usage error, parameter count is incorrect."; "OK"; "Help")
			$0:=-30003
		End if 
		
	: ($1="StartGroup")  //*      Start Func Group
		If ($params>=3)
			edi_ack_NumbSets:=0
			edi_ack_RcvdSets:=0
			edi_ack_AcptSets:=0
			$groupType:=$2
			$groupNumber:=$3
			edi_ack_cursor:=Size of array:C274(edi_ack_msg)+1
			INSERT IN ARRAY:C227(edi_ack_msg; edi_ack_cursor; 1)
			edi_ack_msg{edi_ack_cursor}:="AK1*"+$groupType+"*"+$groupNumber+edi_ack_segDelim
			edi_ack_segCnt:=edi_ack_segCnt+1
			$0:=0
		Else 
			uConfirm("EDI_Acknowledge997:"+$1+" usage error, parameter count is incorrect."; "OK"; "Help")
			$0:=-30004
		End if 
		
	: ($1="CloseGroup")  //*      Close Func Group
		If ($params>=2)
			$isAccepted:=$2
			edi_ack_cursor:=Size of array:C274(edi_ack_msg)+1
			INSERT IN ARRAY:C227(edi_ack_msg; edi_ack_cursor; 1)
			edi_ack_msg{edi_ack_cursor}:="AK9*"+$isAccepted+"*"+String:C10(edi_ack_NumbSets)+"*"+String:C10(edi_ack_RcvdSets)+"*"+String:C10(edi_ack_AcptSets)+edi_ack_segDelim
			edi_ack_segCnt:=edi_ack_segCnt+1
			$0:=0
		Else 
			uConfirm("EDI_Acknowledge997:"+$1+" usage error, parameter count is incorrect."; "OK"; "Help")
			$0:=-30005
		End if 
		
	: ($1="StartXaction")  //*      Start Transaction
		If ($params>=3)
			edi_ack_NumbSets:=edi_ack_NumbSets+1
			edi_ack_RcvdSets:=edi_ack_RcvdSets+1
			$docType:=$2
			$transNumber:=$3
			edi_ack_cursor:=Size of array:C274(edi_ack_msg)+1
			INSERT IN ARRAY:C227(edi_ack_msg; edi_ack_cursor; 1)
			edi_ack_msg{edi_ack_cursor}:="AK2*"+$docType+"*"+$transNumber+edi_ack_segDelim
			edi_ack_segCnt:=edi_ack_segCnt+1
			$0:=0
		Else 
			uConfirm("EDI_Acknowledge997:"+$1+" usage error, parameter count is incorrect."; "OK"; "Help")
			$0:=-30006
		End if 
		
	: ($1="CloseXaction")  //*      Close Transaction
		If ($params>=2)
			$isAccepted:=$2
			If ($isAccepted="A")
				edi_ack_AcptSets:=edi_ack_AcptSets+1
			End if 
			edi_ack_cursor:=Size of array:C274(edi_ack_msg)+1
			INSERT IN ARRAY:C227(edi_ack_msg; edi_ack_cursor; 1)
			edi_ack_msg{edi_ack_cursor}:="AK5*"+$isAccepted+edi_ack_segDelim
			edi_ack_segCnt:=edi_ack_segCnt+1
			$0:=0
		Else 
			uConfirm("EDI_Acknowledge997:"+$1+" usage error, parameter count is incorrect."; "OK"; "Help")
			$0:=-30007
		End if 
		
	: ($1="Revise")  //*      Revise
		If ($params>=5)
			$lookFor:=$2
			$i:=Find in array:C230(edi_ack_msg; $lookFor)
			If ($i>-1)
				$row:=$i+$4
				If ($row<=Size of array:C274(edi_ack_msg))
					$was:=edi_ack_msg{$row}
					edi_ack_msg{$row}:=util_TextSetField($5; $was; $3; iElementDelimitor; iSegmentDelimitor)
				End if 
			End if 
			$0:=0
		Else 
			uConfirm("EDI_Acknowledge997:"+$1+" usage error, parameter count is incorrect."; "OK"; "Help")
			$0:=-30008
		End if 
		
	: ($1="Send")  //*      Send
		utl_Trace
		If (EDI_AccountInfo("getACK"; edi_ack_to)="YES")
			$edi_acctname:=EDI_AccountInfo("getAcctName"; edi_ack_to)
			edi_ack_segCnt:=edi_ack_segCnt+1
			edi_ack_cursor:=Size of array:C274(edi_ack_msg)+2
			INSERT IN ARRAY:C227(edi_ack_msg; edi_ack_cursor; 2)
			edi_ack_msg{edi_ack_cursor-1}:="SE*"+String:C10(edi_ack_segCnt)+"*"+edi_ack_transNumber+edi_ack_segDelim
			edi_ack_msg{edi_ack_cursor}:="GE*1*"+edi_ack_grpNum+edi_ack_segDelim
			edi_msg:=""
			C_TEXT:C284($eol)
			If (Position:C15(Char:C90(13); edi_ack_segDelim)=0)
				//$eol:=Char(10)  `else we get an ISA !=106 error for Chanel
				$eol:=""
			Else 
				$eol:=Char:C90(13)+Char:C90(10)
			End if 
			For ($i; 1; Size of array:C274(edi_ack_msg))
				If (edi_ack_eleDelim#"*")
					edi_ack_msg{$i}:=Replace string:C233(edi_ack_msg{$i}; "*"; edi_ack_eleDelim)
				End if 
				edi_msg:=edi_msg+edi_ack_msg{$i}+$eol
			End for 
			
			$err:=EDI_NewEnvelope(->edi_msg; "ARKAYP"; edi_ack_to; String:C10(Num:C11(edi_ack_grpNum); "000000000"))
			If ($err=0)
				CREATE RECORD:C68([edi_Outbox:155])
				[edi_Outbox:155]ID:1:=Sequence number:C244([edi_Outbox:155])
				[edi_Outbox:155]Path:2:="ACK997_"+edi_ack_transNumber+".temp"
				SET BLOB SIZE:C606([edi_Outbox:155]Content:3; 0)
				TEXT TO BLOB:C554(edi_msg; [edi_Outbox:155]Content:3; UTF8 text without length:K22:17)
				[edi_Outbox:155]SentTimeStamp:4:=0
				[edi_Outbox:155]Subject:5:="997 Ack:"+edi_ack_transNumber+" for IC#"+edi_ack_ichgNum+" to "+edi_ack_to
				[edi_Outbox:155]CrossReference:6:=edi_ack_ichgNum
				[edi_Outbox:155]Com_AccountName:7:=$edi_acctname
				SAVE RECORD:C53([edi_Outbox:155])
				REDUCE SELECTION:C351([edi_Outbox:155]; 0)
				$0:=0
				
			Else 
				uConfirm("Could not put the Acknowledgement into the Outbox."+Char:C90(13)+String:C10($err); "OK"; "Help")
				$0:=-30002
			End if 
		End if   //ack required      
		
	Else 
		uConfirm("Method:'"+$1+"' not understood."; "OK"; "Help")
		$0:=-30001
End case 