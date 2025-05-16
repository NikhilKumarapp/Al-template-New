tableextension 50000 recCustomerExt extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Customer NickName"; Text[100]){
            DataClassification = ToBeClassified;
            Caption = 'Customer NickName';

            trigger OnValidate()
            begin;
            end;

            trigger OnLookup()
            begin;
            end;

        }
    }
    
    keys
    {
        // Add changes to keys here                                              
    }
    
    fieldgroups
    {
        // Add changes to field groups here
    }
    
    var
        myInt: Integer;
}