//%attributes = {"publishedWeb":true}
//  `uCalcPrepMLB  `1/16/95
//  `•052295  MLB  UPR 1505 add price
//  `•061595  MLB  UPR 1636 add price to customer
//  `•072195  MLB  UPR 1684 add thermo
//  `•072895  MLB  take out thermos, they Type 1 the compiled version
//C_POINTER($matl;$labor;$burdon;$price)
//C_LONGINT($i)
//
//:=0
//:=0
//:=0
//:=0
//:=0
//  `ThermoInit (20;"Summarizing Preparatory Costs")
//For ($i;1;20)
//$matl:=Get pointer("r"+String($i))
//$labor:=Get pointer("r"+String($i+20))
//$burdon:=Get pointer("r"+String($i+40))
//$price:=Get pointer("r"+String($i+60))
//:=+$matl->
//:=+$labor->
//:=+$burdon->
//:=+$price->
//  `ThermoUpdate ($i)
//End for 
//  `ThermoClose 
//
//  `ThermoInit (93;"Summarizing Preparatory Prices")
//For ($i;81;93)
//$price:=Get pointer("r"+String($i))
//:=+$price->
//  `ThermoUpdate ($i)
//End for 
//  `ThermoClose 
//
//If (="")  `•061595  MLB  UPR 1636
//:=String(;"###,###,##0")
//
//Else 
//If (Substring(;(Length());1)#"*")
//:=+"*"
//End if 
//End if 
//
//:=++
//[Estimates]_Cost_TotalPrep:=0
//SAVE RECORD([Estimates])
//  `