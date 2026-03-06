package com.oceanview.service;

import com.oceanview.dao.BillDAO;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Bill;
import com.oceanview.model.Reservation;

public class BillingService {

    private final BillDAO billDAO = new BillDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    public String generateBillFromReservation(int reservationId) {
        // Check if bill already exists
        Bill existing = billDAO.getBillByReservationId(reservationId);
        if (existing != null) {
            return "Bill already exists for this reservation: " + existing.getBillNumber();
        }

        // Get reservation details
        Reservation res = getReservationById(reservationId);
        if (res == null) {
            return "Reservation not found.";
        }

        // Generate bill number
        String billNumber = "BILL-" + System.currentTimeMillis();

        Bill bill = new Bill();
        bill.setBillNumber(billNumber);
        bill.setReservationId(reservationId);
        bill.setBillAmount(res.getTotalAmount());
        bill.setBillStatus("GENERATED");

        boolean success = billDAO.createBill(bill);
        return success ? null : "Failed to generate bill.";
    }

    public Bill getBillDetails(int billId) {
        return billDAO.getBillById(billId);
    }

    public Bill getBillByReservationId(int reservationId) {
        return billDAO.getBillByReservationId(reservationId);
    }

    public java.util.List<Bill> getAllBills() {
        return billDAO.getAllBills();
    }

    public boolean updateBillStatus(int billId, String status) {
        return billDAO.updateBillStatus(billId, status);
    }

    private Reservation getReservationById(int reservationId) {
        // Use getAllReservations and find by id (since we don't have getById)
        for (Reservation r : reservationDAO.getAllReservations()) {
            if (r.getReservationId() == reservationId) {
                return r;
            }
        }
        return null;
    }
}
