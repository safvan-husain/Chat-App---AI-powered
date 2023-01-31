import { NextFunction, Request, Response } from "express";
import { Token } from "../utils/auth_token";
import * as jwt from 'jsonwebtoken';

export const auth = (req: any, res: Response, next: NextFunction) => {
  var userID = new Token().getUserIdFromToken(req.headers["x-auth-token"]);
  // var userID = jwt.decode(req.headers["x-auth-token"]);
  if (userID) {
    req.userID = userID;
    next();
  } else {
    res.status(401).json({ message: "Invalid Token" });
  }
};
