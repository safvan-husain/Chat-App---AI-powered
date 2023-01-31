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
exports.SignUpRouter = void 0;
const express_1 = require("express");
const user_model_1 = __importDefault(require("../model/user_model"));
const auth_token_1 = require("../utils/auth_token");
const password_hash_1 = require("../utils/password_hash");
const router = (0, express_1.Router)();
exports.SignUpRouter = router;
router.post("/auth/sign-up", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { email, username, password } = req.body;
    // console.log(email, username, password);
    const hashedpassword = new password_hash_1.Password().hash(password);
    let user = new user_model_1.default({
        username: username,
        email: email,
        password: yield hashedpassword,
        isOnline: false,
    });
    // console.log(user);
    try {
        user = yield user.save();
        let token = new auth_token_1.Token().generate(user._id);
        console.log(user);
        res.status(200).json({ "user": user, "token": token });
    }
    catch (error) {
        console.log(error.message);
    }
}));
