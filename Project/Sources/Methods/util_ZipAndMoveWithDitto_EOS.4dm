//%attributes = {"executedOnServer":true}
// _______
// Method: util_ZipAndMoveWithDitto_EOS   ({path:obj} ) ->
// By: Mel Bohince @ 04/02/21, 09:52:11
// Description
// Execute on Server property set
// Compress the contents of $pathFrom and move to $pathTo (Dropbox folder)
// then move the contents of $pathFrom and move to $pathToLocal
// ----------------------------------------------------
C_TEXT:C284($configFile; $1)
C_OBJECT:C1216($paths_o)  //param 1 should be an object with a from and to path in system format

If (False:C215)  //test with
	//SETUP (once):
	util_JSON_CreateConfig  //set up config file the first time, run on the server in 4D Mono, will be set in the server's Resource folder
	// then 
	util_ZipAndMoveWithDitto_EOS("config_archive")
End if 

C_TEXT:C284($pathFrom; $pathTo; $arg; $stdin; $stdout; $archiveName; $pathToLocal; $pathFromHFS)
C_LONGINT:C283($stderr; $outerBar; $expectedBkUpSize)

$expectedBkUpSize:=500000000  // used when testing the sent file size and current date
$archiveName:="aMsDailyBku.zip"  //archive's name
//$archiveName:="aMsDailyBku_"+fYYMMDD (4D_Current_date )+"_"+Replace string(String(4d_Current_time ;<>HHMM);":";"")+".zip"  //keep versions

C_BOOLEAN:C305($runningOnClient; $continue)
$runningOnClient:=(Not:C34(Application type:C494=4D Server:K5:6))

$continue:=True:C214

If (Count parameters:C259=1)
	$configFile:=$1
Else 
	$configFile:="config_archive"
End if 

If (Not:C34($runningOnClient))
	
	$paths_o:=util_JSON_ObjFromResourceFolder($configFile)
	If (Not:C34(OB Is defined:C1231($paths_o; "from")))  //"/Users/mel/Desktop/DailyBackupVolume/Daily_4BK4BL"  //4D Backup Configuration location
		$continue:=False:C215
	Else 
		If (Length:C16($paths_o.from)<1)
			$continue:=False:C215
		End if 
	End if 
	
	If (Not:C34(OB Is defined:C1231($paths_o; "to")))  //"/Users/mel/Dropbox/Documents/arkay/"  //local Dropbox target folder
		$continue:=False:C215
	Else 
		If (Length:C16($paths_o.to)<1)
			$continue:=False:C215
		End if 
	End if 
	
	If (Not:C34(OB Is defined:C1231($paths_o; "sent")))  //"/Users/mel/Dropbox/Documents/arkay/Sent"  //local repository
		$continue:=False:C215
	Else 
		If (Length:C16($paths_o.sent)<1)
			$continue:=False:C215
		End if 
	End if 
	
	
Else   //test
	If (False:C215)  //test interactive
		$paths_o:=New object:C1471
		$paths_o.from:=Select folder:C670("Select the local folder that holds the aMs backup files")
		If (ok=1)
			$paths_o.sent:=Select folder:C670("Select the local folder to keep what was sent")
			If (ok=1)
				$paths_o.to:=Select folder:C670("Select the DropBox folder to receive backup")
				If (ok=0)
					$continue:=False:C215
				End if 
			Else 
				$continue:=False:C215
			End if 
			
		Else 
			$continue:=False:C215
		End if 
		
	Else   //not interactive
		$configFile:="config_archive"
		$paths_o:=util_JSON_ObjFromResourceFolder($configFile)
	End if   //testing
	
End if   //params

If ($continue) & ($runningOnClient)  //chance to bail
	CONFIRM:C162("Send\r"+$paths_o.from+"\rto\r "+$paths_o.to+$archiveName+" ?")
	If (ok=0)
		$continue:=False:C215
	End if 
End if 

If ($continue)  //create and send archive to Dropbox
	$pathFrom:=Convert path system to POSIX:C1106($paths_o.from)  //bash scripts need path to be posix
	$pathFrom:=Replace string:C233($pathFrom; " "; "\\ ")  //freaking spaces
	$pathTo:=Convert path system to POSIX:C1106($paths_o.to)
	$pathTo:=Replace string:C233($pathTo; " "; "\\ ")
	
	$arg:=$pathFrom+" "+$pathTo+$archiveName  // this will overwrite the existing archive if exists
	
	//send an archive to Dropbox
	$stdin:=""
	$stdout:=""
	$stderr:=0
	
	If ($runningOnClient)  //takes a couple minutes so show a little feedback to ui
		$outerBar:=Progress New  //new progress bar
		Progress SET TITLE($outerBar; "Sending backup files to Dropbox")
		$barberShop:=-1
		Progress SET PROGRESS($outerBar; $barberShop)  //update the thermometer
		Progress SET MESSAGE($outerBar; "Compressing, takes a couple minutes...")
	End if 
	
	//this take 00:01:31 in testing
	LAUNCH EXTERNAL PROCESS:C811("ditto -c -k --sequesterRsrc --keepParent "+$arg; $stdin; $stdout; $stderr)  // this will overlay existing
	BEEP:C151
	
	If ($runningOnClient)
		Progress SET MESSAGE($outerBar; "Wheeee...")  //next steps are fast
	End if 
	
	C_OBJECT:C1216($poDocumentInfo_o)
	$poDocumentInfo_o:=New object:C1471
	
	$pathToInSystem:=Convert path POSIX to system:C1107($pathTo+$archiveName)
	If (Core_Document_GetInfoB($pathToInSystem; ->$poDocumentInfo_o))  //appears to have transferred
		//test if document is current or prior run and big
		If ($poDocumentInfo_o.dModifiedOn=Current date:C33) & ($poDocumentInfo_o.rSize>$expectedBkUpSize)
			BEEP:C151
			//clean up the from dir and put in a local folder
			
			//$pathFrom:=$pathFrom+"/*"  //get all the files
			//$arg:=$pathFrom+" "+$pathToLocal
			//mv works in terminal, does nothing here with wildcard
			//LAUNCH EXTERNAL PROCESS("mv /Users/mel/Desktop/DailyBackupVolume/Daily_4BK4BL/acuoustiblok.png /Users/mel/Desktop/DailyBackupVolume/Sent";$stdin;$stdout;$stderr)
			//LAUNCH EXTERNAL PROCESS("mv "+$arg;$stdin;$stdout;$stderr)  //wtf?
			
			ARRAY TEXT:C222($documentsToMove; 0)
			DOCUMENT LIST:C474($paths_o.from; $documentsToMove; Ignore invisible:K24:16+Posix path:K24:15)
			
			//set up for shell mv
			$pathToLocal:=Convert path system to POSIX:C1106($paths_o.sent)
			$pathToLocal:=Replace string:C233($pathToLocal; " "; "\\ ")
			
			For ($i; 1; Size of array:C274($documentsToMove))
				//MOVE DOCUMENT($paths_o.from+$documentsToMove{$i};$paths_o.sent)//not working////ok, not going to fight it, do them one at a time with mv
				LAUNCH EXTERNAL PROCESS:C811("mv "+$pathFrom+"/"+$documentsToMove{$i}+" "+$pathToLocal; $stdin; $stdout; $stderr)
			End for 
			
		End if 
	End if   //got file info
	
	If ($runningOnClient)
		Progress QUIT($outerBar)  //remove the thermometer
	End if 
	
End if   //continue, from, to, and sent folders supplied



