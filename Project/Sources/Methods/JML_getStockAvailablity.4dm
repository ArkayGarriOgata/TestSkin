//%attributes = {"publishedWeb":true}
//PM: JML_getStockAvailablity(jobform;msg) -> date requested by msg
//@author mlb - 3/4/02  11:35
// Modified by: Mel Bohince (6/17/20)// be specfic about the board

C_DATE:C307($0)
$0:=!00-00-00!

//If (True)  // Modified by: Mel Bohince (6/17/20)// be specfic about the board

//If (Count parameters=0)  //testing
//$jf:="12649.01"
//$what:="Received"
//Else 
$jf:=$1
$what:=$2
//End if 

C_OBJECT:C1216($poiJF_es)
//see if a poitem for board or apet was made specifically for this job
$poiJF_es:=ds:C1482.Purchase_Orders_Job_forms.query("JobFormID = :1 AND (PURCHASE_ITEM.CommodityCode = :2 OR  PURCHASE_ITEM.CommodityCode = :3)"; $jf; 1; 20)

If ($poiJF_es.length>0)  //grab the date requested of the first
	
	Case of 
		: ($what="Due")
			$0:=$poiJF_es.first().PURCHASE_ITEM.ReqdDate
			
		: ($what="Received")
			$0:=$poiJF_es.first().PURCHASE_ITEM.RecvdDate
	End case 
	
End if   //any found

//Else   //original way

//READ ONLY([Purchase_Orders_Job_forms])
//READ ONLY([Purchase_Orders_Items])

//QUERY([Purchase_Orders_Job_forms];[Purchase_Orders_Job_forms]JobFormID=$1)
//If (Records in selection([Purchase_Orders_Job_forms])>0)
//RELATE ONE([Purchase_Orders_Job_forms]POItemKey)
//If (Records in selection([Purchase_Orders_Items])>0)
//Case of 
//: ($2="Due")
//$0:=[Purchase_Orders_Items]ReqdDate
//: ($2="Received")
//$0:=[Purchase_Orders_Items]RecvdDate
//End case 
//End if 
//End if 

//End if   //new way
