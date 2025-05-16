page 50100 StudentCard
{
    PageType = Card;
    SourceTable = Student;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(StudentID; Rec.StudentID)
                {
                    ApplicationArea = All;
                    Editable = IsEditable; // Controlled by the IsEditable variable

                    trigger OnAssistEdit()
                    var
                        SalesSetup: Record "Sales & Receivables Setup";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        NoSeries: Record "No. Series";
                        SelectedNoSeries: Code[20];
                    begin
                        if IsPosting then
                            exit;
                        NoSeries.Reset();
                        if NoSeries.FindSet() then begin
                            // Open the No. Series List page in lookup mode
                            if Page.RunModal(Page::"No. Series", NoSeries) = Action::LookupOK then begin
                                if NoSeries.Get(NoSeries.Code) then begin
                                    SelectedNoSeries := NoSeries.Code;

                                    // Assign the next number from the selected No. Series
                                    Rec.Validate(StudentID, NoSeriesMgt.GetNextNo(SelectedNoSeries, WorkDate(), true));
                                end;
                            end;
                        end;
                    end;

                }
                field(StudentName; Rec.StudentName)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(FatherName; Rec.FatherName)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(MotherName; Rec.MotherName)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(Address2; Rec.Address2)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(PostCode; Rec.PostCode)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(Section; Rec.Section)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(TotalFee; Rec.TotalFee)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(Released; Rec.Released)
                {
                    ApplicationArea = All;
                    Editable = false; // Always non-editable
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false; // Always non-editable
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            part(SubjectDetails; "Student Subject Details")
            {
                ApplicationArea = All;
                SubPageLink = "Document No" = field(StudentID);
                Editable = IsEditable; // Control the editable state of the subpage
            }

            group(OverallResults)
            {
                Caption = 'Overall Results';
                field("Overall Total Marks"; Rec."Overall Total Marks")
                {
                    ApplicationArea = All;
                    Caption = 'Overall Total Marks';
                    Editable = false;
                }
                field("Overall Obtained Marks"; Rec."Overall Obtained Marks")
                {
                    ApplicationArea = All;
                    Caption = 'Overall Obtained Marks';
                    Editable = false;
                }
                field("Overall Percentage"; Rec."Overall Percentage")
                {
                    ApplicationArea = All;
                    Caption = 'Overall Percentage';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Release)
            {
                Caption = 'Release';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Posted then
                        Error('You cannot release a student with the status "Posted".');

                    if Confirm('Are you sure you want to release student %1?', false, Rec."StudentName") then begin
                        Rec."Released" := true;
                        Rec.Status := Rec.Status::Release;
                        Rec.Modify(false);
                        IsEditable := false; // Disable all fields
                        CurrPage.SubjectDetails.Page.Editable(false); // Disable the subpage
                        Message('Student %1 has been released.', Rec."StudentName");
                    end;
                end;
            }

            action(Reopen)
            {
                Caption = 'Reopen';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Posted then
                        Error('You cannot reopen a student with the status "Posted".');

                    if Confirm('Are you sure you want to reopen student %1?', false, Rec."StudentName") then begin
                        Rec."Released" := false;
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify(false);
                        IsEditable := true; // Enable all fields
                        CurrPage.SubjectDetails.Page.Editable(true); // Enable the subpage
                        Message('Student %1 has been reopened.', Rec."StudentName");
                    end;
                end;
            }

            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                trigger OnAction()
                var
                    NewStudent: Record Student;
                    OldStudentID: Code[20];
                    StudentSubjectDetails: Record "Student Subject Details";
                    NewStudentSubjectDetails: Record "Student Subject Details";
                    LineNo: Integer;
                begin
                    if Rec.Status <> Rec.Status::Release then
                        Error('You can only post a student with the status "Release".');

                    // Confirm with the user before proceeding
                    if not Confirm('Are you sure you want to post and delete the current student record?', false) then
                        exit;

                    // Store the old StudentID
                    OldStudentID := Rec.StudentID;

                    // Initialize and transfer fields
                    NewStudent.Init();
                    NewStudent.TransferFields(Rec, false); // Copy all fields except the primary key

                    // Generate a new StudentID
                    NewStudent.StudentID := GenerateNewStudentID();

                    // Ensure NewStudentID is not empty
                    if NewStudent.StudentID = '' then
                        Error('New StudentID is empty. Please check GenerateNewStudentID function.');

                    // Assign old StudentID for reference
                    NewStudent.StudentOldID := OldStudentID;

                    // Transfer Overall Results data
                    NewStudent."Overall Total Marks" := Rec."Overall Total Marks";
                    NewStudent."Overall Obtained Marks" := Rec."Overall Obtained Marks";
                    NewStudent."Overall Percentage" := Rec."Overall Percentage";

                    // Set status to Posted
                    NewStudent.Status := NewStudent.Status::Posted;

                    // Debug Message for verification
                    Message('Old Student ID: %1, New Student ID: %2', OldStudentID, NewStudent.StudentID);

                    // Insert the new student record
                    NewStudent.Insert(true);

                    // Copy Student Subject Details
                    StudentSubjectDetails.Reset();
                    StudentSubjectDetails.SetRange("Document No", OldStudentID);
                    if StudentSubjectDetails.FindSet() then begin
                        repeat
                            // Generate a new Line No for the new record
                            LineNo := GetNextLineNo(NewStudent.StudentID);

                            // Initialize and insert the new Student Subject Details record
                            NewStudentSubjectDetails.Init();
                            NewStudentSubjectDetails.TransferFields(StudentSubjectDetails, false);
                            NewStudentSubjectDetails."Document No" := NewStudent.StudentID; // Set the new StudentID
                            NewStudentSubjectDetails."Line No" := LineNo; // Assign the new Line No
                            NewStudentSubjectDetails.Insert(true);
                        until StudentSubjectDetails.Next() = 0;
                    end;

                    // Delete the original record and its subject details
                    Rec.Delete(true);
                    StudentSubjectDetails.Reset();
                    StudentSubjectDetails.SetRange("Document No", OldStudentID);
                    StudentSubjectDetails.DeleteAll(true);

                    // Open the new student record with the Student Subject Details
                    Page.Run(Page::StudentNewCard, NewStudent);
                end;
            }
        }
    }

    var
        [InDataSet]
        IsEditable: Boolean;
        IsPosting: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsEditable := not Rec."Released";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Initialize IsEditable for new records
        IsEditable := true;
    end;

    local procedure GenerateNewStudentID(): Code[20]
    var
        Student: Record Student;
        NewStudentID: Code[20];
    begin
        // Generate a new unique StudentID (example logic)
        Student.FindLast();
        NewStudentID := IncStr(Student.NewStudentID); // Increment the last StudentID
        Message('Generated Student ID: %1', NewStudentID);
        exit(NewStudentID);
    end;

    local procedure GetNextLineNo(DocumentNo: Code[20]): Integer
    var
        StudentSubjectDetails: Record "Student Subject Details";
    begin
        StudentSubjectDetails.Reset();
        StudentSubjectDetails.SetRange("Document No", DocumentNo);
        if StudentSubjectDetails.FindLast() then
            exit(StudentSubjectDetails."Line No" + 1) // Increment by 1 to avoid conflicts
        else
            exit(10000); // Start with 1
    end;
}
