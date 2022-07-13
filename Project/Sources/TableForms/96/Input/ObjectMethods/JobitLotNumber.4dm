

If ([Job_Forms_Items:44]Jobit:4#[WMS_SerializedShippingLabels:96]Jobit:3)
	READ ONLY:C145([Job_Forms_Items:44])
	$numFound:=qryJMI([WMS_SerializedShippingLabels:96]Jobit:3)
Else 
	$numFound:=1
End if 

If ($numFound>0)
	[WMS_SerializedShippingLabels:96]CPN:2:=[Job_Forms_Items:44]ProductCode:3
	READ ONLY:C145([Finished_Goods:26])
	$numFound:=qryFinishedGood("#CPN"; [WMS_SerializedShippingLabels:96]CPN:2)
	If ($numFound>0)
		[WMS_SerializedShippingLabels:96]CartonDesc:7:=Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 25)
	Else 
		[WMS_SerializedShippingLabels:96]CartonDesc:7:=""
	End if 
	
	If ([WMS_SerializedShippingLabels:96]ContainerType:13="SKID")
		[WMS_SerializedShippingLabels:96]LotNumber:6:="AP"+[WMS_SerializedShippingLabels:96]PlantNumber:8+Replace string:C233([WMS_SerializedShippingLabels:96]Jobit:3; "."; "")
	Else 
		[WMS_SerializedShippingLabels:96]LotNumber:6:=[WMS_SerializedShippingLabels:96]Jobit:3
	End if 
	
Else 
	uConfirm("ERROR: "+[WMS_SerializedShippingLabels:96]Jobit:3+" is not a job item."; "Try Again"; "Help")
	[WMS_SerializedShippingLabels:96]CPN:2:=""
	[WMS_SerializedShippingLabels:96]CartonDesc:7:=""
	[WMS_SerializedShippingLabels:96]Jobit:3:=""
	[WMS_SerializedShippingLabels:96]LotNumber:6:=""
	GOTO OBJECT:C206([WMS_SerializedShippingLabels:96]Jobit:3)
End if 