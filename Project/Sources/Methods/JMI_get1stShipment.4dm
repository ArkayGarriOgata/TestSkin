//%attributes = {"publishedWeb":true}
//PM: JMI_get1stShipment(jobform | item) -> date
//@author mlb - 2/27/02  14:46

C_TEXT:C284($1)
C_DATE:C307($0; $date)
ARRAY DATE:C224($aDate; 0)

$date:=!00-00-00!

//zwStatusMsg ("1stShip";$1)
If (Length:C16($1)=11)  //search by jobit
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$1; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="ship")
Else   //search by form
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=$1; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="ship")
End if 

If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aDate)
	REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
	SORT ARRAY:C229($aDate; >)
	$date:=$aDate{1}
	ARRAY DATE:C224($aDate; 0)
End if 

$0:=$date