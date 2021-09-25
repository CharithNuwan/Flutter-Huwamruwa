
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huwamaruwa/screen/login_screen.dart';
import 'package:huwamaruwa/services/UI_Data.dart';


class CustomAppBar extends StatefulWidget with PreferredSizeWidget{

  final String title;
  final bool bell_icon;

  CustomAppBar({Key key, this.title,this.bell_icon}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}

class _CustomAppBarState extends State<CustomAppBar>{

  String cart;

  @override
  void initState() {
    super.initState();
    if(widget.bell_icon){
//      getNotificationCount();
//      viewCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: GoogleFonts.adventPro(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: Get.height < 680 ? 22.0 : 27.0,
            )
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              UI_Data.Custom_App_Bar_color1,
              UI_Data.Custom_App_Bar_color2,
            ],
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        true ?
        Badge(
          shape: BadgeShape.circle,
          position: BadgePosition.topEnd(top: 1,end: 5),
          animationDuration: Duration(milliseconds: 300),
          animationType: BadgeAnimationType.slide,
          showBadge:  true ,
          badgeContent: Container(
              padding: EdgeInsets.only(left: 2,right: 2),
              child: Text(
                  "",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        fontSize: Get.height < 680 ? 8.0 : 12.0,
                      )
                  )
              ),
          ),
          child: IconButton(
            icon: Icon(Icons.menu_book),
            onPressed: () {
              Get.toNamed("/cart");
            },
          ),
        ) : SizedBox(),

      ],
    );
  }


}

