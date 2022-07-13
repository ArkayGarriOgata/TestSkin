//%attributes = {}
// -------
// Method: FG_ArtProPath   (msg{;docpath} ) -> path
// By: Mel Bohince @ 07/13/16, 16:41:01
// Description
// get or set the document path for an artpro file saved in the fg record's notes field
// ----------------------------------------------------
// Modified by: Mel Bohince (8/25/16) clear prior before setting

C_LONGINT:C283($hit; $end; $start; $err)
C_TEXT:C284($path; $test)

Case of 
	: ($1="get")
		$path:=""
		$save:=True:C214
		$hit:=Position:C15("<ArtPro>"; [Finished_Goods:26]ArtWorkNotes:60)
		If ($hit>0)
			$start:=$hit+8
			$hit:=Position:C15("</ArtPro>"; [Finished_Goods:26]ArtWorkNotes:60)
			If ($hit>0)
				$end:=$hit-$start
				$path:=Substring:C12([Finished_Goods:26]ArtWorkNotes:60; $start; $end)
				$save:=False:C215
			End if 
		End if 
		$0:=$path
		
	: ($1="clear")  // Modified by: Mel Bohince (8/25/16) 
		$test:=[Finished_Goods:26]ArtWorkNotes:60  //"1234<ArtPro>abcd</ArtPro>5678<ArtPro>efgh</ArtPro>90123"
		//try cutting out the tags
		Repeat 
			
			$start:=Position:C15("<ArtPro>"; $test)-1
			If ($start>-1)  //beginning tag exists
				
				$hit:=Position:C15("</ArtPro>"; $test)
				If ($hit>0)  //ending tag found
					$end:=$hit+9  //length of tag
					$front:=Substring:C12($test; 0; $start)  //everything up to the beginning tag
					$back:=Substring:C12($test; $end)  //everything after the ending tag
					$test:=$front+$back  //concatenate
					
				Else   //skip if no ending tag found
					$start:=-1  //bail w/o changing
				End if 
				
			End if 
			
		Until ($start=-1)
		
		Repeat 
			$test:=Replace string:C233($test; "\r\r"; "\r")
			$doubleReturn:=Position:C15("\r\r"; $test)
		Until ($doubleReturn=0)
		
		$0:=$test
		
	: ($1="set")
		If (Count parameters:C259<2)
			$path:=""
		Else 
			$path:=$2
		End if 
		
		$test:=FG_ArtProPath("clear")  // Modified by: Mel Bohince (8/25/16) clear out priors before adding
		
		[Finished_Goods:26]ArtWorkNotes:60:=$test+"\r<ArtPro>"+$path+"</ArtPro>\r"
		SAVE RECORD:C53([Finished_Goods:26])
		$0:=$path
		
	: ($1="view")
		If (util_MountNetworkDrive("Job Files"))  //($continue>-1)
			$path:=FG_ArtProPath("get")
			If (Length:C16($path)>10)
				C_TIME:C306($docRef)
				$docRef:=Open document:C264($path; "*"; Read mode:K24:5)
				If (ok=1)
					CLOSE DOCUMENT:C267($docRef)
					$err:=util_Launch_External_App(document)
					zwStatusMsg("ArtPro Link"; "Viewing: "+document)
					
				Else 
					ALERT:C41("Couldn't open path= "+$path)
				End if 
				
			Else 
				ALERT:C41("Couldn't determine which Artpro file to open.")
			End if 
			
		Else 
			ALERT:C41("Couldn't open the Job Files folder.")
		End if   //mounted volume
		
		
	Else 
		BEEP:C151
End case 
