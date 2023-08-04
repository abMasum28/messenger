import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController? emailController;
  TextEditingController? passController;
  FirebaseAuth? auth;
  bool? showSpinner;
  bool? obscureText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController=TextEditingController();
    passController=TextEditingController();
    auth= FirebaseAuth.instance;
    showSpinner=false;
    obscureText=false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                child: Image.asset('assets/images/logo1.png'),
                height: 200,
              ),

              const SizedBox(height: 10.0,),
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                obscureText: true,
                controller: passController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  hintStyle: TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner=true;
                      });
                      if(emailController!.text.length>2&&passController!.text.length>5){
                        try{
                          final user = await auth!.createUserWithEmailAndPassword(
                              email: emailController!.text,
                              password: passController!.text);
                          if(user.user!.email==emailController!.text){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChatScreen()),
                            );
                          }

                        }
                        catch(error){
                          setState(() {
                            showSpinner=false;
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "Registration Failed",
                              desc: "Firebase Alert",
                            ).show();
                          });
                        }
                      }
                      else{
                        setState(() {
                          showSpinner=false;
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Registration Failed",
                            desc: "All fields are required",
                          ).show();
                        });
                      }


                    },
                    minWidth: 200,
                    height: 40,
                    child: Text('Register'),

                  ),
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }
}

