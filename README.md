# OceanView 🌊

A full-stack **Hotel Room Reservation Management System** built with Java EE (Servlets + JSP), PostgreSQL, and Bootstrap 5.

---

## Features

| Module | Capabilities |
|--------|-------------|
| **Authentication** | Login, register, logout with session management |
| **Dashboard** | Live stats (total rooms, booked, available, guests) — clickable to drill down |
| **Staff Management** | Add, edit, delete staff accounts (Admin only) |
| **Guest Management** | Register, update, delete guests; quick-add from reservation form |
| **Room Management** | View all rooms with live booking status and guest names |
| **Reservation Management** | Create reservations (only available rooms shown), cancel, delete cancelled |
| **Billing** | One-click bill generation + automatic payment recording |
| **Payment History** | Full log of all payments with bill reference |
| **Help Section** | In-app guide for new staff members |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | Java EE — Servlets + JSP |
| **Database** | PostgreSQL + JDBC |
| **Frontend** | Bootstrap 5, Bootstrap Icons, Google Fonts (Inter) |
| **Build** | Maven (WAR packaging) |
| **Server** | GlassFish (or any Servlet 5+ container) |

---

## Architecture

```
com.oceanview
├── controller/     # Servlets (HTTP layer)
├── service/        # Business logic
├── dao/            # Database access (JDBC)
├── model/          # POJOs (User, Guest, Room, Reservation, Bill, Payment)
└── util/           # DBConnection helper
```

**Request flow:**  
`Browser → Servlet → Service → DAO → PostgreSQL`

---

## Database Schema

Run these SQL statements to set up the database:

```sql
-- Users (staff accounts)
CREATE TABLE users (
    user_id   SERIAL PRIMARY KEY,
    username  VARCHAR(50) UNIQUE NOT NULL,
    password  VARCHAR(255) NOT NULL,
    role      VARCHAR(20) NOT NULL DEFAULT 'STAFF',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Guests
CREATE TABLE guests (
    guest_id   SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    phone      VARCHAR(20),
    email      VARCHAR(100),
    address    TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Rooms
CREATE TABLE rooms (
    room_id        SERIAL PRIMARY KEY,
    room_code      VARCHAR(20) UNIQUE NOT NULL,
    room_type      VARCHAR(50) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    status         VARCHAR(20) DEFAULT 'AVAILABLE'
);

-- Reservations
CREATE TABLE reservations (
    reservation_id     SERIAL PRIMARY KEY,
    reservation_number VARCHAR(50) UNIQUE NOT NULL,
    guest_id           INT NOT NULL REFERENCES guests(guest_id),
    room_id            INT NOT NULL REFERENCES rooms(room_id),
    check_in_date      DATE NOT NULL,
    check_out_date     DATE NOT NULL,
    number_of_nights   INT NOT NULL,
    total_amount       DECIMAL(10,2) NOT NULL,
    status             VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bills
CREATE TABLE bills (
    bill_id        SERIAL PRIMARY KEY,
    bill_number    VARCHAR(50) UNIQUE NOT NULL,
    reservation_id INT NOT NULL REFERENCES reservations(reservation_id),
    bill_amount    DECIMAL(10,2) NOT NULL,
    bill_status    VARCHAR(20) NOT NULL DEFAULT 'GENERATED',
    generated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments
CREATE TABLE payments (
    payment_id     SERIAL PRIMARY KEY,
    bill_id        INT NOT NULL REFERENCES bills(bill_id),
    payment_method VARCHAR(20) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Setup & Running

### Prerequisites
- Java 17+
- Maven 3.8+
- PostgreSQL 14+
- GlassFish 7 (or Tomcat 10+)

### 1. Clone the repository
```bash
git clone https://github.com/HammadAhmedAR/oceanview-ap.git
cd oceanview-ap
```

### 2. Configure the database
Edit `src/main/java/com/oceanview/util/DBConnection.java`:
```java
private static final String URL      = "jdbc:postgresql://localhost:5432/oceanview";
private static final String USERNAME = "postgres";
private static final String PASSWORD = "postgres";
```

### 3. Create the database and run SQL schema
```bash
psql -U postgres -c "CREATE DATABASE oceanview;"
psql -U postgres -d oceanview -f schema.sql
```

### 4. Build the WAR
```bash
mvn clean package
```

### 5. Deploy
Copy `target/oceanview.war` to your GlassFish `autodeploy` folder, or deploy via the admin console.

### 6. Access the app
```
http://localhost:8080/oceanview/
```

---

## Default Workflow

```
Landing Page
    └── Login / Register
            └── Dashboard
                    ├── Manage Guests
                    ├── Manage Rooms (view booking status)
                    ├── Manage Reservations
                    │       └── Reservation Details
                    │               ├── Generate Bill & Pay → Invoice
                    │               ├── Cancel Reservation
                    │               └── Delete Reservation (cancelled only)
                    ├── Payment History
                    ├── Manage Staff (Admin only)
                    └── Help
```

---

## User Roles

| Role | Access |
|------|--------|
| **ADMIN** | Full access — including Staff Management |
| **STAFF** | Guests, Reservations, Billing, Payments, Help |

---

## Project Structure

```
src/
└── main/
    ├── java/com/oceanview/
    │   ├── controller/          # 24 Servlets
    │   ├── dao/                 # 7 DAOs
    │   ├── model/               # 6 Models
    │   ├── service/             # 4 Services
    │   └── util/                # DBConnection
    └── webapp/
        ├── css/                 # Per-page stylesheets
        ├── *.jsp                # 16 JSP pages
        └── WEB-INF/web.xml
```

---

## License

MIT License — feel free to use and modify.
