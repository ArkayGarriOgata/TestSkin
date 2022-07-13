Form:C1466.numberLoads:=Job_ConvertSheetsToLoads(Form:C1466.grossSheets; Form:C1466.caliper; Form:C1466.height)
Form:C1466.height:=Round:C94(Form:C1466.qty*Form:C1466.caliper; 2)