//%attributes = {"publishedWeb":true}
//Procedure: fYYMMDD()  041996  MLB
//invert date to text in format of YYMMDD
//•021699  MLB  Y2K fix so batchTHC sorts correctly
C_DATE:C307($1)
C_LONGINT:C283($2)
C_TEXT:C284($3)  //delimiter
C_TEXT:C284($0; $strDate)
Case of 
	: (Count parameters:C259=3)  //•021699  MLB  Y2K
		$0:=String:C10(Year of:C25($1); "0000")+$3+String:C10(Month of:C24($1); "00")+$3+String:C10(Day of:C23($1); "00")
		
	: (Count parameters:C259=2)  //•021699  MLB  Y2K
		$0:=String:C10(Year of:C25($1); "0000")+String:C10(Month of:C24($1); "00")+String:C10(Day of:C23($1); "00")
	Else 
		$strDate:=String:C10($1; <>MIDDATE)
		$len:=Length:C16($strDate)
		Case of 
			: ($len=8)  //01/01/99
				$0:=$strDate[[7]]+$strDate[[8]]+$strDate[[1]]+$strDate[[2]]+$strDate[[4]]+$strDate[[5]]
				
			: ($len=10)  //01/01/2000 
				$0:=$strDate[[9]]+$strDate[[10]]+$strDate[[1]]+$strDate[[2]]+$strDate[[4]]+$strDate[[5]]
				
			Else 
				$0:=$strDate
		End case 
End case   //  
//