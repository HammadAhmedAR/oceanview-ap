package com.oceanview.service;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

public class AuthService {

    private final UserDAO userDAO = new UserDAO();

    public User login(String username, String password) {
        return userDAO.validateLogin(username, password);
    }

    public boolean usernameExists(String username) {
        return userDAO.usernameExists(username);
    }

    public boolean register(String username, String password) {
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole("STAFF");
        return userDAO.registerUser(user);
    }
}