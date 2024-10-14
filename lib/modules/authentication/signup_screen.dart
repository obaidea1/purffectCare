
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/componant.dart';
import 'AuthenticationCubit/cubit.dart';
import 'AuthenticationCubit/state.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
     var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            toastMesage(
                msg: "Successfully Register", state: ToastState.success);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (router) => false);
          }
          if (state is RegisterErrorState) {
            toastMesage(msg: state.error, state: ToastState.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Image(
                              image: AssetImage(
                                "assets/images/purffectCare.png",
                              ),
                              height: 200,
                              width: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Welcome to chatty",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            child: Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    defualtTextFormFiled(
                                      controller: nameController,
                                      function: (validate) {
                                        if (validate!.isEmpty) {
                                          return "Name can't be empty";
                                        }
                                        return null;
                                      },
                                      prefIcon: Icons.person_outline,
                                      type: TextInputType.text,
                                      label: "Name",
                                      context: context,
                                    ),
                                    const SizedBox(height: 10),
                                    defualtTextFormFiled(
                                      controller: emailController,
                                      function: (validate) {
                                        if (validate!.isEmpty) {
                                          return "Email can't be empty";
                                        }
                                        return null;
                                      },
                                      prefIcon: Icons.email_outlined,
                                      type: TextInputType.emailAddress,
                                      label: "Email",
                                      context: context,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    defualtTextFormFiled(
                                      controller: phoneController,
                                      function: (validate) {
                                        if (validate!.isEmpty) {
                                          return "Phone can't be empty";
                                        }
                                        return null;
                                      },
                                      prefIcon: Icons.phone_android_outlined,
                                      type: TextInputType.phone,
                                      label: "Phone",
                                      context: context,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    defualtTextFormFiled(
                                      controller: passController,
                                      function: (validate) {
                                        if (validate!.isEmpty) {
                                          return "Password can't be empty";
                                        }
                                        return null;
                                      },
                                      prefIcon: Icons.lock,
                                      label: "Password",
                                      isAbscure:
                                          AuthenticationCubit.get(context)
                                              .isAbscure,
                                      context: context,
                                    ),
                                    const SizedBox(height: 40),
                                    defaultOutlinedButton(
                                      context: context,
                                      function: () {
                                        if (formKey.currentState!.validate()) {
                                          AuthenticationCubit.get(context)
                                              .userRegister(
                                            email: emailController.text,
                                            password: passController.text,
                                            name: nameController.text,
                                            phone: phoneController.text,
                                          );
                                        }
                                      },
                                      widget: state is RegisterLoadingState
                                          ? const CircularProgressIndicator()
                                          : const Text("Register"),
                                    ),
                                    const SizedBox(height: 30),
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Already have account? ",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "Login!",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen(),
                                                    ),
                                                  );
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(), // This will push the content up when there's extra space
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
