//%attributes = {"publishedWeb":true}
//PM:  RM_newInkubgroup;color;pjtNumber)->ink rmcode  12/18/00  mlb
//create a new Ink number

C_TEXT:C284($1; $2; $3; $0)

CREATE RECORD:C68([Raw_Materials:21])
[Raw_Materials:21]Raw_Matl_Code:1:=RM_newID
[Raw_Materials:21]CommodityCode:26:=2

If ($1#"")
	[Raw_Materials:21]SubGroup:31:=$1
Else 
	[Raw_Materials:21]SubGroup:31:="UV Special"
End if 
fCreateRMgroup(1)

If ($2#"")
	[Raw_Materials:21]Flex5:23:=$2
Else 
	[Raw_Materials:21]Flex5:23:=Request:C163("What color is this ink?"; "")
End if 

If ($3#"")
	If (Length:C16($3)=5)
		READ ONLY:C145([Customers_Projects:9])
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$3)
		If (Records in selection:C76([Customers_Projects:9])>0)
			[Raw_Materials:21]Description:4:="Requested for "+[Customers_Projects:9]CustomerName:4+"'s "+[Customers_Projects:9]Name:2+" project"
		End if 
	End if 
	[Raw_Materials:21]Flex4:22:="Pjt#"+$3
	[Raw_Materials:21]Flex6:24:="RQ# "
Else 
	[Raw_Materials:21]Flex4:22:=""
	[Raw_Materials:21]Description:4:=""
End if 
[Raw_Materials:21]Purchased:7:=True:C214
[Raw_Materials:21]ReceiptUOM:9:=[Raw_Materials:21]IssueUOM:10
[Raw_Materials:21]ConvertRatio_N:16:=1
[Raw_Materials:21]ConvertRatio_D:17:=1
[Raw_Materials:21]Matl_Manager:18:="INX"

[Raw_Materials:21]ModDate:47:=4D_Current_date
[Raw_Materials:21]ModWho:48:=<>zResp
SAVE RECORD:C53([Raw_Materials:21])

$0:=[Raw_Materials:21]Raw_Matl_Code:1

<>PassThrough:=True:C214
CREATE SET:C116([Raw_Materials:21]; "◊PassThroughSet")
REDUCE SELECTION:C351([Raw_Materials:21]; 0)
ViewSetter(2; ->[Raw_Materials:21])
//sFile:=Table name(->)  `reset this for normal exit