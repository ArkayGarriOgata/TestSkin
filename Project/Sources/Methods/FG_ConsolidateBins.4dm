//%attributes = {"publishedWeb":true}
//gPutFGs2OneLoc
//•Mod AJS 3/17/96 - add JobFormItem
//The basis of this roll in is now narrowed down to: same Item on same Jobform
//CPN is Replaced in searches, etc
//°3/17/96  Adam Soos (`roll all fg locations which have the same Job, CPN & Locat
//into one FgLocation record) - deleted

ALL RECORDS:C47([Finished_Goods_Locations:35])
ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >; [Finished_Goods_Locations:35]JobFormItem:32; >; [Finished_Goods_Locations:35]Location:2; >)
$Location:=[Finished_Goods_Locations:35]Location:2
$Job:=[Finished_Goods_Locations:35]JobForm:19
$JobItem:=[Finished_Goods_Locations:35]JobFormItem:32
$QtyOh:=[Finished_Goods_Locations:35]QtyOH:9
$Rec:=Record number:C243([Finished_Goods_Locations:35])
NEXT RECORD:C51([Finished_Goods_Locations:35])

For ($i; 1; Records in selection:C76([Finished_Goods_Locations:35]))
	Case of 
		: ([Finished_Goods_Locations:35]Location:2=$Location) & ([Finished_Goods_Locations:35]JobForm:19=$Job) & ([Finished_Goods_Locations:35]JobFormItem:32=$JobItem)  //this is the same
			[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$QtyOh
			[Finished_Goods_Locations:35]ModDate:21:=4D_Current_date
			[Finished_Goods_Locations:35]ModWho:22:=<>zResp
			SAVE RECORD:C53([Finished_Goods_Locations:35])
			COPY NAMED SELECTION:C331([Finished_Goods_Locations:35]; "Current")
			GOTO RECORD:C242([Finished_Goods_Locations:35]; $Rec)
			DELETE RECORD:C58([Finished_Goods_Locations:35])
			USE NAMED SELECTION:C332("Current")
			
		: ([Finished_Goods_Locations:35]Location:2#$Location)
			$Location:=[Finished_Goods_Locations:35]Location:2
			$Job:=[Finished_Goods_Locations:35]JobForm:19
			$JobItem:=[Finished_Goods_Locations:35]JobFormItem:32
			
		: ([Finished_Goods_Locations:35]JobForm:19#$Job)
			$Location:=[Finished_Goods_Locations:35]Location:2
			$Job:=[Finished_Goods_Locations:35]JobForm:19
			$JobItem:=[Finished_Goods_Locations:35]JobFormItem:32
			
		: ([Finished_Goods_Locations:35]JobFormItem:32#$JobItem)
			$Location:=[Finished_Goods_Locations:35]Location:2
			$Job:=[Finished_Goods_Locations:35]JobForm:19
			$JobItem:=[Finished_Goods_Locations:35]JobFormItem:32
	End case 
	$QtyOh:=[Finished_Goods_Locations:35]QtyOH:9
	$rec:=Record number:C243([Finished_Goods_Locations:35])
	NEXT RECORD:C51([Finished_Goods_Locations:35])
End for 