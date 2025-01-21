# Voting App

Welcome to the Voting App! This application is designed to facilitate secure and efficient voting processes. It provides a user-friendly interface for voters and administrators to manage and participate in elections.

## Overview

The Voting App is built using modern technologies to ensure a seamless and secure voting experience. The frontend is developed using Flutter, which allows for a smooth and responsive user interface across multiple platforms, including Android, iOS, and web. The backend is powered by Node.js and Express.js, providing a robust and scalable server-side solution. MongoDB is used as the database to store user and voting data securely.

## Key Features

- **User Registration and Login**: Users can register and log in securely using their email and password. The app uses JWT (JSON Web Tokens) for authentication to ensure secure access to the app's features.
- **Role-Based Access Control**: The app supports different roles, such as voters and administrators. Each role has specific permissions and access to different features within the app.
- **Voting System**: Users can view a list of candidates and cast their votes securely. The voting process is designed to be simple and intuitive, ensuring a smooth experience for users.
- **Profile Management**: Users can update their profile information, including their name, email, phone number, and address. They can also change their password to maintain account security.
- **Admin Panel**: Administrators have access to a dedicated admin panel where they can manage candidates, view voting results, and perform other administrative tasks.

## Screenshots

Here are some screenshots of the app to give you a visual overview of its features:

### Login Screen

![Login Screen](assets/sc/02.png)

### Signup Screen

![Signup Screen](assets/sc/01.png)

## How It Works

1. **User Registration**: Users can sign up by providing their details such as name, email, phone, age, address, aadhar, and password. The registration process ensures that all required fields are filled out and validates the input data.
2. **User Login**: Registered users can log in using their email and password. Upon successful login, a JWT token is generated and stored securely on the client side to authenticate subsequent requests.
3. **Voting**: Users can view the list of candidates available for voting. Each user can cast their vote for a candidate of their choice. The voting process is secure and ensures that each user can vote only once.
4. **Profile Management**: Users can navigate to their profile page to update their personal information, such as name, email, phone number, and address. They can also change their password to enhance account security.
5. **Admin Panel**: Administrators have access to a special admin panel where they can manage the list of candidates, add new candidates, update candidate information, and view the results of the voting process.

## Endpoints

### User Endpoints

- **POST /signup**: Register a new user.
  - **Request Body**:
    ```json
    {
      "name": "John Doe",
      "email": "john.doe@example.com",
      "phone": "1234567890",
      "age": 30,
      "address": "123 Main St",
      "aadhar": "123456789012",
      "password": "password123",
      "role": "voter"
    }
    ```
  - **Response**:
    ```json
    {
      "message": "Person saved successfully",
      "data": {
        "id": "user_id",
        "name": "John Doe",
        "email": "john.doe@example.com",
        "phone": "1234567890",
        "age": 30,
        "address": "123 Main St",
        "aadhar": "123456789012",
        "role": "voter",
        "isVoted": false
      },
      "token": "jwt_token"
    }

    ## Conclusion
    
    The Voting App is a comprehensive solution for managing elections with ease and security. With its robust features and user-friendly interface, it ensures a smooth voting experience for both voters and administrators. The app leverages modern technologies such as Flutter for the frontend and Node.js for the backend, ensuring a seamless and efficient performance.
    
    ### Key Takeaways
    
    - **Secure Authentication**: The app uses JWT for secure user authentication, ensuring that only authorized users can access the system.
    - **Role-Based Access Control**: Different roles (voter and admin) have specific permissions, enhancing the security and functionality of the app.
    - **User-Friendly Interface**: The app provides a smooth and intuitive user interface, making it easy for users to navigate and perform actions.
    - **Scalable Backend**: The backend, built with Node.js and Express.js, is robust and scalable, capable of handling a large number of users and votes.
    - **Real-Time Voting Results**: Administrators can view real-time voting results, making the election process transparent and efficient.
    
    ### Future Enhancements
    
    - **Multi-Language Support**: Adding support for multiple languages to cater to a diverse user base.
    - **Push Notifications**: Implementing push notifications to keep users informed about important updates and events.
    - **Enhanced Security**: Adding more security features such as two-factor authentication (2FA) to further secure user accounts.
    
    ---
    
    Thank you for checking out the Voting App! We hope you find it useful and engaging. Feel free to explore the app and contribute to its development. If you have any questions or feedback, please don't hesitate to reach out.
    
    Happy Voting!