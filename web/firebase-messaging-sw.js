importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

const firebaseConfig = {
    apiKey: "AIzaSyCiLwls0068lNUZ5w2ch50ZNjdOVrFYJ90",
    authDomain: "falldetectionwebsite.firebaseapp.com",
    projectId: "falldetectionwebsite",
    storageBucket: "falldetectionwebsite.appspot.com",
    messagingSenderId: "1074295281685",
    appId: "1:1074295281685:web:80e62e849e681f4516961c"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    // You can add more options here like icon, image, etc.
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
