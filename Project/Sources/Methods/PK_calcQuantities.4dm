//%attributes = {"publishedWeb":true}
//PK_calcQuantities

$caseLayer:=[Finished_Goods_PackingSpecs:91]Rows:3*[Finished_Goods_PackingSpecs:91]RowCount:5
[Finished_Goods_PackingSpecs:91]CaseCount:2:=[Finished_Goods_PackingSpecs:91]Layers:4*$caseLayer
[Finished_Goods_PackingSpecs:91]CasesPerSkid:29:=[Finished_Goods_PackingSpecs:91]CasesPerLayer:27*[Finished_Goods_PackingSpecs:91]LayerPerSkid:28
[Finished_Goods_PackingSpecs:91]UnitsPerSkid:30:=[Finished_Goods_PackingSpecs:91]CasesPerSkid:29*[Finished_Goods_PackingSpecs:91]CaseCount:2