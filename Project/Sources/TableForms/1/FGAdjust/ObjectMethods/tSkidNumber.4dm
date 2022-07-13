
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 12/03/15, 15:09:24
// ----------------------------------------------------
// Method: [zz_control].FGAdjust.tSkidNumber
// Description
// 
//
// ----------------------------------------------------

$numRecs:=FGL_findBySkid(tSkidNumber; "reset")
If ($numRecs=0)
	sCriterion1:=tSkidNumber+" was not found, try again."
	tSkidNumber:=""
	qtyBeforeAdj:=0
	GOTO OBJECT:C206(tSkidNumber)
	
Else 
	qtyBeforeAdj:=rReal1
End if 

//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]pallet_id=tSkidNumber)
//If (Records in selection([Finished_Goods_Locations])=1)
//qtyBeforeAdj:=[Finished_Goods_Locations]QtyOH
//rReal1:=qtyBeforeAdj
//tJobItNum:=[Finished_Goods_Locations]Jobit
//$numJMI:=qryJMI (tJobItNum)
//sCriterion5:=Substring(tJobItNum;1;5)
//sCriterion6:=Substring(tJobItNum;7;2)
//i1:=Num(Substring(tJobItNum;10))
//sCriterion1:=[Finished_Goods_Locations]CustID+":"+[Finished_Goods_Locations]ProductCode
//sCriterion3:=[Finished_Goods_Locations]Location
//GOTO OBJECT(rReal1)

//Else 
//qtyBeforeAdj:=0
//sCriterion5:=""
//sCriterion6:=""
//i1:=0
//sCriterion1:=tSkidNumber+" was not found, try again."
//sCriterion3:=""
//tSkidNumber:=""
//GOTO OBJECT(tSkidNumber)
//End if 