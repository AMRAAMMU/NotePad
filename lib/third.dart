import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey=GlobalKey<FormState>();
  TextEditingController txt1=TextEditingController();
  TextEditingController txt2=TextEditingController();
  bool text=true;

  void _handleSignup() async{
    String email = txt1.text;
    String password = txt2.text;
    print('email: $email');
    print('password: $password');

    try{
      print('in signup');
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      print('in signup success');
      print('credintial = ${credential.additionalUserInfo}');
    }catch (e) {
      print('Firebase signup error = $e');
    }
  }

  void _handleSignIn() async{
    String email = txt1.text;
    String password = txt2.text;
    print('email: $email');
    print('password: $password');

    try{
      print('in sign in');
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      print('in sign in success');
      print('credintial = ${credential.additionalUserInfo}');
    }catch (e) {
      print(' sign in error = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width:250,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(250),
                    image: DecorationImage(fit: BoxFit.cover,
                        image: AssetImage('assets/img4.png')),
                    border: Border.all(width: 1.0,color: Colors.grey)
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 35,left: 10),
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1,color: Colors.deepPurple)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0,bottom: 5),
                child: TextFormField(
                  controller: txt1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.grey)
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25,left:10,),
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1,color: Colors.deepPurple)

              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0,bottom: 5),
                child: TextFormField(
                  controller: txt2,
                  obscureText: text,
                  obscuringCharacter: '.',
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            text=!text;
                          });
                        },
                        child: Icon(Icons.visibility),

                      )
                  ),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(left: 200),
            //   child: TextButton(
            //       onPressed: (){},
            //       child: Text('forgot password',style: TextStyle(color: Colors.blue),)
            //   ),
            // ),

            Container(
              margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),

              child: SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.withOpacity(0.6),
                    ),
                    onPressed: (){
                      if(txt1.text.isEmpty&&txt2.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(15),
                            content: Text('fill all the requirements')));
                      }else{
                        _handleSignup();
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Note_pad(
                        //     title: ' ',
                        //     subtitle: ' ',
                        //     body: ' ')));
                      }

                    },
                    child: Text('SIGNUP',style: TextStyle(color: Colors.white),)),
              ),
            ),
            Text('Already have an account?',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
            Container(
              margin: EdgeInsets.only(left: 10,top: 10),

              child: SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.withOpacity(0.6),
                    ),
                    onPressed: (){
                      _handleSignIn();
                      // if(txt1.text.isEmpty&&txt2.text.isEmpty){
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       behavior: SnackBarBehavior.floating,
                      //       margin: EdgeInsets.all(15),
                      //       content: Text('fill all the requirements')));
                      // }else{
                      //
                      //    Navigator.push(context, MaterialPageRoute(builder: (context)=>Note_pad(
                      //        title: ' ',
                      //        subtitle: ' ',
                      //        body: ' ')));
                      // }
                    },
                    child: Text('SIGNIN',style: TextStyle(color: Colors.white),)),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text('-or-'),
            SizedBox(
              height: 6,
            ),
            Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0.7,color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        image: DecorationImage(fit: BoxFit.fill,
                          image: AssetImage('assets/google.jpg'),
                        ),
                        color: Colors.white,

                      ),
                    ),
                    TextButton(onPressed: (){},
                        child: Text('SIGNUP WITH GOOGLE ACCONT',style: TextStyle(fontWeight: FontWeight.bold),))
                  ],
                )
            )

          ],
        ),
      ),
    );
  }
}