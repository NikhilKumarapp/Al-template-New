table 50500 "test"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "test"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'test';
        }
        field(2; "Nikhil"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'nikhil';
        }
}
    keys
    {
         key(PK; "test", "Nikhil")
        {
            Clustered = true;
        }
    }
}