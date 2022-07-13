//%attributes = {}
// _______
// Method: RM_coldFoilEquivalent   ( rmcode1;rmcode2) -> true
// By: MelvinBohince @ 01/31/22, 12:03:15
// Description
// given two cold foil rm codes, are their color and width the same
// ----------------------------------------------------
// Modified by: MelvinBohince (2/13/22) only test color

C_BOOLEAN:C305($0)
C_TEXT:C284($1; $2)  //2 coldfoils to compare
C_OBJECT:C1216($rm1_e; $rm2_e)
$0:=False:C215

If (Count parameters:C259=2)
	$cf1:=$1
	$cf2:=$2
Else 
	$cf1:="AL KPS OP"  //"ICF2-100"
	$cf2:="ICF2-100"  //"AL KPS OP-20"//"al kps op-14"
End if 

$rm1_e:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; $cf1).first()
If ($rm1_e#Null:C1517)
	//get the other code
	
	$rm2_e:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; $cf2).first()
	If ($rm2_e#Null:C1517)
		
		If ($rm1_e.Flex4=$rm2_e.Flex4)  //same color
			//If ($rm1_e.VendorPartNum=$rm2_e.VendorPartNum)  //same color and size
			//uConfirm ($cf1+" and "+$cf2+" are the same color and width.";"Ok";"Great!")
			$0:=True:C214
			
		Else 
			//uConfirm ($cf1+" and "+$cf2+" are different.";"Ok";"Great!")
			$0:=False:C215
			
		End if 
		
	Else 
		//uConfirm ($cf2+" was not found";"Ok";"Shucks")
	End if 
	
Else 
	//uConfirm ($cf1+" was not found";"Ok";"Shucks")
End if 
