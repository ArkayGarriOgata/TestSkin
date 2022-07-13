//%attributes = {}
// -------
// Method: patternSetReplacement   ( ) ->
// By: Mel Bohince @ 03/27/19, 08:17:53
// Description
// method to avoid multiple add to sets
// ----------------------------------------------------
// extracted from doPurgeOrders

C_DATE:C307($current_date; $result)
$current_date:=4D_Current_date
$result:=$current_date-r20

C_LONGINT:C283($CANCEL; $Closed; $Kill)
//QBF to avoid multiple sets then union or intersections
QUERY BY FORMULA:C48([Customers_Orders:40]; \
(\
([Customers_Orders:40]Status:10="Closed")\
 & \
([Customers_Orders:40]DateClosed:49<dEndDate)\
)\
 | \
(\
([Customers_Orders:40]Status:10="Kill@")\
 & \
([Customers_Orders:40]DateOpened:6<$result)\
)\
 | \
([Customers_Orders:40]Status:10="Cancel@")\
)


// set up for CREATE SELECTION FROM ARRAY with hand picked records, instead of adding to set
ARRAY LONGINT:C221($_record_finale; 0)

SELECTION TO ARRAY:C260([Customers_Orders:40]Status:10; $_Status; \
[Customers_Orders:40]DateClosed:49; $_DateClosed; \
[Customers_Orders:40]DateOpened:6; $_DateOpened; \
[Customers_Orders:40]; $_record_number)

For ($Iter; 1; Size of array:C274($_Status); 1)
	Case of 
		: (($_Status{$Iter}="Closed@") & ($_DateClosed{$Iter}<dEndDate) & (r16=1))
			
			APPEND TO ARRAY:C911($_record_finale; $_record_number{$Iter})
			$Closed:=$Closed+1
			
		: (($_Status{$Iter}="Kill@") & ($_DateOpened{$Iter}<$result) & (r17=1))
			
			APPEND TO ARRAY:C911($_record_finale; $_record_number{$Iter})
			$Kill:=$Kill+1
			
		: (($_Status{$Iter}="Cancel@") & (r18=1))
			
			APPEND TO ARRAY:C911($_record_finale; $_record_number{$Iter})
			$CANCEL:=$CANCEL+1
			
	End case 
	
End for 



CREATE SELECTION FROM ARRAY:C640([Customers_Orders:40]; $_record_finale)