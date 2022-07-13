//%attributes = {}
/*
Method: JMI_tests   ( ) ->
By: MelvinBohince @ 06/10/22, 10:53:04
Description
       Test entity class of Job_Forms_Items which will lean on
       the entity selection classes of Finished_Goods_Transactions
       and 
*/

var $jobItem_e : cs:C1710.Job_Forms_ItemsEntity
var $jobitToTest : Text
var $available; $calculatedOnHand; $good; $shippped : Integer

//fail, calc avail != avail because 0 onhand, calc 7800
$jobitToTest:="18145.01.05"
$jobItem_e:=ds:C1482.Job_Forms_Items.query("Jobit = :1"; $jobitToTest).first()
$good:=$jobItem_e.quantityGood()
$shippped:=$jobItem_e.quantityShipped()
$calculatedOnHand:=$good-$shippped
$available:=$jobItem_e.quantityAvailable()

ASSERT:C1129($calculatedOnHand=$available; "test#1-FAIL:onhand != good less shipped")

//pass, nothing on hand because all good shipped
$jobitToTest:="17329.04.06"
$jobItem_e:=ds:C1482.Job_Forms_Items.query("Jobit = :1"; $jobitToTest).first()
$good:=$jobItem_e.quantityGood()
$shippped:=$jobItem_e.quantityShipped()
$calculatedOnHand:=$good-$shippped
$available:=$jobItem_e.quantityAvailable()

ASSERT:C1129($calculatedOnHand=$available; "test#2-FAIL:onhand != good less shipped")  //shoud be 0

//fail, inventory only in cc
$jobitToTest:="17165.04.23"
$jobItem_e:=ds:C1482.Job_Forms_Items.query("Jobit = :1"; $jobitToTest).first()
$good:=$jobItem_e.quantityGood()
$shippped:=$jobItem_e.quantityShipped()
$calculatedOnHand:=$good-$shippped
$available:=$jobItem_e.quantityAvailable()

ASSERT:C1129($calculatedOnHand=$available; "test#3-FAIL:onhand != good less shipped")

//fail,  all good shipped, but 3150 remaining
$jobitToTest:="16701.02.02"
$jobItem_e:=ds:C1482.Job_Forms_Items.query("Jobit = :1"; $jobitToTest).first()
$good:=$jobItem_e.quantityGood()
$shippped:=$jobItem_e.quantityShipped()
$calculatedOnHand:=$good-$shippped
$available:=$jobItem_e.quantityAvailable()

ASSERT:C1129($calculatedOnHand=$available; "test#4-FAIL:onhand != good less shipped")  //3150 available
