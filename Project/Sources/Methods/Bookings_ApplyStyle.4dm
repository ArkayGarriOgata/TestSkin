//%attributes = {}
// _______
// Method: Bookings_ApplyStyle   ( ) ->
// By: Mel Bohince @ 12/07/21, 13:41:49
// Description
// adorn the ViewPro area
// ----------------------------------------------------

//remember collection and grid's origin is at 0,0 not 1,1

$areaName:="viewProArea"
$numGridRows:=Form:C1466.bookings_c.length
$numGridCols:=20
$numMthCols:=12
$numCustRows:=$numGridRows-4  // 1 heading, 1 blank, 3 totals

//set up the range names
//VP Cells ( vpAreaName ; column ; row ; columnCount ; rowCount {; sheet} ) -> Range object of cells

VP ADD RANGE NAME(VP Cells($areaName; 0; 0; $numGridCols; 1); "Headings")  //top row

VP ADD RANGE NAME(VP Cells($areaName; 0; 1; 3; $numCustRows); "Customers")  //left 2 columns (id & name)

VP ADD RANGE NAME(VP Cells($areaName; 3; 1; $numMthCols; $numCustRows); "PivotArea")  //per mth totals/cust

VP ADD RANGE NAME(VP Cells($areaName; 15; 1; 1; $numCustRows); "CustomerTotals")  //custs' ytd total
VP ADD RANGE NAME(VP Cells($areaName; 16; 1; 1; $numCustRows); "PV")  //custs' ytd PV
VP ADD RANGE NAME(VP Cells($areaName; 17; 1; 1; $numCustRows); "AVG_UNIT")  //custs' average unit price
VP ADD RANGE NAME(VP Cells($areaName; 18; 1; 1; $numCustRows); "PctBkg")  //custs' percent of ttl bk 
VP ADD RANGE NAME(VP Cells($areaName; 19; 1; 1; $numCustRows); "PctQty")  //custs' percent of ttl qty 


VP ADD RANGE NAME(VP Cells($areaName; 0; ($numGridRows-2); $numGridCols; 1); "MonthTotalsBooking")
VP ADD RANGE NAME(VP Cells($areaName; $numGridCols-4; ($numGridRows-2); 4; 1); "GrandPV")

VP ADD RANGE NAME(VP Cells($areaName; 0; ($numGridRows-1); $numGridCols; 1); "MonthTotalsCost")

VP ADD RANGE NAME(VP Cells($areaName; 0; ($numGridRows); $numGridCols; 1); "MonthTotalsQty")
VP ADD RANGE NAME(VP Cells($areaName; $numGridCols-3; $numGridRows; 3; 1); "GrandAvgUnit")


//apply color
$style:=New object:C1471
$style.font:="12pt Calibri"
$style.backColor:="#1B3409"
$style.foreColor:="FloralWhite"
$style.hAlign:=vk horizontal align right:K89:43
VP SET CELL STYLE(VP Name($areaName; "Headings"); $style)

$style:=New object:C1471
$style.font:="12pt Calibri"
$style.backColor:="#DEF2CF"
$style.foreColor:="Black"
$style.hAlign:=vk horizontal align left:K89:42
VP SET CELL STYLE(VP Name($areaName; "Customers"); $style)

$style:=New object:C1471
$style.font:="12pt Calibri"
$style.backColor:="#CCEBB7"
$style.foreColor:="Black"
$style.hAlign:=vk horizontal align right:K89:43
$style.formatter:="_($* #,##0_)"
VP SET CELL STYLE(VP Name($areaName; "CustomerTotals"); $style)

$style.formatter:="_(* #,##0_)"
$style.backColor:="#9BD770"
VP SET CELL STYLE(VP Name($areaName; "PV"); $style)

$style.formatter:="_($* #,##0.00_)"
$style.backColor:="#66B032"
VP SET CELL STYLE(VP Name($areaName; "AVG_UNIT"); $style)

$style.formatter:="_(* #,##0.00_)"
$style.backColor:="#38700F"
$style.foreColor:="White"
VP SET CELL STYLE(VP Name($areaName; "PctBkg"); $style)

$style.backColor:="#375F1B"
VP SET CELL STYLE(VP Name($areaName; "PctQty"); $style)



$style:=New object:C1471
$style.font:="12pt Calibri"
$style.backColor:="#CCEBB7"
$style.foreColor:="Black"
$style.hAlign:=vk horizontal align right:K89:43
$style.formatter:="_($* #,##0_)"
VP SET CELL STYLE(VP Name($areaName; "MonthTotalsBooking"); $style)

$style.formatter:="_*#,##0_"
VP SET CELL STYLE(VP Name($areaName; "GrandPV"); $style)

$style.backColor:="#9BD770"
$style.foreColor:="Red"
VP SET CELL STYLE(VP Name($areaName; "MonthTotalsCost"); $style)

$style.backColor:="#66B032"
$style.foreColor:="Blue"
$style.formatter:="_*#,##0_"
VP SET CELL STYLE(VP Name($areaName; "MonthTotalsQty"); $style)

$style.formatter:="_($* #,##0.00_)"
VP SET CELL STYLE(VP Name($areaName; "GrandAvgUnit"); $style)




$style:=New object:C1471
$style.font:="12pt Calibri"
$style.backColor:="#F6FCF2"
$style.foreColor:="Black"
$style.hAlign:=vk horizontal align right:K89:43
$style.formatter:="_($* #,##0_)"

VP SET CELL STYLE(VP Name($areaName; "PivotArea"); $style)


VP SET CELL STYLE(VP Cells($areaName; 0; 0; 2; $numGridRows+1); New object:C1471("hAlign"; vk horizontal align left:K89:42))



//VP SET VALUES (VP Cell ($areaName;0;2);$cellsValues)

//VP ADD FORMULA NAME ($areaName;"-A1+G1";"evolutionAppDoctor";New object("baseRow";0;"baseColumn";12))

//VP SET FORMULA (VP Cells ($areaName;15;2;6;$esDoctors.length);"evolutionAppDoctor")

//$dayRangeY1:=VP Cells ($areaName;3;2;1;$esDoctors.length)
//$dayRangeY2:=VP Cells ($areaName;9;2;1;$esDoctors.length)
//VP SET CELL STYLE (VP Combine ranges ($dayRangeY1;$dayRangeY2);New object("formatter";"###\" d\""))

//$minRangeY1:=VP Cells ($areaName;4;2;1;$esDoctors.length)
//$minRangeY2:=VP Cells ($areaName;10;2;1;$esDoctors.length)
//VP SET CELL STYLE (VP Combine ranges ($minRangeY1;$minRangeY2);New object("formatter";"###\" mn\""))

//VP SET CELL STYLE (VP Column ($areaName;17;4);New object("formatter";"[green]+General;[Red]-General;[blue]General"))

//VP SET CELL STYLE (VP Column ($areaName;15;1);New object("formatter";"[green]+General\" d\";[Red]-General\" d\";[blue]General\" d\""))

//VP SET CELL STYLE (VP Column ($areaName;16;1);New object("formatter";"[green]+General\" mn\";[Red]-General\" mn\";[blue]General\" mn\""))

//VP COLUMN AUTOFIT (VP Column ($areaName;1;2)).   //v19


