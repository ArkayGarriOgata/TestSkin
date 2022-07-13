//%attributes = {"publishedWeb":true}
//(p) RmShellCreate
//allows the user to enter outline information to create a new RM 
//initially used only by planners for creating Inks
//$1 - string - Rm Code
//$2 - string - Commodity key
//• 1/27/98 cs created
//• 5/20/98 cs insure that RM code has no spaces leading or trailing

C_TEXT:C284($1; $2)
C_TEXT:C284(xText)
C_TEXT:C284(sUOM)

Case of   //perpare for other commodities in future
	: ($2="02@") | ($2="03@")  //this is an ink
		sCriterion4:=""
		sCriterion2:=fStripSpace("B"; Substring:C12($1; 1; 20))  //• 5/20/98 cs insure that RM code has no spaces leading or trailing
		sCriterion3:=$2
		sUOM:="LB"
		xText:=""
		uDialog("InkShell"; 325; 255)
		
		If (OK=1)
			READ WRITE:C146([Raw_Materials:21])
			CREATE RECORD:C68([Raw_Materials:21])
			[Raw_Materials:21]Raw_Matl_Code:1:=sCriterion2
			[Raw_Materials:21]Commodity_Key:2:=$2
			[Raw_Materials:21]Status:25:="Active"
			[Raw_Materials:21]ReceiptUOM:9:=sUOM
			[Raw_Materials:21]IssueUOM:10:=sUOM
			[Raw_Materials:21]ConvertRatio_N:16:=1
			[Raw_Materials:21]ConvertRatio_D:17:=1
			[Raw_Materials:21]Flex5:23:=sCriterion4  //color entered in dialog
			[Raw_Materials:21]Description:4:=xText
			[Raw_Materials:21]CommodityCode:26:=Num:C11(Substring:C12($2; 1; 2))
			[Raw_Materials:21]CompanyID:27:="1"  //just a default
			[Raw_Materials:21]DepartmentID:28:="9999"  //default for inventory items
			If ([Raw_Materials:21]CommodityCode:26=2)
				[Raw_Materials:21]Obsolete_ExpCode:29:="1242"  //default for ink
			Else 
				[Raw_Materials:21]Obsolete_ExpCode:29:="1244"  //default for coating
			End if 
			[Raw_Materials:21]SubGroup:31:=Substring:C12($2; 4)
			[Raw_Materials:21]ModDate:47:=4D_Current_date
			[Raw_Materials:21]ModWho:48:=<>zResp
			[Raw_Materials:21]Flex4:22:="Created by Planner(s)"
			SAVE RECORD:C53([Raw_Materials:21])
			READ ONLY:C145([Raw_Materials:21])
		End if 
End case 