/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const Razorpay = require("razorpay");
const cors = require("cors")({ origin: true });

// Replace with your Razorpay keys
const razorpay = new Razorpay({
  key_id: "rzp_test_ls7IwqX7O8o1EY",
  key_secret: "x1lk02uKxAcL0YaJroVWDWLL",
});

exports.createOrder = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") {
      return res.status(405).send("Method Not Allowed");
    }

    const { amount, currency } = req.body;

    const options = {
      amount: amount * 100, // paise
      currency: currency || "INR",
      receipt: "order_rcptid_" + Date.now(),
    };

    try {
      const order = await razorpay.orders.create(options);
      res.status(200).json(order);
    } catch (error) {
      console.error("Error creating Razorpay order", error);
      res.status(500).send("Error creating order");
    }
  });
});
