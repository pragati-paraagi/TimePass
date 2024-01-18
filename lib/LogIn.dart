import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:timepass/chatScreen.dart';
const Color active=Colors.white38;
const Color inactive=Colors.white;

enum Count { email, password}

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _auth= FirebaseAuth.instance;
  String email='';
  String password='';
  TextEditingController search = TextEditingController();
  TextEditingController search2 = TextEditingController();
  Color mail=inactive;
  Color mail2=inactive;
  bool spinner=false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF111328),
        body: ModalProgressHUD(
          inAsyncCall: spinner,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Hero(
                  tag: 'logo',
                  child: Center(
                    child: Text('👻',
                     style: TextStyle(
                       fontSize: 60,
                       fontWeight: FontWeight.bold,
                     ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
                ElevatedButton(
                  child: Container(
                    width: 315,
                    height: 60,
                    child:TextField(
                        keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      controller: search,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            mail= active;
                            mail2 = inactive;
                          });
                        };
                        email=value;
                      }
                    ),
                  ),
                  onPressed: (){
                    setState(() {

                    });

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mail,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  child: Container(
                    width: 315,
                    height: 60,
                    child:TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      controller: search2,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            mail2 = active;
                            mail = inactive;
                          });
                        };
                        password=value;
                      }
                    ),
                  ),
                  onPressed: (){
                    setState(() {

                    });

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mail2,
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                Container(
                  child: ElevatedButton(
                    child: Container(
                      height: 60,
                      width: 315,
                      child: Center(
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        spinner=true;
                      });
                      try {
                            final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
                            final user = userCredential.user;

                            if (user != null) {
                              //Navigator.pushNamed(context, 'chatScreen');
                              Navigator.push((context),
                                MaterialPageRoute(builder: (context)=> ChatScreen(),
                                ),
                              );
                            }
                            else {
                              print('error');
                            }
                            setState(() {
                              spinner=false;
                            });
                      }
                      catch (e) {
                          print(e);
                      }
                      },


                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB1555),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
