//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 365)
If ($err=0)
	//If (Records in selection([JobMasterLog])=1)
	//If ([JobMasterLog]MAD=!00/00/00!)
	//[JobMasterLog]MAD:=[JobForm]NeedDate
	//SAVE RECORD([JobMasterLog])
	//End if 
	//End if 
End if 