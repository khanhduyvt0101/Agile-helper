import '../../authentication/authentication_bloc/authentication_bloc.dart';
import '../../planning_poker/home/view/planning_poker_home_view.dart';
import '../../retro/home/view/retro_home_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common/config/config.dart';
import '../../../common/utils/widget/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../authentication/authentication_bloc/authentication_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthenticationBloc _authenticationBloc;
  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: ScreenUtil().screenHeight,
        margin: EdgeInsets.symmetric(
            horizontal: PaddingConfig.paddingLargeW * 2,
            vertical: PaddingConfig.paddingNormalH),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (context, state) {
            if (state is IsAuthenticationTokenExpired ||
                state is AuthenticationSuccess) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  SizedBox(height: PaddingConfig.paddingLargeH),
                  Container(
                    color: AppColors.whiteBackground,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight * 2 / 9,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButtonFunction(
                              title: "Planning Poker",
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ConfigRoutes.PLANNING_POKER_HOME,
                                    arguments: PlanningPokerHomeViewArguments(
                                        tokenLogin: state.tokenLogin));
                              }),
                          TextButtonFunction(
                              title: "Online Retro",
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ConfigRoutes.RETRO_HOME_VIEW,
                                    arguments: RetroHomeViewArguments(
                                        tokenLogin: state.tokenLogin));
                              })
                        ]),
                  ),
                  SizedBox(height: 5 * PaddingConfig.paddingLargeH),
                  Flexible(
                      child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => const DialogLogout());
                    },
                    child: CircleAvatarCustom(
                      userNameEncrypt: state.tokenLogin.userNameEncrypt,
                    ),
                  )),
                ],
              );
            }
            return const CustomLoadingWidget();
          },
        ),
      ),
    ));
  }
}
