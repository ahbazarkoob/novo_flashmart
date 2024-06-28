importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyAFHjdDOOZSYN6fCvOyoh3RCE_pNW9hHQo",
  authDomain: "novo-flashmart.firebaseapp.com",
//   databaseURL: "https://ammart-8885e-default-rtdb.firebaseio.com",
  projectId: "novo-flashmart",
  storageBucket: "novo-flashmart.appspot.com",
  messagingSenderId: "155652134190",
  appId: "1:155652134190:android:2ef7b2f3978290986b96bf",
  measurementId: "G-R767W7WVQP"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});