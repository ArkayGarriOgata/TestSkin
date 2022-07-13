//Script: bQuote()  062697  MLB
//CONFIRM("By POitem or search RM_Bins?";"PO Number";"Bins")
//If (ok=1)
//uSpawnProcess ("rRptRMbarcodes";0;"Print R/M Labels")

//Else 
//uSpawnProcess ("x_Print_RM_Labels";0;"Print R/M Labels")
//End if 
//If (False)
//rRptRmBarcodes 
//x_Print_RM_Labels 
//End if 
//
uSpawnProcess("RM_ScanLabel"; 0; "Print R/M Labels")
