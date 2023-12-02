const router = require('express').Router();
const CryptoJS = require('crypto-js');
const BuyersUser = require('../models/BuyersUser');

const {verifyTokenBuyer,verifyTokenAndAuthorization} = require('../midware/verifyToken');

// UPDATE BUYER

router.put("/:id", verifyTokenAndAuthorization, async (req, res) => {
    try {
      if (req.body.password) {
        req.body.password = CryptoJS.AES.encrypt(
          req.body.password,
          process.env.PASS_SEC
        ).toString();
      }
  
      const updateUser = await BuyersUser.findByIdAndUpdate(
        req.params.id,
        { $set: req.body },
        { new: true }
      );
  
      if (!updateUser) {
        return res.status(404).json({ error: "User not found" });
      }
  
      res.status(200).json(updateUser);
    } catch (err) {
      console.error(err); // Log the error
      res.status(500).json({ error: "Internal Server Error" });
    }
  });
   


module.exports = router;
