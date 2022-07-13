//OM: bShow() -> 
//@author mlb - 9/18/02  15:04
//◊jobform:="80669.01"

// Modified by: Garri Ogata (10/22/21) - added option to check alias users (shift down)
//   leave it this way until we can be certain it works correctly.

If (Shift down:C543)  //New
	
	If (True:C214)  //Initialize
		
		Compiler_0000_ConstantsToDo
		
		C_LONGINT:C283($nSubForm; $nNumberOfSubforms)
		C_TEXT:C284($tJobform; $tPathName)
		C_BOOLEAN:C305($bNetworkDrive)
		C_OBJECT:C1216($oAlert)
		
		$tJobform:=Replace string:C233(<>jobform; CorektPeriod; CorektBlank)
		
		$tNetworkDriveName:="Layout PDF"
		$tNetworkDrive:=$tNetworkDriveName
		
		$nNumberOfSubforms:=Size of array:C274(aSubForm)
		
		If ($nNumberOfSubforms=1)
			aSubForm{1}:=1
		End if 
		
		$oAlert:=New object:C1471()
		
	End if   //Done initialize
	
	Case of   //Verify
			
		: (Length:C16($tJobform)#7)
			
			$oAlert.tMessage:="Jobform: "+$tJobform+"' is not 7 characters."
			Core_Dialog_Alert($oAlert)
			
		: (Not:C34(util_MountNetworkDrive($tNetworkDriveName)))
			
			$oAlert.tMessage:="Connect to 192.168.4.50 [VA] or 192.168.2.50 [NY](viewer:view), and mount 'Layout Pdf'"
			Core_Dialog_Alert($oAlert)
			
		Else   //Open PDF
			
			For ($nSubForm; 1; $nNumberOfSubforms)  //Subform
				
				$tPathName:="/Volumes/Layout\\ PDF/"+$tJobform+String:C10($nSubForm; "00")+".pdf"
				
				Core_Document_OpenPdf($tPathName)
				
			End for   //Done subform
			
	End case   //Done Verify
	
Else   //Old
	
	C_LONGINT:C283($errCode; $i)
	C_TEXT:C284($jobform; <>jobform)
	$jobform:=Replace string:C233(<>jobform; "."; "")
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
	
End if   //Done alias users

