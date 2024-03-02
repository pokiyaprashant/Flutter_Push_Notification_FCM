

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(onPressed: (){

          // send notification from one device to another
          notificationServices.getDeviceToken().then((value)async{

            print('value---${value}');
            var data = {
              'to' : 'cfTdvMuATPuQVxo2fReRi5:APA91bGLxJssoL9xsRPd8vf9-QEs99xYSeTGwLQUIVzyoUla67WPpsx1vYB1-6iQMTHTUdY5KGonmLYHdPbxVkpI-Iu3VPc4RVAeB-azexutiOoXXxx598A1RX9dg2tj6igc_pwOQh0A',
              'notification' : {
                'title' : 'Prashant' ,
                'body' : 'Subscribe to my channel' ,
                // "sound": "jetsons_doorbell.mp3"
            },
              'android': {
                'notification': {
                  'notification_count': 23,
                },
              },
              'data' : {
                'type' : 'msj' ,
                'id' : 'Prashant Pokiya'
              }
            };

            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data) ,
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization' : 'key=AAAAqqjGWj0:APA91bEEL8wA1PDxr4QILUtqPuMxcDVrBb4uMexrEjc5z05TBUgp2WQ4G_mzUi1orPNCZZERnajzbCN-LCAzDpSTCaCU2fzAG2Nrmd8zi9Qdnp_s4Krj8nq0yxlVzJLbEU6DwpCt4t9T'
              }
            ).then((value){
              if (kDebugMode) {
                print(value.body.toString());
              }
            }).onError((error, stackTrace){
              if (kDebugMode) {
                print(error);
              }
            });
          });
        },
            child: Text('Send Notifications')),
      ),
    );
  }
}
