//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/27/09, 15:37:06
// ----------------------------------------------------
// Method: ADDR_CrossIndexLauder(GET_AMS|GET_EL;lookup)->crossindex
// ----------------------------------------------------

C_TEXT:C284($0; $1; $2; $errMsg; $ams_id; $lauder_id; $leadtime)
C_TEXT:C284($3)
C_TIME:C306($docRef)

Case of 
	: (Count parameters:C259=0)
		READ ONLY:C145([Addresses:30])
		QUERY:C277([Addresses:30]; [Addresses:30]Lauder_ID:41#"")
		SELECTION TO ARRAY:C260([Addresses:30]ID:1; address_AMS; [Addresses:30]Lauder_ID:41; address_EL)
		REDUCE SELECTION:C351([Addresses:30]; 0)
		For ($address; 1; Size of array:C274(address_AMS))  //commas can be used for multiple el codes using an ams code
			$comma:=Position:C15(","; address_EL{$address})
			While ($comma>0)  //add and element
				$key:=Substring:C12(address_EL{$address}; 1; ($comma-1))
				APPEND TO ARRAY:C911(address_EL; $key)
				APPEND TO ARRAY:C911(address_AMS; address_AMS{$address})  //value
				address_EL{$address}:=Substring:C12(address_EL{$address}; ($comma+1))
				$comma:=Position:C15(","; address_EL{$address})
			End while 
		End for 
		
		$0:=String:C10(Size of array:C274(address_AMS))+" addresses"
		
	: ($1="GET_AMS")
		$hit:=Find in array:C230(address_EL; $2)
		If ($hit>-1)
			$0:=address_AMS{$hit}
		Else 
			$0:="n/f"
		End if 
		
	: ($1="GET_EL")
		$hit:=Find in array:C230(address_AMS; $2)
		If ($hit>-1)
			$0:=address_EL{$hit}
		Else 
			$0:="n/f"
		End if 
		
	: ($1="GET_SPL")
		//QUERY([Addresses];[Addresses]edi_NAD=$3)
		//If (Records in selection([Addresses])=0)  `first time seen
		CREATE RECORD:C68([Addresses:30])
		[Addresses:30]ID:1:=app_set_id_as_string(Table:C252(->[Addresses:30]))
		[Addresses:30]Active:12:=True:C214
		[Addresses:30]zCount:18:=1
		[Addresses:30]Notes:13:="Created by ADDR_CrossIndexLauder"
		[Addresses:30]edi_NAD:43:=$3  //UK HUB:Fulfood Road:Havant, HA PO0 5AX GB
		[Addresses:30]edi_Send_ASN:42:=True:C214
		[Addresses:30]Lauder_ID:41:=$2  //1550 or 1560
		[Addresses:30]TransLeadDays:38:=4
		[Addresses:30]ModDate:19:=4D_Current_date
		[Addresses:30]ModWho:20:=<>zResp
		$nad_string:=[Addresses:30]edi_NAD:43
		$colon:=Position:C15(":"; $nad_string)
		[Addresses:30]Name:2:=Substring:C12($nad_string; 1; $colon-1)  //UK HUB
		$nad_string:=Substring:C12($nad_string; $colon+1)  //Fulfood Road:Havant, HA PO0 5AX GB
		$colon:=Position:C15(":"; $nad_string)
		[Addresses:30]Address1:3:=Substring:C12($nad_string; 1; $colon-1)  //Fulfood Road
		$nad_string:=Substring:C12($nad_string; $colon+1)  //Havant, HA PO0 5AX GB
		$colon:=Position:C15(","; $nad_string)
		[Addresses:30]City:6:=Substring:C12($nad_string; 1; $colon-1)  //Havant
		$nad_string:=Substring:C12($nad_string; $colon+2)  //HA PO0 5AX GB
		$colon:=Position:C15(":"; $nad_string)
		If ($colon=0)  //PA 19007 looks domestic
			$colon:=Position:C15(" "; $nad_string)
			[Addresses:30]State:7:=Substring:C12($nad_string; 1; $colon-1)  //PA or HA
			$nad_string:=Substring:C12($nad_string; $colon+1)  //19007 or PO0 5AX GB
			$colon:=Position:C15(" "; $nad_string)
			If ($colon=0)  //19007
				[Addresses:30]Zip:8:=$nad_string
			Else   //PO0 5AX GB
				[Addresses:30]Zip:8:=Substring:C12($nad_string; 1; $colon)  //PO0 
				$nad_string:=Substring:C12($nad_string; $colon+1)  //5AX GB
				$colon:=Position:C15(" "; $nad_string)
				[Addresses:30]Zip:8:=[Addresses:30]Zip:8+Substring:C12($nad_string; 1; $colon-1)  //5AX
				[Addresses:30]Country:9:=Substring:C12($nad_string; $colon+1)  //GB
			End if 
			
		Else   //ONTARIO:CANADA M1S3K9
			[Addresses:30]State:7:=Substring:C12($nad_string; 1; $colon-1)  //ONTARIO
			$nad_string:=Substring:C12($nad_string; $colon+1)
			$colon:=Position:C15(" "; $nad_string)
			[Addresses:30]Country:9:=Substring:C12($nad_string; 1; $colon-1)  //CANADA
			[Addresses:30]Zip:8:=Substring:C12($nad_string; $colon+1)  //M1S3K9
		End if 
		SAVE RECORD:C53([Addresses:30])
		//End if 
		APPEND TO ARRAY:C911(address_EL; [Addresses:30]Lauder_ID:41)
		APPEND TO ARRAY:C911(address_AMS; [Addresses:30]ID:1)  //value
		
		$0:=[Addresses:30]ID:1
		UNLOAD RECORD:C212([Addresses:30])
		
	: ($1="LOAD")
		READ WRITE:C146([Addresses:30])
		$docRef:=Open document:C264("")
		
		If ($docRef#?00:00:00?)
			
			RECEIVE PACKET:C104($docRef; $line; Char:C90(13))
			While (OK=1)
				$errMsg:=util_TextParser(3; $line)
				$ams_id:=util_TextParser(1)
				$lauder_id:=util_TextParser(2)
				$leadtime:=util_TextParser(3)
				QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$ams_id)
				If (Records in selection:C76([Addresses:30])=1)
					[Addresses:30]Lauder_ID:41:=$lauder_id+","+[Addresses:30]Lauder_ID:41
					[Addresses:30]TransLeadDays:38:=Num:C11($leadtime)
					SAVE RECORD:C53([Addresses:30])
				End if 
				RECEIVE PACKET:C104($docRef; $line; Char:C90(13))
				
			End while 
			
			UNLOAD RECORD:C212([Addresses:30])
			
		End if   //open doc
		
		CLOSE DOCUMENT:C267($docRef)
End case 