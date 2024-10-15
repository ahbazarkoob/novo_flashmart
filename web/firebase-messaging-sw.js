importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyDxLliLKbo_Bxv-mshuEqU90Y9PesmWDAw',
    authDomain: 'brella-88d35.firebaseapp.com',
    //   databaseURL: "https://ammart-8885e-default-rtdb.firebaseio.com",
    projectId: 'brella-88d35',
    storageBucket: 'brella-88d35.appspot.com',
    messagingSenderId: '751256638769',
    appId: '1:751256638769:web:ceb567f89449a68ff80c10',
    measurementId: 'G-G9L15HRCQ7'
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