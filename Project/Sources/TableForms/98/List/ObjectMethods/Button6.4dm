ALL RECORDS:C47([Finished_Goods_Specifications:98])
util_FindAndHighlight(->[Finished_Goods_Specifications:98]ProductCode:3; ->[Finished_Goods_Specifications:98]ControlNumber:2; ->[Finished_Goods_Specifications:98]Status:68; ->[Finished_Goods_Specifications:98]FG_Key:1)
USE SET:C118("UserSet")
CREATE EMPTY SET:C140([Finished_Goods_Specifications:98]; "UserSet")
HIGHLIGHT RECORDS:C656

CREATE SET:C116([Finished_Goods_Specifications:98]; "◊LastSelection"+String:C10(fileNum))
CREATE SET:C116([Finished_Goods_Specifications:98]; "CurrentSet")
winTitle:="Find...  "+fNameWindow(->[Finished_Goods_Specifications:98])
SET WINDOW TITLE:C213(winTitle)

Case of 
	: (b1=1)
		$orderBy:=->[Finished_Goods_Specifications:98]DateArtReceived:63
	: (b2=1)
		$orderBy:=->[Finished_Goods_Specifications:98]ControlNumber:2
	: (b3=1)
		$orderBy:=->[Finished_Goods_Specifications:98]FG_Key:1
	: (b4=1)
		$orderBy:=->[Finished_Goods:26]PressDate:64
	: (b5=1)
		$orderBy:=->[Finished_Goods_Specifications:98]Priority:50
	: (b6=1)
		$orderBy:=->[Finished_Goods_Specifications:98]DateArtReceived:63
End case 

SET AUTOMATIC RELATIONS:C310(True:C214; False:C215)
ORDER BY:C49([Finished_Goods_Specifications:98]; $orderBy->; >)
//End if 
SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)