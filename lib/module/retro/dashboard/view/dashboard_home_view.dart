import '../../../../data/repository/retro/dashboard_repository.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'action_item_list_view.dart';
import 'board_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/style.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/user/token_login.dart';

class DashBoardHomeViewArguments {
  final TokenLogin tokenLogin;

  DashBoardHomeViewArguments({this.tokenLogin});
}

class DashBoardHomeView extends StatefulWidget {
  final TokenLogin tokenLogin;
  const DashBoardHomeView({this.tokenLogin, Key key}) : super(key: key);

  @override
  State<DashBoardHomeView> createState() => _DashBoardHomeViewState();
}

class _DashBoardHomeViewState extends State<DashBoardHomeView> {
  DashBoardBloc _dashBoardBloc;

  @override
  void initState() {
    _dashBoardBloc = BlocProvider.of<DashBoardBloc>(context);
    _dashBoardBloc.dashboardRepository =
        DashboardRepository(token: widget.tokenLogin.token);
    _dashBoardBloc.add(GetCountBoardForDashboardEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarRetro(
          title: 'DashBoard',
          isLogo: true,
          userNameEncrypt: widget.tokenLogin.userNameEncrypt,
        ),
        body: Container(
            padding: EdgeInsets.only(
              left: PaddingConfig.paddingAppW,
              right: PaddingConfig.paddingAppW,
              top: PaddingConfig.paddingAppH,
            ),
            child: BlocBuilder(
                bloc: _dashBoardBloc,
                builder: (context, state) {
                  if (state is LoadedCountBoardForDashboardState) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: BoardType.values.length,
                        itemBuilder: (context, index) {
                          return CardHomeRetro(
                            tokenLogin: widget.tokenLogin,
                            title: BoardType.values[index],
                            countBoard: state.data[BoardType.values[index]]
                                .toString(), // todo: get countBoard from server
                          );
                        });
                  } else {
                    return const CustomLoadingWidget();
                  }
                })));
  }
}

class CardHomeRetro extends StatelessWidget {
  final TokenLogin tokenLogin;
  final BoardType title;
  final String countBoard;
  const CardHomeRetro({
    this.countBoard,
    this.title,
    this.tokenLogin,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _title;
    if (title == BoardType.Public) {
      _title = 'Public board';
    } else if (title == BoardType.Archived) {
      _title = 'Archived board';
    } else {
      _title = 'Action Item List';
    }
    return Container(
      margin: EdgeInsets.only(bottom: PaddingConfig.paddingSuperLargeH),
      child: ElevatedButton(
          onPressed: () async {
            if (title == BoardType.Public) {
              BlocProvider.of<DashBoardBloc>(context).add(
                LoadPublicBoardEvent(),
              );
              Navigator.pushNamed(context, ConfigRoutes.BOARD_VIEW,
                  arguments: BoardViewArguments(
                      tokenLogin: tokenLogin, boardType: BoardType.Public));
            } else if (title == BoardType.Archived) {
              BlocProvider.of<DashBoardBloc>(context).add(
                LoadArchivedBoardEvent(),
              );
              Navigator.pushNamed(context, ConfigRoutes.BOARD_VIEW,
                  arguments: BoardViewArguments(
                      tokenLogin: tokenLogin, boardType: BoardType.Archived));
            } else {
              BlocProvider.of<DashBoardBloc>(context).add(
                LoadListActionItemEvent(token: tokenLogin.token),
              );
              Navigator.pushNamed(context, ConfigRoutes.ACTION_ITEM_LIST_VIEW,
                  arguments:
                      ActionItemListViewArguments(tokenLogin: tokenLogin));
            }
          },
          child: Column(
            children: [
              Text(
                _title,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: PaddingConfig.paddingSuperLargeH,
              ),
              Text(
                countBoard + ' boards',
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          style: Style.buttonStyle().copyWith(
            padding: MaterialStateProperty.all(EdgeInsets.only(
                top: PaddingConfig.paddingSuperLargeH,
                bottom: PaddingConfig.paddingSuperLargeH)),
          )),
    );
  }
}
