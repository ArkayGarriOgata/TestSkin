
C_BOOLEAN:C305(bNewSkid)
bNewSkid:=False:C215

$numRecs:=FGL_findBySkid(sCriter10; "reset")
If ($numRecs=0)
	sCriterion1:=sCriter10+" was not found, try again."
	sCriter10:=""
	GOTO OBJECT:C206(sCriter10)
End if 


// Modified by: Mel Bohince (8/30/19) what was I thinking, only if there is a location with that skid# is any of this relavent
//If (wms_itemExists (sCriter10))
//sCriterion3:=[WMS_ItemMasters]LOCATION
//asFrom{0}:=sCriterion3
//$hit:=Find in array(asFrom;sCriterion3)
//If ($hit=-1)
//INSERT IN ARRAY(asFrom;1;1)
//asFrom{1}:=sCriterion3
//End if 
//rReal1:=[WMS_ItemMasters]QTY

//sJobit:=[WMS_ItemMasters]LOT
//$numRecs:=qryJMI (sJobit)
//If ($numRecs>0)  //5/4/95 
//sCriterion1:=[Job_Forms_Items]ProductCode
//sCriterion2:=[Job_Forms_Items]CustId
//sCriterion5:=[Job_Forms_Items]JobForm
//sCriterion6:=[Job_Forms_Items]OrderItem
//i1:=[Job_Forms_Items]ItemNumber
//Else 
//sJobit:=""
//End if 

//Else 
//READ ONLY([WMS_SerializedShippingLabels])
//QUERY([WMS_SerializedShippingLabels];[WMS_SerializedShippingLabels]HumanReadable=sCriter10)
//If (Records in selection([WMS_SerializedShippingLabels])>0)
//rReal1:=[WMS_SerializedShippingLabels]Quantity
//sJobit:=[WMS_SerializedShippingLabels]Jobit
//$numRecs:=qryJMI (sJobit)
//If ($numRecs>0)  //5/4/95 
//sCriterion1:=[Job_Forms_Items]ProductCode
//sCriterion2:=[Job_Forms_Items]CustId
//sCriterion5:=[Job_Forms_Items]JobForm
//sCriterion6:=[Job_Forms_Items]OrderItem
//i1:=[Job_Forms_Items]ItemNumber
//End if 

//Else 
//uConfirm ("Are you making a new Skid?";"New Skid";"Try Again")
//If (ok=1)
//bNewSkid:=True
//Else 
//sCriter10:=""
//GOTO OBJECT(sCriter10)
//End if 
//End if 
//End if 
