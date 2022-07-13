//%attributes = {"publishedWeb":true}
//This is used by several of the fCalc...() procedures to determine for an
//Estimate the # of Flat Units, # of Emboss Units; # Combo Units, and
//Per Position Coverage of these.
//This procedure uses the following global process variables for passing
//this information back to the calling procedure.

C_LONGINT:C283(vUnitsFlat; vUnitsEmbos; vUnitsCombo; vCoverage)

vUnitsFlat:=0
vUnitsEmbos:=0
vUnitsCombo:=0
vCoverage:=0
vUnitsFlat:=[Estimates_Machines:20]Flex_Field2:19
vUnitsEmbos:=[Estimates_Machines:20]Flex_field1:18
vUnitsCombo:=[Estimates_Machines:20]Flex_Field3:20
vCoverage:=[Estimates_Machines:20]Flex_Field4:21