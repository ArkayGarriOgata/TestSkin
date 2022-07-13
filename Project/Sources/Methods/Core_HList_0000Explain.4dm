//%attributes = {}
//Method:  Core_HList_0000Explain
//Description:  This method explains how to use a CorenHList object.

//*  What to do  *

//1.  Copy and paste the HList List from the project forms "Core_Tmpl_HList"
//          Rename object with new HList list number.  (if more than one on form)
//          Use 99 if creating a form that could be called as a sheet from other forms

//2.  Write the method to load the arrays {Modl_FormName}_LoadHList and add it to the CorektPhaseInitialize in the {Modl_FormName}_Initialize method

//3.  Replace {Modl}, FormName and {#} appropriately

//Method:  {Modl_FormName}_LoadHList
//Description:  This will load the HList

//       Compiler_{Modl}_Array ("{Modl_FormName}_LoadHList";4)

//        {Modl}apParameter{CoreknHListTable}:=◊ModlkpTable
//        {Modl}apParameter{CoreknHListPrimaryKey}:=->[Table]Table_Key
//        {Modl}apParameter{CoreknHListFolder}:=->[Table]FolderName
//        {Modl}apParameter{CoreknHListTitle}:=->[Table]ItemName

//        If (Records in selection(◊{Modl}kpTable->)>0)  `Record

//           ORDER BY(◊{Modl}kpTable->;[Table]Field;>)

//           Core_HList_Initialize ({#};->{Modl}apParameter;CoreknFormatNoSpace;True)

//           Core_HList_Create ({#};True)

//        Else 

//           CorenHList{#}:=0

//        End if   `Done record  

//       REDRAW(CorenHList{#})


//3.  Write the method to handle what to do when something changes.

//        {Modl}_OM_HList (OBJECT Get pointer;tFormName)

//  In the {Modl}_OM_HList it should contain code similiar to this
//     Case of   `What form event
//        : (($nFormEvent=On Clicked ) | ($nFormEvent=On Double Clicked ))

//           If (Not(Core_HList_IsFolderB (->CorenHList{#})))  `Its not a folder

//                 {Modl}_List_Initialize (CorektMapAssignFields)  `Save changes to the current record
//                 {Modl}_List_Initialize (CorektMapAssignVariables)

//           Else   `clicked on a folder

//              If ({Modl}t{Field}_Key#CorektBlank)  `Make sure the table key is not cleared
//                 Modl_List_Initialize (CorektMapAssignFields)  `Save changes to the current record
//              End if 

//           End if   `Its not a folder

