const express = require('express');
const mongoose = require('mongoose');
const app = express();
const dotenv = require('dotenv');
dotenv.config();
//routes
const userRoute = require('./routes/user');
const authRoute = require('./routes/auth');

// connecting mongodb
mongoose.connect(process.env.MONGO_URL).then(() => {
    console.log('connected to db')
}).catch((err) => {
console.log(err)
});
app.use(express.json());


app.use("/api/auth",authRoute);
app.use("/api/users",userRoute);


app.listen( process.env.PORT || 3000, () => {
    console.log(`server is running`)
})




