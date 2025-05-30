const admin = require('firebase-admin');
const serviceAccount = require('./fir-flutter-codelab-8daf6-firebase-adminsdk-fbsvc-e8fa95bba3.json'); 

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const targetToken = 'd_DuxmNxMfHFS8b7HBJbat:APA91bEDWAQbY7RqBqvjmV4YiK9ckirEFk7dVpGa8nn0VB0OKbtE66SJMFLs2T8rHpdTWdFVS2CiaWTzWUumq2fk6pH2kimZvv2gOZnI-UoaW_UfSig0iLU';

const message = {
  token: targetToken,
  notification: {
    title: 'Сайн уу!',
    body: 'Энэ бол серверээс ирж буй мэдэгдэл',
  },
  webpush: {
    headers: {
      Urgency: 'high',
    },
    notification: {
      icon: 'https://yourdomain.com/icons/icon-192.png', 
      click_action: 'http://localhost:5000', 
    },
  },
};

admin
  .messaging()
  .send(message)
  .then((response) => {
    console.log('✅ Амжилттай илгээгдлээ:', response);
  })
  .catch((error) => {
    console.error('❌ Илгээхэд алдаа гарлаа:', error);
  });
