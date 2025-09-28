import 'package:flutter/material.dart';

import 'notifi_service.dart';

class NotificationTest extends StatelessWidget {
  const NotificationTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('local notificattion'),centerTitle: true,),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              //normal notification
              ElevatedButton(
                onPressed: () {
                 NotificationService().showNotification(title: 'sample ', body: 'its work!');
              }, child: Text('show notification'),),


              //scedule notification
              ElevatedButton(
                onPressed: () {
                  NotificationService().scheduleNotification(
                    title: "Test",
                    body: "This should fire in 10sT",
                    hour: 22,
                    minute: 24,
                  );


                }, child: Text('sceduel notification'),),
            ],
          )),
    );
  }
}
