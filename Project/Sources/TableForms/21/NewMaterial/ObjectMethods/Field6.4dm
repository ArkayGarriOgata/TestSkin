[Raw_Materials:21]SubGroup:31:=fStripSpace("B"; [Raw_Materials:21]SubGroup:31)  //•041197  MLB  make library call

If (fCreateRMgroup(1))
	RELATE ONE:C42([Raw_Materials:21]Commodity_Key:2)
End if 
sRMflexFields([Raw_Materials:21]CommodityCode:26)
//
//