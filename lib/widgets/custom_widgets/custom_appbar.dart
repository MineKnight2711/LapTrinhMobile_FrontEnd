import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLeading;
  final VoidCallback onPressed;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Color? backGroundColor;
  const CustomAppBar(
      {super.key,
      this.title,
      this.showLeading = true,
      required this.onPressed,
      this.bottom,
      this.actions,
      this.backGroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backGroundColor ?? Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: showLeading
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: mainBottomNavColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_ios_outlined,
                      color: mainAppThemeColor),
                ),
              ),
            )
          : null,
      actions: actions,
      title: Text(
        title ?? "",
        style: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: mediaAspectRatio(context, 1 / 42),
          fontWeight: FontWeight.w400,
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
