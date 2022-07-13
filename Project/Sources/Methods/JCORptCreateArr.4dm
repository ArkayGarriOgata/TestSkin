//%attributes = {"publishedWeb":true}
//(P) JCORptCreateArr
//based on gCreateArrays
//• 12/9/97 cs created

ARRAY TEXT:C222(ayA1; 0)  //upr 1407 make string array larger
ARRAY REAL:C219(ayA2; 0)
ARRAY REAL:C219(ayA3; 0)
ARRAY REAL:C219(ayA4; 0)
ARRAY REAL:C219(ayA5; 0)
ARRAY REAL:C219(ayA6; 0)
ARRAY REAL:C219(ayA7; 0)

ARRAY TEXT:C222(ayB1; 0)  //upr 1407 make string array larger
ARRAY REAL:C219(ayB2; 0)
ARRAY REAL:C219(ayB3; 0)
ARRAY REAL:C219(ayB4; 0)
ARRAY REAL:C219(ayB5; 0)
ARRAY REAL:C219(ayB6; 0)
ARRAY REAL:C219(ayB7; 0)
ARRAY REAL:C219(ayBX; 0)

ARRAY TEXT:C222(ayC1; 0)  //upr 1407 make string array larger
ARRAY REAL:C219(ayC2; 0)
ARRAY REAL:C219(ayC3; 0)
ARRAY REAL:C219(ayC4; 0)
ARRAY REAL:C219(ayC5; 0)
ARRAY REAL:C219(ayC6; 0)
ARRAY REAL:C219(ayC7; 0)
ARRAY REAL:C219(ayCX; 0)

ARRAY TEXT:C222(ayD1; 10)
ayD1{1}:="  Total Material"
ayD1{2}:="  Total MR"
ayD1{3}:="  Total Run"
ayD1{4}:="Total Conv."
ayD1{5}:="Total MFG c"
ayD1{6}:=" Outside Com/Other"
ayD1{7}:="Direct Cost"
ayD1{8}:=" Sales Revenue"
ayD1{9}:="Contribution"
ayD1{10}:="Contribution Factor"
ARRAY REAL:C219(ayD2; 10)
ARRAY REAL:C219(ayD3; 10)
ARRAY REAL:C219(ayD4; 10)
ARRAY REAL:C219(ayD5; 10)
ARRAY REAL:C219(ayD6; 10)
ARRAY REAL:C219(ayD7; 10)

ARRAY TEXT:C222(ayE1; 24)
ayE1{1}:="Budgeted Quantity"
ayE1{2}:="Produced Quantity"
ayE1{3}:="Selling Price/M"
ayE1{4}:="Allowed Overrun Percent"
ayE1{5}:="Budgeted Net Sheets "
ayE1{6}:="Budgeted Gross Sheets (including start up)"
ayE1{7}:="First Sheet Count times # Up (from Cost Sheet)"
ayE1{8}:="Actual Waste (G - B)"
ayE1{9}:="Actual Waste Percent (H / G)"
ayE1{10}:="Budgeted Waste Percent ((F - E) / F)"
ayE1{11}:="Budgeted Waste Cartons (J * G)"
ayE1{12}:="Difference of Cartons (K - H)"
ayE1{13}:="Loss of selling dollars (L / 1000 * C)"
ayE1{14}:="Allowed Overrun (A * D)"
ayE1{15}:="Actual Over/Underrun (B - A)"
ayE1{16}:="Difference (O - N)"
ayE1{17}:="Loss of selling dollars (P / 1000 * C)"
ayE1{18}:="Actual Board Cost (from Close-Out)"
ayE1{19}:="Budgeted Board Waste (J * R)"
ayE1{20}:="Actual Board Waste (I * R)"
ayE1{21}:="Board Waste Variance (S - T)"
ayE1{22}:="Total Board Variance (from Close-Out)"
ayE1{23}:="Board Spending Variance (V - U)"
ayE1{24}:="Selling Dollars (O / 1000 * C)"
ARRAY REAL:C219(ayE2; 24)
aHdTitle1:="Selling Dollars lost due to Excess Waste"
aHdTitle2:="Selling Dollars lost due to less than full Overrun"
aHdTitle3:="Calculation of Board Waste and Board Spending Variances"
aHdTitle4:="Calculation of Actual Overrun Sales Value"

aSubTitle1:=ayE1{1}
aSubTitle2:=ayE1{2}
aSubTitle3:=ayE1{3}
aSubTitle4:=ayE1{4}
aSubTitle5:=ayE1{5}
aSubTitle6:=ayE1{6}
aSubTitle7:=ayE1{7}
aSubTitle8:=ayE1{8}
aSubTitle9:=ayE1{9}
aSubTitle10:=ayE1{10}
aSubTitle11:=ayE1{11}
aSubTitle12:=ayE1{12}
aSubTitle13:=ayE1{13}
aSubTitle14:=ayE1{14}
aSubTitle15:=ayE1{15}
aSubTitle16:=ayE1{16}
aSubTitle17:=ayE1{17}
aSubTitle18:=ayE1{18}
aSubTitle19:=ayE1{19}
aSubTitle20:=ayE1{20}
aSubTitle21:=ayE1{21}
aSubTitle22:=ayE1{22}
aSubTitle23:=ayE1{23}
aSubTitle24:=ayE1{24}

aLTitle1:="A."
aLTitle2:="B."
aLTitle3:="C."
aLTitle4:="D."
aLTitle5:="E."
aLTitle6:="F."
aLTitle7:="G."
aLTitle8:="H."
aLTitle9:="I."
aLTitle10:="J."
aLTitle11:="K."
aLTitle12:="L."
aLTitle13:="M."
aLTitle14:="N."
aLTitle15:="O."
aLTitle16:="P."
aLTitle17:="Q."
aLTitle18:="R."
aLTitle19:="S."
aLTitle20:="T."
aLTitle21:="U."
aLTitle22:="V."
aLTitle23:="W."
aLTitle24:="X."