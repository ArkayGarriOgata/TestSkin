//%attributes = {"publishedWeb":true}
//PM:  Est_FormOrientationhortgrain;->formWidth;->formLength)  9/13/99  MLB
//set the formWidth and formLength variables
//was embedded in estimate calculation
//• 5/23/97 cs upr 1870 - consistant use of field values, with JobBag
//formWidth & formLength - these dimensions are also passed to material calcs
//this insures that there are no problems with data entry (width v Length)
//•091099  mlb  erronously compared [JobForm] fields!

C_BOOLEAN:C305($1; $0; $isShort)
C_POINTER:C301($2; $3)

$isShort:=$1
$0:=$isShort

Case of   //this insures that there is NO problem with data entry order (length v width)
	: ([Estimates_DifferentialsForms:47]Width:5=[Estimates_DifferentialsForms:47]Lenth:6)  //if these are the same size pick one, does not matter
		$2->:=[Estimates_DifferentialsForms:47]Width:5
		$3->:=[Estimates_DifferentialsForms:47]Lenth:6
	: ($isShort) & ([Estimates_DifferentialsForms:47]Width:5<[Estimates_DifferentialsForms:47]Lenth:6)  //if this is SHORT grain, Width is smaller -> length
		$2->:=[Estimates_DifferentialsForms:47]Lenth:6
		$3->:=[Estimates_DifferentialsForms:47]Width:5
	: ($isShort) & ([Estimates_DifferentialsForms:47]Width:5>[Estimates_DifferentialsForms:47]Lenth:6)  //if this is SHORT grain, Length is smaller stays length
		$2->:=[Estimates_DifferentialsForms:47]Width:5
		$3->:=[Estimates_DifferentialsForms:47]Lenth:6
	: ([Estimates_DifferentialsForms:47]Width:5<[Estimates_DifferentialsForms:47]Lenth:6)  //if this is NORMAL grain, width is smallest -> stays width
		$2->:=[Estimates_DifferentialsForms:47]Width:5
		$3->:=[Estimates_DifferentialsForms:47]Lenth:6
	: ([Estimates_DifferentialsForms:47]Width:5>[Estimates_DifferentialsForms:47]Lenth:6)  //if this is NORMAL grain, Length is smallest -> Width
		$2->:=[Estimates_DifferentialsForms:47]Lenth:6
		$3->:=[Estimates_DifferentialsForms:47]Width:5
End case 
//• 5/23/97 cs end 
$0:=$isShort

Est_LogIt("Short Grain = "+("Yes"*Num:C11($isShort))+("No"*Num:C11(Not:C34($isShort))))
Est_LogIt("Form Dimensions = "+String:C10($2->)+"W x "+String:C10($3->)+"L")