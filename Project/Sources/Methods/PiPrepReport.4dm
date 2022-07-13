//%attributes = {"publishedWeb":true}
//(p) PiPrepReport
//requests from user what part of FG_location data to print
//and does needed searches.
//sets up primary title on report
//see also rPiAjdwCost (similar code but on [fg_tranasctions])
//created cs 3/6/97 upr1858
// Modified by: Mel Bohince (12/18/15) replace missing dialog
uClearSelection(->[Finished_Goods_Locations:35])
//uDialog ("SelectFgType";270;210)
rbAll:=1
brbBoth:=1
ok:=1

If (OK=1)
	Case of 
		: (rbAll=1)  //all locations
			Case of 
				: (brbBoth=1)  //both divisions
					ALL RECORDS:C47([Finished_Goods_Locations:35])
					t2:="All Locations"
				: (brbRoanoke=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="@:R@")
					t2:="All Roanoke"
				Else 
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"@:R@")
					t2:="All Hauppauge"
			End case 
			
		: (rbFg=1)  //just FG:
			Case of 
				: (sLocation#"All") & (Not:C34((Length:C16(sLocation)=1) & (Character code:C91(sLocation)=Character code:C91("@"))))  //• 4/9/97 cs user wants specific location
					QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9=sLocation; *)
					t2:="Location = "+sLocation
				: (brbBoth=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:@")
					t2:="All FG:"
				: (brbRoanoke=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:R@")
					t2:="Roanoke FG:"
				Else 
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"FG:R@"; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:@")
					t2:="Hauppauge FG:"
			End case 
			
		: (rbCC=1)  //just CC:
			Case of 
				: (brbBoth=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="CC:@")
					t2:="All CC:"
				: (brbRoanoke=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="CC:R@")
					t2:="Roanoke CC:"
				Else 
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"CC:R@"; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="CC:@")
					t2:="Hauppauge CC:"
			End case 
			
		: (rbEx=1)  //just Ex:
			Case of 
				: (brbBoth=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="EX:@")
					t2:="All EX:"
				: (brbRoanoke=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="EX:R@")
					t2:="Roanoke EX:"
				Else 
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"EX:R@"; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="EX:@")
					t2:="Hauppauge EX:"
			End case 
			
		: (rbBH=1)  //just BH:
			Case of 
				: (brbBoth=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="BH:@")
					t2:="All BH:"
				: (brbRoanoke=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="BH:R@")
					t2:="Roanoke BH:"
				Else 
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH:R@"; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="BH:@")
					t2:="Hauppauge BH:"
			End case   //just xc:
			
		: (rbXc=1)
			Case of 
				: (brbBoth=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="XC:@")
					t2:="All XC:"
				: (brbRoanoke=1)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="XC:R@")
					t2:="Roanoke XC:"
				Else 
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"XC:R@"; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="XC:@")
					t2:="Hauppauge XC:"
			End case 
	End case 
End if 