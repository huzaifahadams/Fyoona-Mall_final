const mongoose = require('mongoose');

const vendorsSchema = new mongoose.Schema({
    fullname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    phonenumber: { type: Number, required: true },
    vendorlogo: { type: String, required: false },
    businessname: { type: String, required: true },
    country: { type: String, required: true },
    state: { type: String, required: true },
    city: { type: String, required: true },
    taxStatus: { type: Boolean, default: false },
    taxNumber: { type: Number, required: false },
    isAdmin: { type: Boolean, default: false },
    isVendor: { type: Boolean, default: true },
    isBuyer: { type: Boolean, default: false }
},
{ timestamps: true }
);

module.exports = mongoose.model("VendorsUser", vendorsSchema);
