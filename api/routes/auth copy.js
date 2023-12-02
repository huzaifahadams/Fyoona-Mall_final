const router = require('express').Router();
const BuyersUser = require('../models/BuyersUser');
const CryptoJS = require('crypto-js');
const nodemailer = require('nodemailer');
const jwt = require('jsonwebtoken');
//buyers
// regesiter
router.post('/registerbuyer', async (req, res) => {
  try {
    const { fullname, email, password, phonenumber, userImg } = req.body;

    // Check for empty inputs
    if (!fullname || !email || !password || !phonenumber || !userImg) {
      return res.status(400).json('All fields must be filled');
    }

    // Check if email is already used
    const existingUser = await BuyersUser.findOne({ email });
    if (existingUser) {
      return res.status(400).json('Email is already in use');
    }

    // Add more password strength checks if needed
    if (password.length < 6) {
      return res.status(400).json('Password must be at least 6 characters long');
    }

    const encryptedPassword = CryptoJS.AES.encrypt(password, process.env.PASS_SEC).toString();

    // Generate a 6-digit activation code
    const activationCode = Math.floor(100000 + Math.random() * 900000);

    const newUser = new BuyersUser({
      fullname,
      email,
      password: encryptedPassword,
      phonenumber,
      userImg,
      activationCode,
      isActivated: false, // Add a field to track account activation status
    });

    const savedUser = await newUser.save();

   
    const transporter = nodemailer.createTransport({
        host: process.env.EMAIL_HOST,
        port: process.env.EMAIL_PORT,
        secure: process.env.SMTP_security_mode === 'SSL',
        auth: {
          user: process.env.EMAIL,
          pass: process.env.EMAIL_PASSWORD,
        },
      });
      
    const mailOptions = {
        from:  process.env.EMAIL,
        to: email,
        subject: 'Activate Your Account',
        text: `${fullname},
          Thank you for joining! Please use the following code to activate your account: ${activationCode}`,
      };
      
   
    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          console.error('Error sending email:', error);
          return res.status(500).json('Failed to send activation email');
        }
        console.log('Activation email sent:', info.response);
        res.status(201).json(savedUser);
      });
      

  } catch (err) {
    console.error(err);
    res.status(500).json(err.message || 'Internal Server Error');
  }
});

// login buyer
router.post('/loginbuyer', async (req, res) => {
    try {
      const buyerUser = await BuyersUser.findOne({ email: req.body.email });
  
      if (!buyerUser) {
        return res.status(401).json('Wrong Credentials');
      }
  
      const hashedPass = CryptoJS.AES.decrypt(buyerUser.password, process.env.PASS_SEC);
      const truepassword = hashedPass.toString(CryptoJS.enc.Utf8);
  
      if (truepassword !== req.body.password) {
        return res.status(401).json('Wrong Credentials');
      }
//jwt 
const accessTOekn = jwt.sign({
    id:buyerUser._id,
    isAdmin: buyerUser.isAdmin //to be removed

}, process.env.JWT_SEC, {expiresIn: '2d'})
      const{password, ...others} = buyerUser._doc;


      res.status(200).json({...others, accessTOekn}) ;
    } catch (err) {
      res.status(500).json(err.message || 'Internal Server Error');
    }
  });
  
module.exports = router;
