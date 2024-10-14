import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/component/componant.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/state.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is GetUserDataSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var formKey = GlobalKey<FormState>();
        var cubit = AppCubit.get(context);
        TextEditingController _name = TextEditingController();
        _name.text = cubit.userModel.name!;
        TextEditingController _phone = TextEditingController();
        _phone.text = cubit.userModel.phone!;
        TextEditingController _bio = TextEditingController();
        _bio.text = cubit.userModel.bio!;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Edit Profile"),
            actions: [
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    cubit.updateUserData(
                        name: _name.text, bio: _bio.text, phone: _phone.text);
                  }
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is UpdateUserDataLoadingState)
                    const LinearProgressIndicator(),
                  if (state is UpdateUserDataLoadingState)
                    const SizedBox(
                      height: 10,
                    ),
                  SizedBox(
                    height: 230,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 170,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      cubit.coverImage.isEmpty
                                          ? "${cubit.userModel.coverImage}"
                                          : cubit.coverImage,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  cubit.changeCoverImage();
                                },
                                child: const CircleAvatar(
                                  radius: 13,
                                  child: Icon(Icons.edit_rounded),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  cubit.profileImage.isEmpty
                                      ? "${cubit.userModel.image}"
                                      : cubit.profileImage,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  cubit.changeImage();
                                },
                                child: const CircleAvatar(
                                  radius: 13,
                                  child: Icon(Icons.edit_rounded),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defualtTextFormFiled(
                      controller: _name,
                      function: (String? value) {
                        if (value!.isEmpty) {
                          return "the name should not be empty";
                        }
                        return null;
                      },
                      context: context,
                      label: "Name",
                      prefIcon: Icons.person_outline),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defualtTextFormFiled(
                      controller: _bio,
                      function: (String? value) {
                        if (value!.isEmpty) {
                          return "your bio should not be empty";
                        }
                        return null;
                      },
                      context: context,
                      label: "Bio",
                      prefIcon: Icons.description_outlined),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defualtTextFormFiled(
                      controller: _phone,
                      function: (String? value) {
                        if (value!.isEmpty) {
                          return "you should put your number";
                        }
                        return null;
                      },
                      context: context,
                      label: "Phone",
                      prefIcon: Icons.phone),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
