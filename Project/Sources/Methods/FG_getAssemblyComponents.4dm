//%attributes = {}
// -------
// Method: FG_getAssemblyComponents   ( ) ->
// By: Mel Bohince @ 11/02/16, 13:06:36
// Description
// 
// ----------------------------------------------------
<>USE_SUBCOMPONENT:=True:C214

C_TEXT:C284($parentJobform; $1)
ARRAY TEXT:C222($aCPN_Components; 0)
ARRAY TEXT:C222($aJob_Components; 0)

C_BLOB:C604($0; $anArray)
SET BLOB SIZE:C606($0; 0)
SET BLOB SIZE:C606($anArray; 0)

If (Count parameters:C259=0)  //get all the components
	Begin SQL
		select distinct(Raw_Matl_Code) from Job_Forms_Materials where Commodity_Key like '33%'
		into :$aCPN_Components
	End SQL
	
	VARIABLE TO BLOB:C532($aCPN_Components; $anArray)
	
Else 
	
	$parentJobform:=$1
	//$parentJobform:="98158.01"  //$1
	Begin SQL
		select Raw_Matl_Code, JobForm from Job_Forms_Materials where Commodity_Key like '33%' 
		and JobForm = :$parentJobform
		into :$aCPN_Components, :$aJob_Components
	End SQL
	
	VARIABLE TO BLOB:C532($aCPN_Components; $anArray)
	
End if 

$0:=$anArray