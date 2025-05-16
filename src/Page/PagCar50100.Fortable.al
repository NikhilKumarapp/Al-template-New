page 50000 UserCard
{
    PageType = Card;
    SourceTable = UserTable;
    ApplicationArea = All;
    Caption = 'User Card';
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ID; Rec.ID) { Editable = false; } // Auto-incremented ID
                field(Name; Rec.Name) { } // Name field with validation
                field(ValidateName; Rec.ValidateName) { } // ValidateName field with validation

                field(PhoneNo; Rec.PhoneNo) { } //phone no field with validation

                field(Gender; Rec.Gender) { } // Gender field with auto filled with prefix name 

                field(Prefix; Rec.Prefix) { } // Prefix of the field name like Mr. and Mrs.

                field(FirstName; Rec.FirstName) { } // Firstname field 

                field(LastName; Rec.LastName) { } // Lastname field 
            }
        }
    }
}
