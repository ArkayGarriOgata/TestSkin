//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/09/10, 15:25:57
// ----------------------------------------------------
// Method: Jobform_print_layout_pdf(jobform)
// Description
// based on script under the Show Layout PDF on the ebag
// attempt to print the layout on Mac, or just open on Windows
// ----------------------------------------------------

C_LONGINT:C283($errCode; $i)
C_TEXT:C284($jobform; $1)
ARRAY LONGINT:C221(aSubForm; 0)

$jobform:=Replace string:C233($1; "."; "")
$numItems:=qryJMI($1+"@")
JBNSubFormRatio

If (Length:C16($jobform)=7)
	//ARRAY TEXT($aVolumes;0)
	//VOLUME LIST($aVolumes)
	//$hit:=Find in array($aVolumes;"Layout Pdf")
	If (util_MountNetworkDrive("Layout PDF"))  //($hit>-1)
		If (Size of array:C274(aSubForm)=1)
			aSubForm{1}:=1
		End if 
		
		C_TEXT:C284($stdin; $stdout; $stderr)
		$stdin:=""  //not used
		$stdout:=""  //not used
		$stderr:=""
		
		For ($i; 1; Size of array:C274(aSubForm))
			If (<>DELIMITOR=":")  //mac
				$path:="/Volumes/Layout\\ PDF/"+$jobform+String:C10($i; "00")+".pdf"
				zwStatusMsg("OPEN PDF"; $path)
				LAUNCH EXTERNAL PROCESS:C811("open "+$path; $stdin; $stdout; $stderr)
			Else 
				If (Length:C16(<>LayoutPDF_Volume)=0)
					<>LayoutPDF_Volume:=Select folder:C670("Find the Layout PDF Volume")
				End if 
				If (Length:C16(<>AdobeAcrobat)=0)
					<>AdobeAcrobat:=Select document:C905(""; "exe"; "Find the Adobe Acrobat"; Multiple files:K24:7)
				End if 
				$doc:=$jobform+String:C10($i; "00")+".pdf"
				zwStatusMsg("OPEN PDF"; $doc+" with "+<>AdobeAcrobat)
				LAUNCH EXTERNAL PROCESS:C811(<>AdobeAcrobat+" "+<>LayoutPDF_Volume+"\\"+$doc; $stdin; $stdout; $stderr)
			End if 
			If (Length:C16($stderr)>0)
				ALERT:C41("Error: "+$stderr)
			End if 
		End for 
		zwStatusMsg("Launch"; "Finished attempting "+String:C10(Size of array:C274(aSubForm))+" documents"+" "+$stderr)
		
	Else 
		uConfirm("Connect to 192.168.4.50[VA]192.168.2.50[NY](viewer:view), and mount 'Layout Pdf'"; "I knew that")
	End if 
	
Else 
	uConfirm("Jobform: '"+$jobform+"' is not the correct number of characters."; "I knew that")
End if 