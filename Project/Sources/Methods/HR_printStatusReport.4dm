//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/10/05, 15:40:48
// ----------------------------------------------------
// Method: HR_printStatusReport
// ----------------------------------------------------

C_PICTURE:C286(signature1; signature2; signature3; signature4)
C_POINTER:C301($sigPointer)

HR_getSignaturePicture
While (Size of array:C274(<>UserInitials)=0)
	DELAY PROCESS:C323(Current process:C322; 30)
End while 

zwStatusMsg("Printing"; "Status Change Report")

Case of 
	: ([Users:5]StatusChange:43=0)
		//ALERT("ok to print, with signatures")
		$useSignatures:=txt_Trim([Users:5]LastApprovers:57)
	: ([Users:5]StatusChange:43=1)
		//ALERT("print proposed form")
	: ([Users:5]StatusChange:43=2)
		//ALERT("print proposed form, with no or partial signatures")
		$useSignatures:=txt_Trim([Users:5]ApprovedBy:45)
	: ([Users:5]StatusChange:43=3)
		//ALERT("ok to print, with signatures")
		$useSignatures:=txt_Trim([Users:5]ApprovedBy:45)
End case 

For ($i; 1; 4)  //each signatureN
	$sigPointer:=Get pointer:C304("signature"+String:C10($i))
	$sigPointer->:=<>nilPicture
	If (Length:C16($useSignatures)>0)
		$space:=Position:C15(" "; $useSignatures)
		If ($space>0)
			$initials:=Substring:C12($useSignatures; 1; $space-1)
			HR_getSignaturePicture($initials; $sigPointer)
			$useSignatures:=Substring:C12($useSignatures; $space+1)
		Else   //is there one more
			If (Length:C16($useSignatures)>0)
				HR_getSignaturePicture($useSignatures; $sigPointer)
				$useSignatures:=""
			End if 
		End if 
	End if 
End for 

zwStatusMsg("Printing"; "Change of Status for "+[Users:5]UserName:11)
FORM SET OUTPUT:C54([Users:5]; "ChangeOfStatus")
PRINT RECORD:C71([Users:5])
FORM SET OUTPUT:C54([Users:5]; "List")

zwStatusMsg("Finished"; "Change of Status for "+[Users:5]UserName:11)