// _______
// Method: [Raw_Materials_Locations].Reconciliation.reviewRawMaterial   ( ) ->
// By: MelvinBohince @ 04/05/22, 14:09:42
// Description
// open the selected location's raw material record in reveiw mode
// ----------------------------------------------------

READ ONLY:C145([Raw_Materials:21])

SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Locations:25]Raw_Matl_Code:1)
SET QUERY DESTINATION:C396(Into current selection:K19:1)

<>PassThrough:=True:C214
ViewSetter(3; ->[Raw_Materials:21])

OBJECT SET ENABLED:C1123(*; "reviewRawMaterial"; False:C215)  //set up for new selection
