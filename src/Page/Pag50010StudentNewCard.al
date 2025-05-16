page 51110 StudentNewCard
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
                field(NewStudentID; Rec.NewStudentID) 
                {
                    ApplicationArea = All;
                    Editable = IsEditable; // Controlled by the IsEditable variable
                }
                field(StudentName; Rec.StudentName)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                }
                field(StudentOldID; Rec.StudentOldID){
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
}
