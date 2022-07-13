//%attributes = {"publishedWeb":true}
//NaNtoZero(real_value) - useful for zapping NANs to zero.
//use: APPLY TO SUBSELECTION([File1]subfile;[File1]subfile'field:=NANsToZero ([Fi
//use: APPLY TO SELECTION([File1];[File1]real:=NANsToZero ([File1]real))
//by Paul Carnine, Committed Software.
//•032097  MLB

$0:=$1

$str:=String:C10($1)

Case of 
	: (Length:C16($str)<1)
		$0:=0
		
	: ($str="-INF")
		$0:=0
		
	Else 
		$ch:=Character code:C91($str[[1]])
		
		If (($ch<40) | ($ch>57))
			$0:=0
		End if 
End case 