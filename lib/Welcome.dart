import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;



  @override
  void initState(){
    super.initState();
    controller=AnimationController(
        duration : Duration(seconds: 1),
        vsync: this
    );
    animation=CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    animation.addStatusListener((status) {
      if(status== AnimationStatus.completed){
        controller.reverse(from: 1.0);
      }
      else if(status==AnimationStatus.dismissed){
        controller.forward();
      }
    });
    controller.addListener(() { 
      setState(() {
        
      });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF111328).withOpacity(controller.value),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 260,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 14,
                  ),
                  Hero(tag: 'logo', child: Center(
                    child: Text('👻',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: animation.value*35,

                      ),
                    ),
                  ),),
                  SizedBox(
                    width: 11,
                  ),
                  TypewriterAnimatedTextKit(
                    isRepeatingAnimation: true,
                    speed: Duration(milliseconds: 200),
                    text: ['CONVOSPHERE'],
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Oregano',
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                //flex: 1,
                child: ElevatedButton(
                  child: Container(
                     height: 20,
                    width: 300,

                    child: Center(
                      child: Text('Log In',
                   style: TextStyle(
                       color: Colors.white,

                   ),
                  ),
                    ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEB1555),
                  ),
                  onPressed: (){
                     Navigator.pushNamed(context, 'LogIn');
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                //flex: 1,
                child: ElevatedButton(

                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEB1555),
                  ),
                  onPressed: (){
                     Navigator.pushNamed(context, 'Register');
                  },
                ),
              ),
              SizedBox(
                height: 360,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

