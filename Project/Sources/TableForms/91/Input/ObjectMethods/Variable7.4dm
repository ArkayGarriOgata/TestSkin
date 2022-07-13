Case of 
	: (sJobit="")
	: (sJobit="TRANSFER")
	: (sJobit="Roanoke")
		
	Else   //validate jobform
		sJobform:=Substring:C12(sJobit; 1; 8)
		READ ONLY:C145([Job_Forms:42])
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sJobform)
		If (Records in selection:C76([Job_Forms:42])#1)
			uConfirm(sJobform+" was not found."; "Try again"; "Help")
			sJobit:=""
			GOTO OBJECT:C206(sJobit)
		End if 
End case 
