//%attributes = {"publishedWeb":true}
//(p) JBPrintMatl
//prints the material sections of the new job bag
//$1 Longint Number of pixels printed so far
//$2  longint Max Pixels to a page
//• 12/1/97 cs created
//hold on to current record to print
//sort by commodity
//print only that commodity from group
//then look for more (differnt commodities to print
// Modified by: Mel Bohince (2/24/16) check if form exists for this commodity

C_LONGINT:C283($Pixels; $i; $MaxPixels; $1; $2; $height)
C_TEXT:C284($Comm)
CREATE SET:C116([Job_Forms_Materials:55]; "ToPrint")  //all items to print

$Pixels:=$1
$MaxPixels:=$2
$Comm:=""

//• 2/10/98 cs added sort by Subform then rotation for inks

ORDER BY FORMULA:C300([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Alpha20_2:21; >; [Job_Forms_Materials:55]Real2:18; >; Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2); >)

For ($i; 1; Records in selection:C76([Job_Forms_Materials:55]))
	If ($Pixels+24>$MaxPixels)  //if there is not enough room start new page
		$Pixels:=JBN_PrintHeader("M")
	End if 
	
	If ($Comm#Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2))
		$Comm:=Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2)
		If (Position:C15($Comm; " 01 02 03 04 05 06 07 08 09 12 13 17 33 ")=0)  // Modified by: Mel Bohince (2/24/16) check if form exists for this commodity
			$Comm:="12"
		End if 
		$height:=Print form:C5([Job_Forms_Materials:55]; "JBN_"+$Comm+".h")
		$Pixels:=$Pixels+12
	End if 
	
	If ([Raw_Materials:21]Raw_Matl_Code:1#[Job_Forms_Materials:55]Raw_Matl_Code:7)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
	End if 
	
	$height:=Print form:C5([Job_Forms_Materials:55]; "JBN_"+$Comm+".d")
	$Pixels:=$Pixels+12
	ADD TO SET:C119([Job_Forms_Materials:55]; "Printed")
	NEXT RECORD:C51([Job_Forms_Materials:55])
End for 
$0:=$Pixels

If (False:C215)
	If ([Job_Forms_Machines:43]CostCenterID:4#[Job_Forms_Materials:55]CostCenterID:2) & ([Job_Forms_Machines:43]Sequence:5=[Job_Forms_Materials:55]Sequence:3)  //• 2/24/98 cs locate machine job records for geting budgeted MR and Run times
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4=[Job_Forms_Materials:55]CostCenterID:2; *)
		QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=[Job_Forms_Materials:55]Sequence:3; *)
		QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Materials:55]JobForm:1)
	End if 
End if 