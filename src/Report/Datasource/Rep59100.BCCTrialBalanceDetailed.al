report 59100 "BCC Trial Balance - Detailed"
{
    ApplicationArea = All;
    Caption = 'GL Detail';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = BCCRDLCTrialBalanceDetailed;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(GlobalGLEntry; "G/L Entry")
        {
            RequestFilterFields = "G/L Account No.", "Global Dimension 1 Code", "BCC Account Category";
        }

        dataitem(BCCTempTrialBalance; "BCC Temp Trial Balance")
        {
            DataItemTableView = sorting("G/L Account No.", "Cost Center");
            UseTemporary = true;

            column(CompanyName; CompanyInformation.Name) { }
            column(CompanyShortName; CompanyInformation."Custom System Indicator Text") { }
            column("UserID"; UserID()) { }
            column(CurrentTime; Format(Time(), 0, '<Hours12,2>:<Minutes,2>:<Seconds,2> <AM/PM>')) { }
            column(StartingPeriod; StartingPeriod) { }
            column(EndingPeriod; EndingPeriod) { }
            column(ShowDetails; ShowDetails) { }
            column(IsHideAccountInfo; not "Is First Record") { }
            column(IsHideSubTotals; (Period <> EndingPeriod)) { }
            column(IsZeroSubTotals; "Is Zero Sub") { }
            column(IsHideTotals; not "Is Calc. Totals") { }
            column(IsHideCategoryTotals; true) { }// not "Is Last Category Record" or ("G/L Account Category" = "G/L Account Category"::" ")) { }
            column(GLAccountNo; "G/L Account No.") { }
            column(GLAccountName; "G/L Account Name") { }
            column(GLAccountType; "G/L Account Type") { }
            column(GLAccountCategory; "G/L Account Category") { }
            column(GLAccountFullInfo; "G/L Account Full Info") { }
            column(GLAccountCostCenter; "Cost Center") { }
            column(GLAccountCostCenterName; "Cost Center Name") { }
            column(GLAccountCostCenterFullInfo; "Cost Center Full Info") { }
            column(TotalSubBeginingBalance; "Total Sub Begining Balance") { }
            column(TotalSubEndingBalance; "Total Sub Ending Balance") { }
            column(TotalSubDebitAmount; "Total Sub Debit Amount") { }
            column(TotalSubCreditAmount; "Total Sub Credit Amount") { }
            column(TotalAccountBeginingBalance; "Total Acc. Begining Balance") { }
            column(TotalAccountEndingBalance; "Total Acc. Ending Balance") { }
            column(TotalAccountDebit; "Total Acc. Debit Amount") { }
            column(TotalAccountCredit; "Total Acc. Credit Amount") { }
            column(TotalCategoryBeginingBalance; "Total Cat. Begining Balance") { }
            column(TotalCategoryEndingBalance; "Total Cat. Ending Balance") { }
            column(TotalCategoryDebit; "Total Cat. Debit Amount") { }
            column(TotalCategoryCredit; "Total Cat. Credit Amount") { }
            column(GLAccountPeriod; Period) { }
            column(GLAccountPeriodDescription; "Period Description") { }
            column(SubtotalBeginningBalance; "Period CC Begining Balance") { }
            column(SubtotalDebitAmount; "Period CC Debit Amount") { }
            column(SubtotalCreditAmount; "Period CC Credit Amount") { }
            column(SubtotalEndingBalance; "Period CC Ending Balance") { }
            column(IncomeBeginingBalance; BCCTempTrialBalanceIncomeTotals."Total Cat. Begining Balance") { }
            column(IncomeEndingBalance; BCCTempTrialBalanceIncomeTotals."Total Cat. Ending Balance") { }
            column(IncomeDebitAmount; BCCTempTrialBalanceIncomeTotals."Total Cat. Debit Amount") { }
            column(IncomeCreditAmount; BCCTempTrialBalanceIncomeTotals."Total Cat. Credit Amount") { }
            dataitem(TempGLE; "G/L Entry")
            {
                UseTemporary = true;
                DataItemLink = "G/L Account No." = field("G/L Account No."),
                                       "Global Dimension 1 Code" = field("Cost Center"),
                                       "IC Partner Code" = field(Period);
                DataItemTableView = sorting("G/L Account No.", "Global Dimension 1 Code");
                column(GLEJnlBatchName; "Journal Batch Name") { }
                column(GLEJnlTmplName; "Journal Templ. Name") { }
                column(GLEDocumentType; "Document Type") { }
                column(GLEDocumentNo; "Document No.") { }
                column(GLEEntryNo; "Entry No.") { }
                column(GLEExternalDocumentNo; "External Document No.") { }
                column(GLEPostingDate; Format("Posting Date", 0, '<Month,2>/<Day,2>/<Year>')) { }
                column(GLEPostingDatePeriod; "IC Partner Code") { }
                column(GLEDescription; Description) { }
                column(GLEBeginningBalance; Amount - "Debit Amount" + "Credit Amount") { }
                column(GLEDebitAmount; "Debit Amount") { }
                column(GLECreditAmount; "Credit Amount") { }
                column(GLEEndingBalance; Amount) { }
                column(GLESourceCode; "Source Code") { }
                column(GLESourceNo; "Source No.") { }
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    Caption = 'Filters';
                    field(StartingDateFilter; StartingDate)
                    {
                        Caption = 'Starting Date';
                        trigger OnValidate()
                        begin
                            StartingDate := CalcDate('<-CM>', StartingDate);
                        end;
                    }
                    field(EndingDateFilter; EndingDate)
                    {
                        Caption = 'Ending Date';
                        trigger OnValidate()
                        begin
                            EndingDate := CalcDate('<CM>', EndingDate);
                        end;
                    }
                    field(ShowDetails; ShowDetails)
                    {
                        Caption = 'Show Details';
                    }
                    field(HideZeroBalancedGLAccounts; HideZeroBalancedGLAccounts)
                    {
                        Caption = 'Hide Zero Balanced G/L Accounts';
                    }
                }
            }
        }

    }

    rendering
    {
        layout(BCCRDLCTrialBalanceDetailed)
        {
            Type = RDLC;
            LayoutFile = 'src/Report/RDLC/Rep59100.BCCTrialBalanceDetailed.rdlc';
        }
        // layout(BCCRDLCTrialBalancePivotTableExcel)
        // {
        //     Type = Excel;
        //     LayoutFile = 'src/Report/Excel/Rep59100.BCCRDLCTrialBalancePivotTableExcel.xlsx';
        // }
    }

    trigger OnInitReport()
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SetRange("New Fiscal Year", true);
        AccountingPeriod.SetFilter("Starting Date", '<=%1', Today());
        AccountingPeriod.FindLast();
        // StartingDate := AccountingPeriod."Starting Date";
        StartingDate := CalcDate('<-CM-1M>', Today());
        EndingDate := CalcDate('<CM>', StartingDate);
        ShowDetails := true;
        HideZeroBalancedGLAccounts := true;
    end;

    trigger OnPreReport()
    begin
        if EndingDate > 20261231D then
            Error('Ending Date is too late, please select a date before December 31, 2026.');

        InitSourceData();
    end;

    procedure InitSourceData()
    begin
        StartingPeriod := DateToTextPeriod(StartingDate);
        EndingPeriod := DateToTextPeriod(EndingDate);

        CompanyInformation.Get();
        InitAccountingPeriod();
        InitGeneralLedgerEntriesByAccountingPeriod();
        InitBCCTrialBalance();
        InitBCCTempTrialBalanceTotals();
        if HideZeroBalancedGLAccounts then
            CleanupZeroBalanceAccounts();
    end;

    local procedure InitAccountingPeriod()
    var
        PeriodStartDate: Date;
        PeriodEndDate: Date;
    begin
        if not TempAccountingPeriod.IsTemporary then
            Error('Temporary table expected.');

        if not TempAccountingPeriod.IsEmpty then
            TempAccountingPeriod.DeleteAll();

        if EndingDate < StartingDate then
            Error('Ending Date cannot be earlier than Starting Date.');

        PeriodStartDate := CalcDate('<-CM>', StartingDate);
        PeriodEndDate := CalcDate('<-CM>', EndingDate);

        TempAccountingPeriod."Starting Date" := PeriodStartDate;
        TempAccountingPeriod.Name := DateToTextPeriod(PeriodStartDate);
        TempAccountingPeriod.Insert();

        while PeriodStartDate <= PeriodEndDate do begin
            PeriodStartDate := CalcDate('<+1M>', PeriodStartDate);

            if PeriodStartDate > PeriodEndDate then
                break;

            TempAccountingPeriod."Starting Date" := PeriodStartDate;
            TempAccountingPeriod.Name := DateToTextPeriod(PeriodStartDate);
            TempAccountingPeriod.Insert();
        end;
    end;

    local procedure InitGeneralLedgerEntriesByAccountingPeriod()
    var
        GLAccount: Record "G/L Account";
        ProcessGLAccount: Boolean;
        NextEntryNo: Integer;
    begin
        if TempAccountingPeriod.IsEmpty then
            Error('No accounting periods found.');

        if not TempGLE.IsTemporary then
            Error('Temporary table expected.');

        if not TempGLE.IsEmpty then
            TempGLE.DeleteAll();

        if not TempGLEForCalc.IsTemporary then
            Error('Temporary table expected.');

        if not TempGLEForCalc.IsEmpty then
            TempGLEForCalc.DeleteAll();

        ProcessGLAccount := true;
        if GlobalGLEntry.GetFilters = '' then begin
            if GLAccount.FindSet() then
                repeat
                    TempGLAccount := GLAccount;
                    TempGLAccount.Insert();
                // InitTotalGLAccountGLEntries(GLAccount);
                until GLAccount.Next() = 0;

            ProcessGLAccount := false;
        end;

        GlobalGLEntry.SetCurrentKey("Posting Date");
        GlobalGLEntry.SetRange("Posting Date", StartingDate, EndingDate);

        if GlobalGLEntry.FindSet() then
            repeat
                TempGLE := GlobalGLEntry;
                TempGLE."IC Partner Code" := DateToTextPeriod(GlobalGLEntry."Posting Date");
                if TempGLE.Insert() then begin

                    //copy GLE for calc
                    TempGLEForCalc := TempGLE;
                    TempGLEForCalc.Insert();
                end;

                if ProcessGLAccount then
                    if not TempGLAccount.Get(GlobalGLEntry."G/L Account No.") then
                        if GLAccount.Get(GlobalGLEntry."G/L Account No.") then begin
                            TempGLAccount := GLAccount;
                            TempGLAccount.Insert();
                            // InitTotalGLAccountGLEntries(GLAccount);
                        end;

            until GlobalGLEntry.Next() = 0;

        // if ProcessGLAccount then begin
        // if GlobalGLEntry.GetFilter("G/L Account No.") <> '' then begin
        //     GLAccount.Reset();
        //     GLAccount.SetFilter("No.", GlobalGLEntry.GetFilter("G/L Account No."));
        //     if GLAccount.FindSet() then
        //         repeat
        //             TempGLAccount := GLAccount;
        //             if TempGLAccount.Insert() then;
        //             InitTotalGLAccountGLEntries(GLAccount);
        //         until GLAccount.Next() = 0;
        // end;

        // if GlobalGLEntry.GetFilter("Global Dimension 1 Code") <> '' then begin
        //     GLAccount.Reset();
        //     GLAccount.SetFilter("Global Dimension 1 Code", GlobalGLEntry.GetFilter("Global Dimension 1 Code"));
        //     if GLAccount.FindSet() then
        //         repeat
        //             TempGLAccount := GLAccount;
        //             if TempGLAccount.Insert() then;
        //             InitTotalGLAccountGLEntries(GLAccount);
        //         until GLAccount.Next() = 0;
        // end;

        // if GlobalGLEntry.GetFilter("BCC Account Category") <> '' then begin
        //     GLAccount.Reset();
        //     GLAccount.SetFilter("Account Category", GlobalGLEntry.GetFilter("BCC Account Category"));
        //     if GLAccount.FindSet() then
        //         repeat
        //             TempGLAccount := GLAccount;
        //             if TempGLAccount.Insert() then;
        //             InitTotalGLAccountGLEntries(GLAccount);
        //         until GLAccount.Next() = 0;
        // end;
        // end;

        //Add Total G/L Accounts
        TempGLAccount.Reset();
        GLAccount.Reset();
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Total);
        if GLAccount.FindSet() then
            repeat
                // TempGLAccount.SetFilter("No.", GLAccount.Totaling);
                // if not TempGLAccount.IsEmpty then
                //     continue;

                TempGLEForCalc.Reset();
                TempGLEForCalc.SetFilter("G/L Account No.", GLAccount.Totaling);
                if TempGLEForCalc.IsEmpty then
                    continue;

                TempGLAccount := GLAccount;
                IF TempGLAccount.Insert() then;
            until GLAccount.Next() = 0;

        TempGLAccount.Reset();
    end;

    local procedure TextPeriodToDate(Period: Text): Date
    var
        AccountingPeriod: Record "Accounting Period";
        TypeHelper: Codeunit "Type Helper";
        Variant: Variant;
        DateFormat: Text;
        Date: Date;
    begin
        Variant := Date;
        TypeHelper.Evaluate(Variant, '01-' + Period, 'dd-MM-yy', '');
        Date := Variant;
        AccountingPeriod.SetRange("New Fiscal Year", true);
        if AccountingPeriod.FindLast() then
            if AccountingPeriod."Starting Date".Month = 7 then
                Date := CalcDate('<-6M>', Date);
        exit(Date);
    end;

    local procedure DateToTextPeriod(InputDate: Date): Text
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        if AccountingPeriod.FindLast() then
            if AccountingPeriod."Starting Date".Month = 7 then
                InputDate := CalcDate('<6M>', InputDate);
        exit(Format(InputDate, 0, '<Month,2>-<Year>'));
    end;

    local procedure CalcBalance(GLAccountNo: Code[20]; CostCenterCode: Code[20]; Period: Code[10]; IsBeginningBalance: Boolean): Decimal
    var
        GLAccountLocal: Record "G/L Account";
        PeriodStartDate: Date;
        PeriodEndDate: Date;
    begin
        GLAccountLocal.SetRange("No.", GLAccountNo);
        GLAccountLocal.SetFilter("Global Dimension 1 Filter", CostCenterCode);
        if CostCenterCode = '' then
            if GlobalGLEntry.GetFilter("Global Dimension 1 Code") <> '' then
                GLAccountLocal.SetFilter("Global Dimension 1 Filter", GlobalGLEntry.GetFilter("Global Dimension 1 Code"));

        if Period <> '' then begin
            PeriodStartDate := TextPeriodToDate(Period);
            PeriodEndDate := CalcDate('<CM>', PeriodStartDate);
            if IsBeginningBalance then
                GLAccountLocal.SetRange("Date Filter", 0D, PeriodStartDate - 1)
            else
                GLAccountLocal.SetRange("Date Filter", 0D, PeriodEndDate);
        end else begin
            if IsBeginningBalance then
                GLAccountLocal.SetRange("Date Filter", 0D, StartingDate - 1)
            else
                GLAccountLocal.SetRange("Date Filter", 0D, EndingDate);
        end;

        if GLAccountLocal.FindFirst() then
            GLAccountLocal.CalcFields("Balance at Date");
        exit(GLAccountLocal."Balance at Date");
    end;

    local procedure CalcCategoryBalance(GLAccountNo: Code[20]; IsBeginningBalance: Boolean): Decimal
    var
        GLAccountLocal: Record "G/L Account";
        TotalCategoryBalance: Decimal;
    begin
        GLAccountLocal.Get(GLAccountNo);
        if GLAccountLocal."Account Type" = GLAccountLocal."Account Type"::Total then
            exit(0);

        GLAccountLocal.SetRange("Account Category", GLAccountLocal."Account Category");

        if GlobalGLEntry.GetFilter("Global Dimension 1 Code") <> '' then
            GLAccountLocal.SetFilter("Global Dimension 1 Filter", GlobalGLEntry.GetFilter("Global Dimension 1 Code"));

        if IsBeginningBalance then
            GLAccountLocal.SetRange("Date Filter", 0D, StartingDate - 1)
        else
            GLAccountLocal.SetRange("Date Filter", 0D, EndingDate);

        if GLAccountLocal.FindSet() then
            repeat
                GLAccountLocal.CalcFields("Balance at Date");
                TotalCategoryBalance += GLAccountLocal."Balance at Date";
            until GLAccountLocal.Next() = 0;

        exit(TotalCategoryBalance);
    end;

    local procedure CalcDCBalance(GLAccountNo: Code[20]; CostCenterCode: Code[20]; Period: Code[10]; IsDebit: Boolean): Decimal
    var
        GLAccountLocal: Record "G/L Account";
    begin
        GLAccountLocal.Get(GLAccountNo);

        TempGLEForCalc.Reset();
        TempGLEForCalc.SetRange("G/L Account No.", GLAccountNo);
        if GLAccountLocal."Account Type" = GLAccountLocal."Account Type"::Total then
            TempGLEForCalc.SetFilter("G/L Account No.", GLAccountLocal.Totaling);

        TempGLEForCalc.SetFilter("Global Dimension 1 Code", CostCenterCode);
        TempGLEForCalc.SetFilter("IC Partner Code", Period);
        if TempGLEForCalc.FindSet() then;
        TempGLEForCalc.CalcSums("Debit Amount", "Credit Amount");

        if IsDebit then
            exit(TempGLEForCalc."Debit Amount")
        else
            exit(TempGLEForCalc."Credit Amount");
    end;

    local procedure CalcCategoryDCBalance(GLAccountNo: Code[20]; IsDebit: Boolean): Decimal
    var
        GLAccountLocal: Record "G/L Account";
        TotalCategoryAmount: Decimal;
    begin
        GLAccountLocal.Get(GLAccountNo);
        GLAccountLocal.SetRange("Account Category", GLAccountLocal."Account Category");
        if GLAccountLocal.FindSet() then
            repeat
                TempGLEForCalc.Reset();
                if TempGLEForCalc.FindFirst() then begin
                    TempGLEForCalc.SetRange("G/L Account No.", GLAccountLocal."No.");
                    TempGLEForCalc.CalcSums("Debit Amount", "Credit Amount");

                    if IsDebit then
                        TotalCategoryAmount += TempGLEForCalc."Debit Amount"
                    else
                        TotalCategoryAmount += TempGLEForCalc."Credit Amount";
                end;
            until GLAccountLocal.Next() = 0;

        exit(TotalCategoryAmount);
    end;

    local procedure InitBCCTrialBalance()
    var
        GenLedgerSetup: Record "General Ledger Setup";
        GLAccountLocal: Record "G/L Account";
        TempCostCenter: Record "Dimension Value" temporary;
        DimensionValue: Record "Dimension Value";
        NextLineNo: Integer;
        GLEntryExists: Boolean;
        GLCategory: Enum "G/L Account Category";
        GLCategoryOrdinal: Integer;
    begin
        GenLedgerSetup.Get();

        if TempGLAccount.FindSet() then
            repeat
                TempCostCenter.Reset();
                if not TempCostCenter.IsEmpty then
                    TempCostCenter.DeleteAll();

                TempGLEForCalc.Reset();
                TempGLEForCalc.SetCurrentKey("Posting Date");
                TempGLEForCalc.SetRange("G/L Account No.", TempGLAccount."No.");

                if TempGLEForCalc.FindSet() then
                    repeat
                        if TempCostCenter.Get(GenLedgerSetup."Global Dimension 1 Code", TempGLEForCalc."Global Dimension 1 Code") then
                            continue;

                        DimensionValue.Get(GenLedgerSetup."Global Dimension 1 Code", TempGLEForCalc."Global Dimension 1 Code");
                        TempCostCenter := DimensionValue;
                        TempCostCenter.Insert();
                    until TempGLEForCalc.Next() = 0;

                Clear(BCCTempTrialBalance);
                BCCTempTrialBalance."G/L Account Category" := TempGLAccount."Account Category";
                BCCTempTrialBalance."G/L Account No." := TempGLAccount."No.";
                BCCTempTrialBalance."G/L Account Type" := TempGLAccount."Account Type";
                BCCTempTrialBalance."G/L Account Name" := TempGLAccount."Name";
                BCCTempTrialBalance."G/L Account Full Info" := StrSubstNo('%1 - %2', TempGLAccount."No.", TempGLAccount."Name");
                BCCTempTrialBalance."Is First Record" := true;

                if TempAccountingPeriod.FindSet() then
                    repeat
                        NextLineNo += 10;
                        BCCTempTrialBalance.Period := TempAccountingPeriod.Name;
                        BCCTempTrialBalance."Line No." := NextLineNo;
                        BCCTempTrialBalance."Period Start Date" := TempAccountingPeriod."Starting Date";
                        BCCTempTrialBalance."Period End Date" := CalcDate('<CM>', TempAccountingPeriod."Starting Date");
                        BCCTempTrialBalance."Period Description" := 'Period: ' + TempAccountingPeriod.Name;
                        BCCTempTrialBalance."Is First Record" := BCCTempTrialBalance.Period = StartingPeriod ? true : false;

                        if TempCostCenter.FindSet() then
                            repeat
                                BCCTempTrialBalance."Cost Center" := TempCostCenter.Code;
                                BCCTempTrialBalance."Cost Center Name" := TempCostCenter.Name;
                                BCCTempTrialBalance."Cost Center Full Info" := StrSubstNo('%1 - %2', TempCostCenter.Code, TempCostCenter.Name);
                                BCCTempTrialBalance.Insert();
                            until TempCostCenter.Next() = 0
                        else
                            BCCTempTrialBalance.Insert();

                    until TempAccountingPeriod.Next() = 0;

                BCCTempTrialBalance."Is Calc. Totals" := true;
                BCCTempTrialBalance.Modify();
            until TempGLAccount.Next() = 0;

        //recalculate balance for each line
        if BCCTempTrialBalance.FindSet() then
            repeat
                BCCTempTrialBalance."Period CC Begining Balance" := CalcBalance(BCCTempTrialBalance."G/L Account No.", BCCTempTrialBalance."Cost Center", BCCTempTrialBalance.Period, true);
                BCCTempTrialBalance."Period CC Debit Amount" := CalcDCBalance(BCCTempTrialBalance."G/L Account No.", BCCTempTrialBalance."Cost Center", BCCTempTrialBalance.Period, true);
                BCCTempTrialBalance."Period CC Credit Amount" := CalcDCBalance(BCCTempTrialBalance."G/L Account No.", BCCTempTrialBalance."Cost Center", BCCTempTrialBalance.Period, false);
                BCCTempTrialBalance."Period CC Ending Balance" := CalcBalance(BCCTempTrialBalance."G/L Account No.", BCCTempTrialBalance."Cost Center", BCCTempTrialBalance.Period, false);

                BCCTempTrialBalance."Total Sub Begining Balance" := CalcBalance(BCCTempTrialBalance."G/L Account No.", BCCTempTrialBalance."Cost Center", '', true);
                BCCTempTrialBalance."Total Sub Debit Amount" := CalcDCBalance(BCCTempTrialBalance."G/L Account No.", BCCTempTrialBalance."Cost Center", '', true);
                BCCTempTrialBalance."Total Sub Credit Amount" := CalcDCBalance(BCCTempTrialBalance."G/L Account No.", BCCTempTrialBalance."Cost Center", '', false);
                BCCTempTrialBalance."Total Sub Ending Balance" := CalcBalance(BCCTempTrialBalance."G/L Account No.", BCCTempTrialBalance."Cost Center", '', false);

                //calc totals
                if BCCTempTrialBalance."Is Calc. Totals" then begin
                    BCCTempTrialBalance."Total Acc. Begining Balance" := CalcBalance(BCCTempTrialBalance."G/L Account No.", '', '', true);
                    BCCTempTrialBalance."Total Acc. Debit Amount" := CalcDCBalance(BCCTempTrialBalance."G/L Account No.", '', '', true);
                    BCCTempTrialBalance."Total Acc. Credit Amount" := CalcDCBalance(BCCTempTrialBalance."G/L Account No.", '', '', false);
                    BCCTempTrialBalance."Total Acc. Ending Balance" := CalcBalance(BCCTempTrialBalance."G/L Account No.", '', '', false);

                    BCCTempTrialBalance."Total Cat. Begining Balance" := CalcCategoryBalance(BCCTempTrialBalance."G/L Account No.", true);
                    BCCTempTrialBalance."Total Cat. Debit Amount" := CalcCategoryDCBalance(BCCTempTrialBalance."G/L Account No.", true);
                    BCCTempTrialBalance."Total Cat. Credit Amount" := CalcCategoryDCBalance(BCCTempTrialBalance."G/L Account No.", false);
                    BCCTempTrialBalance."Total Cat. Ending Balance" := CalcCategoryBalance(BCCTempTrialBalance."G/L Account No.", false);
                end;

                BCCTempTrialBalance."Is Zero Sub" := (BCCTempTrialBalance."Total Sub Begining Balance" = 0) and
                                                    (BCCTempTrialBalance."Total Sub Debit Amount" = 0) and
                                                    (BCCTempTrialBalance."Total Sub Credit Amount" = 0) and
                                                    (BCCTempTrialBalance."Total Sub Ending Balance" = 0);
                BCCTempTrialBalance.Modify();
            until BCCTempTrialBalance.Next() = 0;

        //show/hide category total line
        foreach GLCategoryOrdinal in "G/L Account Category".Ordinals() do begin
            GLCategory := "G/L Account Category".FromInteger(GLCategoryOrdinal);
            BCCTempTrialBalance.Reset();
            BCCTempTrialBalance.SetRange("G/L Account Category", GLCategory);
            BCCTempTrialBalance.SetRange("Is Calc. Totals", true);
            if BCCTempTrialBalance.FindLast() then begin
                BCCTempTrialBalance."Is Last Category Record" := true;
                BCCTempTrialBalance.Modify();
            end;
        end;
    end;

    local procedure InitBCCTempTrialBalanceTotals()
    GLAccountLocal: Record "G/L Account";
    begin
        BCCTempTrialBalance.Reset();
        BCCTempTrialBalance.SetRange("Is Last Category Record", true);
        if GLAccountLocal.Get('9999') then
            BCCTempTrialBalance.SetFilter("G/L Account No.", GLAccountLocal.Totaling);

        if BCCTempTrialBalance.FindSet() then
            repeat
                BCCTempTrialBalanceIncomeTotals."Total Cat. Begining Balance" += BCCTempTrialBalance."Total Cat. Begining Balance";
                BCCTempTrialBalanceIncomeTotals."Total Cat. Debit Amount" += BCCTempTrialBalance."Total Cat. Debit Amount";
                BCCTempTrialBalanceIncomeTotals."Total Cat. Credit Amount" += BCCTempTrialBalance."Total Cat. Credit Amount";
                BCCTempTrialBalanceIncomeTotals."Total Cat. Ending Balance" += BCCTempTrialBalance."Total Cat. Ending Balance";
            until BCCTempTrialBalance.Next() = 0;
        BCCTempTrialBalanceIncomeTotals.Insert();
    end;

    local procedure InitTotalGLAccountGLEntries(GLAccount: Record "G/L Account")
    var
        GLEntry: Record "G/L Entry";
    // TotalGLAccount: Record "G/L Account";
    begin
        if GLAccount."Account Type" <> GLAccount."Account Type"::Total then
            exit;

        GLEntry.SetCurrentKey("Posting Date");
        GLEntry.SetRange("Posting Date", StartingDate, EndingDate);
        GLEntry.SetFilter("G/L Account No.", GLAccount.Totaling);

        if GLEntry.FindSet() then
            repeat
                TempGLE := GLEntry;
                TempGLE."IC Partner Code" := DateToTextPeriod(GLEntry."Posting Date");
                if TempGLE.Insert() then begin
                    TempGLEForCalc := TempGLE;
                    TempGLEForCalc.Insert();
                end;
            until GLEntry.Next() = 0;

        // TotalGLAccount.SetFilter("No.", GLAccount.Totaling);
        // TotalGLAccount.SetRange("Account Type", TotalGLAccount."Account Type"::Total);
        // if TotalGLAccount.FindSet() then
        //     repeat
        //         InitTotalGLAccountGLEntries(TotalGLAccount);
        //     until TotalGLAccount.Next() = 0;
    end;

    local procedure CleanupZeroBalanceAccounts()
    var
        GLAccount: Record "G/L Account";
        TempDimensionValue: Record "Dimension Value" temporary;
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();

        GLAccount.SetFilter("Account Type", '<>%1', GLAccount."Account Type"::Total);
        if GLAccount.FindSet() then
            repeat
                TempDimensionValue.Reset();
                if not TempDimensionValue.IsEmpty then
                    TempDimensionValue.DeleteAll();

                BCCTempTrialBalance.Reset();
                BCCTempTrialBalance.SetRange("G/L Account No.", GLAccount."No.");
                if BCCTempTrialBalance.FindSet() then
                    repeat
                        if BCCTempTrialBalance."Cost Center" = '' then
                            continue;

                        if TempDimensionValue.Get(GLSetup."Global Dimension 1 Code", BCCTempTrialBalance."Cost Center") then
                            continue;

                        TempDimensionValue.Code := BCCTempTrialBalance."Cost Center";
                        TempDimensionValue."Dimension Code" := GLSetup."Global Dimension 1 Code";
                        TempDimensionValue.Insert();
                    until BCCTempTrialBalance.Next() = 0;

                TempDimensionValue.Code := '';
                TempDimensionValue."Dimension Code" := GLSetup."Global Dimension 1 Code";
                if TempDimensionValue.Insert() then;

                if TempDimensionValue.FindSet() then
                    repeat
                        BCCTempTrialBalance.SetRange("Cost Center", TempDimensionValue.Code);
                        if not BCCTempTrialBalance.FindFirst() then
                            continue;

                        BCCTempTrialBalance.CalcSums("Period CC Begining Balance", "Period CC Debit Amount", "Period CC Credit Amount", "Period CC Ending Balance");
                        if (BCCTempTrialBalance."Period CC Begining Balance" = 0) and
                           (BCCTempTrialBalance."Period CC Debit Amount" = 0) and
                           (BCCTempTrialBalance."Period CC Credit Amount" = 0) and
                           (BCCTempTrialBalance."Period CC Ending Balance" = 0) then
                            BCCTempTrialBalance.DeleteAll();
                    until TempDimensionValue.Next() = 0;

            until GLAccount.Next() = 0;
        BCCTempTrialBalance.Reset();
    end;


    var
        CompanyInformation: Record "Company Information";
        TempGLAccount: Record "G/L Account" temporary;
        TempAccountingPeriod: Record "Accounting Period" temporary;
        TempGLEForCalc: Record "G/L Entry" temporary;
        BCCTempTrialBalanceIncomeTotals: Record "BCC Temp Trial Balance" temporary;
        StartingDate: Date;
        EndingDate: Date;
        StartingPeriod: Text;
        EndingPeriod: Text;
        ShowDetails: Boolean;
        HideZeroBalancedGLAccounts: Boolean;
}
