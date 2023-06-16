Chat App with Chatbot
This is a personal project developed using Node.js and Flutter, implementing a chat app with a chatbot feature. The app utilizes the Stacked package for the MVVC architecture in the Flutter app, and it incorporates Google Authentication, push notifications, MongoDB as the database, and TypeScript for the Node.js backend.

Features
User authentication with Google sign-in
Real-time chat functionality
Integration of a chatbot powered by the OpenAI API
Push notifications for new messages
Stacked MVVC architecture for the Flutter app
MongoDB for storing user information and chat history
Utilization of TypeScript for the Node.js backend
Technologies Used
Node.js: JavaScript runtime environment used for the backend
Flutter: UI toolkit for building natively compiled applications for mobile, web, and desktop platforms
Stacked: MVVC architectural pattern package for Flutter
MongoDB: NoSQL document database for data storage
TypeScript: Superset of JavaScript that adds static typing and other features to the language
Installation
Prerequisites
Node.js: Make sure you have Node.js installed on your machine.
Flutter: Install Flutter on your development machine.
Backend Setup
Clone the repository to your local machine.
Navigate to the backend directory: cd server.
Install the required dependencies: npm install.
Rename .env.example file to .env.
Open the .env file and provide the necessary configurations such as the MongoDB connection URL, OpenAI API key, etc.
Start the backend server: npm run dev.
Frontend Setup
Navigate to the frontend directory: cd client.
Install the required dependencies: flutter pub get.
Start the app in your preferred development environment: flutter run.
Configuration
The configuration for the app can be found in the .env file located in the backend directory. The following environment variables need to be configured:

MONGODB_URI: The connection URL for the MongoDB database.
OPENAI_API_KEY: API key for the OpenAI service.
Usage
Once the app is up and running, you can use the chat app to communicate with other users. The chatbot feature powered by OpenAI can also provide automated responses based on the user's messages. You can sign in using your Google account and send messages to other users.
