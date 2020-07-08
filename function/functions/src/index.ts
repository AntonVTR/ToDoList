import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
    .document('user_task/{user}')
    .onCreate(async snapshot => {
        const u = snapshot.id;
        let token = '';
        let task, task_name, task_desc;

        const v = await snapshot.data()
        if (v) {
            task = await v.task;
            //console.log('1 task is ', task);

        }
        await db
            .collection('tasks')
            .doc(task)
            .get()
            .then(doc => {
                if (!doc.exists) {
                    console.log('No such document!');
                } else {
                    const s_task = doc.data();
                    //console.log('2 Document data:', s_task);
                    if (s_task) {
                        task_name = s_task.name;
                        task_desc = s_task.description + '/n tap to start';
                        //console.log('3 s_task= ', s_task.name);
                    }
                }
            })
            .catch(err => {
                console.log('Error getting document', err);
            });

        await db
            .collection('users')
            .doc(u)
            .collection('tokens')
            .get()
            .then(snapShot => {
                if (snapShot.empty) {
                    console.log('No matching documents.');
                    return;
                }
                snapShot.forEach(doc => {
                    token = doc.id;
                    console.log('4 token is ', token);
                });
            })
            .catch(err => {
                console.log('Error getting documents', err);
            });
        console.log("6 Task name is ", task_name, ' task description is ', task_desc, " task id is ", task, ' token is ', token, ' user is ', u);
        //console.log('7 user is ', u);


        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: task_name,
                body: task_desc,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            },
            data: {
                task_id: task,
            },

        };
        //console.log("6 Task name is ", task_name, " task id is ", task, 'token is ', token);

        return fcm.sendToDevice(token, payload);

    });

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript


export const helloFriend = functions.https.onRequest(async (request, response) => {
    response.send("Hello my virtual friend!");
});
