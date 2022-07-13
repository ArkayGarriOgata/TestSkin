//(s) commodity code [poclauselink] clasueincld
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]CommodityCode:26=Self:C308->)
If (Records in selection:C76([Raw_Materials:21])=0)
	ALERT:C41("Invalid Commodity Code, Please try again.")
	GOTO OBJECT:C206(Self:C308->)
	Self:C308->:=0
End if 
//eos