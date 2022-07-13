//uSpawnProcess ("PiEndPi";500000;"Inventory";True;True)
//
//If (False)  `insider reference
PiEndPi
//End if 

If ([zz_control:1]InvInProgress:24)
	OBJECT SET ENABLED:C1123(<>ibNewPhyInv; False:C215)
	OBJECT SET ENABLED:C1123(<>ibEndPhyInv; True:C214)
Else 
	OBJECT SET ENABLED:C1123(<>ibEndPhyInv; False:C215)
	OBJECT SET ENABLED:C1123(<>ibNewPhyInv; True:C214)
End if 