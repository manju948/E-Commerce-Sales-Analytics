import pandas as pd
import pyodbc

# SQL Server Connection
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=localhost,1433;"
    "DATABASE=ECommerceSalesAnalytics;"
    "UID=sa;"
    "PWD=Manju@123;"
    "TrustServerCertificate=yes;"
)

cursor = conn.cursor()

# Read CSV files
customers = pd.read_csv("dataset/customers.csv")
products = pd.read_csv("dataset/products.csv")
orders = pd.read_csv("dataset/orders.csv")
order_items = pd.read_csv("dataset/order_items.csv")

# Clear existing data (important because of foreign keys)
cursor.execute("DELETE FROM OrderItems")
cursor.execute("DELETE FROM Orders")
cursor.execute("DELETE FROM Products")
cursor.execute("DELETE FROM Customers")
conn.commit()

# ---------------- Customers ----------------
for _, row in customers.iterrows():
    cursor.execute("""
        INSERT INTO Customers
        (CustomerID, FirstName, LastName, Email, Phone, City, State, SignupDate)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """,
    int(row.CustomerID),
    row.FirstName,
    row.LastName,
    row.Email,
    str(row.Phone),
    row.City,
    row.State,
    row.SignupDate)

conn.commit()
print("Customers Imported")

# ---------------- Products ----------------
for _, row in products.iterrows():
    cursor.execute("""
        INSERT INTO Products
        (ProductID, ProductName, Category, Brand, Price, Stock)
        VALUES (?, ?, ?, ?, ?, ?)
    """,
    int(row.ProductID),
    row.ProductName,
    row.Category,
    row.Brand,
    float(row.Price),
    int(row.Stock))

conn.commit()
print("Products Imported")

# ---------------- Orders ----------------
for _, row in orders.iterrows():
    cursor.execute("""
        INSERT INTO Orders
        (OrderID, CustomerID, OrderDate, PaymentMethod, OrderStatus)
        VALUES (?, ?, ?, ?, ?)
    """,
    int(row.OrderID),
    int(row.CustomerID),
    row.OrderDate,
    row.PaymentMethod,
    row.OrderStatus)

conn.commit()
print("Orders Imported")

# ---------------- Order Items ----------------
for _, row in order_items.iterrows():
    cursor.execute("""
        INSERT INTO OrderItems
        (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
        VALUES (?, ?, ?, ?, ?)
    """,
    int(row.OrderItemID),
    int(row.OrderID),
    int(row.ProductID),
    int(row.Quantity),
    float(row.UnitPrice))

conn.commit()
print("Order Items Imported")

cursor.close()
conn.close()

print("🎉 All data imported successfully!")