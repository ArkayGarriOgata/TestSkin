//%attributes = {}
//Methd:  ______GarriTest
//Description:  This method is for testing

//$tCurrent:=

//For each ()  //Sum

//$tComparator:=  //Comparator

//Initial

//$rTotal:=$rValue

//Same

//$rTotal:=$rTotal+$rValue

//Different

//Insert Row

//VP SET FORMULA (VP Cell ("ViewProArea";13;1);"SUM($M$2:$M$3)")  // 

//$rTotal:=$rValue

//Value 
//Column

//End for each   //Done sum

//$nNumberOfRows:=42  //last row

//$nBreakColumn:=7  //ColumnToBreakOn

//$nSumColumn:=12  //Extended Price

//For ($nRow;1;$nNumberOfRows)  //Loop thru carton description

//$oComparatorCell:=VP Cell ("ViewProArea";$nBreakColumn;$nRow)
//$tComparator:=VP Get value ($oComparatorCell)

//$oSumCell:=VP Cell ("ViewProArea";$nSumColumn;$nRow)
//$rValue:=VP Get value ($oSumCell)


//Case of   //

//: ($nRow=1)  //Initial

//$rTotal:=$rValue
//$tCurrentComparator:=$tComparator

//: ($tCurrentComparator=$tComparator)  //Same

//$rTotal:=$rTotal+$rValue

//: ($tCurrentComparator#$tComparator)  //Different

//  //Insert Row This command isn't available till v19

//  //VP SET FORMULA (VP Cell ("ViewProArea";13;1);"SUM($M$2:$M$3)")  // 

//  //$rTotal:=$rValue

//  //Value 
//  //Column

//End case 

//End for   //Done loop thru carton description
