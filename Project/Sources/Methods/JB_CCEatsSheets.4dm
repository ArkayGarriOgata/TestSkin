//%attributes = {"publishedWeb":true}
//(p) JB_CCeatsSheets
//determine if the current cost center changes uses sheets
//during the process - ex Plates do NOT, presses DO
//retuns boolean True - if the cost center uses sheets
//$1 - string - Cost center to check
//$2 - longint - previous CC's planned qty
//• 2/2/98 cs created
//• 2/24/98 cs changed from testing specific CCs to testing
//   previous qtys verse current CC planned qty
//•082202  mlb  add 402 403 442 443

C_TEXT:C284($1)
C_LONGINT:C283($ID; $2)
C_BOOLEAN:C305($0)

$ID:=Num:C11($1)
$0:=($2#[Job_Forms_Machines:43]Planned_Qty:10)  //determine if the currrent is different that previous

Case of 
	: ($1="401")  //plates - often the first CC so there was/is no previous  
		$0:=False:C215
	: ($1="402")  //plates - often the first CC so there was/is no previous  
		$0:=False:C215
	: ($1="403")  //plates - often the first CC so there was/is no previous  
		$0:=False:C215
	: ($1="442")  //plates - often the first CC so there was/is no previous  
		$0:=False:C215
	: ($1="443")  //plates - often the first CC so there was/is no previous  
		$0:=False:C215
End case 