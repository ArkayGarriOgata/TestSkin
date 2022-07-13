//%attributes = {"publishedWeb":true}
//Procedure: uReadOnlyEst
//make all estimate releateed records read only to aviod 'grabbing' a record while
//and locking it.
//• 5/23/97 cs  created upr 1865

READ ONLY:C145([Estimates:17])
READ ONLY:C145([Work_Orders:37])
READ ONLY:C145([Estimates_PSpecs:57])
READ ONLY:C145([Process_Specs:18])
READ ONLY:C145([Process_Specs_Materials:56])
READ ONLY:C145([Process_Specs_Machines:28])
READ ONLY:C145([Estimates_Carton_Specs:19])
READ ONLY:C145([Estimates_Differentials:38])
READ ONLY:C145([Process_Specs:18])
READ ONLY:C145([Estimates_FormCartons:48])
READ ONLY:C145([Estimates_Machines:20])
READ ONLY:C145([Estimates_Materials:29])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Addresses:30])