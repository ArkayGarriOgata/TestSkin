//%attributes = {}
//Method:  Core_Document_OpenPdf(tFullPathName)
//Description: This method will open a pdf file
// The pathname will look something like:  /Volumes/Layout\\ PDF/163920201.pdf
// Alias accounts for  
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tFullPathname)
	
	C_BOOLEAN:C305($bDone)
	C_LONGINT:C283($nAlias; $nDocumentStart; $nExtension)
	C_TEXT:C284($tDirectory; $tDocument; $tExtension)
	
	C_TEXT:C284($tStdin; $tStdOut; $tStdErr)
	
	C_OBJECT:C1216($oAlert)
	
	$oAlert:=New object:C1471()
	
	$tFullPathname:=$1
	
	$tStdin:=CorektBlank
	$tStdOut:=CorektBlank
	$tStdErr:=CorektBlank
	
	$nExtension:=Position:C15(CorektPeriod; $tFullPathname)
	
	$nAlias:=Choose:C955(($nExtension>0); 0; CoreknMaxAlias+1)
	
	$tExtension:=Core_Document_GetExtensionT($tFullPathname)
	$tDocument:=Core_Document_GetNameT($tFullPathname; Character code:C91("/"))
	
	$nDocumentStart:=Position:C15($tDocument; $tFullPathname)
	$tDirectory:=Substring:C12($tFullPathname; 1; $nDocumentStart-2)
	
End if   //Done initialize

Repeat   //Open
	
	$tStdErr:=CorektBlank
	
	Case of   //Open
			
		: ($nAlias>CoreknMaxAlias)
			
			$bDone:=True:C214
			
		: (Is macOS:C1572)
			
			zwStatusMsg("OPEN PDF"; $tFullPathname)
			
			LAUNCH EXTERNAL PROCESS:C811("open "+$tFullPathname; $tStdin; $tStdOut; $tStdErr)
			
			$bDone:=($tStdErr=CorektBlank)
			
		: (Is Windows:C1573)
			
			If (Length:C16(<>LayoutPDF_Volume)=0)
				<>LayoutPDF_Volume:=Select folder:C670("Find the Layout PDF Volume")
			End if 
			
			If (Length:C16(<>AdobeAcrobat)=0)
				<>AdobeAcrobat:=Select document:C905(""; "exe"; "Find Adobe Acrobat"; Multiple files:K24:7)
			End if 
			
			$tDocument:=$tDocument+CorektPeriod+$tExtension
			
			zwStatusMsg("OPEN PDF"; $tDocument+" with "+<>AdobeAcrobat)
			
			LAUNCH EXTERNAL PROCESS:C811(<>AdobeAcrobat+" "+<>LayoutPDF_Volume+"\\"+$tDocumentt; $stdin; $stdout; $stderr)
			
			$bDone:=($tStdErr=CorektBlank)
			
	End case   //Done open
	
	If (Not:C34($bDone))  //Alias
		
		$nAlias:=$nAlias+1
		
		$tFullPathname:=$tDirectory+CorektDash+String:C10($nAlias)+"/"
		
		$tFullPathname:=$tFullPathname+$tDocument+CorektPeriod+$tExtension
		
	End if   //Done alias
	
Until ($bDone)

If (Length:C16($tStdErr)>0)  //Error
	
	$oAlert.tMessage:="Error: "+$tStdErr
	Core_Dialog_Alert($oAlert)
	
	zwStatusMsg("Launch"; "Was not able to open pdf document "+$tDocument+CorektSpace+$tStdErr)
	
Else 
	
	zwStatusMsg("Launch"; "Finished opening pdf document "+$tDocument)
	
End if   //Done error
