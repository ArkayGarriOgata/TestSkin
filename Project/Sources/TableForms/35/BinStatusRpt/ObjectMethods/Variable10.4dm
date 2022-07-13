//rReal1 [fg_location]binstatusRpt
If ([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Finished_Goods_Locations:35]JobForm:19; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=[Finished_Goods_Locations:35]ProductCode:1)
End if 
Self:C308->:=([Finished_Goods_Locations:35]QtyOH:9*[Job_Forms_Items:44]PldCostTotal:21)/1000
//
aLoc{iOnPage}:=String:C10(iPage)+Char:C90(9)+[Finished_Goods_Locations:35]Location:2