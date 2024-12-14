import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purffectcare/modules/authentication/signup_screen.dart';
import '../../layout/user_layout.dart';
import '../../shared/component/componant.dart';
import '../../shared/network/local/CashHelper.dart';
import 'AuthenticationCubit/cubit.dart';
import 'AuthenticationCubit/state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            toastMesage(msg: "Successfully Login", state: ToastState.success);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeLayoutScreen()),
                (router) {
              return false;
            });
            CashHelper.putData(key: "isLogin", value: true);
          }
          if (state is LoginErrorState) {
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
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Welcome back",
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
                                      controller: emailController,
                                      function: (validate) {
                                        if (validate!.isEmpty) {
                                          return "Email can't be empty";
                                        }
                                        return null;
                                      },
                                      prefIcon: Icons.email_outlined,
                                      label: "Email",
                                      context: context,
                                    ),
                                    const SizedBox(height: 10),
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
                                              .userLogin(
                                                  email: emailController.text,
                                                  password:
                                                      passController.text);
                                        }
                                      },
                                      widget: state is LoginLoadingState
                                          ? const CircularProgressIndicator()
                                          : const Text("Login"),
                                    ),
                                    const SizedBox(height: 30),
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Don't have an account? ",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "Register!",
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
                                                          const SignUpScreen(),
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
