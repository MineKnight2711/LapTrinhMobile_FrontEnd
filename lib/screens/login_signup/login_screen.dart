// ignore_for_file: use_build_context_synchronously

// import 'package:app_settings/app_settings.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';
import 'package:keyboard_mobile_app/controller/login_controller.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/screens/login_signup/register_screen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/centered_text_with_linebar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_input.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

import '../../api/fingerprint_api/local_auth_api.dart';
import '../../controller/order_controller.dart';
import '../../widgets/custom_widgets/forgot_password_alertdialog.dart';
import 'complete_register_with_google.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginController = Get.find<LoginController>();
  final accountApi = Get.find<AccountApi>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        title: 'Đăng nhập',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              SizedBox(
                height: size.height / 25,
              ),
              Container(
                width: size.height / 2.7,
                height: size.height / 6.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/images/login.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: size.height / 20),
              CustomInputTextField(
                onChanged: loginController.validateEmail,
                controller: loginController.emailController,
                labelText: 'Email',
                hintText: 'Nhập email...',
              ),
              SizedBox(
                height: size.height / 60,
              ),
              CustomPasswordTextfield(
                onChanged: loginController.validatePassword,
                controller: loginController.passwordController,
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu...',
              ),
              SizedBox(
                height: size.height / 40,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width / 1.45,
                    child: Obx(
                      () => DefaultButton(
                          enabled: loginController.isValidEmail.value &&
                              loginController.isValidPassword.value,
                          press: () async {
                            String result = await loginController.logIn(
                                loginController.emailController.text,
                                loginController.passwordController.text);
                            if (result == 'Success') {
                              CustomSuccessMessage.showMessage(result);
                              loginController.onClose();
                              replaceFadeInTransition(context, HomeScreen());
                              Get.put(OrderController());
                            } else {
                              CustomSnackBar.showCustomSnackBar(
                                  context, result, 3,
                                  backgroundColor: mainErrorColor);
                              loginController.onClose();
                              return;
                            }
                          },
                          text: 'Đăng nhập'),
                    ),
                  ),
                  const Spacer(),
                  CircleIconButton(
                    icon: Icons.fingerprint,
                    onPressed: () async {
                      if (accountApi.enableFingerprint.value) {
                        final isAuthenticated =
                            await LocalAuthApi.authenticate();
                        if (isAuthenticated == 'Success') {
                          final result = await loginController
                              .authenticatedWithFingerPrint();
                          switch (result) {
                            case 'Success':
                              CustomSuccessMessage.showMessage(
                                  'Xác thực thành công!');
                              await accountApi.fetchCurrent();
                              replaceFadeInTransition(context, HomeScreen());
                              Get.put(OrderController());
                              break;
                            case 'NotFound':
                              CustomErrorMessage.showMessage(
                                  'Không tìm thấy tài khoản!');
                              break;
                            default:
                              break;
                          }
                        } else if (isAuthenticated == 'BiometricsNotEnable') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                onPressed: () {
                                  AppSettings.openSecuritySettings();
                                  Navigator.pop(context);
                                  // AppSettings.openAppSettings(
                                  //     type: AppSettingsType.security);
                                },
                                content:
                                    "Bạn chưa kích hoạt sinh trắc học trên thiết bị này!\nVui lòng kích hoạt bằng cách vào Cài đặt->Bảo mật->Sinh trắc học",
                                title: 'Lỗi',
                              );
                            },
                          );
                          return;
                        } else {
                          CustomErrorMessage.showMessage(
                              'Điện thoại của bạn chưa hỗ trợ  sinh trắc học!');
                          return;
                        }
                      } else {
                        CustomErrorMessage.showMessage(
                            'Vui lòng đăng nhập để bật tính năng này!');
                        return;
                      }
                    },
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const CenteredTextWithLineBars(
                  text: 'hoặc',
                  textFlex: 1,
                ),
              ),
              LoginWithSocialButton(
                  onPressed: () async {
                    final result = await loginController.signInWithGoogle();
                    switch (result) {
                      case 'SigninSuccess':
                        CustomSuccessMessage.showMessage(
                            'Đăng ký thành công!\nCòn 1 bước nữa...');
                        slideInTransitionReplacement(
                            context, SignUpGoogleCompletedScreen());
                        break;
                      case 'LoginSuccess':
                        CustomSuccessMessage.showMessage(
                                'Đăng nhập thành công!')
                            .whenComplete(() {
                          Get.put(OrderController());
                        });
                        replaceFadeInTransition(context, HomeScreen());
                        break;

                      case 'CancelSignIn':
                        CustomSuccessMessage.showMessage('Đã huỷ đăng nhập!');
                        break;

                      default:
                        CustomErrorMessage.showMessage('Đăng nhập thất bại!');
                        break;
                    }
                  },
                  buttonText: 'Tiếp tục với Google',
                  buttonIconAssets: 'assets/icons/google.png'),
              SizedBox(
                height: size.height / 25,
              ),
              RichText(
                text: TextSpan(
                  text: 'Bạn chưa có tài khoản? ',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'Đăng ký',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          slideInTransition(context, RegisterScreen());
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PasswordRecoveryDialog();
                        },
                      );
                    },
                    child: Text(
                      'Quên mật khẩu',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
