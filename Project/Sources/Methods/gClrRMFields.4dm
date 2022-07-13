//%attributes = {"publishedWeb":true}
//(P) gClrRMFields: Clear Fields for RM Receipt or Issue
//•2/13/97 cs - added scompany to vars to clear
//• 6/20/97 cs added sCC (who) and sName (department to clears)

sPONumber:=""
//sPONum:=""
sItemNumber:=""
sRMCode:=""
sDesc:=""
lSeqNumber:=0  //?
sBinNo:=""
sRefNo:=""
sPONo:=""  //?
sBinPO:=""
rQty:=0
rQty2:=0
r1:=1
r2:=1
sUM1:=""
sUM2:=""
sUM3:=""
rPriceConv:=1
aActCost:=0
lRecordNo:=0
sCC:=""  //who ordered field
sName:=""
sLocation:=""  //department name field
sCompany:=""  //• 2/13/97
dRMDate:=4D_Current_date
sCustname:=""
rActPrice:=0
rPriceConv:=0
rPOPrice:=0
OBJECT SET ENABLED:C1123(bAdd; False:C215)