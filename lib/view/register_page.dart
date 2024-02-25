import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gems_pay/service/fire_auth_service.dart';

import 'home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _SignUp();
}

class _SignUp extends State<RegisterPage> {
  final FireAuth fireAuth = FireAuth();
  final _formKey = GlobalKey<FormState>();
  late bool _isObscured = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isObscured;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()))),
        backgroundColor: Colors.white,
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
                    child: const Center(
                      child: Text(
                        "Gems Finance!",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),


                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Column(
                        children: [
                          TextFormField(

                            controller: nameController,

                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 12.0),
                              // icon: Icon(Icons.email),
                              prefixIcon: IconButton(
                                onPressed: () {},
                                // icon: const Icon(Icons.email_rounded),
                                icon: const Icon(Icons.person),
                              ),
                              hintText: 'Name here',
                              filled: true,
                              fillColor: Colors.black12,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height:15),
                          TextFormField(

                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email cannot be empty';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,5}')
                                  .hasMatch(value!)) {
                                return 'Invalid email';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 12.0),

                              prefixIcon: IconButton(
                                onPressed: () {},
                                // icon: const Icon(Icons.email_rounded),
                                icon: const Icon(Icons.email),
                              ),
                              hintText: 'Email here',
                              filled: true,
                              fillColor: Colors.black12,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: _isObscured,
                            controller: passwordController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 12.0),

                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.password_sharp),
                              ),
                              hintText: 'Password here',
                              filled: true,
                              suffixIcon: IconButton(
                                padding:
                                const EdgeInsetsDirectional.only(end: 12.0),
                                icon: _isObscured
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                        () {
                                      _isObscured = !_isObscured;
                                    },
                                  );
                                },
                              ),
                              fillColor: Colors.black12,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],),),



                  SizedBox(
                    height: 53,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;

                          FireAuth.registerUsingEmailPassword(
                              context: context,
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text);
                        });

                        Future.delayed(const Duration(seconds: 4), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },

                      //From Here
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),

                      //To here
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                            indent: 20,
                            endIndent: 20,
                            thickness: 2,
                            color: Colors.black38),
                      ),
                      Text(
                        "Or Sign Up with",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                      ),
                      Expanded(
                        child: Divider(
                            indent: 20,
                            endIndent: 20,
                            thickness: 2,
                            color: Colors.black38),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  SizedBox(
                    height: 53,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        // setState(() {
                        //   _isSigningIn = true;
                        // });

                        User? user = await fireAuth.signInWithGoogle(context);

                        // setState(() {
                        //   _isSigningIn = false;
                        // });

                        if (user != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => FinanceTrackerHomePage(
                                user: user,
                              ),
                            ),
                          );
                        }
                      },

                      //From Here
                      style: ElevatedButton.styleFrom(
                          // primary: Colors.black,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Sign up with google',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),

                      //To here
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              )),
        ]),
      ),
    );
  }
}
