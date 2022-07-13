//%attributes = {}
// -------
// Method: FG_getAssemblyParents   ( ) ->
// By: Mel Bohince @ 11/02/16, 13:02:06
// Description
// 
// ----------------------------------------------------
<>USE_SUBCOMPONENT:=True:C214

C_BLOB:C604($0; $anArray)
SET BLOB SIZE:C606($0; 0)
SET BLOB SIZE:C606($anArray; 0)

ARRAY TEXT:C222($aCPN_Parents; 0)


Begin SQL
	select distinct(ProductCode) from Job_Forms_Items 
	where JobForm in 
	(select distinct(JobForm) from Job_Forms_Materials where Commodity_Key like '33%')
	into :$aCPN_Parents
End SQL

VARIABLE TO BLOB:C532($aCPN_Parents; $anArray)


$0:=$anArray
