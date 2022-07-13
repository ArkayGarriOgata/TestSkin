//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceProofRead() -> 
//@author mlb - 8/10/01  13:15
// • mel (6/1/04, 12:02:38)add-- Verify UPC knockout agrees with Prep Spec
// • mel (6/23/05, 09:40:51) change numbering
// Modified by Mel Bohince on 1/11/07 at 15:04:37 : added i and j
// • mel (11/23/10) change to [QA_Proof_Reading_Specs] shared by all, just for printing
ALL RECORDS:C47([QA_Proof_Reading_Specs:190])
If (Records in selection:C76([QA_Proof_Reading_Specs:190])#9)  //force to the standard set of tasks
	$i:=util_DeleteSelection(->[QA_Proof_Reading_Specs:190])
	
	ARRAY TEXT:C222($aTask; 9)
	$aTask{1}:="     a. Code number"
	$aTask{2}:="     b. Item Description"
	$aTask{3}:="     c. Verify UPC is correct and meets scanning requirements"
	$aTask{4}:="     d. Control number"
	$aTask{5}:="     e. Glue flap bar code same as control number"
	$aTask{6}:="     f. Copy is correct"
	$aTask{7}:="     g. No copy (return to customer for approval to proceed with order)"
	$aTask{8}:="     h. Copy is unreadable (return to customer for approval to proceed with "+"order)"
	$aTask{9}:="     i. All visual elements are correct to customer supplied art"
	ARRAY INTEGER:C220($aDisplayOrder; Size of array:C274($aTask))
	For ($i; 1; Size of array:C274($aTask))
		$aDisplayOrder{$i}:=$i
	End for 
	ARRAY TO SELECTION:C261($aDisplayOrder; [QA_Proof_Reading_Specs:190]DisplayOrder:1; $aTask; [QA_Proof_Reading_Specs:190]Task:2)
	ALL RECORDS:C47([QA_Proof_Reading_Specs:190])
End if 
ORDER BY:C49([QA_Proof_Reading_Specs:190]; [QA_Proof_Reading_Specs:190]DisplayOrder:1; >)



//ALL SUBRECORDS([Finished_Goods_Specifications]ProofReading)
//If (Records in subselection([Finished_Goods_Specifications]ProofReading)=0)
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=1
//[Finished_Goods_Specifications]ProofReading'Task:="     a. Code number"
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=2
//[Finished_Goods_Specifications]ProofReading'Task:="     b. Item Description"
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=3
//[Finished_Goods_Specifications]ProofReading'Task:="     c. Verify UPC is correct and meets scanning requirements"
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=4
//  `[Finished_Goods_Specifications]ProofReading'Task:="     c.1. Verify UPC knockout agrees with Prep Spec"
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=5
//[Finished_Goods_Specifications]ProofReading'Task:="     d. Control number"
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=6
//  `[Finished_Goods_Specifications]ProofReading'Task:="     e. Colors & Coatings"
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=7
//  `[Finished_Goods_Specifications]ProofReading'Task:="     f. Size & Style for 1-Up Prep"
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=8
//[Finished_Goods_Specifications]ProofReading'Task:="     e. Glue flap bar code same as control number"
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=9
//[Finished_Goods_Specifications]ProofReading'Task:="     f. Copy is correct"
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=10
//[Finished_Goods_Specifications]ProofReading'Task:="     g. No copy (return to customer for approval to proceed with order)"
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=11
//  `[Finished_Goods_Specifications]ProofReading'Task:="    h. Glue flap bar code same as control number"
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=12
//[Finished_Goods_Specifications]ProofReading'Task:="     h. Copy is unreadable (return to customer for approval to proceed with "+"order)"
//CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//[Finished_Goods_Specifications]ProofReading'DisplayOrder:=13
//[Finished_Goods_Specifications]ProofReading'Task:="     i. All visual elements are correct to customer supplied art"
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=11
//  `[Finished_Goods_Specifications]ProofReading'Task:="3. Hot stamp traps correct."
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=12
//  `[Finished_Goods_Specifications]ProofReading'Task:="4. Glue area dropout for back side printing and coating."
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=13
//  `[Finished_Goods_Specifications]ProofReading'Task:="5. Glue area dropout for front side printing and coating."
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=14
//  `[Finished_Goods_Specifications]ProofReading'Task:="3. Spot coating in copy area correct to Film Overlay."
//  `CREATE SUBRECORD([Finished_Goods_Specifications]ProofReading)
//  `[Finished_Goods_Specifications]ProofReading'DisplayOrder:=15
//  `[Finished_Goods_Specifications]ProofReading'Task:="4. Prints are signed and dated."
//
//ALL SUBRECORDS([Finished_Goods_Specifications]ProofReading)
//End if 