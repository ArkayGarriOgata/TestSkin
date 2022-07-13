//%attributes = {"publishedWeb":true}
//sSetPurchaseUM
//upr 1456 3/22/95
C_LONGINT:C283($1)  //the commodity
If ([Purchase_Orders_Items:12]UM_Arkay_Issue:28="") & ($1>0)
	Case of 
		: ($1=1)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="LF"
		: ($1=2)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="LB"
		: ($1=3)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="LB"
		: ($1=4)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="EACH"
		: ($1=5)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="ROLL"
		: ($1=6)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="SHT"
		: ($1=7)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="EACH"  //upr 1456 3/22/95
		: ($1=8)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="LF"
		: ($1=9)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="SHT"
		: ($1=13)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="EACH"  //    
		: ($1=17)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="LF"
		: ($1=51)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="M"
		: ($1=71)
			[Purchase_Orders_Items:12]UM_Arkay_Issue:28:="SQIN"
	End case 
End if 
//