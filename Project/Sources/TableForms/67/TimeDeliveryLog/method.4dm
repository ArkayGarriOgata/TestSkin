Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If ([Job_Forms_Master_Schedule:67]ActualFirstShip:19#!00-00-00!)
			r1:=[Job_Forms_Master_Schedule:67]ActualFirstShip:19-[Job_Forms_Master_Schedule:67]EnterOrderDate:9
			r2:=[Job_Forms_Master_Schedule:67]ActualFirstShip:19-[Job_Forms_Master_Schedule:67]MAD:21
			r3:=[Job_Forms_Master_Schedule:67]ActualFirstShip:19-[Job_Forms_Master_Schedule:67]OrigRevDate:20
			r4:=[Job_Forms_Master_Schedule:67]ActualFirstShip:19-[Job_Forms_Master_Schedule:67]FirstReleaseDat:13
		Else 
			r1:=1/0
			r2:=1/0
			r3:=1/0
			r4:=1/0
		End if 
		
		
End case 
//