import { Router } from "express";
import { auth } from "../middlewares/authentication";
import UserModel from "../model/user_model";

const router = Router();

router.get("/get-data/all-user", auth, async (req, res) => {
  try {
    const users = await UserModel.find();
    res.status(200).json(users);
  } catch (err) {
    res.status(500).json(err);
    console.log(err);
  }
});

export { router as DataRouter}