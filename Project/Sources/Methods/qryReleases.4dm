//%attributes = {"publishedWeb":true}
//(p) qryReleases
//$1- CustomerID
//$2 (optional)  Product code field to find 
//2/7/97 cs 
//Returns number of OPEN releases found

C_TEXT:C284($1)
C_TEXT:C284($2)

If (Count parameters:C259>1)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$2; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=$1; *)
Else 
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=$1; *)
End if 
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
$0:=Records in selection:C76([Customers_ReleaseSchedules:46])