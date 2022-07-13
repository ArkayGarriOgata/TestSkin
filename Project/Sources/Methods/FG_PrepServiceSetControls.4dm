//%attributes = {"publishedWeb":true}
//PM:  FG_PrepServiceSetControls  1/19/01  mlb
//set controls

Case of 
	: ([Finished_Goods_Specifications:98]SizeAndStyleApproved:12="")
		calVar1:=0
	: ([Finished_Goods_Specifications:98]SizeAndStyleApproved:12="No")
		calVar1:=1
	: ([Finished_Goods_Specifications:98]SizeAndStyleApproved:12="Yes")
		calVar1:=2
	Else 
		calVar1:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]OriginalItem:13="")
		calVar2:=0
	: ([Finished_Goods_Specifications:98]OriginalItem:13="No")
		calVar2:=1
	: ([Finished_Goods_Specifications:98]OriginalItem:13="Yes")
		calVar2:=2
	Else 
		calVar2:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]MakePasteUp:25="")
		calVar3:=0
	: ([Finished_Goods_Specifications:98]MakePasteUp:25="No")
		calVar3:=1
	: ([Finished_Goods_Specifications:98]MakePasteUp:25="Yes")
		calVar3:=2
	Else 
		calVar3:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]Stamps:16="")
		calVar4:=0
	: ([Finished_Goods_Specifications:98]Stamps:16="No")
		calVar4:=1
	: ([Finished_Goods_Specifications:98]Stamps:16="Flat")
		calVar4:=2
	: ([Finished_Goods_Specifications:98]Stamps:16="Emboss")
		calVar4:=3
	: ([Finished_Goods_Specifications:98]Stamps:16="Combo")
		calVar4:=4
	Else 
		calVar4:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]Embosses:17="")
		calVar5:=0
	: ([Finished_Goods_Specifications:98]Embosses:17="No")
		calVar5:=1
	: ([Finished_Goods_Specifications:98]Embosses:17="Flat")
		calVar5:=2
	: ([Finished_Goods_Specifications:98]Embosses:17="Emboss")
		calVar5:=3
	: ([Finished_Goods_Specifications:98]Embosses:17="Combo")
		calVar5:=4
	Else 
		calVar5:=0
End case 

Case of 
	: (True:C214)
		//deleted this value    
	: ([Finished_Goods_Specifications:98]Omits:18="")
		calVar6:=0
	: ([Finished_Goods_Specifications:98]Omits:18="No")
		calVar6:=1
	: ([Finished_Goods_Specifications:98]Omits:18="Yes")
		calVar6:=2
	Else 
		calVar6:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]Coated:26="")
		calVar7:=0
	: ([Finished_Goods_Specifications:98]Coated:26="No")
		calVar7:=1
	: ([Finished_Goods_Specifications:98]Coated:26="Dull")
		calVar7:=2
	: ([Finished_Goods_Specifications:98]Coated:26="Satin")
		calVar7:=3
	: ([Finished_Goods_Specifications:98]Coated:26="Semi")
		calVar7:=4
	: ([Finished_Goods_Specifications:98]Coated:26="Gloss")
		calVar7:=5
	Else 
		calVar7:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]CoatingMethod:27="")
		calVar8:=0
	: ([Finished_Goods_Specifications:98]CoatingMethod:27="No")
		calVar8:=1
	: ([Finished_Goods_Specifications:98]CoatingMethod:27="Inline")
		calVar8:=2
	: ([Finished_Goods_Specifications:98]CoatingMethod:27="Offline")
		calVar8:=3
	: ([Finished_Goods_Specifications:98]CoatingMethod:27="Combo")
		calVar8:=4
	Else 
		calVar8:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]CoatingOmit:28="")
		calVar9:=0
	: ([Finished_Goods_Specifications:98]CoatingOmit:28="No")
		calVar9:=1
	: ([Finished_Goods_Specifications:98]CoatingOmit:28="Omit Scores")
		calVar9:=2
	: ([Finished_Goods_Specifications:98]CoatingOmit:28="Emboss/Die Cut")
		calVar9:=3
	Else 
		calVar9:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]GraphicsCommon:29="")
		calVar10:=0
	: ([Finished_Goods_Specifications:98]GraphicsCommon:29="No")
		calVar10:=1
	: ([Finished_Goods_Specifications:98]GraphicsCommon:29="Yes")
		calVar10:=2
	Else 
		calVar10:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]CodeNeeded:31="")
		calVar11:=0
	: ([Finished_Goods_Specifications:98]CodeNeeded:31="No")
		calVar11:=1
	: ([Finished_Goods_Specifications:98]CodeNeeded:31="Yes")
		calVar11:=2
	Else 
		calVar11:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]ItemWith:33="")
		calVar12:=0
	: ([Finished_Goods_Specifications:98]ItemWith:33="Plain Carton")
		calVar12:=1
	: ([Finished_Goods_Specifications:98]ItemWith:33="Internal Cells")
		calVar12:=2
		//: ([FG_Specification]ItemWith="Remain Blank")
		//  calVar12:=3
		//: ([FG_Specification]ItemWith="Print in Color")
		// calVar12:=4
	Else 
		calVar12:=0
End case 

Case of 
	: ([Finished_Goods_Specifications:98]Omit_Window_BS:75="")
		calVar13:=0
	: ([Finished_Goods_Specifications:98]Omit_Window_BS:75="No")
		calVar13:=1
	: ([Finished_Goods_Specifications:98]Omit_Window_BS:75="Yes")
		calVar13:=2
	Else 
		calVar13:=0
End case 

If ([Finished_Goods:26]PreflightAt:74#0)
	TS2DateTime([Finished_Goods:26]PreflightAt:74; ->dDate; ->tTime)
Else 
	dDate:=!00-00-00!
	tTime:=?00:00:00?
End if 

