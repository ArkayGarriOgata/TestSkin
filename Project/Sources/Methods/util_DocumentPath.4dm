//%attributes = {}
// Method: util_DocumentPath () -> path to ~/Documents/aMs_Documents/ folder
// ----------------------------------------------------
// by: mel: 08/18/03, 09:45:03
// ----------------------------------------------------
// Description:
// return a standard path for dumping all documents into
// Updates:
// • mel (11/17/03, 15:10:56) try to make windows compatible
// ----------------------------------------------------

C_TEXT:C284($0; $path)
C_TEXT:C284(<>DELIMITOR)
If (Length:C16(<>DELIMITOR)=0)  //in a race condition
	DELAY PROCESS:C323(Current process:C322; 10)
End if 

Case of 
	: (<>DELIMITOR=":")
		$path:=System folder:C487(Documents folder:K41:18)
		//$path:=Replace string($path;"Library:Application Support:";"Documents")// Modified by: Mel Bohince (9/23/13) updated command ^^
		
	Else   //\\ 
		$path:=System folder:C487(Desktop:K41:16)  //"C:\\"
End case 

If (Test path name:C476($path)#Is a folder:K24:2)
	CREATE FOLDER:C475($path)
End if 

<>AA_PNGA_CHANGED_START:=True:C214
C_LONGINT:C283($CodeLastCharPath; $CodeDELIMITOR)
$CodeLastCharPath:=Character code:C91(Substring:C12($path; Length:C16($path); 1))
$CodeDELIMITOR:=Character code:C91(<>DELIMITOR)
$path:=$path+(<>DELIMITOR*Num:C11($CodeLastCharPath#$CodeDELIMITOR))+"AMS_Documents"
<>AA_PNGA_CHANGED_END:=True:C214

If (Test path name:C476($path)#Is a folder:K24:2)
	CREATE FOLDER:C475($path)
End if 

$0:=$path+<>DELIMITOR
