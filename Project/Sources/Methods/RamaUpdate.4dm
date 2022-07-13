//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 10/22/12, 13:02:47
// ----------------------------------------------------
// Method: RamaUpdate
// Description:
// If the new Rama PO Number field is empty. Fill it in.
// ----------------------------------------------------

READ WRITE:C146([zz_control:1])
ALL RECORDS:C47([zz_control:1])

If ([zz_control:1]RamaPONum:60="")
	[zz_control:1]RamaPONum:60:="0204183"  //This is the old default PO Number. It can be changed now.
	SAVE RECORD:C53([zz_control:1])
End if 

UNLOAD RECORD:C212([zz_control:1])