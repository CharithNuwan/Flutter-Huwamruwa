import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:huwamaruwa/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';




class LoginScreen extends StatefulWidget {

  static const String routeName = '/login';
  static bool flage = true;
  static int p1QTY=10;
  static int p2QTY=8;
  static int p3QTY=12;
  static int CartD=0;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const String routeName = '/login';
  SharedPreferences sharedPreferences;
  final TextEditingController mobileNumberController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        decoration: BoxDecoration(
            color: Colors.black87
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) :
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.90,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Image.asset("assets/images/logo.png",fit: BoxFit.contain,),
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(
                  "LOGIN",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5.0,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(
                                      color: Colors.white10
                                  )
                              ),
                              child: TextFormField(
                                  style: TextStyle(color: Colors.white,),
                                  controller: mobileNumberController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.white60),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(
                                      color: Colors.white10
                                  )
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: passwordController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.white60),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.blue
                              ),
                              child: OutlineButton(
                                splashColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0)
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if(passwordController.text!=""){
                                    // Navigator.pushReplacementNamed(context, Routes.home);
                                  }else{
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                 login(mobileNumberController.text, passwordController.text);
                                },
                                child: Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, Routes.forgotPassword);
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Divider(color: Colors.white24,),
                      SizedBox(height: 20.0,),
                      Text(
                        "Don't have an account ? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue
                        ),
                        child: OutlineButton(
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0)
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, Routes.singUp);
                          },
                          child: Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  // Future login(emil,pass) async {
  //   final url = "http://10.0.2.2:8090/getUserss";
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     final jsonStudent = jsonDecode(response.body);
  //     print(response.body.hashCode.toString());
  //   } else {
  //     print(response.statusCode.toString());
  //     throw Exception();
  //   }
  // }


  Future login(email,pass) async {
    print("---signupStep---");
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("email", email.toString());
    // print("get Key "+prefs.getString(UiData.signup_authKey).toString());
    Map data = {
        "email":email.toString(),
        "password":pass.toString()
    };
    Map<String, dynamic> userDataMap;
    print(data);


    // var response = await http.post(url);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    var response = await post("http://10.0.2.2:8090/user/verify", headers: <String, String>{
      'Content-Type': 'application/json',
    },body:jsonEncode(data)).then((response){
      print(data);
      print(response.body.toString());
      userDataMap = jsonDecode(response.body.toString());
      print("---Response Status Code "+response.statusCode.toString()+"---");
      if(response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, Routes.home);
        setState(() {
          isLoading=false;
        });
        print(response.body);
      } else {
        print("---else---");
        AwesomeDialog(context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: "",
            desc: userDataMap["status"],
            dismissOnTouchOutside: false,
            btnOkOnPress: () {
            }).show();
        print("---ERRO---");
        setState(() {
          isLoading=false;
        });
      }
    }).catchError((e){
      setState(() {
        isLoading=false;
      });
      print("---ERRO---");
      print("----- "+e+" -----");
    });
  }

}
