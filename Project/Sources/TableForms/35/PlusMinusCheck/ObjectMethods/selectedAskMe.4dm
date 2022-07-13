// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/13/13, 15:09:50
// ----------------------------------------------------
// Method: [Finished_Goods_Locations].PlusMinusCheck.bAskMe
// ----------------------------------------------------
// Modified by: Mel Bohince (4/6/16) keep askme a singleton

<>AskMeFG:=atProdCode{abJobIts}
<>AskMeCust:=""  //[CustomerOrder]CustID
displayAskMe("New")  // Modified by: Mel Bohince (4/6/16) keep askme a singleton
//vAskMePID:=uSpawnProcess ("sAskMe";64000;"AskMe:F/G")