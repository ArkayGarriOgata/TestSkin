//  //ALERT("should print a real pick list, meanwhile...";"simple bin list")
//  //util_outerJoin (->[RM_BINS]Raw_Matl_Code;->[WMS_WarehouseOrder]RawMatlCode)
//  //CREATE SET([RM_BINS];"preSelected")
//  //rPiRmCountSheet ("preSelected")

//C_TEXT($t;$r)
//$t:="  "  //Char(9)
//$r:=Char(13)

//C_TEXT(xTitle;xText;docName)
//xTitle:=""
//xText:=""
//C_TIME($docRef)

//DISTINCT VALUES([WMS_WarehouseOrders]RawMatlCode;$aRM)
//CUT NAMED SELECTION([WMS_WarehouseOrders];"beforePick")

//C_LONGINT($i;$numElements)
//$numElements:=Size of array($aRM)

//uThermoInit ($numElements;"Processing Array")
//For ($i;1;$numElements)
//xTitle:="  WAREHOUSE PICK SHEET  "
//$title:=$aRM{$i}
//$len:=Length($title)
//xText:=("*"*($len+4))+$r+"* "+$title+" *"+$r+("*"*($len+4))

//xText:=xText+$r+$r

//xText:=xText+"NEEDED BY "+$t+"FOR JOBIT  "+$t+"   QTY   "+$t+"   ID#   "+$r
//xText:=xText+"----------"+$t+"-----------"+$t+"---------"+$t+"---------"+$r+$r
//$total:=0
//QUERY([WMS_WarehouseOrders];[WMS_WarehouseOrders]RawMatlCode=$aRM{$i};*)
//QUERY([WMS_WarehouseOrders]; & ;[WMS_WarehouseOrders]Delivered=!00-00-00!)
//If (Not(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record

//ORDER BY([WMS_WarehouseOrders];[WMS_WarehouseOrders]Needed;>)
//While (Not(End selection([WMS_WarehouseOrders])))
//xText:=xText+String([WMS_WarehouseOrders]Needed;Internal date short)+$t+[WMS_WarehouseOrders]JobReference+$t+txt_Pad (String([WMS_WarehouseOrders]Qty);" ";-1;6)+$t+txt_Pad (String([WMS_WarehouseOrders]id);" ";-1;8)+$r+$r
//$total:=$total+[WMS_WarehouseOrders]Qty
//NEXT RECORD([WMS_WarehouseOrders])
//End while 


//Else 

//ARRAY DATE($_Needed;0)
//ARRAY TEXT($_JobReference;0)
//ARRAY LONGINT($_Qty;0)
//ARRAY LONGINT($_id;0)

//SELECTION TO ARRAY([WMS_WarehouseOrders]Needed;$_Needed;[WMS_WarehouseOrders]JobReference;$_JobReference;[WMS_WarehouseOrders]Qty;$_Qty;[WMS_WarehouseOrders]id;$_id)


//SORT ARRAY($_Needed;$_JobReference;$_Qty;$_id;>)

//For ($Iter;1;Size of array($_Qty);1)
//xText:=xText+String($_Needed{$Iter};Internal date short)+$t+$_JobReference{$Iter}+$t+txt_Pad (String($_Qty{$Iter});" ";-1;6)+$t+txt_Pad (String($_id{$Iter});" ";-1;8)+$r+$r
//$total:=$total+$_Qty{$Iter}

//End for 


//End if   // END 4D Professional Services : January 2019 First record
//xText:=xText+"          "+$t+"==========="+$t+"========="+$r
//xText:=xText+"          "+$t+"TOTAL NEED:"+$t+txt_Pad (String($total);" ";-1;6)+$r
//xText:=xText+$r+$r

//xText:=xText+"PO_ITEM  "+$t+"LOCATION    "+$t+"   QTY   "+$t+"  TAKEN  "+$r
//xText:=xText+"---------"+$t+"------------"+$t+"---------"+$t+"---------"+$r+$r

//$total:=0
//QUERY([Raw_Materials_Locations];[Raw_Materials_Locations]Raw_Matl_Code=$aRM{$i})
//If (Not(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record

//ORDER BY([Raw_Materials_Locations];[Raw_Materials_Locations]POItemKey;>;[Raw_Materials_Locations]Location;>)
//While (Not(End selection([Raw_Materials_Locations])))
//xText:=xText+[Raw_Materials_Locations]POItemKey+$t+txt_Pad ([Raw_Materials_Locations]Location;" ";1;12)+$t+txt_Pad (String([Raw_Materials_Locations]QtyOH);" ";-1;6)+$t+"   _________"+$r+$r
//$total:=$total+[Raw_Materials_Locations]QtyOH
//NEXT RECORD([Raw_Materials_Locations])
//End while 

//Else 

//ARRAY TEXT($_POItemKey;0)
//ARRAY TEXT($_Location;0)
//ARRAY REAL($_QtyOH;0)


//SELECTION TO ARRAY([Raw_Materials_Locations]POItemKey;$_POItemKey;[Raw_Materials_Locations]Location;$_Location;[Raw_Materials_Locations]QtyOH;$_QtyOH)

//SORT ARRAY($_POItemKey;$_Location;$_QtyOH;>)

//For ($Iter;1;Size of array($_QtyOH);1)

//xText:=xText+$_POItemKey{$Iter}+$t+txt_Pad ($_Location{$Iter};" ";1;12)+$t+txt_Pad (String($_QtyOH{$Iter});" ";-1;6)+$t+"   _________"+$r+$r
//$total:=$total+$_QtyOH{$Iter}

//End for 

//End if   // END 4D Professional Services : January 2019 First record

//xText:=xText+"         "+$t+"============"+$t+"========="+$r
//xText:=xText+"         "+$t+"ONHAND TOTAL"+$t+txt_Pad (String($total);" ";-1;6)+$r

//xText:=xText+$r+$r
//xText:=xText+"END OF "+xTitle
//If (<>PrintToPDF)
//DELAY PROCESS(Current process;120)
//End if 
//rPrintText   // (String($i)+".txt")

//uThermoUpdate ($i)
//End for 
//uThermoClose 

//USE NAMED SELECTION("beforePick")
//zwStatusMsg ("PRINT PICK";"Sent to printer")
//BEEP
//  //