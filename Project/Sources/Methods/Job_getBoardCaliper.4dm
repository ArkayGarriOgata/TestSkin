//%attributes = {}
// Method: Job_getBoardCaliper ($jobform) -> r:caliper
// ----------------------------------------------------
// by: mel: 04/01/04, 13:38:04
// ----------------------------------------------------

C_REAL:C285($0)
C_TEXT:C284($1)

$0:=0  //the caliper

READ ONLY:C145([Job_Forms_Materials:55])
SET QUERY LIMIT:C395(1)
QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$1; *)
QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12="01@")

If (Records in selection:C76([Job_Forms_Materials:55])>0)
	If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)
		READ ONLY:C145([Raw_Materials:21])
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
		If (Records in selection:C76([Raw_Materials:21])>0)
			Case of   //make sure its in 1ooo'ths
					
				: ([Raw_Materials:21]Flex1:19>99)
					$0:=[Raw_Materials:21]Flex1:19/10000
				: ([Raw_Materials:21]Flex1:19>1)
					$0:=[Raw_Materials:21]Flex1:19/1000
				: ([Raw_Materials:21]Flex1:19>0.03)
					$0:=[Raw_Materials:21]Flex1:19/10
				Else 
					$0:=[Raw_Materials:21]Flex1:19
			End case 
		End if 
	End if 
End if 

SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([Raw_Materials:21]; 0)
REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)