//%attributes = {"publishedWeb":true}
//(p) JCOIssDtermCost
//determins cost/unit for material being issued
//Returns : Real - cost/unit of material, sets process var fFlag1(boolean)
//• 12/3/97 cs created

C_REAL:C285($Cost; $0)
C_LONGINT:C283($i)

QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]UseForEst:12=True:C214; *)  //try to locate Group (standards) used by Estimating
QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]Commodity_Key:3=[Job_Forms_Materials:55]Commodity_Key:12)
$Cost:=0

If (Records in selection:C76([Raw_Materials_Groups:22])=0)  //if there was NOT a Group/Standard  found
	fFlag1:=True:C214  //casting by Commodit standard averaging
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]UseForEst:12=True:C214; *)  //locate all Group records for Comm Code
	QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]Commodity_Key:3=Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2)+"@")
	
	For ($i; 1; Records in selection:C76([Raw_Materials_Groups:22]))  //average Costs across all Estimating standards for this Comm Code.
		$Cost:=$Cost+[Raw_Materials_Groups:22]Std_Cost:4
	End for 
	$Cost:=$Cost/($i-1)  //get average cost
Else   //just assign the cost from the standard
	fFlag1:=False:C215
	$Cost:=[Raw_Materials_Groups:22]Std_Cost:4
End if 

$0:=$Cost