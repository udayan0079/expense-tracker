# Personal Expense Tracker App

A Flutter application developed for the Ostad assignment that allows users to manage daily income and expenses with local persistence using SQLite (`sqflite`).

---

## 📱 Features & Criteria Fulfillment

### 1. Dashboard Screen
- **App Title:** "Expense Tracker" displayed prominently in the AppBar.
- **Dynamic Summary Cards:**
  - **Total Income:** Automatically calculated sum of all income transactions (Green theme).
  - **Total Expense:** Automatically calculated sum of all expense transactions (Red theme).
  - **Current Balance:** Dynamically calculated (`Total Income - Total Expense`).
- **Recent Transactions:** Displayed in real-time.
- **Floating Action Button (FAB):** Convenient `+ Add Transaction` button to quickly record transactions.

### 2. Add Transaction Screen
- **Fields Included:**
  - `Title`: Text input for transaction title.
  - `Amount`: Numeric text input with decimal support.
  - `Category`: Dropdown selection (Salary, Food, Transport, Rent, Shopping, Bills, etc.).
  - `Transaction Type`: Dropdown selection for `Income` and `Expense` with visual indicators.
  - `Date`: Date picker modal to pick any date.
  - `Save Transaction`: Elevated button to submit.
- **Form Validations:**
  - Title cannot be empty.
  - Amount must be a valid positive number (`> 0`).
  - Category must be selected.
  - Transaction type must be selected.

### 3. Transaction List
- Built with efficient list builders (`ListView.builder` / `SliverList`).
- Each item shows:
  - **Title**
  - **Amount**
  - **Category**
  - **Date**
  - **Transaction Type**
- Distinct color coding: **Green** for Income and **Red** for Expense.

### 4. Update Transaction
- Selecting an item or tapping the edit option opens the edit form with previously saved information pre-filled.
- Updates are saved directly to the local SQLite database.

### 5. Delete Transaction
- An `AlertDialog` confirmation appears before deleting any transaction.
- Upon deletion, the transaction list and dashboard summary cards update immediately.

### 6. Transaction Details Screen
- Complete transaction details are displayed with a card layout and badges.
- Includes direct **Edit** and **Delete** options.

### 7. Local Database (SQLite / `sqflite`)
- **Database Name:** `expense_tracker.db`
- **Table Name:** `transactions`
- **Table Schema:**
  - `id`: `INTEGER PRIMARY KEY AUTOINCREMENT`
  - `title`: `TEXT`
  - `amount`: `REAL`
  - `category`: `TEXT`
  - `type`: `TEXT`
  - `date`: `TEXT`
- **Persistence:** All data persists across application restarts.

---

## 📁 Project Structure

```
lib/
├── database/
│   └── db_helper.dart                   # SQLite database operations (CRUD & totals)
├── models/
│   └── transaction_model.dart            # Transaction data model (fromMap & toMap)
├── screens/
│   ├── dashboard_screen.dart            # Dashboard with summary cards, list, and FAB
│   ├── add_edit_transaction_screen.dart # Form for adding and updating transactions
│   └── transaction_details_screen.dart  # Transaction details with Edit/Delete actions
└── main.dart                            # Application entry point & theme
```

---

## 🚀 How to Run

1. Open a terminal in the `et` directory:
   ```bash
   cd et
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

4. Run tests:
   ```bash
   flutter test
   ```
