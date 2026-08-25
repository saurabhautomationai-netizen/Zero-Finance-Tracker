-- =========================================================
-- Fractional CFO Assets & Net Worth Table for Supabase
-- Run this in Supabase SQL Editor
-- =========================================================

CREATE TABLE IF NOT EXISTS assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    whatsapp_number VARCHAR(50) NOT NULL,
    asset_name VARCHAR(100) NOT NULL, -- e.g. "HDFC Savings Account", "Nifty 50 Index Fund", "Zerodha Portfolio", "Sovereign Gold Bond"
    asset_type VARCHAR(50) NOT NULL DEFAULT 'liquid_cash', -- 'liquid_cash', 'mutual_fund', 'stocks', 'gold', 'real_estate', 'crypto', 'other'
    current_value NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(10) DEFAULT 'INR',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_asset UNIQUE (whatsapp_number, asset_name)
);

CREATE INDEX IF NOT EXISTS idx_assets_user ON assets(whatsapp_number);

-- Optional starter sample balance sheet for Saurabh (1104381256)
INSERT INTO assets (whatsapp_number, asset_name, asset_type, current_value, notes)
VALUES 
  ('1104381256', 'Primary Savings Account', 'liquid_cash', 65000, 'Liquid emergency bank balance'),
  ('1104381256', 'Mutual Funds & SIPs', 'mutual_fund', 120000, 'Index & Flexicap portfolios'),
  ('1104381256', 'Stock Trading Capital', 'stocks', 45000, 'Zerodha active equity holding')
ON CONFLICT (whatsapp_number, asset_name) DO NOTHING;
