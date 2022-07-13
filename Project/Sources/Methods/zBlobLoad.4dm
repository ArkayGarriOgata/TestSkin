//%attributes = {}
//Method: zBlobLoad({path;timestamp;outbox switch)    MLB
//put a document into a blob record

C_TEXT:C284($1)  //path
C_LONGINT:C283($2)  //timestamp
C_TEXT:C284($3)  //outbox switch
C_POINTER:C301($4)
C_LONGINT:C283($0)
C_TIME:C306($docRef)
C_BLOB:C604(theBlob)
SET BLOB SIZE:C606(theBlob; 0)
C_TEXT:C284($tPath)

$0:=-1

If (Count parameters:C259=4)
	theBlob:=$4->
	ok:=1
	$tPath:=$1
Else 
	If (Count parameters:C259=0)
		$docRef:=Open document:C264("")
	Else 
		$docRef:=Open document:C264($1)
	End if 
	$tPath:=Document
End if 

If (ok=1)
	If (Count parameters:C259<4)
		CLOSE DOCUMENT:C267($docRef)
		DOCUMENT TO BLOB:C525(Document; theBlob)
	End if 
	
	If (ok=1)
		If (Count parameters:C259<3)
			CREATE RECORD:C68([edi_Inbox:154])
			[edi_Inbox:154]ID:1:=Sequence number:C244([edi_Inbox:154])
			//[Inbox]Path:=Document
			[edi_Inbox:154]Path:2:=$tPath
			[edi_Inbox:154]Content:3:=theBlob
			[edi_Inbox:154]Date_Received:9:=Current date:C33
			
			If (Count parameters:C259=2)
				If ($2#0)
					[edi_Inbox:154]Received:5:=$2
				Else 
					[edi_Inbox:154]Received:5:=TSTimeStamp
				End if 
			Else 
				[edi_Inbox:154]Received:5:=TSTimeStamp
			End if 
			SAVE RECORD:C53([edi_Inbox:154])
			
			If (Count parameters:C259=0)
				ALL RECORDS:C47([edi_Inbox:154])
				ORDER BY:C49([edi_Inbox:154]; [edi_Inbox:154]Received:5; <)
			Else 
				REDUCE SELECTION:C351([edi_Inbox:154]; 0)
			End if 
			
		Else 
			CREATE RECORD:C68([edi_Outbox:155])
			[edi_Outbox:155]ID:1:=Sequence number:C244([edi_Outbox:155])
			[edi_Outbox:155]Path:2:=Document
			[edi_Outbox:155]Content:3:=theBlob
			[edi_Outbox:155]Subject:5:=Document
			SAVE RECORD:C53([edi_Outbox:155])
		End if 
		
		$fileName:=HFSShortName(Document)
		util_deleteDocument(<>tempFolderPath+$fileName)
		MOVE DOCUMENT:C540(Document; <>tempFolderPath+$fileName)
		
		$0:=0
		
	Else 
		$0:=-2
		uConfirm("Couldn't read "+Document; "OK"; "Help")
	End if 
	
End if   //opened document