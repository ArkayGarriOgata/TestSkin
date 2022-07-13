//%attributes = {}
// Method: FG_PrepServiceProofReadDelete () -> 
// ----------------------------------------------------
// by: mel: 06/23/05, 10:14:23
// ----------------------------------------------------
// Description:
// clear existing record so changes in standard set can take effect

// Updates:
//11/23/10 mlb -- table changed to QA_Proof_Reading_Specs, only need one set for printing purposes
// ----------------------------------------------------
//ALL SUBRECORDS([Finished_Goods_Specifications]ProofReading)
//While (Records in subselection([Finished_Goods_Specifications]ProofReading)>0)
//DELETE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//ALL SUBRECORDS([Finished_Goods_Specifications]ProofReading)
//End while 

