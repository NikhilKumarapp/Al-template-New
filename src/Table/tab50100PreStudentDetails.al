table 50121 "Student Subject Details"
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

                if "Total Marks" > 0 then
                    "Percentage" := ("Obtained Marks" / "Total Marks") * 100
                else
                    "Percentage" := 0;    
            end;
        }
        field(6; "Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage';
            trigger OnValidate()
            begin
                // Recalculate Obtained Marks if Percentage is filled
                if "Total Marks" > 0 then
                    "Obtained Marks" := ("Percentage" / 100) * "Total Marks"
                else
                    "Obtained Marks" := 0;
                    UpdateStudentOverallValues();
            end;
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
            Student.CalculateOverallValues(); // Now accessible
        end;
    end;

    internal procedure GetNextLineNo(): Integer
    var
        StudentSubjectDetails: Record "Student Subject Details";
    begin
        // Find the last Line No for the current Document No
        StudentSubjectDetails.SetRange("Document No", "Document No");
        if StudentSubjectDetails.FindLast() then
            exit(StudentSubjectDetails."Line No" + 1) // Increment by 1
        else
            exit(10000); // Start with 1000
    end;
    
}