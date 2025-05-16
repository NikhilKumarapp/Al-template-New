// report 50100 "Company Information Report"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'CompanyReport.rdl';

//     dataset
//     {
//         dataitem(Company; "Company Information")
//         {
//             column(Company_Name; "Company Name")
//             {
//             }
//             column(State_Code; "State Code")
//             {
//             }
//             column(State_Name; GetStateName("State Code"))
//             {
//             }
//             column(Revenue; Revenue)
//             {
//             }
//         }
//     }

//     local procedure GetStateName(StateCode: Code[2]): Text
//     var
//         StateCodeToName: Dictionary of [Code[2], Text];
//     begin
//         // Populate the dictionary with state codes and names
//         StateCodeToName.Add('AL', 'Alabama');
//         StateCodeToName.Add('AK', 'Alaska');
//         StateCodeToName.Add('AZ', 'Arizona');
//         StateCodeToName.Add('AR', 'Arkansas');
//         StateCodeToName.Add('CA', 'California');
//         StateCodeToName.Add('CO', 'Colorado');
//         StateCodeToName.Add('CT', 'Connecticut');
//         StateCodeToName.Add('DE', 'Delaware');
//         StateCodeToName.Add('FL', 'Florida');
//         StateCodeToName.Add('GA', 'Georgia');
//         StateCodeToName.Add('HI', 'Hawaii');
//         StateCodeToName.Add('ID', 'Idaho');
//         StateCodeToName.Add('IL', 'Illinois');
//         StateCodeToName.Add('IN', 'Indiana');
//         StateCodeToName.Add('IA', 'Iowa');
//         StateCodeToName.Add('KS', 'Kansas');
//         StateCodeToName.Add('KY', 'Kentucky');
//         StateCodeToName.Add('LA', 'Louisiana');
//         StateCodeToName.Add('ME', 'Maine');
//         StateCodeToName.Add('MD', 'Maryland');
//         StateCodeToName.Add('MA', 'Massachusetts');
//         StateCodeToName.Add('MI', 'Michigan');
//         StateCodeToName.Add('MN', 'Minnesota');
//         StateCodeToName.Add('MS', 'Mississippi');
//         StateCodeToName.Add('MO', 'Missouri');
//         StateCodeToName.Add('MT', 'Montana');
//         StateCodeToName.Add('NE', 'Nebraska');
//         StateCodeToName.Add('NV', 'Nevada');
//         StateCodeToName.Add('NH', 'New Hampshire');
//         StateCodeToName.Add('NJ', 'New Jersey');
//         StateCodeToName.Add('NM', 'New Mexico');
//         StateCodeToName.Add('NY', 'New York');
//         StateCodeToName.Add('NC', 'North Carolina');
//         StateCodeToName.Add('ND', 'North Dakota');
//         StateCodeToName.Add('OH', 'Ohio');
//         StateCodeToName.Add('OK', 'Oklahoma');
//         StateCodeToName.Add('OR', 'Oregon');
//         StateCodeToName.Add('PA', 'Pennsylvania');
//         StateCodeToName.Add('RI', 'Rhode Island');
//         StateCodeToName.Add('SC', 'South Carolina');
//         StateCodeToName.Add('SD', 'South Dakota');
//         StateCodeToName.Add('TN', 'Tennessee');
//         StateCodeToName.Add('TX', 'Texas');
//         StateCodeToName.Add('UT', 'Utah');
//         StateCodeToName.Add('VT', 'Vermont');
//         StateCodeToName.Add('VA', 'Virginia');
//         StateCodeToName.Add('WA', 'Washington');
//         StateCodeToName.Add('WV', 'West Virginia');
//         StateCodeToName.Add('WI', 'Wisconsin');
//         StateCodeToName.Add('WY', 'Wyoming');

//         // Return the state name based on the state code
//         if StateCodeToName.ContainsKey(StateCode) then
//             exit(StateCodeToName.Get(StateCode))
//         else
//             exit('Unknown State');
//     end;
// }