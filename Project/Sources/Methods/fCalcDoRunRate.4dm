//%attributes = {"publishedWeb":true}
//fCalcDoRunRate(sheets;redux1;redux2)   -JML   8/3/93
//a support procedure for the fCalc...() procedures
//determines standard run rate based on range
//•2/02/00  mlb  add reductions

C_LONGINT:C283($1; $speed; $0)
C_BOOLEAN:C305($2; $3)

$Gross:=$1

Case of 
	: ($gross<=[Cost_Centers:27]RS_shortTo:45)
		$speed:=[Cost_Centers:27]RS_short:46
	: ($gross<=[Cost_Centers:27]RS_MediumTo:47)
		$speed:=[Cost_Centers:27]RS_Medium:48
	Else 
		$speed:=[Cost_Centers:27]RS_Long:50
End case 

If (Count parameters:C259>=2)
	If ($2)
		$speed:=$speed*(1-([Cost_Centers:27]RS_reduction1:53/100))
	End if 
	
	If (Count parameters:C259>=3)
		If ($3)
			$speed:=$speed*(1-([Cost_Centers:27]RS_reduction2:54/100))
		End if 
	End if 
End if 

$0:=$speed