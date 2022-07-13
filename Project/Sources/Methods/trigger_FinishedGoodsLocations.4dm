//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 11:55:32
// ----------------------------------------------------
// Method: trigger_FinishedGoodsLocations()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1) | (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Finished_Goods_Locations:35]Jobit:33:=JMI_makeJobIt([Finished_Goods_Locations:35]JobForm:19; [Finished_Goods_Locations:35]JobFormItem:32)
		[Finished_Goods_Locations:35]FG_Key:34:=[Finished_Goods_Locations:35]CustID:16+":"+[Finished_Goods_Locations:35]ProductCode:1
		
		$location:=[Finished_Goods_Locations:35]Location:2
		Case of 
			: (Position:C15("AV"; $location)>0)
				[Finished_Goods_Locations:35]Warehouse:36:="Consignment"
			: (Position:C15("OS"; $location)>0)
				[Finished_Goods_Locations:35]Warehouse:36:="O/S Vendor"
			: (Position:C15(":R"; $location)>0)
				[Finished_Goods_Locations:35]Warehouse:36:="Roanoke"
			: (Position:C15(":V"; $location)>0)
				[Finished_Goods_Locations:35]Warehouse:36:="Vista"
			: (Position:C15(":"; $location)>0)
				[Finished_Goods_Locations:35]Warehouse:36:="Hauppauge"
			: (Position:C15("BNR"; $location)>0)
				[Finished_Goods_Locations:35]Warehouse:36:="EastPark"
			Else 
				[Finished_Goods_Locations:35]Warehouse:36:="EastPark"
		End case 
		
		Case of 
			: (Position:C15("#BL"; $location)>0)  //see BOL_StagingName
				//do nothing, leave it as-is so it could be returned
				
			: (Length:C16($location)=13)
				[Finished_Goods_Locations:35]Row:37:=Num:C11(Substring:C12($location; 5; 2))
				[Finished_Goods_Locations:35]Bin:38:=Num:C11(Substring:C12($location; 8; 3))
				[Finished_Goods_Locations:35]Tier:39:=Num:C11(Substring:C12($location; 12; 2))
			: (Length:C16($location)=11)
				[Finished_Goods_Locations:35]Row:37:=Num:C11(Substring:C12($location; 5; 2))
				[Finished_Goods_Locations:35]Bin:38:=Num:C11(Substring:C12($location; 8; 2))
				[Finished_Goods_Locations:35]Tier:39:=Num:C11(Substring:C12($location; 11; 1))
			: (Length:C16($location)=10)
				[Finished_Goods_Locations:35]Row:37:=Num:C11(Substring:C12($location; 4; 2))
				[Finished_Goods_Locations:35]Bin:38:=Num:C11(Substring:C12($location; 7; 2))
				[Finished_Goods_Locations:35]Tier:39:=Num:C11(Substring:C12($location; 10; 1))
			Else   //treat as floor location
				[Finished_Goods_Locations:35]Row:37:=0
				[Finished_Goods_Locations:35]Bin:38:=0
				[Finished_Goods_Locations:35]Tier:39:=0
		End case 
		
		
		If (Position:C15("Kill"; [Finished_Goods_Locations:35]Location:2)>0)
			[Finished_Goods_Locations:35]KillStatus:30:=1
		End if 
		// Modified by: Mel Bohince (9/25/14) Rows 17 and 18 are dedicated to XC until further notice
		// Modified by: Mel Bohince (4/21/15) undone
		//If ([Finished_Goods_Locations]Row=17) | ([Finished_Goods_Locations]Row=18)
		//If (Substring([Finished_Goods_Locations]Location;1;2)="FG")
		//[Finished_Goods_Locations]Location:="XC"+Substring([Finished_Goods_Locations]Location;3)
		//End if 
		//End if 
		
End case 