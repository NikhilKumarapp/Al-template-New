table 50000 UserTable
{
    DataClassification = ToBeClassified;
    Caption = 'User Table';

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
        }

        field(2; Name; Code[20])
        {
            Caption = 'Name';
            trigger OnValidate()
            var
                i: Integer;
            begin
                if StrLen(Name) <> 10 then
                    Error('Name must be exactly 10 characters long.');

                for i := 1 to 5 do
                    if not (Name[i] in ['A' .. 'Z', 'a' .. 'z']) then
                        Error('First 5 characters must be letters.');

                for i := 6 to 9 do
                    if not (Name[i] in ['0' .. '9']) then
                        Error('Middle 4 characters must be digits.');

                if not (Name[10] in ['A' .. 'Z', 'a' .. 'z']) then
                    Error('Last character must be a letter.');
            end;
        }

        field(3; FirstName; Code[20])
        {
            Caption = 'First Name';
            trigger OnValidate()
            var
                i: Integer;
            begin
                // if StrLen(FirstName) <> 20 then
                //     Error('First Name must be exactly 20 characters long.');

                for i := 1 to 20 do
                    // if not (FirstName[i] in ['A'..'Z', 'a'..'z']) then
                    //     Error('First Name must contain only letters.');

                    if FirstName = '' then
                        LastName := ''; // Auto-clear LastName if FirstName is empty
            end;
        }

        field(4; LastName; Code[20])
        {
            Caption = 'Last Name';
            trigger OnValidate()
            var
                i: Integer;
            begin
                // if StrLen(LastName) <> 20 then
                //     Error('Last Name must be exactly 20 characters long.');

                for i := 1 to 20 do
                    // if not (LastName[i] in ['A'..'Z', 'a'..'z']) then
                    //     Error('Last Name must contain only letters.');

                    if LastName = '' then
                        FirstName := ''; // Auto-clear FirstName if LastName is empty
            end;
        }

        field(5; ValidateName; Code[20])
        {
            Caption = 'Validate Name';
            trigger OnValidate()
            var
                i: Integer;
            begin
                if StrLen(ValidateName) <> 15 then
                    Error('ValidateName must be exactly 15 characters long.');

                // First 2 characters must be digits
                for i := 1 to 2 do
                    if not (ValidateName[i] in ['0' .. '9']) then
                        Error('First 2 characters must be digits.');

                // Next 5 characters must be letters
                for i := 3 to 7 do
                    if not (ValidateName[i] in ['A' .. 'Z', 'a' .. 'z']) then
                        Error('Characters 3 to 7 must be letters.');

                // Next 4 characters must be digits
                for i := 8 to 11 do
                    if not (ValidateName[i] in ['0' .. '9']) then
                        Error('Characters 8 to 11 must be digits.');

                // Last 3 characters must be letters
                for i := 12 to 15 do
                    if not (ValidateName[i] in ['A' .. 'Z', 'a' .. 'z']) then
                        Error('Last 3 characters must be letters.');
            end;
        }

        field(6; PhoneNo; Code[10])
        {
            Caption = 'Phone Number';
            trigger OnValidate()
            var
                i: Integer;
            begin
                if StrLen(PhoneNo) <> 10 then
                    Error('Phone Number must be exactly 10 digits.');

                for i := 1 to 10 do
                    if not (PhoneNo[i] in ['0' .. '9']) then
                        Error('Phone Number must contain only digits (0-9), no letters or special characters.');
            end;
        }

        field(7; Gender; Option)
        {
            Caption = 'Gender';
            OptionMembers = SelectGender,Male,Female;

            trigger OnValidate()
            begin
                if Gender = Gender::SelectGender then
                    Prefix := '';
                if Gender = Gender::Male then
                    Prefix := 'Mr.';
                if Gender = Gender::Female then
                    Prefix := 'Mrs.';
            end;
        }

        field(8; Prefix; Code[5])
        {
            Caption = 'Prefix';
            Editable = false; // Prevents manual input, auto-set by Gender
        }
    }

    keys
    {
        key(PK; ID) { Clustered = true; }
    }
}
