const mongoose = require('mongoose');

const buyersSchema = new mongoose.Schema({
    fullname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    phonenumber: { type: String, required: true },
    address: { type: String, default: '' },

    userImg: { type: String, default: ''  },
    isAdmin: { type: Boolean, default: false },
    isVendor: { type: Boolean, default: false },
    isBuyer: { type: Boolean, default: true },
    activationCode:{ type: String, required: true },
    isActivated:{ type: Boolean, default: false },
},
{ timestamps: true }
);

module.exports = mongoose.model("BuyersUser", buyersSchema);
