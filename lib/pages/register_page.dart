import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimalsocialmedia/components/my_button.dart';
import 'package:minimalsocialmedia/components/my_textfield.dart';
import 'package:minimalsocialmedia/helper/helper_fuction.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmController = TextEditingController();

  //register methode
  void registerUser() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ));
    //make sure password match
    if (passwordController.text != confirmController.text) {
      //pop loading Circle
      Navigator.pop(context);
      //show error message
      displayMessageToUser("Password don't match!", context);
    } else {
      //try creating the user now
      try {
        //create user
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        //create a user document and add to firestore
        createUserDocument(userCredential);

        //pop loading the circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //pop loading the circle
        Navigator.of(context);
        // display error message

        displayMessageToUser(e.code, context);
      }
    }
  }

  //create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': userController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.person,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(
              height: 20,
            ),

            //app name
            const Text('M I N I M A L', style: TextStyle(fontSize: 20)),

            const SizedBox(
              height: 50,
            ),
            // user textfield
            MyTextField(
              hintText: 'User Name',
              obsecureText: false,
              controller: userController,
            ),

            const SizedBox(
              height: 10,
            ),

            // email textfield
            MyTextField(
              hintText: 'Email',
              obsecureText: false,
              controller: emailController,
            ),

            const SizedBox(
              height: 10,
            ),

            //password textfield
            MyTextField(
                hintText: 'Password',
                controller: passwordController,
                obsecureText: true),

            const SizedBox(
              height: 10,
            ),

            // confirmpassword textfield
            MyTextField(
              hintText: 'Confirm Password',
              obsecureText: true,
              controller: confirmController,
            ),

            const SizedBox(
              height: 25,
            ),
            //forgot password

            //register button
            MyButton(
              text: 'Register',
              onTap: registerUser,
            ),

            const SizedBox(
              height: 25,
            ),

            //already have  account? Register here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have a account ?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Login Here',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
