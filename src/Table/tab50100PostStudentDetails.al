table 50122 "Student Subject Post Details"
{
    DataClassification = ToBeClassified;
    Caption = 'Student Subject Details';

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No';
            TableRelation = Student.StudentID;
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No';
        }
        field(3; "Subject Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Subject Name';
        }
        field(4; "Total Marks"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Marks';
            trigger OnValidate()
            begin
                UpdateStudentOverallValues();
                if "Obtained Marks" > "Total Marks" then
                    Error('Obtained Marks cannot be greater than Total Marks.');
            end;
        }
        field(5; "Obtained Marks"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Obtained Marks';
            trigger OnValidate()
            begin
                UpdateStudentOverallValues();
                if "Obtained Marks" > "Total Marks" then
                    Error('Obtained Marks cannot be greater than Total Marks.');
            end;
        }
        field(6; "Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage';
        }
        field(7; NewStudentID;Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'StudentNewID of the Student';
        }
    }

    keys
    {
        key(PK; "Document No", "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        CalculatePercentage();
        UpdateStudentOverallValues();
         if "Line No" = 0 then
            "Line No" := GetNextLineNo();
    end;
    trigger OnInsert()
    begin    
        if "Line No" = 0 then
            "Line No" := GetNextLineNo();
        CalculatePercentage();
        UpdateStudentOverallValues();  
    end;

    trigger OnDelete()
    begin
        UpdateStudentOverallValues();

    end;

    local procedure CalculatePercentage()
    begin
        if "Total Marks" > 0 then
            "Percentage" := ("Obtained Marks" / "Total Marks") * 100
        else
            "Percentage" := 0;
    end;

    local procedure UpdateStudentOverallValues()
    var
        Student: Record Student;
    begin
        if Student.Get("Document No") then begin
            // Student.CalculateOverallValues(); // Now accessible
        end;
    end;

    local procedure GetNextLineNo(): Integer
    var
        StudentSubjectDetails: Record "Student Subject Details";
    begin
        StudentSubjectDetails.SetRange("Document No", "Document No");
        if StudentSubjectDetails.FindLast() then
            exit(StudentSubjectDetails."Line No" + 10000) // Increment by 10000 to allow for manual line numbers in between
        else
            exit(1); // Start with 10000
    end;

    
}