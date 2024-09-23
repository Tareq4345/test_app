import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/features/auth/controller/auth_controller.dart';
import 'package:test_app/service/notification_services.dart';


class MainScreren extends ConsumerStatefulWidget {
  const MainScreren({super.key});

  @override
  _MainScrerenState createState() => _MainScrerenState();
}

class _MainScrerenState extends ConsumerState<MainScreren> {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final AndroidFlutterLocalNotificationsPlugin androidFlutterLocalNotificationsPlugin = AndroidFlutterLocalNotificationsPlugin();


  @override
  void initState() {
    super.initState();
    requistPermission();
    initInfo();
  }

  initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings = InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);
   
     FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print('forground message: ${message.notification?.title}');
       const AndroidNotificationDetails androidPlatformChannelSpecifies =
        AndroidNotificationDetails(
           "high importance_channer",
           "high importance Notification",
           importance: Importance.max,
           priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifies = const NotificationDetails(android: androidPlatformChannelSpecifies);
    
     await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platformChannelSpecifies);

     });


  }

void requistPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User   granted permission');
      
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");
    }else{
      print("User declined or has not accepted permission");
    }
  }

  _sendNotification(String userToken) async {
    String title = 'title';
    String body = 'body';

    if (title.isEmpty || body.isEmpty) {
      _showDialog("error", "title and body cannnot be empty");
      return;
    }

    try {
      final accessToken = await Service().getAccessToken();
      await Service().sendNotificaton(accessToken, userToken, title, body);
      _showDialog('Success', 'Notification sent successfully.');
    } catch (e) {
      debugPrint('Error sending notification: $e');
      _showDialog('Error', 'Error sending notification.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  


  Widget build(BuildContext context) {
    final userList = ref.watch(getAllUsers);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
             ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
               itemCount:userList.value == null?0: userList.value!.length,
               itemBuilder: (context, index){
              final user = userList.value![index];
        
              return userList.value == null?const CircularProgressIndicator(): GestureDetector(
                onTap: (){
                  _sendNotification(user.deviceToken);
                },
                child: Container(
                   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   height: 80,
                   decoration: BoxDecoration(
                    color: Colors.white10,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    
                    Text(user.name,),
                    const SizedBox(width: 15,),
                    // Text(user.deviceToken,style: const TextStyle(fontSize: 15,overflow: TextOverflow.ellipsis))
                  ],
                ),
                            ),
              );
          }),
            
            
          ],
        ),
      ),
    );
  }
}