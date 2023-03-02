import { Router } from "express";
import * as dotenv from "dotenv";
import { Configuration, OpenAIApi } from "openai";
import { auth } from "../middlewares/authentication";

dotenv.config();
const configuration = new Configuration({
  apiKey: process.env.openai_api_key,
});
const openai = new OpenAIApi(configuration);
const router = Router();

router.post('/ai/generate',auth, async (req, res) => {
  const { message } = req.body;


  const completion = await openai.createCompletion({
    model: "text-curie-001",
    prompt: generatePrompt(message),
    temperature: 0.84,
    max_tokens: 300,
    top_p: 1,
    
  });
  console.log(completion.data);
  res.status(200).json({ result: completion.data.choices[0].text });
});

function generatePrompt(message: string) {
  return `
  Have a chat with me. act as a smart Rajappan who is an Artificial Intelligence
  me: what's the first letter of your name?
  AI_Rajappan: R
   ${message}   
   `;
}

export { router as aiRouter}