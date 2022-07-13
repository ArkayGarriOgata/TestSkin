// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 9/18/02  15:04
// ----------------------------------------------------
// Method: [Job_Forms].Input.Button6
// ----------------------------------------------------

C_LONGINT:C283($errCode; $i)
C_TEXT:C284($jobform; <>jobform)

$jobform:=Replace string:C233(<>jobform; "."; "")

If (Length:C16($jobform)=7)
	ARRAY TEXT:C222($aVolumes; 0)
	
	VOLUME LIST:C471($aVolumes)
	$hit:=Find in array:C230($aVolumes; "Layout Pdf")
	If ($hit>-1)
		JBNSubFormRatio
		If (Size of array:C274(aSubForm)=1)
			aSubForm{1}:=1
		End if 
		
		For ($i; 1; Size of array:C274(aSubForm))
			$path:="Layout Pdf:"+$jobform+String:C10($i; "00")+".pdf"
			zwStatusMsg("Launch"; $path)
			$errCode:=util_Launch_External_App($path)
			Case of 
				: ($errCode=-43)
					uConfirm("Layout for "+<>jobform+"'s Subform: "+String:C10($i; "00")+" is not available, contact Imaging."; "Continue"; "Abort")
					If (ok=0)
						$i:=$i+Size of array:C274(aSubForm)
					End if 
				: ($errCode#0)
					uConfirm("Error# "+String:C10($errCode)+" occurred opening"+$path+" contact Systems."; "Continue"; "Abort")
					If (ok=0)
						$i:=$i+Size of array:C274(aSubForm)
					End if 
			End case 
		End for 
		
		zwStatusMsg("Launch"; "Finished attempting "+String:C10(Size of array:C274(aSubForm))+" documents")
		
	Else 
		uConfirm("Connect to 192.168.4.50[VA]192.168.2.50[NY](viewer:view), and mount 'Layout Pdf'"; "OK"; "Help")
	End if 
	
Else 
	uConfirm("Jobform: '"+$jobform+"' is not the correct number of characters."; "OK"; "Help")
End if 