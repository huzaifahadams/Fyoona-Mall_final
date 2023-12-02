const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
    orderId: { type: String, required: true },
    buyersId: { type: String, required: true },
    products: [
        {
            productId: { type: String },
            quantity: { type: Number, default: 1 },
            price: { type: String },
            vendorId: { type: String },
            productSize: { type: String },
            productColor: { type: String },
            scheduleDate: { type: Date }, // or { type: Date } depending on your use case
            buyersId: { type: String },
            orderDate: { type: Date, default: Date.now },
            productImage: { type: Array },
            productName: { type: String },
            accepted: { type: String, default: false },
        }
    ],
    email: { type: String, required: true },
    phoneNumber: { type: String, required: true },
    address: { type: String, required: true },
    fullame: { type: String, required: true },
    buyerPhoto: { type: String, required: true },
    availquantity: { type: Number },
    status: { type: String, default: "pending" },
},
{ timestamps: true }
);

module.exports = mongoose.model("Orders", orderSchema);
