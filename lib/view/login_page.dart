import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gems_pay/service/fire_auth_service.dart';
import 'package:gems_pay/view/home_page.dart';
import 'package:gems_pay/view/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageScreen();
}

class _LoginPageScreen extends State<LoginPage> {
  FireAuth fireAuth = FireAuth();
  bool isLoading = false;
  late bool _isObscured = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isObscured;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 80),
              child: const Center(
                child: Text(
                  "Welcome Back!",
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
                // icon: Icon(Icons.email),
                prefixIcon: IconButton(
                  onPressed: () {},
                  // icon: const Icon(Icons.email_rounded),
                  icon: const Icon(Icons.person),
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
            Container(
              margin: const EdgeInsets.all(5),
              height: 53,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    FireAuth.signInUsingEmailPassword(context,
                        email: emailController.text,
                        password: passwordController.text);
                  });

                  Future.delayed(
                    const Duration(seconds: 5),
                        () {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  );
                },

                //From Here
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  ' Login',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white),
                ),
                //To here
              ),
            ),

            const SizedBox(height: 30),
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
                  "Or login with",
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
              height: 10,
            ),

            Container(
              margin: const EdgeInsets.all(5),
              height: 53,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(


                onPressed: () async {
                  // setState(() {
                  //   _isSigningIn = true;
                  // });
                  isLoading = true;
                  User? user =
                  await fireAuth.signInWithGoogle(context);

                  // setState(() {
                  //   _isSigningIn = false;
                  // });

                  if (user != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            FinanceTrackerHomePage(
                              user: user,
                            ),
                      ),
                    );
                  }
                },

                //From Here
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blue,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  ' Login with Google',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                    fontSize: 18,

                       ),
                ),
                //To here
              ),
            ),
            const SizedBox(height: 8),


            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RegisterPage(),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ],),),


          ],
        ),
      ),
    );
  }
}
