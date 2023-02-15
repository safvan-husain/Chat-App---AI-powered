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
exports.ProfileRouter = void 0;
const express_1 = require("express");
const authentication_1 = require("../middlewares/authentication");
const user_model_1 = __importDefault(require("../model/user_model"));
const router = (0, express_1.Router)();
exports.ProfileRouter = router;
router.post("/profile/change-dp", authentication_1.auth, (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    // console.log(req.body);
    const { avatar } = req.body;
    try {
        let user = yield user_model_1.default.findById(req.userID);
        if (user != null) {
            user.avatar = avatar;
            user = yield user.save();
            res.status(200).json(user);
        }
        else {
            console.log('user not found');
        }
    }
    catch (error) {
        res.status(500).json(error);
        console.log(error);
    }
}));