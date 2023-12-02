const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
    productName: { type: String, required: true },
    productPrice: { type: Number, required: true },
    password: { type: String, required: true },
    quantity: { type: Number, required: true },
    scheduleDate: { type: Date, required: false },
    category: { type: Array, required: true },
    productDescription: { type: String, required: true },
    imageUrList: { type: Array, required: true },
    videoUrl: { type: String, required: true },
    chargeShipping: { type: Boolean, default: false },
    shippingFee: { type: Number, required: false },
    brandName: { type: String, required: true },
    sizeList: { type: Array, required: false },
    colorList: { type: Array, required: false },
    vendorId: { type: String, required: true },

},
{ timestamps: true }
);

module.exports = mongoose.model("Product", productSchema);
