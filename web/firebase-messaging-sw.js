// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDmfyKjxsYSSZTCnKRJQ8Lyl2FUxZ7ImII",
  authDomain: "fir-flutter-codelab-8daf6.firebaseapp.com",
  projectId: "fir-flutter-codelab-8daf6",
  storageBucket: "fir-flutter-codelab-8daf6.firebasestorage.app",
  messagingSenderId: "574670391972",
  appId: "1:574670391972:web:22819178cccd3bf8ee3431",
});

const messaging = firebase.messaging();
