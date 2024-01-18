import 'package:flutter/material.dart';
import 'LogIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth=FirebaseAuth.instance;
  bool spinner=false;
  Color mail=inactive;
  Color mail2=inactive;
  TextEditingController search = TextEditingController();
  TextEditingController search2 = TextEditingController();
  String email='';
  String password='';
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print("Firebase initialized successfully");
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }
 @override
  void initState() {
    super.initState();
    initializeFirebase(); // Initialize Firebase when the widget is created
  }

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
                      onChanged: (value){
                         if(value.isNotEmpty){
                           setState(() {
                             mail=active;
                             mail2=inactive;
                           });
                         }
                         email=value;
                      },
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
                            mail= inactive;
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
                               'Register',
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
                          print(email);
                          print(password);
                          try{
                            final newuser= await _auth.createUserWithEmailAndPassword(email: email, password: password);
                            if(newuser!=null){
                              Navigator.pushNamed(context, 'chatScreen');
                            }
                            setState(() {
                              spinner=false;
                            });
                          }
                          catch(e){
                            print(e);
                          }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB1555),
                      ),
                    ),

                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
