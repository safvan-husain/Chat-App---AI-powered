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
Object.defineProperty(exports, "__esModule", { value: true });
exports.aiRouter = void 0;
const express_1 = require("express");
const openai_1 = require("openai");
const authentication_1 = require("../middlewares/authentication");
const configuration = new openai_1.Configuration({
    apiKey: "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",
});
const openai = new openai_1.OpenAIApi(configuration);
const router = (0, express_1.Router)();
exports.aiRouter = router;
router.post('/ai/generate', authentication_1.auth, (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { message } = req.body;
    const completion = yield openai.createCompletion({
        model: "text-curie-001",
        prompt: generatePrompt(message),
        temperature: 0.84,
        max_tokens: 300,
        top_p: 1,
    });
    console.log(completion.data);
    res.status(200).json({ result: completion.data.choices[0].text });
}));
function generatePrompt(message) {
    return `
  Have a chat with me. act as a smart Rajappan who is an Artificial Intelligence
  me: what's the first letter of your name?
  AI_Rajappan: R
   ${message}   
   `;
}
