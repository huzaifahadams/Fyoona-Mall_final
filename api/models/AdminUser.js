const mongoose = require('mongoose');

const adminSchema = new mongoose.Schema({
    fullname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    username: { type: String, required: true, unique: true },
    isAdmin: { type: Boolean, default: true },
    isVendor: { type: Boolean, default: false },
    isBuyer: { type: Boolean, default: false }
},
{ timestamps: true }
);

module.exports = mongoose.model("AdminUser", adminSchema);
