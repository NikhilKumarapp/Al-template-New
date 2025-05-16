tableextension 50090 StduentExt extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "StudentID"; Text[100]){
            DataClassification = ToBeClassified;
            Caption = 'Student ID';

           TableRelation = "No. Series";

            
        }
        field(51110;"StudentNewID"; Text[100]){
            DataClassification = ToBeClassified;
            Caption = 'Student New ID';

            TableRelation = "No. Series";
        }
        field(51111;"NewStudentID"; Text[100]){
            DataClassification = ToBeClassified;
            Caption = 'New Student ID';

            TableRelation = "No. Series";
        }
        field(50101; "StudentID Series 1"; Code[20])
        {
            Caption = 'Student ID Series 1';
            TableRelation = "No. Series";
        }
        field(50102; "StudentID Series 2"; Code[20])
        {
            Caption = 'Student ID Series 2';
            TableRelation = "No. Series";
        }
        field(50103; "StudentID Series 3"; Code[20])
        {
            Caption = 'Student ID Series 3';
            TableRelation = "No. Series";
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