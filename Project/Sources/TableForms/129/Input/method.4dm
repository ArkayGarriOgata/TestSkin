Case of 
	: (Form event code:C388=On Load:K2:1)
		READ WRITE:C146([Finished_Goods_Color_Submission:78])
		QUERY:C277([Finished_Goods_Color_Submission:78]; [Finished_Goods_Color_Submission:78]Color:2=[Finished_Goods_Color_SpecSolids:129]id:1)
		ORDER BY:C49([Finished_Goods_Color_Submission:78]; [Finished_Goods_Color_Submission:78]dateIn:3; <)
	: (Form event code:C388=On Validate:K2:3)
		SAVE RECORD:C53([Finished_Goods_Color_Submission:78])
		REDUCE SELECTION:C351([Finished_Goods_Color_Submission:78]; 0)
	: (Form event code:C388=On Unload:K2:2)
		REDUCE SELECTION:C351([Finished_Goods_Color_Submission:78]; 0)
End case 
