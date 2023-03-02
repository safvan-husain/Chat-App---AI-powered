import UserModel from "../model/user_model";

var FCM = require('fcm-node');
var serverKey = require('./../chat-app---ai-powered-firebase-adminsdk-kclpe-ade272fda9.json'); //put your server key here
var fcm = new FCM(serverKey);


// Send message
export async function sendMessage({title,body,username}:{title: string,body: string, username: string}) {
    console.log('send message caled');
    
    try {
        var user = await UserModel.findOne({ username: username });
        var event = { //this may vary according to the message type (single recipient, multicast, topic, et cetera)
            to: user?.appToken, 
            
            notification: {
                title: title, 
                body: body
            },
            
            data: {  //you can send only notification or only data(or include both)
                reciever: 'husain',
            }
        };
        
        fcm.send(event, function(err: any, response: any){
            if (err) {
                console.log("Something has gone wrong!");
                console.log(err.message);
                
            } else {
                console.log("Successfully sent with response: ", response);
            }
        });
    } catch (error) {
        console.log(error);
        
    }
}


