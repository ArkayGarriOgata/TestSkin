//%attributes = {}
// _______
// Method: BOL_getTariffHeading   ( ) ->
// By: Mel Bohince @ 06/05/20, 13:02:34
// Description
// 
// ----------------------------------------------------
C_TEXT:C284($shipToAddressID; $1; $tariffSchedule; $0)  //used on form [Customers_Bills_of_Lading];"IntlInvoice"
$shipToAddressID:=$1
$tariffSchedule:="4819.10.0040"  //used since January 2015, consider as the default, may actually be the corrugate instead of the cartons

C_OBJECT:C1216($addr_e)
$addr_e:=ds:C1482.Addresses.query("ID = :1"; $shipToAddressID).first()
If ($addr_e#Null:C1517)
	If (Length:C16($addr_e.TariffReference)>0)  //over ride the default
		$tariffSchedule:=$addr_e.TariffReference
	End if 
End if 

$tariffSchedule:="Customs Tariff Number:  "+$tariffSchedule+CorektCR
$tariffSchedule:=$tariffSchedule+"Folding Cartons - Paper Board"

$0:=$tariffSchedule
