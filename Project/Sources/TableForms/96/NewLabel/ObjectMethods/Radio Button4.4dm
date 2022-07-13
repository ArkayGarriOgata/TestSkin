sArkayUCCid:="0030808292"
wms_bin_id:="BNRCC"
cbSuperCase:=1
cbReceiveAMS:=0
cbMoveOS:=0
SetObjectProperties("supercase@"; -><>NULL; True:C214)

//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Jobit=sCriterion1;*)
//QUERY([Finished_Goods_Locations];&;[Finished_Goods_Locations]Location="FG:OS@")
//If (Records in selection([Finished_Goods_Locations])>0)
//uConfirm ("Is this being received from the vendor?";"Yes";"No")
//If (ok=1)
//wms_bin_id:="BNRFG"
//cbReceiveAMS:=0
//Else 
//wms_bin_id:="BNRCC"
//cbReceiveAMS:=1
//end if
//end if