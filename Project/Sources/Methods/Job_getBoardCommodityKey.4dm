//%attributes = {}
// -------
// Method: Job_getBoardCommodityKey   (jobform ) -> [Job_Forms_Materials]Commodity_Key
// By: Mel Bohince @ 03/02/18, 16:42:01
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($1; $0; $commodity; $jf)

If (Count parameters:C259=1)
	$jf:=$1
Else 
	$jf:="99733.01"
End if 

Begin SQL
	select Commodity_Key from Job_Forms_Materials 
	where JobForm = :$jf 
	and (Commodity_Key like '01%' or Commodity_Key like '20%') 
	into :$commodity
End SQL

If (Length:C16($commodity)>0)
	$0:=$commodity
Else 
	$0:="Board not found"
End if 