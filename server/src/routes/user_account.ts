import { Response, Router } from "express";
import { auth } from "../middlewares/authentication";
import UserModel from "../model/user_model";

const router = Router();

router.post("/profile/change-dp", auth, async (req: any, res : Response) => {
    // console.log(req.body);
    
    const { avatar} = req.body;
    try {
        let user = await UserModel.findById(req.userID)
        if (user != null) {
        user.avatar = avatar;
        user = await user.save()
        res.status(200).json(user);
    }else {
        console.log('user not found');
        
    }
    } catch (error) {
        res.status(500).json(error);
        console.log(error);
        
    }
});
export { router as ProfileRouter}