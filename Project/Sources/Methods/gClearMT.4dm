//%attributes = {"publishedWeb":true}
//(P)gClearMT
//12/19/94
//05/30/00 add shift

C_DATE:C307($1)

If (Count parameters:C259=1)
	dMADate:=$1
Else 
	dMADate:=4D_Current_date-1
End if 

sMAJob:=""
iMASeq:=0
sMACC:=""
iMAItemNo:=0
rMAMRHours:=0
rMARHours:=0
rMADTHours:=0
sMADTCat:=" "
tMRcode:=""
lMAGood:=0
lMAWaste:=0
sP_C:=""
iShift:=0  //05/30/00 add shift
adMADate:=0
sCustName:=""
fNewMT:=True:C214

SetObjectProperties(""; ->iMAItemNo; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->sMADTCat; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->tMRcode; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties("item@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties("mr@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties("dt@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
GOTO OBJECT:C206(sMAJob)