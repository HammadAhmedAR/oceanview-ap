package com.oceanview.model;

import java.math.BigDecimal;

public class Room {

    private int roomId;
    private String roomCode;
    private String roomType;
    private BigDecimal pricePerNight;
    private String status;

    public Room() {
    }

    public Room(int roomId, String roomCode, String roomType, BigDecimal pricePerNight, String status) {
        this.roomId = roomId;
        this.roomCode = roomCode;
        this.roomType = roomType;
        this.pricePerNight = pricePerNight;
        this.status = status;
    }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getRoomCode() { return roomCode; }
    public void setRoomCode(String roomCode) { this.roomCode = roomCode; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
