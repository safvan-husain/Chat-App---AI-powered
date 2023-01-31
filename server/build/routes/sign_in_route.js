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
exports.SigninRouter = void 0;
const express_1 = require("express");
const authentication_1 = require("../middlewares/authentication");
const user_model_1 = __importDefault(require("../model/user_model"));
const auth_token_1 = require("../utils/auth_token");
const password_hash_1 = require("../utils/password_hash");
const router = (0, express_1.Router)();
exports.SigninRouter = router;
router.post("/auth/sign-in", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { username, password } = req.body;
    try {
        let user = yield user_model_1.default.findOne({ username });
        let token;
        if (user) {
            console.log(yield new password_hash_1.Password().validate(password, user.password));
            console.log(password + "=" + user.password);
            if (yield new password_hash_1.Password().validate(password, user.password)) {
                token = new auth_token_1.Token().generate(user._id);
                console.log(token + user._id);
                res.status(200).json({ user: user, token: token });
            }
            else {
                res.status(401).json({ message: "Invalid password" });
            }
            // console.log({"user": user, "token": token});
        }
        else {
            res.status(401).json({ message: "User not found" });
            console.log("user not found");
        }
    }
    catch (err) {
        console.log(err);
        res.status(500).json({ message: err.message });
    }
}));
router.get("/auth/token", authentication_1.auth, (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        var user = yield user_model_1.default.findById(req.userID);
        console.log(user);
        res.status(200).json(user);
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
}));
