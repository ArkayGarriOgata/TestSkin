//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/16/10, 16:47:46
// ----------------------------------------------------
// Method: CUST_nameCache
// Description
// cache customer names
// used by CUST_getName someday
// ----------------------------------------------------

C_TEXT:C284($1)  //cust id
C_LONGINT:C283($hit)
C_TEXT:C284($0)

If (Count parameters:C259=1)
	$hit:=Find in array:C230(<>aCustCacheID; $1)
	If ($hit>-1)
		$0:=<>aCustCacheName{$hit}
	Else 
		$0:="n/f"
	End if 
	
Else 
	READ ONLY:C145([Customers:16])
	ALL RECORDS:C47([Customers:16])
	SELECTION TO ARRAY:C260([Customers:16]ID:1; <>aCustCacheID; [Customers:16]Name:2; <>aCustCacheName)
	REDUCE SELECTION:C351([Customers:16]; 0)
	SORT ARRAY:C229(<>aCustCacheID; <>aCustCacheName; >)
End if 