const jwt = require("jsonwebtoken")

const verifyTokenBuyer = (req,res,next)=> {
    const authHeader = req.headers.token

    if(authHeader){
        jwt.verify(token,procces.env.JWT_SEC,(err,user) =>{
            if(err) res.status(401).json('Token is not valid!');

            req.user = user
            next();


        })
    } else{
        return res.status(401).json('You are not authenticated');

    }
};

const verifyTokenAndAuthorization = (req,res,next)=>{

verifyTokenBuyer(req,res, () =>{
if(req.user.id === req.params.id  || req.user.isAdmin || req.user.isVenodr){
    next()
} else {
    res.status(403).json('You have no  Acces to do that')
}
})
}


module.exports = {verifyTokenBuyer , verifyTokenAndAuthorization};
