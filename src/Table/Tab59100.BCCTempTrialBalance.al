table 59100 "BCC Temp Trial Balance"
{
    Caption = 'BCC Temp Trial Balance';
    DataClassification = ToBeClassified;
    TableType = Temporary;


    fields
    {
        field(1; "G/L Account Category"; Enum "G/L Account Category") { }
        field(2; "G/L Account No."; Code[20]) { }
        field(3; "G/L Account Type"; Enum "G/L Account Type") { }
        field(4; "G/L Account Name"; Text[100]) { }
        field(5; "G/L Account Full Info"; Text[250]) { }
        field(6; "Cost Center"; Code[20]) { }
        field(7; "Cost Center Name"; Text[100]) { }
        field(8; "Cost Center Full Info"; Text[250]) { }
        field(9; Period; Code[10]) { }
        field(10; "Line No."; Integer) { }
        field(11; "Period CC Begining Balance"; Decimal) { }
        field(12; "Period CC Debit Amount"; Decimal) { }
        field(13; "Period CC Credit Amount"; Decimal) { }
        field(14; "Period CC Ending Balance"; Decimal) { }
        field(15; "Period Start Date"; Date) { }
        field(16; "Period End Date"; Date) { }
        field(17; "Period Description"; Text[100]) { }
        field(18; "Total Acc. Begining Balance"; Decimal) { }
        field(19; "Total Acc. Debit Amount"; Decimal) { }
        field(20; "Total Acc. Credit Amount"; Decimal) { }
        field(21; "Total Acc. Ending Balance"; Decimal) { }
        field(22; "Is Calc. Totals"; Boolean) { }
        field(23; "Is First Record"; Boolean) { }
        field(24; "Total Cat. Begining Balance"; Decimal) { }
        field(25; "Total Cat. Debit Amount"; Decimal) { }
        field(26; "Total Cat. Credit Amount"; Decimal) { }
        field(27; "Total Cat. Ending Balance"; Decimal) { }
        field(28; "Total Sub Begining Balance"; Decimal) { }
        field(29; "Total Sub Debit Amount"; Decimal) { }
        field(30; "Total Sub Credit Amount"; Decimal) { }
        field(31; "Total Sub Ending Balance"; Decimal) { }
        field(32; "Is Last Category Record"; Boolean) { }
        field(33; "Is Zero Sub"; Boolean) { }

    }
    keys
    {
        key(PK; "G/L Account Category", "G/L Account No.", "Cost Center", "Line No.")
        {
            Clustered = true;
        }
    }
}
