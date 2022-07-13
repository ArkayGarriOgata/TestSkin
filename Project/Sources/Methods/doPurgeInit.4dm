//%attributes = {"publishedWeb":true}
//Procedure: doPurgeEstInit()  062995  MLB
//•062995  MLB  UPR 1507
//• 4/11/97 cs Jim requested a date for orders
//•101399 mlb change some inits
//*Init files

READ WRITE:C146([Estimates:17])
READ WRITE:C146([Estimates_PSpecs:57])
READ WRITE:C146([Work_Orders:37])
READ WRITE:C146([Estimates_Carton_Specs:19])
READ WRITE:C146([Estimates_Differentials:38])
READ WRITE:C146([Estimates_DifferentialsForms:47])
READ WRITE:C146([Estimates_Materials:29])
READ WRITE:C146([Estimates_Machines:20])
READ WRITE:C146([Estimates_FormCartons:48])
READ ONLY:C145([Customers_Orders:40])
READ ONLY:C145([Job_Forms:42])
READ WRITE:C146([Purchase_Orders:11])
READ WRITE:C146([Purchase_Orders_Items:12])
READ WRITE:C146([Job_Forms_Issue_Tickets:90])
READ WRITE:C146([Raw_Materials_Transactions:23])
READ WRITE:C146([Finished_Goods_Transactions:33])
//*.   Create empty sets
CREATE EMPTY SET:C140([Estimates:17]; "New")
CREATE EMPTY SET:C140([Estimates:17]; "RFQ")
CREATE EMPTY SET:C140([Estimates:17]; "Estimated")
CREATE EMPTY SET:C140([Estimates:17]; "Priced")
CREATE EMPTY SET:C140([Estimates:17]; "Quoted")
CREATE EMPTY SET:C140([Estimates:17]; "Ordered")
CREATE EMPTY SET:C140([Estimates:17]; "Accepted")
CREATE EMPTY SET:C140([Estimates:17]; "Budgeting")
CREATE EMPTY SET:C140([Estimates:17]; "Budget")
CREATE EMPTY SET:C140([Estimates:17]; "Contract")
CREATE EMPTY SET:C140([Estimates:17]; "Hold")
CREATE EMPTY SET:C140([Estimates:17]; "Kill")
CREATE EMPTY SET:C140([Estimates:17]; "blank")
CREATE EMPTY SET:C140([Estimates:17]; "Super")
C_REAL:C285(r1; r2; r3; r4; r5; r6; r7; r8; r9; r10; r11; r12; r13; r14; r15; r20)  //• 4/11/97 cs added r20
C_REAL:C285(r21; r22; r23; r24; r25; r26; r27; r28; r29; r30; r31; r32; r33; r34; r35; r36; r37; r38)  //• 4/11/97 cs added r35-r38
C_REAL:C285(r41; r42; r43; r44; r45; r46; r47; r48; r49; r50; r51; r52; r53; r54; r55; r56)
C_REAL:C285(r60; r61; r62; r63; r64; r65; r66)  //`• 11/6/97 cs fg transactions
C_REAL:C285(rFg60; rFg61; rFg62; rRMdays; rSuperCount; rSuperDays)  //;rFg63;rFg64;rFg65;rFg66;rFg67)
C_LONGINT:C283(cb1; cb2; cb3; cb4; cb5; cb6; cb7; cb8; cb9; cb10)
C_DATE:C307(dRmTransDat; dEndDate; dAsOf; $PurgeDate)  //• 4/11/97 cs 
$PurgeDate:=Date:C102(FiscalYear("start"; 4D_Current_date))
rFg60:=32
rFg61:=64
rFg62:=4D_Current_date-$PurgeDate+1  //keep current fiscal year
rFg63:=rFg62
r37:=rFg62  //closed jobs was 60
drmTransDat:=$PurgeDate
rRMdays:=rFg62

$PurgeDate:=Add to date:C393($PurgeDate; -1; 0; 0)  //keep last fiscal year
//4D_Current_date-$PurgeDate  `keep last fiscal year

dEndDate:=$PurgeDate  //• 4/11/97 cs used for closed Orders
dAsOf:=4D_Current_date
//*.   Set up default days old
r20:=60  //killed orders

r21:=90
r22:=90
r23:=90
r24:=90
r25:=180
r26:=90
r27:=90
r28:=180
r29:=90
r30:=90  //•050196  MLB  increase contract default
r31:=90
r32:=1
r33:=30
r34:=0
r35:=0

//*.   init the record in set counters
r41:=0
r42:=0
r43:=0
r44:=0
r45:=0
r46:=0
r47:=0
r48:=0
r49:=0
r50:=0
r51:=0
r52:=0
r53:=0
r54:=0
r60:=0  //• 11/6/97 cs fg transaction date ranges
r61:=0
r62:=0
r63:=0
r64:=0
r65:=0
r66:=0

//*.   the total count varibles
r55:=Records in table:C83([Estimates:17])
r56:=0  //total records selected
C_REAL:C285(r61; r62; r63; r64; r65; r66; r67; r68; r69; r70; r71; r72; r73)  //count of deleted related records
r61:=0
r62:=0
r63:=0
r64:=0
r65:=0
r66:=0
r67:=0
r68:=0
r69:=0
r70:=0
r71:=0
r72:=0
r73:=0
//
cb1:=1  //POs
cb2:=1  //Issue tickets
cb3:=1  //fgs trans w/o qtys
cb4:=1  //fg trans moves