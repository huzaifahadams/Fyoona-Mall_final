const jwt = require("jsonwebtoken");

const verifyTokenBuyer = (req, res, next) => {
  const authHeader = req.headers.token;

  if (authHeader) {
    const token = authHeader.split(" ")[1];
    jwt.verify(token, process.env.JWT_SEC, (err, user) => {
      if (err) res.status(401).json('Token is not valid!');

      req.user = user;
      next();
    });
  } else {
    return res.status(401).json('You are not authenticated');
  }
};

const verifyTokenAndAuthorization = (req, res, next) => {
  verifyTokenBuyer(req, res, () => {
    if (req.user.id === req.params.id || req.user.isAdmin || req.user.isVendor) {
      next();
    } else {
      res.status(403).json('You have no access to do that');
    }
  });
};

///admin
const verifyTokenAndAdmin = (req, res, next) => {
  verifyTokenBuyer(req, res, () => {
    if (req.user.isAdmin) {
      next();
    } else {
      res.status(403).json('You have no access to do that');
    }
  });
};

///vendor
const verifyTokenAndVendor = (req, res, next) => {
  verifyTokenBuyer(req, res, () => {
    if (req.user.isVendor) {
      next();
    } else {
      res.status(403).json('You have no access to do that');
    }
  });
};

module.exports = { verifyTokenBuyer, verifyTokenAndAuthorization, verifyTokenAndAdmin, verifyTokenAndVendor };
