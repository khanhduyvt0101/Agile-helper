// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:agile_helper/module/planning_poker/create_game/bloc/create_game_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/planning_poker/create_game_model.dart';
import '../bloc/create_game_bloc.dart';

class CustomDesk extends StatefulWidget {
  String token;
  CustomDesk(this.token, {Key key}) : super(key: key);

  @override
  State<CustomDesk> createState() => _CustomDeskState();
}

class _CustomDeskState extends State<CustomDesk> {
  CreateGameBloc _createGameBloc;
  String user;
  List<Map<String, dynamic>> _listDeskValue = [
    {'value': '1', 'active': false},
    {'value': '2', 'active': false},
    {'value': '3', 'active': false},
    {'value': '4', 'active': false},
    {'value': '5', 'active': false},
  ];

  String valueHint = '';

  final _deskNameController = TextEditingController();
  final _deskValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createGameBloc = BlocProvider.of<CreateGameBloc>(context);
    _deskValueController.addListener(() {
      _onChangeValue();
    });
    for (int i = 0; i < _listDeskValue.length; i++) {
      valueHint = valueHint + _listDeskValue[i]['value'] + ', ';
    }
    valueHint = valueHint.substring(0, valueHint.length - 2);
    _deskValueController.text = valueHint;
  }

  @override
  void dispose() {
    _deskNameController.dispose();
    _deskValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.only(
          left: PaddingConfig.paddingNormalW,
          top: PaddingConfig.paddingNormalH,
          bottom: PaddingConfig.paddingNormalH,
          right: PaddingConfig.paddingNormalW),
      child: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight * 5 / 6,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(
                    left: PaddingConfig.paddingSuperLargeW,
                    top: PaddingConfig.paddingLargeH,
                    bottom: PaddingConfig.paddingLargeH,
                    right: PaddingConfig.paddingSuperLargeW,
                  ),
                  color: AppColors.whiteBackground,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create a custom desk',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        children: [
                          _buildDeskNameInput(context),
                          _buildDeskValueInput(),
                        ],
                      ),
                      _buildTextBlock(context),
                      SizedBox(
                          height: ScreenUtil().screenHeight * 1 / 4,
                          child: _buildCardsBlock(_listDeskValue)),
                      SizedBox(
                        height: 2 * PaddingConfig.paddingNormalH,
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: PaddingConfig.paddingForBottomButtonH,
      color: AppColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              width: ScreenUtil().screenWidth / 2 -
                  2 * PaddingConfig.paddingSuperLargeW,
              height: PaddingConfig.paddingForBottomButtonH / 2,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.whiteBackground),
                  borderRadius:
                      BorderRadius.circular(PaddingConfig.cornerRadiusFrame)),
              child: Center(
                  child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: AppColors.whiteBackground,
                ),
              )),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              _createGameBloc.add(CreateGameCreateDeskEvent(
                  token: widget.token,
                  votingSystem: VotingSystem(
                      name: _deskNameController.text.trim().isNotEmpty
                          ? _deskNameController.text.trim()
                          : 'My desk',
                      cardValue: CardValue(listValue:
                          List<String>.from(_listDeskValue.map((element) {
                        return element['value'];
                      }))))));
            },
            child: Container(
              width: ScreenUtil().screenWidth / 2 -
                  2 * PaddingConfig.paddingSuperLargeW,
              height: PaddingConfig.paddingForBottomButtonH / 2,
              decoration: BoxDecoration(
                  color: AppColors.whiteBackground,
                  border: Border.all(color: AppColors.primary),
                  borderRadius:
                      BorderRadius.circular(PaddingConfig.cornerRadiusFrame)),
              child: Center(
                  child: Text(
                'Save desk',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: AppColors.primary,
                ),
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardsBlock(List<Map<String, dynamic>> listValue) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listValue.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              SizedBox(
                height: ScreenUtil().screenHeight * 1 / 5,
                child: InkWell(
                    onTap: () {
                      setState(() {
                        for (var i = 0; i < listValue.length; i++) {
                          if (i != index) {
                            listValue[i]['active'] = false;
                          }
                        }
                        listValue[index]['active'] = true;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CardGame(
                            value_cards:
                                listValue[index]['value'].toString().trim(),
                            active: listValue[index]['active'],
                            data: ''),
                        listValue[index]['active']
                            ? SizedBox(
                                height: PaddingConfig.paddingSuperLargeH,
                              )
                            : Container()
                      ],
                    )),
              ),
              SizedBox(
                width: PaddingConfig.paddingLargeW,
              )
            ],
          );
        });
  }

  Widget _buildTextBlock(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: PaddingConfig.paddingLargeH,
        ),
        Text(
          'This is a preview of how your desk will look like.',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildDeskNameInput(context) {
    return Container(
      padding: EdgeInsets.only(
          left: PaddingConfig.paddingLargeW,
          top: PaddingConfig.paddingLargeH,
          bottom: PaddingConfig.paddingNormalH,
          right: PaddingConfig.paddingNormalW),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/desk_name_input.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: TextFormField(
        controller: _deskNameController,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "My desk",
          hintStyle: TextStyle(
            color: AppColors.hintText,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
          errorStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: AppColors.danger,
          ),
        ),
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _buildDeskValueInput() {
    return Column(
      children: [
        SizedBox(
          height: PaddingConfig.paddingLargeH,
        ),
        Container(
          padding: EdgeInsets.only(
              left: PaddingConfig.paddingLargeW,
              top: PaddingConfig.paddingLargeH,
              bottom: PaddingConfig.paddingNormalH,
              right: PaddingConfig.paddingNormalW),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/desk_value_input.png'),
              fit: BoxFit.contain,
            ),
          ),
          child: TextFormField(
            controller: _deskValueController,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.danger,
              ),
            ),
            keyboardType: TextInputType.multiline,
            validator: (value) {
              if (value.isEmpty) {
                return "Required";
              } else {
                return null;
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/icon/exclamation.svg',
            ),
            SizedBox(
              width: PaddingConfig.paddingNormalW,
            ),
            Flexible(
              child: Text(
                'Enter up to 3 characters per value, separated by commas and not contain duplicated values.',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: AppColors.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onChangeValue() {
    setState(() {
      _listDeskValue = [];
      var deskValue = _deskValueController.text.split(',');
      for (var element in deskValue) {
        var index = element.trim();
        //Rule: The number of characters on a card cannot be more than 3
        if (index.length < 4) {
          _listDeskValue.add({'value': index.toString(), 'active': false});
        }
      }
      if (_listDeskValue[_listDeskValue.length - 1]['value']
          .toString()
          .isEmpty) {
        _listDeskValue.removeAt(_listDeskValue.length - 1);
      }
    });
  }
}
