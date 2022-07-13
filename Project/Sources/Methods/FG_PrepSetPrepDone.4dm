//%attributes = {"publishedWeb":true}
//PM: FG_PrepSetPrepDone() -> 
//@author mlb - 8/22/02  14:34
//clear out prephcarges

C_BOOLEAN:C305($wasSet)
C_DATE:C307($1; $theDate)
If (Count parameters:C259=1)
	[Finished_Goods_Specifications:98]DatePrepDone:6:=$1
End if 

READ WRITE:C146([Prep_Charges:103])
USE SET:C118("allPrepCharges")

QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]QuantityQuoted:2=0; *)
QUERY SELECTION:C341([Prep_Charges:103];  & ; [Prep_Charges:103]QuantityRevised:10=0; *)
QUERY SELECTION:C341([Prep_Charges:103];  & ; [Prep_Charges:103]QuantityActual:3=0)
util_DeleteSelection(->[Prep_Charges:103])

$theDate:=[Finished_Goods_Specifications:98]DatePrepDone:6
USE SET:C118("allPrepCharges")
QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]RequestSeries:13=1)
APPLY TO SELECTION:C70([Prep_Charges:103]; [Prep_Charges:103]DateDone:14:=$theDate)
REDUCE SELECTION:C351([Prep_Charges:103]; 0)
