const router = require('express').Router();
const BuyersUser = require('../models/BuyersUser');
const CryptoJS = require('crypto-js');
const nodemailer = require('nodemailer');
const jwt = require('jsonwebtoken');

const transporter = nodemailer.createTransport({
  host: process.env.EMAIL_HOST,
  port: process.env.EMAIL_PORT,
  secure: process.env.SMTP_security_mode,
  
//   === 'SSL',
  auth: {
    user: process.env.EMAIL,
    pass: process.env.EMAIL_PASSWORD,
  },
});

//buyer
// Register
router.post('/registerbuyer', async (req, res) => {
  try {
    const { fullname, email, password, phonenumber, userImg } = req.body;

    // Check for empty inputs
    if (!fullname || !email || !password || !phonenumber || !userImg) {
      return res.status(400).json('All fields must be filled');
    }

    // Check email format
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!regexEmail.test(email)) {
      return res.status(400).json('Invalid email format');
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

    // Save user with activation code
    try {
         // Save user with activation code and expiration time
    const expirationTime = Date.now() + 10 * 60 * 1000; // 10 minutes in milliseconds
   
        const savedUser = await new BuyersUser({
            fullname,
            email,
            password: encryptedPassword,
            phonenumber,
            userImg,
            activationCode,
            activationCodeExpires: expirationTime,
            isActivated: false,
          }).save();

    // Send activation email
    const mailOptions = {
      from: `"${process.env.SENDERNAME}" <${process.env.EMAIL}>`,
      to: email,
      subject: 'Activate Your Account',
      html: `
        <html>
          <body>
            <div style="font-family: Arial, sans-serif; padding: 20px; text-align: center;">
              <h2 style="color: #3498db;">Welcome to Fyoona Mall!</h2>
              <p>${fullname},</p>
              <p>Thank you for joining! Please use the following code to activate your account:</p>
              <h3 style="background-color: #3498db; color: #fff; padding: 10px; display: inline-block; margin: auto;">${activationCode}</h3>
              <p style="color: #ff0000;">This code expires in 10 minutes.</p>
            </div>
          </body>
        </html>
      `,
    };

    // Logic for code expiration

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error('Error sending email:', error);
        return res.status(500).json('Failed to send activation email');
      }
      console.log('Activation email sent:', info.response);
      res.status(201).json(savedUser);
    });
    } catch (error) {
      console.error('Error creating user:', error);
      res.status(500).json('Failed to create user');
    }
  } catch (err) {
    console.error(err);
    res.status(500).json(err.message || 'Internal Server Error');
  }
});

// Login buyer
router.post('/loginbuyer', async (req, res) => {
  try {
    const buyerUser = await BuyersUser.findOne({ email: req.body.email });

    if (!buyerUser) {
      return res.status(401).json('Wrong Credentials');
    }

    // if (!buyerUser.isActivated) {
    //   return res.status(401).json('Account not activated. Check your email for activation instructions.');
    // }
 // Check if activation code is expired
 if (buyerUser.activationCodeExpires && buyerUser.activationCodeExpires < Date.now()) {
    return res.status(401).json('Activation code has expired. Request a new one.');
  }
    // Generate JWT token upon successful login
    const accessToken = jwt.sign(
      {
        id: buyerUser._id,
        isAdmin: buyerUser.isAdmin, // to be removed
        isVendor: buyerUser.isVendor, // to be removed

      },
      process.env.JWT_SEC,
      { expiresIn: '2d' }
    );

    const { password, ...others } = buyerUser._doc;

    res.status(200).json({ ...others, accessToken });
  } catch (err) {
    res.status(500).json(err.message || 'Internal Server Error');
  }
});


// Logout buyer with JWT tokens
router.post('/logoutbuyer', (req, res) => {
  res.status(200).json({ message: 'Logout successful' });
});


module.exports = router;
