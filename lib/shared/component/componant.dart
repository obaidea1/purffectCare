
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../modules/authentication/AuthenticationCubit/cubit.dart';

Widget defualtTextFormFiled({
  required TextEditingController controller,
  required String? Function(String?)? function,
  void Function(String?)? onSubmitted,
  required BuildContext context,
  String? label,
  TextInputType? type,
  IconData? prefIcon,
  bool? isAbscure,
  bool? isEnable,
}) =>
    TextFormField(
      controller: controller,
      validator: function,
      enabled: isEnable,
      style:  TextStyle(color: Colors.grey[600]),
      obscureText: isAbscure ?? false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(prefIcon),
        suffixIcon: isAbscure != null
            ? IconButton(
          icon: Icon(
              isAbscure ? Icons.lock_outline : Icons.lock_open_rounded),
          onPressed: () {
            AuthenticationCubit.get(context).changeAbscure();
          },
        )
            : null,
        label: Text(label ?? ""),
      ),
      onFieldSubmitted: onSubmitted,
      keyboardType: type ?? TextInputType.text,
    );

Widget defaultOutlinedButton({
  required BuildContext context,
  required void Function() function,
  required Widget widget,
}) =>
    SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: function,
        child: widget,
      ),
    );
Future<bool?> toastMesage({
  required String? msg,
  required ToastState state,
}) {
  return Fluttertoast.showToast(
      msg: msg!,
      backgroundColor: selectColor(state),
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
      toastLength: Toast.LENGTH_SHORT);
}

enum ToastState {
  success,
  warning,
  error,
}

Color selectColor(ToastState toastState) {
  Color color;
  switch (toastState) {
    case ToastState.success:
      color = Colors.green;
      break;
    case ToastState.warning:
      color = Colors.yellowAccent;
      break;
    case ToastState.error:
      color = Colors.red;
      break;
  }
  return color;
}
Widget articleBuilder({
  required String img,
  required String title,
}) => Card(
  elevation: 5,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  clipBehavior: Clip.antiAlias,
  margin: EdgeInsets.zero, // Remove margin
  child: Stack(
    children: [
      Image.network(
        img,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.white.withOpacity(0.8), // Optional to enhance readability
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey, // Set to white for better contrast
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    ],
  ),
);

Widget buildProductCard(String title, String imagePath) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Container(
      width: 120,
      child: Column(
        children: [
          Image.asset(imagePath, height: 80, width: 80, fit: BoxFit.cover),
          SizedBox(height: 10),
          Text(title, style: GoogleFonts.poppins(fontSize: 14)),
        ],
      ),
    ),
  );
}
