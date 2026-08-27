-- ====================================================================
-- ZERO FINANCE TRACKER: ENTERPRISE BALANCE SHEET & SECURITY SCHEMA
-- Run this in Supabase SQL Editor
-- ====================================================================

-- 1. ASSETS TABLE (Live Multi-Asset Tracking)
CREATE TABLE IF NOT EXISTS assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    whatsapp_number VARCHAR(50) NOT NULL,
    asset_name VARCHAR(100) NOT NULL, -- e.g. "HDFC Savings Account", "Nifty 50 Index Fund", "PPF SBI", "EPF EPFO", "Sovereign Gold Bond"
    asset_type VARCHAR(50) NOT NULL DEFAULT 'liquid_cash', -- 'liquid_cash', 'fd', 'ppf', 'epf', 'gold', 'stocks', 'mutual_fund', 'real_estate', 'crypto', 'other'
    institution_name VARCHAR(100), -- e.g. "HDFC Bank", "Zerodha", "SBI", "EPFO"
    current_value NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(10) DEFAULT 'INR',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_asset_name UNIQUE (whatsapp_number, asset_name)
);

CREATE INDEX IF NOT EXISTS idx_assets_user ON assets(whatsapp_number);

-- 2. LIABILITIES TABLE (Live Multi-Liability Tracking)
CREATE TABLE IF NOT EXISTS liabilities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    whatsapp_number VARCHAR(50) NOT NULL,
    liability_name VARCHAR(100) NOT NULL, -- e.g. "HDFC Credit Card Outstanding", "SBI Home Loan", "Personal Loan"
    liability_type VARCHAR(50) NOT NULL DEFAULT 'loan', -- 'credit_card', 'personal_loan', 'home_loan', 'auto_loan', 'education_loan', 'emi', 'other'
    lender_name VARCHAR(100), -- e.g. "HDFC Bank", "SBI", "Bajaj Finserv"
    total_borrowed NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    outstanding_balance NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    monthly_emi NUMERIC(15, 2) DEFAULT 0.00,
    interest_rate NUMERIC(5, 2) DEFAULT 0.00,
    due_day_of_month INT DEFAULT 5,
    currency VARCHAR(10) DEFAULT 'INR',
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_liability_name UNIQUE (whatsapp_number, liability_name)
);

CREATE INDEX IF NOT EXISTS idx_liabilities_user ON liabilities(whatsapp_number);

-- 3. FINANCIAL SNAPSHOTS TABLE (Month-End Wealth History)
CREATE TABLE IF NOT EXISTS financial_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    whatsapp_number VARCHAR(50) NOT NULL,
    snapshot_month VARCHAR(7) NOT NULL, -- e.g. "2026-08"
    total_assets NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    total_liabilities NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    net_worth NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    total_income NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    total_expense NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    net_savings NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    savings_rate_pct NUMERIC(5, 2) DEFAULT 0.00,
    liquid_runway_months NUMERIC(5, 2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_snapshot_month UNIQUE (whatsapp_number, snapshot_month)
);

CREATE INDEX IF NOT EXISTS idx_snapshots_user_month ON financial_snapshots(whatsapp_number, snapshot_month);

-- 4. SEED SAMPLE LIVE ASSETS FOR USER (1104381256)
INSERT INTO assets (whatsapp_number, asset_name, asset_type, institution_name, current_value, notes)
VALUES 
  ('1104381256', 'HDFC Primary Savings', 'liquid_cash', 'HDFC Bank', 72400.00, 'Primary liquid operating bank account'),
  ('1104381256', 'Nifty 50 & Flexicap SIPs', 'mutual_fund', 'Groww / Zerodha Coin', 145000.00, 'Monthly index & equity fund portfolio'),
  ('1104381256', 'Public Provident Fund (PPF)', 'ppf', 'State Bank of India', 85000.00, 'Long-term 80C tax-exempt sovereign compounding'),
  ('1104381256', 'Employee Provident Fund (EPF)', 'epf', 'EPFO', 110000.00, 'Retirement corpus with employer match'),
  ('1104381256', 'Sovereign Gold Bonds / Gold', 'gold', 'RBI / MMTC-PAMP', 60000.00, 'Inflation hedge & physical gold reserve'),
  ('1104381256', 'Zerodha Equity Demat', 'stocks', 'Zerodha', 48000.00, 'Direct equity holdings')
ON CONFLICT (whatsapp_number, asset_name) 
DO UPDATE SET current_value = EXCLUDED.current_value, updated_at = CURRENT_TIMESTAMP;

-- 5. SEED SAMPLE LIVE LIABILITIES FOR USER (1104381256)
INSERT INTO liabilities (whatsapp_number, liability_name, liability_type, lender_name, total_borrowed, outstanding_balance, monthly_emi, interest_rate)
VALUES 
  ('1104381256', 'HDFC Millennia Credit Card', 'credit_card', 'HDFC Bank', 150000.00, 12850.00, 12850.00, 0.00),
  ('1104381256', 'Gadget / Consumer Loan EMI', 'emi', 'Bajaj Finserv', 45000.00, 22400.00, 3750.00, 11.50)
ON CONFLICT (whatsapp_number, liability_name) 
DO UPDATE SET outstanding_balance = EXCLUDED.outstanding_balance, updated_at = CURRENT_TIMESTAMP;

-- 6. ROW-LEVEL SECURITY ENFORCEMENT
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE liabilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_snapshots ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service Role Access" ON assets;
DROP POLICY IF EXISTS "Service Role Access" ON liabilities;
DROP POLICY IF EXISTS "Service Role Access" ON financial_snapshots;

CREATE POLICY "Service Role Access" ON assets FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service Role Access" ON liabilities FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service Role Access" ON financial_snapshots FOR ALL USING (true) WITH CHECK (true);
