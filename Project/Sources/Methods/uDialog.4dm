//%attributes = {"publishedWeb":true}
//Procedure : uDialog
//Called from : everywhere
//Parameters : 4  (1)string (2)Integers) 1(any)
//$1 string, dialog layout name
//$2 (Optional) window width Size,
//$3 (optioanl) window length size
//$4 (optional) window type
//$5 (optional) window title - 
//opens a  dialog from the constants file and layout name passed unless
//dialog window is a standardized 250 (w) x 120 (H) unless window sizes passed
//• 7/11/97 cs aded capability for title
//•052699  mlb  switch to "NewWindow" method

Case of 
	: (Count parameters:C259<3)
		NewWindow(250; 120; 6; -2)  //if no other size specified
	: (Count parameters:C259=4)
		NewWindow($2; $3; 0; $4)
	: (Count parameters:C259=5)
		NewWindow($2; $3; 0; $4; $5)
	Else 
		NewWindow($2; $3; 0; -2)  //custom window size
End case 

$Dialog:=$1
DIALOG:C40([zz_control:1]; $Dialog)
CLOSE WINDOW:C154