# Zero Finance Tracker 🚀
### Autonomous Multi-Modal Personal Finance Intelligence & Tracking System

An end-to-end automated personal finance assistant powered by **n8n Cloud**, **Supabase PostgreSQL**, **OpenAI GPT-4o / Whisper / Vision**, **Telegram Bot**, and **Gmail Ingestion**.

---

## 🌟 Key Capabilities

- **100% PostgreSQL-Native**: Fully migrated from Google Sheets to an enterprise relational PostgreSQL schema in Supabase with foreign keys, constraints, and indexes.
- **Multi-Modal Data Capture**:
  - ✍️ **Natural Text**: Single expenses and multi-line batch transaction lists.
  - 🎙️ **Voice Notes**: Speech-to-text via OpenAI Whisper.
  - 📸 **Receipt Photos**: Computer Vision AI scanner for receipts, bills, and invoices.
  - 📄 **PDF Statements**: Multi-month bank & credit card statement bulk imports.
- **Autonomous Gmail Ingestion (`saurabh7596@gmail.com`)**:
  - Background polling worker that scans unread financial alerts (debits, credits, UPI receipts, Swiggy, Amazon, SaaS renewals).
  - Automatically extracts and logs transactions into Supabase and sends real-time Telegram notifications.
- **Conversational Financial Intelligence**:
  - 💬 **Finance Chat**: Instant category spending, balance, and merchant queries.
  - 📊 **Monthly Reports**: Full income, expense, net savings, and category breakdowns for any month.
  - 💡 **Smart Affordability Engine**: Computes true monthly free cash flow against active EMIs & dues and provides intelligent purchase verdicts.
  - 🔮 **Cashflow Forecasting**: Projected savings calculation.
- **Credit Cards, Loans & Reminders**:
  - 💳 Credit card billing & payment tracking.
  - 🏦 Loan & EMI commitments.
  - ⏰ Bill payment reminders with a daily **09:00 AM** automated morning alert.

---

## 🗄️ Database Schema (`schema.sql`)

- `users`: User profiles and currency preferences.
- `transactions`: Central transaction ledger across all capture channels.
- `credit_cards`: Active card bills, minimum dues, and billing cycles.
- `loans`: Active loans, EMIs, and monthly due dates.
- `reminders`: Bill payment reminders and notification timestamps.
- `subscriptions`: Recurring SaaS subscriptions.
- `conversation_context`: Multi-turn conversational memory.

---

## 📁 Repository Structure

```text
├── schema.sql                               # Complete PostgreSQL DDL schema for Supabase
├── zero-finance-tracker.json                # Main 115-node n8n workflow (PostgreSQL + Telegram)
├── zero-finance-tracker-email-ingestion.json# Autonomous Gmail Ingestion workflow
├── .gitignore                               # Environment and secret protection
└── README.md                                # Project documentation
```

---

## 🚀 Setup & Deployment

1. **Deploy Database**:
   - Run `schema.sql` in your Supabase SQL Editor.
2. **Import Workflows into n8n**:
   - Import `zero-finance-tracker.json` into n8n Cloud and link credentials for Telegram, OpenAI, and PostgreSQL.
   - Import `zero-finance-tracker-email-ingestion.json` and link Gmail OAuth2.
3. **Activate & Chat**:
   - Start chatting with your Telegram bot (`@PersonalAccounti1bot`) or send transaction emails!
