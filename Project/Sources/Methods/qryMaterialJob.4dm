//%attributes = {"publishedWeb":true}
//qryMaterialJob 091395

C_TEXT:C284($1; $jobForm)
C_LONGINT:C283($2; $seq)

$jobForm:=$1
$seq:=$2

QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$jobForm; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=$seq)  //•081495  MLB 

$0:=Records in selection:C76([Job_Forms_Materials:55])