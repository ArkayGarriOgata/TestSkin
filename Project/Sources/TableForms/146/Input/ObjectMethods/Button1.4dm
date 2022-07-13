// ----------------------------------------------------
// Object Method: [WMS_WarehouseOrders].Input.Button1
// ----------------------------------------------------
// Modified by: Mel Bohince (8/31/21) OBSOLETE OBSOLETE OBSOLETE OBSOLETE 

//If ([WMS_WarehouseOrders]QtyDelivered=0)
//SetObjectProperties ("wms@";-><>NULL;True;"";True)  // Modified by: Mark Zinke (5/14/13)
//SetObjectProperties ("";->bAdd;True;"Make your changes")  // Modified by: Mark Zinke (5/14/13)
//OBJECT SET ENABLED(bAdd;False)
//GOTO OBJECT([WMS_WarehouseOrders]RawMatlCode)
//Else 
//BEEP
//ALERT("Can't change, already delivered.";"Make a New Order")
//End if 