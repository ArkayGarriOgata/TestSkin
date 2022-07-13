
// ******* Verified  - 4D PS - January  2019 ********

QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
QUERY SELECTION:C341([Raw_Materials_Locations:25])


// ******* Verified  - 4D PS - January 2019 (end) *********
rOnHand:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)