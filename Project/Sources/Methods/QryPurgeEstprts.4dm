//%attributes = {"publishedWeb":true}
//Procedure: QryPurgeEstprts(estimateID)  062995  MLB 
//•062995  MLB  UPR 1507
//get all the records relelated to the current estimate see also x_ExportEst

RELATE MANY:C262([Estimates:17]EstimateNo:1)

RELATE MANY SELECTION:C340([Estimates_DifferentialsForms:47]DiffId:1)
RELATE MANY SELECTION:C340([Estimates_FormCartons:48]DiffFormID:2)
RELATE MANY SELECTION:C340([Estimates_Machines:20]DiffFormID:1)
RELATE MANY SELECTION:C340([Estimates_Materials:29]DiffFormID:1)