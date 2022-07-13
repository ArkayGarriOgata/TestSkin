//%attributes = {"publishedWeb":true}
//PM: JML_getStockRMcode() -> 
//@author mlb - 3/4/02  11:34

QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$1; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12="01@")
If ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")  //**      Get the B&P material code
	$0:=[Job_Forms_Materials:55]Raw_Matl_Code:7
Else 
	$0:=Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 4)
End if 