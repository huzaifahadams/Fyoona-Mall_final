const router = require('express').Router();
const CryptoJS = require('crypto-js');
const BuyersUser = require('../models/BuyersUser');

const {verifyTokenBuyer,verifyTokenAndAuthorization, verifyTokenAndAdmin} = require('../midware/verifyToken');

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


   //DELETE BUYER
   router.delete('/delete/:id', verifyTokenAndAuthorization, async (req, res) => {
    try {
      const deleteUser = await BuyersUser.findByIdAndDelete(req.params.id);
      res.status(200).json('User deleted');

      if (!deleteUser) {
        return res.status(404).json({ error: "User not found" });
      }

      res.status(204).json(deleteUser);
    } catch (err) {
      console.error(err); // Log the error
      res.status(500).json({ error: "Internal Server Error" });
    }
  });

// GET BUYER ...admin 
router.get('/find/:id', verifyTokenAndAdmin, async (req, res) => {
  try {
    const GetUserAdmin = await BuyersUser.findById(req.params.id);
    if (!GetUserAdmin) {
      return res.status(404).json({ error: "User not found" });
    }

    const { password, ...others } = GetUserAdmin._doc;
    res.status(200).json(others);
  } catch (err) {
    console.error(err); // Log the error
    res.status(500).json({ error: "Internal Server Error" });
  }
});


// GET BUYER ...admin get all users
router.get('/', verifyTokenAndAdmin, async (req, res) => {
  const query = req.query.new
  try {
    //grtting new users or old user
    const GetUserAdmin = query ? await BuyersUser.find().sort({_id:-1}).limit(10): await BuyersUser.find();

    res.status(200).json(GetUserAdmin);


  } catch (err) {
    console.error(err); // Log the error
    res.status(500).json({ err });
  }
});


//GET USER STATS
//am gettig user statics par month 
router.get('/stats/', verifyTokenAndAdmin, async (req, res) => {   

const date = new Date();
const lastYear = new Date(date.setFullYear(date.getFullYear() - 1));

  try {
    const getUserStats = await BuyersUser.aggregate([
      { $match: {createdAt: {$gte: lastYear,}
        }},
        {
$project:{
  month: { $month: "$createdAt" },
}
 },
      {
         $group: { _id: "$month", 
         total: { $sum: 1 } 
        } },
    ]);
    res.status(200).json(getUserStats);
  } catch (err) {
    console.error(err); // Log the error
    res.status(500).json({ err });
  }
})

module.exports = router;

