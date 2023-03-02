"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendMessage = void 0;
const user_model_1 = __importDefault(require("../model/user_model"));
var FCM = require('fcm-node');
var serverKey = require('./../chat-app---ai-powered-firebase-adminsdk-kclpe-ade272fda9.json'); //put your server key here
var fcm = new FCM(serverKey);
// Send message
function sendMessage({ title, body, username }) {
    return __awaiter(this, void 0, void 0, function* () {
        console.log('send message caled');
        try {
            var user = yield user_model_1.default.findOne({ username: username });
            var event = {
                to: user === null || user === void 0 ? void 0 : user.appToken,
                notification: {
                    title: title,
                    body: body
                },
                data: {
                    reciever: 'husain',
                }
            };
            fcm.send(event, function (err, response) {
                if (err) {
                    console.log("Something has gone wrong!");
                    console.log(err.message);
                }
                else {
                    console.log("Successfully sent with response: ", response);
                }
            });
        }
        catch (error) {
            console.log(error);
        }
    });
}
exports.sendMessage = sendMessage;
