//%attributes = {"publishedWeb":true}
//(p) JCOIssueExcept
//this setsup the text needed for printing an exception report for
//items which had to be issued to a generic bin
//$1 - string (24) - costing method
//$2 - real - Cost/unit
//$3 - Real - Issue amount
//• 5/7/98 cs modified to handle exception of NO commodity code

C_TEXT:C284($Text; $0)
C_TEXT:C284($RM)
C_REAL:C285($2; $3)
C_TEXT:C284($1)

Case of 
	: ([Job_Forms_Materials:55]Commodity_Key:12="")
		$RM:=""
	: ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")
		$RM:=[Job_Forms_Materials:55]Raw_Matl_Code:7
	Else 
		$RM:="No Raw Material Specified."
End case 

If ($Rm#"")
	$Text:="•  Issuing - "+$Rm+" with Commodity "+[Job_Forms_Materials:55]Commodity_Key:12+" Into Generic Bin: "
	$Text:=$Text+Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2)+"-Generic"+Char:C90(13)
	$Text:=$Text+"    Planned Quantity = "+String:C10([Job_Forms_Materials:55]Planned_Qty:6; "###,##0.00")+"  "
	$Text:=$Text+" Issuing Quantity = "+String:C10($3; "###,##0.00")+" at a Cost of "+String:C10($2; "###,##0.00")+Char:C90(13)
	$Text:=$Text+"    Costing determined by : "+$1+Char:C90(13)+Char:C90(13)
Else 
	$Text:="• Commodity code was not specified.  Can not issue materials against a "+"Budget Item without a Commodity Code."+Char:C90(13)
	$Text:="   Materials Code = "+[Job_Forms_Materials:55]Raw_Matl_Code:7+" Planned Quantity = "+String:C10([Job_Forms_Materials:55]Planned_Qty:6; "###,##0.00")+"  "+Char:C90(13)+Char:C90(13)
End if 

$0:=$Text