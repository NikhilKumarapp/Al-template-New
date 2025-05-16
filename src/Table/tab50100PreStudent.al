table 50100 Student
{
    DataClassification = ToBeClassified;
    Caption = 'Student From Details';

    fields
    {
        field(1; StudentID; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; StudentName; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; FatherName; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; MotherName; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; Address; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; Address2; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; City; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; PostCode; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Post Code";

            trigger OnValidate()
            var
                PostcodeRec: Record "Post Code"; // Ensure correct table name
            begin
                PostcodeRec.Reset();
                PostcodeRec.SetRange(Code, Rec.PostCode);
                if PostcodeRec.FindFirst() then begin
                    "City" := PostcodeRec."City";
                end
                else begin
                    Error('Postcode not found in the system.');
                    "City" := '';
                end;
            end;
        }
        field(9; Class; Enum ClassEnum)
        {
            DataClassification = CustomerContent;
        }
        field(10; Section; Enum SectionEnum)
        {
            DataClassification = CustomerContent;
        }
        field(11; TotalFee; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Released"; Boolean) { Caption = 'Released'; }

        field(13; NewStudentID; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; StudentOldID; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Select,Open,Release,Posted;
        }
        field(16; "Subject Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Subject Name';
        }
        field(17; "Total Marks"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Marks';
        }
        field(18; "Obtained Marks"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Obtained Marks';
        }
        field(19; "Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage';
            // Editable = false;
        }
        field(20; "Overall Total Marks"; Decimal)
        {
            Caption = 'Overall Total Marks';
            Editable = false;
        }
        field(21; "Overall Obtained Marks"; Decimal)
        {
            Caption = 'Overall Obtained Marks';
            Editable = false;
        }
        field(22; "Overall Percentage"; Decimal)
        {
            Caption = 'Overall Percentage';
            Editable = false;
        }
        field(23; "Posted"; Boolean) { Caption = 'Posted'; }
    }

    keys
    {
        key(PK; StudentID)
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        CalculateOverallValues();
    end;

    trigger OnDelete()
    begin
        CalculateOverallValues();
    end;

    trigger OnRename()
    begin
        CalculateOverallValues();
        
    end;



    trigger OnInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "StudentID" = '' then begin
            if SalesSetup.Get() then begin
                "StudentID" := NoSeriesMgt.GetNextNo(SalesSetup."StudentID", WorkDate(), true);
            end;
        end;
        if "NewStudentID" = '' then begin
            if SalesSetup.Get() then begin
                "NewStudentID" := NoSeriesMgt.GetNextNo(SalesSetup."NewStudentID", WorkDate(), true);
            end;
        end;
        // CalculateOverallValues();
    end;
    

    internal procedure CalculateOverallValues()
    var
        SubjectDetails: Record "Student Subject Details";
        TotalMarks: Decimal;
        ObtainedMarks: Decimal;
    begin
        // Initialize totals
        TotalMarks := 0;
        ObtainedMarks := 0;

        // Calculate totals from subject details
        SubjectDetails.Reset();
        SubjectDetails.SetRange("Document No", Rec.StudentID);
        if SubjectDetails.FindSet() then begin
            repeat
                TotalMarks += SubjectDetails."Total Marks";
                ObtainedMarks += SubjectDetails."Obtained Marks";
            until SubjectDetails.Next() = 0;
        end;

        // Update the overall fields
        Rec."Overall Total Marks" := TotalMarks;
        Rec."Overall Obtained Marks" := ObtainedMarks;

        // Calculate overall percentage
        if TotalMarks > 0 then
            Rec."Overall Percentage" := (ObtainedMarks / TotalMarks) * 100
        else
            Rec."Overall Percentage" := 0;

        // Modify the record to save the changes
        Rec.Modify();
    end;

}