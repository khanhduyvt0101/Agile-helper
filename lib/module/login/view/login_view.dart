import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common/config/config.dart';
import '../../../common/utils/widget/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../authentication/authentication_bloc/authentication_bloc.dart';
import '../../authentication/authentication_bloc/authentication_event.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final twoFAAuthController = TextEditingController();

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    userNameController.addListener(_onUserChange);
    passwordController.addListener(_onPasswordChange);
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    // twoFAAuthController.dispose();

    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<LoginBloc, LoginState>(listener: (context, state) {
          if (state.isServerWrong) {
            showDialog(
              context: context,
              builder: (_) => CustomDialog(
                title: 'Login failed',
                content: 'Server error',
                ok: 'Ok',
                onOk: () => Navigator.pop(context),
              ),
            );
          } else if (state.isFailure) {
            showDialog(
              context: context,
              builder: (_) => CustomDialog(
                title: 'Login failed',
                content: 'Incorrect email or password',
                ok: 'Ok',
                onOk: () => Navigator.pop(context),
              ),
            );
          }

          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(
              AuthenticationLoggedIn(tokenLogin: _loginBloc.state.tokenLogin),
            );

            Navigator.pushNamed(context, ConfigRoutes.HOME_VIEW);
          }
        }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          if (state.isSubmitting) {
            return const CustomLoadingWidget();
          }
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: PaddingConfig.paddingLargeW * 2,
                vertical: PaddingConfig.paddingNormalH),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: PaddingConfig.paddingLargeH),
                Container(
                    color: AppColors.whiteBackground,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight * 1 / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            color: AppColors.whiteBackground,
                            width: ScreenUtil().screenWidth,
                            height: ScreenUtil().screenHeight * 2 / 9,
                            child: SvgPicture.asset(
                              'assets/icon/logo.svg',
                            )),
                        Text(
                          'Agile Helper',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                Container(
                    color: AppColors.whiteBackground,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight * 0.4,
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextInputCustom(
                                hintText: "Username",
                                textController: userNameController,
                                obscureText: false,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "User name is required";
                                  }
                                  return null;
                                }),
                            TextInputCustom(
                                hintText: "Password",
                                textController: passwordController,
                                obscureText: true,
                                validator: (String value) {
                                  if (value.length < 6) {
                                    return "Enter at least 6 chars";
                                  }

                                  return null;
                                }),
                            TextInputCustom(
                                hintText: "2FA CODE",
                                textController: twoFAAuthController,
                                obscureText: false,
                                validator: (String value) {
                                  if (value.length < 6) {
                                    return "Enter at least 6 chars";
                                  }

                                  return null;
                                }),
                            SizedBox(height: PaddingConfig.paddingNormalH),
                            TextButtonFunction(
                                title: "Login",
                                onPressed: () => _onLoginPressed()),
                          ]),
                    ))
              ],
            ),
          );
        })));
  }

  void _onUserChange() {
    _loginBloc.add(LoginUserNameChange(userName: userNameController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: passwordController.text));
  }

  void _onLoginPressed() {
    setState(() {
      if (!_formKey.currentState.validate()) {
        return;
      }

      _formKey.currentState.save();
      _loginBloc.add(LoginWithCredentialsPressed(
          userName: userNameController.text,
          password: passwordController.text,
          twoFACode: twoFAAuthController.text));
    });
  }
}
