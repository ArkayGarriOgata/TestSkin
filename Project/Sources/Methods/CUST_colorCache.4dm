//%attributes = {"publishedWeb":true}
//PM: CUST_colorCache() -> o
//@author mlb - 3/28/02  12:00   

//From what I can gather this is never called with 3 parameters
//<>aCustName and <>aColor are never used outside of this method
//  Most of the time it is called to load <>aCustName and <>aColor
//  up that way it can be used later when past a customer name.

C_TEXT:C284($1)
C_LONGINT:C283($0; $i)
C_POINTER:C301($2; $3)  //color settings

Case of 
	: (Count parameters:C259=1)
		$i:=Find in array:C230(<>aCustName; $1)
		If ($i>-1)
			$0:=<>aColor{$i}
		Else 
			$0:=-15
		End if 
		
	: (Count parameters:C259=3)  //Never called with 3 parameters
		$i:=Find in array:C230(<>aCustName; $1)
		If ($i>-1)
			$0:=<>aColor{$i}
			$2->:=(<>aColor{$i}*-1)%256
			$3->:=(<>aColor{$i}*-1)\256
		Else 
			$0:=-15
			$2->:=15
			$3->:=0
		End if 
		
	Else   //init  
		QUERY:C277([Customers:16]; [Customers:16]DisplayColor:55#0)
		ARRAY TEXT:C222(<>aCustName; 0)
		ARRAY LONGINT:C221(<>aColor; 0)
		SELECTION TO ARRAY:C260([Customers:16]Name:2; <>aCustName; [Customers:16]DisplayColor:55; <>aColor)
		REDUCE SELECTION:C351([Customers:16]; 0)
		$0:=Size of array:C274(<>aColor)
End case 