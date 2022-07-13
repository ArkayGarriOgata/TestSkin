//%attributes = {}
//Method:  RwMt_SetFSCCodeB(oParameters)=>bSetCode
//Description:  This method will set Raw Material code

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oParameters)
	C_BOOLEAN:C305($0; $bSetCode)
	
	If (Count parameters:C259>=1)
		$oParameters:=$1
	End if 
	
	$bSetCode:=False:C215
	
	$tTableName:=Table name:C256(->[Raw_Materials:21])
	
	$tQuery:="Raw_Matl_Code = "+$tRawMaterialCode
	
End if   //Done initialize

$esRawMaterials:=ds:C1482[$tTableName].query($tQuery)

Case of   //Verify
	: ($esRawMaterials.length#1)
	: (Not:C34($esRawMaterials.IsFSC))
	: ($bUseVendor)
		
		//$tFSCCode:=
		
	Else 
		
		$tFSCCode:="FSC#: BV-COC-070906  FSC Mix Credit"
		
End case   //Done verify

$0:=$bSetCode