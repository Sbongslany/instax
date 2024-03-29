import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../components/strings.dart';
import '../../components/textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String? _erroMsg;
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signInRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if(state is SignInSuccess){
          setState(() {
            signInRequired = false;
          });
        } else if(state is SignInprocess){
          setState(() {
            signInRequired = true;
          });
        } else if(state is SignInFailure){
          setState(() {
            signInRequired = false;
            _erroMsg = 'Invalid email or password';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  errorMsg: _erroMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill this field';
                    } else if (!emailRexExp.hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                onChanged: (val) {
                  if (val!.contains(RegExp(r'[A-Z]'))) {
                    setState(() {
                      containsUpperCase = true;
                    });
                  } else {
                    setState(() {
                      containsUpperCase = false;
                    });
                  }

                  if (val!.contains(RegExp(r'[a-z]'))) {
                    setState(() {
                      containsLowerCase = true;
                    });
                  } else {
                    setState(() {
                      containsLowerCase = false;
                    });
                  }

                  if (val!.contains(RegExp(r'[0-9]'))) {
                    setState(() {
                      containsNumber = true;
                    });
                  } else {
                    setState(() {
                      containsNumber = false;
                    });
                  }

                  if (val!.contains(specialCharRexExp)) {
                    setState(() {
                      containsSpecialChar = true;
                    });
                  } else {
                    setState(() {
                      containsSpecialChar = false;
                    });
                  }

                  if (val.length >= 8) {
                    setState(() {
                      contains8Length = true;
                    });
                  } else {
                    setState(() {
                      contains8Length = false;
                    });
                  }
                  return null;
                },
                errorMsg: _erroMsg,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                      if (obscurePassword) {
                        iconPassword = CupertinoIcons.eye_fill;
                      } else {
                        iconPassword = CupertinoIcons.eye_slash_fill;
                      }
                    });
                  },
                  icon: Icon(iconPassword),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill this field';
                  } else if (!passwordRexExp.hasMatch(val)) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '. 1 Uppercase',
                      style: TextStyle(
                          color: containsUpperCase
                              ? Colors.green
                              : Theme.of(context).colorScheme.onBackground),
                    ),
                    Text(
                      '. 1 Lowercase',
                      style: TextStyle(
                          color: containsLowerCase
                              ? Colors.green
                              : Theme.of(context).colorScheme.onBackground),
                    ),
                    Text(
                      '. 1 Number',
                      style: TextStyle(
                          color: containsNumber
                              ? Colors.green
                              : Theme.of(context).colorScheme.onBackground),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '. 1 Special character',
                      style: TextStyle(
                          color: containsSpecialChar
                              ? Colors.green
                              : Theme.of(context).colorScheme.onBackground),
                    ),
                    Text(
                      '. 8 Minimum character',
                      style: TextStyle(
                          color: contains8Length
                              ? Colors.green
                              : Theme.of(context).colorScheme.onBackground),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(CupertinoIcons.person_fill),
                  errorMsg: _erroMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill this field';
                    } else if (val.length > 30) {
                      return 'Name too long';
                    }
                    return null;
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            !signInRequired
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          MyUser myUser = MyUser.empty;
                          myUser = myUser.copyWith(
                              email: emailController.text,
                              name: nameController.text);

                          setState(() {
                            context.read<SignUpBloc>().add(SignUpRequired(
                                  myUser,
                                  passwordController.text,
                                ));
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                          elevation: 3.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60))),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(backgroundColor: Colors.black,)
          ],
        ),
      ),
    );
  }
}
