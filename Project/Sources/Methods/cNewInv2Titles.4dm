//%attributes = {"publishedWeb":true}
//used as a refernce from rptNewInvtor2
//$titles:=$blankLine    
//$titles:=Change string($titles;"Date";$col2)
//$titles:=Change string($titles;"    Booked";$col5)
//$titles:=Change string($titles;"   Over";$col6)
//$titles:=Change string($titles;"   Cartons";$col7)
//$titles:=Change string($titles;"       Net";$col8)
//$titles:=Change string($titles;"      Open";$col9)
//$titles:=Change string($titles;"  Produced";$col10)
//$titles:=Change string($titles;"      Over";$col11)
//$titles:=Change string($titles;"     Order";$col12)
//$titles:=Change string($titles;"  All Open";$col13)
//$titles:=Change string($titles;"     Total";$col14)
//$titles:=Change string($titles;"      Need";$col15)

//$titles2:=$blankLine
//$titles2:=Change string($titles2;"P.O. Nº";$col1)
//$titles2:=Change string($titles2;"Opened";$col2)
//$titles2:=Change string($titles2;"Product Code";$col3)
//$titles2:=Change string($titles2;"Line";$col4)
//$titles2:=Change string($titles2;"  Quantity";$col5)
//$titles2:=Change string($titles2;"    Run";$col6)
//$titles2:=Change string($titles2;"      Sold";$col7)
//$titles2:=Change string($titles2;"   Shipped";$col8)
//$titles2:=Change string($titles2;"  Quantity";$col9)
//$titles2:=Change string($titles2;"  Quantity";$col10)
//$titles2:=Change string($titles2;"  Produced";$col11)
//$titles2:=Change string($titles2;"    Excess";$col12)
//$titles2:=Change string($titles2;"    Orders";$col13)
//$titles2:=Change string($titles2;"    Excess";$col14)
//$titles2:=Change string($titles2;"    to Mfg";$col15)
//$ref:=Create document("")
//SEND PACKET($ref;$titles)
//CLOSE DOCUMENT($ref)

//$totals:=Change string($totals;" ---------";$col5)
//$totals:=Change string($totals;" ---------";$col7)
//$totals:=Change string($totals;" ---------";$col8)
//$totals:=Change string($totals;" ---------";$col9)
//$totals:=$totals+$CR