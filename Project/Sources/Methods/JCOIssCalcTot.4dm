//%attributes = {"publishedWeb":true}
//(p) JCOIssCalcTot
//based on gIssCalcTot
//• 12/3/97 cs created

MESSAGE:C88(<>sCR+"Calculating RM Actuals!"+<>sCR+"Please Wait...")
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Location:15="WIP")

[Job_Forms:42]ActMatlCost:40:=uNANCheck(Sum:C1([Raw_Materials_Transactions:23]ActExtCost:10)*-1)  //•070695 add the -1
[Job_Forms:42]ActFormCost:13:=uNANCheck([Job_Forms:42]ActLabCost:37+[Job_Forms:42]ActOvhdCost:38+[Job_Forms:42]ActS_ECost:39+[Job_Forms:42]ActMatlCost:40)

If (([Job_Forms:42]QtyActProduced:35#0) & ([Job_Forms:42]ActFormCost:13#0))
	[Job_Forms:42]ActCost_M:41:=uNANCheck(Round:C94(([Job_Forms:42]ActFormCost:13/[Job_Forms:42]QtyActProduced:35)*1000; 2))
Else 
	[Job_Forms:42]ActCost_M:41:=0
End if 
SAVE RECORD:C53([Job_Forms:42])