table 50101 StudentClean
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Student_ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; StudentName; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Class; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; AverageMarks; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Student_ID)
        {
            Clustered = true;
        }
    }
}