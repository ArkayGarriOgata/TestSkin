//%attributes = {"publishedWeb":true}
//PM: PO_fixPrice(po;newprice) -> 
//@author mlb - 5/11/01  14:35
//called from beforePOReview when err detected

C_TEXT:C284($1)
C_REAL:C285($2)

[Purchase_Orders:11]ChgdOrderAmt:13:=$2
SAVE RECORD:C53([Purchase_Orders:11])
zwStatusMsg("PRICE FIX"; "[PURCHASE_ORDER]ChgdOrderAmt set to "+String:C10($2)+" on PO# "+$1)