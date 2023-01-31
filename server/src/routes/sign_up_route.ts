import { Router } from "express";
import UserModel from "../model/user_model";
import { Token } from "../utils/auth_token";
import { Password } from "../utils/password_hash";

const router = Router();

router.post("/auth/sign-up",async (req, res) => {
  const { email, username, password } = req.body;
  // console.log(email, username, password);
  const hashedpassword =new Password().hash(password);
  let user = new UserModel({
    username: username,
    email: email,
    password:await hashedpassword, 
    isOnline: false,
  });
  // console.log(user);

  
  try {
    user = await user.save();
   let token = new Token().generate(user._id)
    console.log(user);
    res.status(200).json({"user": user, "token": token});    
  } catch (error : any) {
    console.log(error.message); 
    
  }
}); 

export { router as SignUpRouter };
