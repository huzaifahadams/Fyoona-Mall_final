const mongoose = require('mongoose');

const cartSchema = new mongoose.Schema({
    buyersId: { type: String, required: true },
    products: [
        {
            productId: { type: String },
            quantity: { type: Number, default: 1 },
            imageUrList: { type: Array },
            price: { type: String },
            vendorId: { type: String },
            productSize: { type: String },
            productColor: { type: String },
            scheduleDate: { type: Date }, // or { type: String } depending on your use case
            userId: { type: String },
            shippingFee: { type: String, required: false },
        }
    ]
},
{ timestamps: true }
);

module.exports = mongoose.model("Cart", cartSchema);
