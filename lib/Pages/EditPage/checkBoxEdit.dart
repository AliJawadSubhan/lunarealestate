import 'dart:developer';

import 'package:floading/floading.dart';
import 'package:flutter/material.dart';

import '../../Service/backend.dart';
import '../../Widgets/Utils.dart';
import '../../Widgets/choiceTile.dart';
import '../../Widgets/customAppBar.dart';
import '../../Widgets/roundbutton.dart';

// ignore: must_be_immutable
class checkBoxEditPage extends StatefulWidget {
  String val1;
  String val2;
  String val;
  String column;
  String formid;
  String title;
  checkBoxEditPage({
    super.key,
    required this.val1,
    required this.val,
    required this.val2,
    required this.column,
    required this.formid,
    required this.title,
  });

  @override
  State<checkBoxEditPage> createState() => _checkBoxEditPageState();
}

class _checkBoxEditPageState extends State<checkBoxEditPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log(widget.val);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                opacity: 0.2,
                image: AssetImage(
                  'assets/images/tower.jpg',
                ),
                fit: BoxFit.cover,
              )),
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [CustomAppBar('Edit Property')];
              },
              body: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ChoiceTile(
                        y: widget.val == 'none'
                            ? false
                            : widget.val == 'true'
                                ? true
                                : false,
                        n: widget.val == 'none'
                            ? false
                            : widget.val == 'true'
                                ? false
                                : true,
                        index: '',
                        bgColor: Colors.white.withOpacity(0.4),
                        title: widget.title,
                        onChange1: (newVal) {
                          if (newVal!) {
                            setState(() {
                              widget.val = 'true';
                            });
                          } else {
                            setState(() {
                              widget.val = 'none';
                            });
                          }
                        },
                        onChange2: (newVal) {
                          if (newVal!) {
                            setState(() {
                              widget.val = 'false';
                            });
                          } else {
                            setState(() {
                              widget.val = 'none';
                            });
                          }
                          print(newVal);
                        },
                        box1: widget.val1,
                        box2: widget.val2),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  roundButton(
                    onClick: (() async {
                      FocusManager.instance.primaryFocus?.unfocus();

                      FLoading.show(
                        context,
                        loading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/icon.png",
                              width: 200,
                              height: 200,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            CircularProgressIndicator()
                          ],
                        ),
                        closable: false,
                        color: Colors.black.withOpacity(0.7),
                      );
                      var res = await backend().update({
                        'value': widget.val,
                        'column': widget.column,
                        'table': 'house_details',
                        'id': widget.formid,
                      });

                      if (res['status'] == 'success') {
                        debugPrint('success');
                        FLoading.hide();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context, 'success');
                      } else {
                        FLoading.hide();
                        debugPrint('fail');
                        // ignore: use_build_context_synchronously
                        Utils().showSnackbar(res['msg'], Colors.red, context);
                      }
                    }),
                    text: 'UPDATE',
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              )),
        ),
      ),
    );
  }
}
