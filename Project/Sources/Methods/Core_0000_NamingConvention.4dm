//%attributes = {}
//Method:  Core_0000_NamingConvention
//Description:  This method explains the Naming Conventions {optional}

//For interprocess and process variables
//{<>}+Modl+{k}+{data structure}+type+VaraiableName
//Modl  - is the module
//k - is a constant
//data structure -
//     a - Array
//     p - Pointer
//   2Da - 2Dimensional Array
//     v - Variant

//Type -  type of variable
//    b - Boolean
//    l - bLob
//    u - plUgin area 
//    d - Date
//    g - picture (Graphic)
//    h - time (Hour)
//    n - loNginteger (Number) (Just use longints)
//    p - Pointer
//    r - Real
//    t - Text
//    i - Integer (Don't use these if possible always use longint)
//    o - Object (e for entity and es for entity selection)
//    s - ClaSs
//    c - Collection

//Relationships
//    f - Foreign Key
//.     fOne_Table for One-To-Many relationship name
//.     fMany_Table for Many-To-One relationship name
//.   Example:  $esCustomer.fOrder.OrderNumber
//    Naming Convention for Relationships
//       UPPERCASE the name One-To-Many => fManyTablename and Many-to-One => fOneTablename

//Entity (e)
//.   Always use TableName
//.   C_OBJECT($ePerson)

//Entity Selection (es)
//.   Always use TableName for entity selections
//.   C_OBJECT($esPerson)

//Ex.
//<>CorekatStructureAccess  -  InterProcess variable for the Core module that is a constant array of type text named StructureAccess
//CorepatStructureAccess -  Process variable for the Core module that is a pointer to an array of type text named SturctureAccess

//For local variables the module and constant is not needed
//${data structure}+type+VaraiableName
//Ex.
//$ptMyVariable reads pointer to a text variable called MyVariable

//Methods  Modl_+{SubModule_ or Grouping_}+MethodName+{X run on server}+{H for Hook}
//Functions Modl_+{SubModule_ or Grouping_}+FunctionName+{X run on server}+{H for Hook}+(Type)

//Type is the return Type T for text B for Boolean etc.
//Ex.
//Core_Process_Initialize `Core method used with the Process group to Initialize values
//        Use this with a case statement for the different status
//Core_QuitHB  `core function returns a boolean and is a hook method.
//Core_Dialog  `core method that displays a project form

//Form naming conventions:
//.  Modl_FormName_MethodName

//.  Object name standards
//.      Modl_FormName_{type}{ObjectName} for the object name of object referenced by Form.{type}{Object}
//.      Modl_FormName_Text for the object name for text object. like Title1

//.   Modl_FormName_{Name}

//Form Names (Try and keep form names to 5 characters)
// Entr - A form used to enter new or modify a record
// Mdfy - A form used to modify a record in substantianlty differenet from entry
// View  - A form used to view information usually not editable although grids might be.

// List  - A form used for list of records in a module
// Home  - A form with HList of categories and priorities
// Task  - A form like home but geared for tasks to be accomplished launched from home

// Otpt  - A form used for user mode type output listing
// Inpt  - A form used for user mode type input listing

// Find  - A form used for custom find in a module
// Rprt  - A form used for printing and tied to the report module

//Command Key equivalents
// M  -  Modify
// N  -  New
// O  -  Open
// P  -  Print
// F  -  Find
// S  -  Save
// T  -  Sort
// I  -  Import
// E  -  Export
// D  -  Delete
// R  -  Report
// Q  -  Quit

// X  -  Cut
// C  -  Copy
// V  -  Paste

//Terminology:

// Phase  -  Use phase for an order that is important to programming          
// State  -  For Objects usually when to set them to visible, enabled etc.
// Status -  This is for when variables and fields need to be set cleared etc.
// Event  -  For form events and object events used by 4D

// Get    -  When you will return a value
// Put    -  When you will store a value 
// Set    -  When you assign a known value based on a business rule
// Fill   -  When you fill an array or collection or object with values or group of values

// Load   -  When files are retreived from a volume
// Place  -  When files are put onto a volume

// Send   -  When you send a value to a document
// Recv   -  When you receive a value from a document

// Store  -  When you store a full record somewhere else
// Restore -  When you restore a full record from somewhere else

// Pick   -  When user will pick the best option
// Select -  When code will select based on users pick (think LISTBOX SELECT ROW)

// Attribute - Is a quality given to an entity selection.
// Property  - Is a quality given to an object.
// Inherent  - Is an object that is derived from an entity or object.

// Manager - Used to manage enable and disable of objects in a form

// Verify - Used by methods to assure database rules are maintained (Referential integrity, Mandatory fields)
// Check  - Used by methods to assure business rules are maintained (No PO's after 3:00 PM at end of the month)
// Valid  - Used to assure access privileges. User_IsValidBcore
// Certify - Used to assure API's, PlugIns etc are good

// Initialize -  Initialize and declare values at start to default or defined 
//               based on conditions prior to be used or seen in a form (usually On_Load or PreDialog)

// Query  -  Used for doing a pre defined query
// Find   -  Used for find with magnigying glass
// Search -  Used for built searches and searching other data sources or web etc.

// Criteria -  Used as plural for Criterion. Use these to represent Query, Find and Search parameters
// Criterion - Used as a singular Criteria

// Clear  -  Used to set values to default

// Create -  Used building a record procedurally
// New    -  Used when building a record from a form
// Add    -  Used when adding to a sublist

// Alter  -  Used modifying a record procedurally 
// Modify -  Used modifying a record from a form
// Adjust -  Used as modify for add (Reserved for now do not use)

// Drop   -  Used as the opposite of create
// Delete -  Used as opposite of new
// Remove -  Used as opposite of add (Remove from sublist)

// Commit -  Save operation for proceurally (Create, Alter, Drop, Commit)
// Save   -  Save operation for form   (New, Modify, Delete, Save)
// Apply  -  Save for Add (Add, Adjust, Remove, Apply) 

// Link   -  used as a link table for many-to-many relationships

// Category -  Use for ideas
// Group    -  Use for people
// Kind     -  Use for things
// Genre    -  Use for music

// Avoid using class, set, object or entity

//Constants naming convention (4D pop)
//    Always CamelCase and do not use _ (underscores)
//    Modl+k+Type+{TableName/Category}+Name/FieldName

//Using Sub Modules
//  If a module has a sub module here are the naming conventions:
//    Module table is [Module] acronym "Modl". Example: [Product] acronym is "Prdc"
//    Submodule table [Modl_SubModule]. Example: [Prdc_Make]
//    The Acronym will be MdSb(where Md is the first two or first and last for the Modl and SubModule is the first two or first and last of SubModule)
//    Acronym form [Prdc_Make] is "PrMk"
//    The key field is always [TableName]TableName_Key. Example [Prdc_Make]Prdc_Make_Key for Product Make
