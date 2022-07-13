//QUERY([ColorSubmission];[ColorSubmission]Returned=!00/00/00!;*)

//QUERY([ColorSubmission]; & ;[ColorSubmission]Color=[ColorSpecSolid]id)

//APPLY TO SELECTION([ColorSubmission];[ColorSubmission]Returned:=4D_Current_date)


CREATE RECORD:C68([Finished_Goods_Color_Submission:78])
[Finished_Goods_Color_Submission:78]Color:2:=[Finished_Goods_Color_SpecSolids:129]id:1
[Finished_Goods_Color_Submission:78]ProjectNo:1:=[Finished_Goods_Color_SpecMaster:128]projectId:4
[Finished_Goods_Color_Submission:78]dateIn:3:=4D_Current_date
SAVE RECORD:C53([Finished_Goods_Color_Submission:78])

QUERY:C277([Finished_Goods_Color_Submission:78]; [Finished_Goods_Color_Submission:78]Color:2=[Finished_Goods_Color_SpecSolids:129]id:1)
ORDER BY:C49([Finished_Goods_Color_Submission:78]; [Finished_Goods_Color_Submission:78]dateIn:3; <)