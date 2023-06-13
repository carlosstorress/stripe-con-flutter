// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// admin.initializeApp();
// const db = admin.firestore();

// // // Create and deploy your first functions
// // // https://firebase.google.com/docs/functions/get-started
// //
// // exports.helloWorld = functions.https.onRequest((request, response) => {
// //   functions.logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");
// // });

// const stripe = require('stripe')(functions.config().stripe.testkey);

// exports.stripePayment = functions.https.onRequest(async (req, res) => {
//     const paymentIntent = await stripe.paymentIntents.create({
//         payment_method_types: ["card"],
//         amount: 416760,
//         currency: 'mxn',
//         description: 'Pago de colegiatura',
//         shipping: {
//             name: 'Carlos Torres', // Nombre del destinatario
//             address: {
//               line1: 'Av. Principal 123',
//               line2: 'Colonia Centro',
//               city: 'Ciudad de México',
//               state: 'CDMX',
//               postal_code: '12345',
//               country: 'MX'
//             } // Agregar shipping address
//           },
//     },
//     function (err, paymentIntent){
//         if(err!=null) {
//             console.log(err);
//         }
//         else {
//             res.json({
//                 paymentIntent: paymentIntent.client_secret
//             })
//         }
//     }
//    )
// })

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

const stripe = require('stripe')(functions.config().stripe.testkey);

exports.stripePayment = functions.https.onRequest(async (req, res) => {
  const { shippingName, shippingAddressLine1, shippingAddressLine2, shippingCity, shippingState, shippingPostalCode, shippingCountry } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
        payment_method_types: ["card"],
        amount: 416760,
        currency: 'mxn',
        description: 'Pago de colegiatura',
        shipping: {
            name: shippingName,
            address: {
              line1: shippingAddressLine1,
              line2: shippingAddressLine2,
              city: shippingCity,
              state: shippingState,
              postal_code: shippingPostalCode,
              country: shippingCountry
            }
          },
    });

    res.json({
        paymentIntent: paymentIntent.client_secret
    });
});
