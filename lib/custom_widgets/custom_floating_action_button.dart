import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class CustomFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0, color: Colors.grey[900]),
      backgroundColor: Theme.of(context).primaryColor,
      marginBottom: 80,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: true,
      overlayColor: Colors.grey[800],
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.message, color: Colors.grey[800]),
          backgroundColor: Colors.amber,
          onTap: () => Get.toNamed('/messenger'),
          label: "Promote",
          labelStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[800]),
          labelBackgroundColor: Colors.amberAccent,
        ),
        // SpeedDialChild(
        //   child: Icon(Icons.account_circle, color: Colors.grey[800]),
        //   backgroundColor: Colors.redAccent,
        //   onTap: () => Get.toNamed('/profile'),
        //   label: "lable2",
        //   labelStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[800]),
        //   labelBackgroundColor: Colors.redAccent,
        // ),

      ],
    );
  }

}
