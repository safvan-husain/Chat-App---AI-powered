import { Response, Router } from "express";
import { auth } from "../middlewares/authentication";
import UserModel from "../model/user_model";
import { Token } from "../utils/auth_token";
import { Password } from "../utils/password_hash";

const router = Router();

router.post("/auth/sign-in", async (req, res) => {
  const { username, password } = req.body;
// console.log('login called');

  try {
    let user = await UserModel.findOne({ username });
    let token;
    if (user) {
      // console.log(await new Password().validate(password, user!.password));
      // console.log(password + "=" + user.password);

      if (await new Password().validate(password, user.password)) {
        token = new Token().generate(user._id);
        // console.log(token + user._id);

        res.status(200).json({ user: user, token: token });
      } else {
        res.status(401).json({ message: "Invalid password" });
      }
      // console.log({"user": user, "token": token});
    } else {
      res.status(401).json({ message: "User not found" });
      console.log("user not found");
    }
  } catch (err: any) {
    console.log(err);  
    res.status(500).json({ message: err.message });
  }
});

router.get("/auth/token", auth, async (req: any, res: Response) => {
  try {
    var user = await UserModel.findById(req.userID);
    
    res.status(200).json(user);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export { router as SigninRouter };
