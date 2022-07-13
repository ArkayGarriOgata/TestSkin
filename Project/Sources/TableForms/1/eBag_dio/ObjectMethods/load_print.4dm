// _______
// Method: [zz_control].eBag_dio.load_print   ( ) ->
// By: Mel Bohince @ 05/01/19, 15:53:15
// Description
// 
// ----------------------------------------------------

//$doWhat:=uYesNoCancel ("Print or send to WMS?";"Print";"Send to WMS")

//Case of 
//: ($doWhat="Print")

CUT NAMED SELECTION:C334([Job_Forms_Loads:162]; "holdWhilePrinting")
USE SET:C118("$ListboxSet")  //"load_listboxSet")


Job_LoadLabel("Print")

USE NAMED SELECTION:C332("holdWhilePrinting")

//: ($doWhat="Send to WMS")
//Job_LoadLabel ("wms")
//End case 


