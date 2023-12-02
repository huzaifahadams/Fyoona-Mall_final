const router = require('express').Router();
const CryptoJS = require('crypto-js');

const {verifyTokenBuyer,verifyTokenAndAuthorization} = require('../midware/verifyToken');



//UPDATE BUYER
router.put("/:id", verifyTokenAndAuthorization,(req,res)=>{

if(req.body.passwprd){
    const encryptedPassword = CryptoJS.AES.encrypt(password, process.env.PASS_SEC).toString();

}
})



module.exports = router;
