//%attributes = {"publishedWeb":true}
//(P) uMyLoadRec: Loads and Locks record from selected file
//Example: uMyLoadRec(»[FILE];TRUE)
//•081595  MLB  
//• 6/13/97 cs changed messaging - more informative

C_BOOLEAN:C305($fLocked; $2; $Message)  //$2=update message wanted, true/false
C_POINTER:C301($1)  //pointer to file
C_LONGINT:C283($i)

If (Count parameters:C259<2)  //message on/off not specified
	$Message:=True:C214  //defualt to on
Else 
	$Message:=$2
End if 
$fLocked:=False:C215
LOAD RECORD:C52($1->)  //load it
$i:=0

While (Locked:C147($1->))  //is it locked
	$fLocked:=True:C214  //flag to indicate lock found and message screen displayed
	
	If ($Message)  //message desired
		If ($i%10=0)  //clear every ten decimal points
			uLockMessage($1; "*")  //• 6/13/97 cs changed messaging
			$i:=$i+1
		End if 
		DELAY PROCESS:C323(Current process:C322; 300)  //delay  5 seconds
		LOAD RECORD:C52($1->)  //load again
	End if   //message    
End while 

If ($fLocked)
	CLOSE WINDOW:C154
End if 


//• 6/13/97 cs removed code

//If (Locked($1»)) & ($Message)  `locked and message requested
//uCenterWindow (300;35;720;"")  ``•081595  MLB  
//$i:=0
//End if `