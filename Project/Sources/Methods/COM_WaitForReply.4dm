//%attributes = {}
//Method: COM_WaitForReply(StreamReference;{save multiReplys}) ->text reply 091498
//get the reply from the host

C_TEXT:C284($buffer; $reply)
C_BLOB:C604($bufferBlob; $replyBlob)
C_LONGINT:C283($1; $bytes; $posEOL; $2; $i; $0)
C_LONGINT:C283($err; com_state)
C_BOOLEAN:C305($TimedOut)
SET BLOB SIZE:C606($bufferBlob; 0)
SET BLOB SIZE:C606($replyBlob; 0)

$reply:=""
$buffer:=""
com_state:=0
$TimedOut:=COM_TimeOut(0)  //reset

Repeat 
	$TimedOut:=COM_TimeOut
	
	//$err:=TCP_Receive ($1;$buffer)
	//problem exceeding 32k before
	SET BLOB SIZE:C606($bufferBlob; 0)
	$err:=TCP_ReceiveBLOB($1; $bufferBlob)
	
	$buffer:=BLOB to text:C555($bufferBlob; Mac text without length:K22:10)  //just take what fits for feed back
	com_SessionLog:=com_SessionLog+Replace string:C233($buffer; Char:C90(10); "")  //
	
	//$reply:=$reply+$buffer
	$offset:=BLOB size:C605($replyBlob)  //append blob on replyblob
	COPY BLOB:C558($bufferBlob; $replyBlob; 0; $offset; BLOB size:C605($bufferBlob))
	
	IDLE:C311
	C_BOOLEAN:C305(com_Trace)
	If (com_Trace)
		If (Length:C16($buffer)>0)
			MESSAGE:C88($buffer+"!")  //+Char(13))
		End if 
		If (Length:C16($buffer)>32000)
			MESSAGE:C88("TRUNCATED!")  //+Char(13))
		End if 
	End if 
	
	//$posEOL:=Position(eol;$buffer)  `eol:=Char(13)+Char(10)  `CR +LF
	//If ($posEOL=0)
	//$TimedOut:=COM_TimeOut 
	//End if 
	
	//look for the eol marker in the blob
	$lenBlob:=BLOB size:C605($replyBlob)
	If ($lenBlob>1)
		$charNumberLast:=$replyBlob{$lenBlob-1}
		$charNumberPrior:=$replyBlob{$lenBlob-2}
		$pair:=Char:C90($charNumberPrior)+Char:C90($charNumberLast)
		If ($pair#eol)
			$TimedOut:=COM_TimeOut
			$posEOL:=0
		Else 
			$posEOL:=$lenBlob-2
		End if 
	Else 
		$TimedOut:=COM_TimeOut
	End if 
	
Until (($posEOL>0) | ($TimedOut))

//pack each line of the reply into an array for processing
ARRAY TEXT:C222(com_aReplyBuffer; 0)  //clear last
//$i:=1
//While (Length($reply)>0) & ($posEOL>0)
//ARRAY TEXT(com_aReplyBuffer;$i)
//com_aReplyBuffer{$i}:=Substring($reply;1;$posEOL-1)
//$reply:=Substring($reply;$posEOL+2)
//$posEOL:=Position(eol;$reply)
//$i:=$i+1
//End while 

$i:=1
$lenBlob:=BLOB size:C605($replyBlob)
$textLine:=""
For ($byte; 0; $lenBlob-1)
	Case of 
		: ($replyBlob{$byte}=13)  //CR - end of line found
			APPEND TO ARRAY:C911(com_aReplyBuffer; $textLine)
			$textLine:=""
		: ($replyBlob{$byte}=10)  //ignore FF
			//drop the char
		Else 
			$textLine:=$textLine+Char:C90($replyBlob{$byte})
	End case 
End for 

$textLine:=""

SET BLOB SIZE:C606($bufferBlob; 0)
SET BLOB SIZE:C606($replyBlob; 0)

$0:=Num:C11(Substring:C12(com_aReplyBuffer{Size of array:C274(com_aReplyBuffer)}; 1; 3))