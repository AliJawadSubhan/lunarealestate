// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:floading/floading.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lunarestate/Pages/EditPage/checkBoxEdit.dart';
import 'package:lunarestate/Pages/EditPage/textEdit.dart';
import 'package:lunarestate/Service/backend.dart';
import 'package:rxdart/rxdart.dart';

import '../../Widgets/Utils.dart';
import '../../Widgets/customAppBar.dart';
import '../Gallery/ImageView.dart';
import 'package:page_transition/page_transition.dart';

StreamController _houseDetail = BehaviorSubject();

getData(String formId) async {
  // add error to show loading progress
  _houseDetail.addError('loading');
  log('calling data');
  var res = await backend().fetchFullPropertyDetails(formId);
  _houseDetail.add(res);
}

class FullDetail extends StatelessWidget {
  String from;

  String formId;
  FullDetail({super.key, required this.formId, required this.from});
  final List<String> imgList = [];
  getImages() async {
    var res = await backend().fetchPropertyImages(formId);
    if (res != null)
      for (var i = 0; i < res.length; i++) {
        log('image $i');
        imgList.add(res[i]['gallery']);
      }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getData(formId);
    return Scaffold(
      body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CustomAppBar('My House'),
            ];
          },
          physics: NeverScrollableScrollPhysics(),
          body: Container(
            child: Column(
              children: [
                FutureBuilder(
                    future: getImages(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());

                        default:
                          if (snapshot.hasError) {
                            return Text('Error');
                            // ignore: prefer_is_empty
                          } else if (imgList.length >= 1) {
                            return CarouselSlider(
                                options: CarouselOptions(),
                                items: imgList
                                    .map((item) => GestureDetector(
                                          onDoubleTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: ImageView(url: item),
                                                    type: PageTransitionType
                                                        .fade));
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.30,
                                            width: double.infinity,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: item,
                                                  width: double.infinity,
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList());
                          }
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.30,
                            width: double.infinity,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Image.asset(
                                  'assets/icons/defaultHouse.png',
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          );
                      }
                    }),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                        child: Text(
                      'Propert Details:',
                      style: TextStyle(fontSize: 18, color: Colors.amber),
                    )),
                  ),
                  width: size.width,
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<dynamic>(
                    stream: _houseDetail.stream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Expanded(
                              child: ListView(
                                children: [
                                  ListCard(
                                    title: 'Title:',
                                    val: snapshot.data[0]['title'],
                                    type: 'text',
                                    column: 'title',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                    title: 'Address:',
                                    val: snapshot.data[0]['location'],
                                    type: 'text',
                                    column: 'location',
                                    formId: formId,
                                    from: from,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      height: 70,
                                      child: Card(
                                        color: Colors.black.withOpacity(0.5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Date:',
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text(
                                                    snapshot.data[0]['date'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 14.0),
                                                child: Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.amber,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListCard(
                                    title: 'Name:',
                                    val: snapshot.data[0]['ownerName'],
                                    type: 'text',
                                    column: 'location',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                    title: 'Bedrooms',
                                    type: 'text',
                                    val: snapshot.data[0]['bedrooms'],
                                    column: 'bedrooms',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                    title: 'Bathrooms:',
                                    val: snapshot.data[0]['bathrooms'],
                                    type: 'text',
                                    column: 'bathrooms',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                    title: 'Stories:',
                                    val: snapshot.data[0]['stories'],
                                    type: 'text',
                                    column: 'stories',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                    title: 'Lot Size:',
                                    val: snapshot.data[0]['areaSize'],
                                    type: 'text',
                                    column: 'areaSize',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                    title: 'Square Footage:',
                                    val: snapshot.data[0]['squarefootage'],
                                    type: 'text',
                                    column: 'squarefootage',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                    title: 'Existing Moragage:',
                                    val: snapshot.data[0]['existingMorgage'],
                                    type: 'checkbox',
                                    column: 'existingMorgage',
                                    formId: formId,
                                    from: from,
                                    box1: 'Yes',
                                    box2: 'No',
                                  ),
                                  ListCard(
                                    title: 'Survey:',
                                    val: snapshot.data[0]['survery'],
                                    type: 'checkbox',
                                    column: 'survery',
                                    formId: formId,
                                    from: from,
                                    box1: 'Yes',
                                    box2: 'No',
                                  ),
                                  ListCard(
                                    title: 'Washer:',
                                    val: snapshot.data[0]['washer'],
                                    type: 'checkbox',
                                    column: 'washer',
                                    formId: formId,
                                    from: from,
                                    box1: 'Yes',
                                    box2: 'No',
                                  ),
                                  ListCard(
                                    title: 'Dryer:',
                                    val: snapshot.data[0]['dryer'],
                                    type: 'checkbox',
                                    column: 'dryer',
                                    formId: formId,
                                    from: from,
                                    box1: 'Yes',
                                    box2: 'No',
                                  ),
                                  ListCard(
                                    title: 'Range:',
                                    val: snapshot.data[0]['userRange'],
                                    type: 'checkbox',
                                    column: 'userRange',
                                    formId: formId,
                                    from: from,
                                    box1: 'Electric',
                                    box2: 'Gas',
                                  ),
                                  ListCard(
                                    title: 'Gas utility availble?:',
                                    val: snapshot.data[0]['gasUtilityavail'],
                                    type: 'checkbox',
                                    column: 'gasUtilityavail',
                                    formId: formId,
                                    from: from,
                                    box1: 'Yes',
                                    box2: 'No',
                                  ),
                                  ListCard(
                                      title: 'Water on?:',
                                      val: snapshot.data[0]['waterOn'],
                                      type: 'checkbox',
                                      column: 'waterOn',
                                      formId: formId,
                                      from: from,
                                      box1: 'City',
                                      box2: 'Well'),
                                  ListCard(
                                      title: 'Sewer:',
                                      val: snapshot.data[0]['sewer'],
                                      type: 'checkbox',
                                      column: 'sewer',
                                      formId: formId,
                                      from: from,
                                      box1: 'City',
                                      box2: 'Septic'),
                                  ListCard(
                                      title: 'Backed tax owed?:',
                                      val: snapshot.data[0]['backedTaxowed'],
                                      type: 'checkbox',
                                      column: 'backedTaxowed',
                                      formId: formId,
                                      from: from,
                                      box1: 'Yes',
                                      box2: 'No'),
                                  ListCard(
                                      title: 'Leins on property?:',
                                      val: snapshot.data[0]['lop'],
                                      type: 'checkbox',
                                      column: 'lop',
                                      formId: formId,
                                      from: from,
                                      box1: 'Yes',
                                      box2: 'No'),
                                  ListCard(
                                      title: 'Is property?:',
                                      val: snapshot.data[0]['isProp'],
                                      type: 'checkbox',
                                      column: 'isProp',
                                      formId: formId,
                                      from: from,
                                      box1: 'vecant',
                                      box2: 'occupied'),
                                  ListCard(
                                      title:
                                          'Is there a lockbox for inspections?:',
                                      val: snapshot.data[0]['lockbox'],
                                      type: 'checkbox',
                                      column: 'lockbox',
                                      formId: formId,
                                      from: from,
                                      box1: 'Yes',
                                      box2: 'No'),
                                  ListCard(
                                      title: 'Open to owner financed?:',
                                      val: snapshot.data[0]['owfinance'],
                                      type: 'checkbox',
                                      column: 'owfinance',
                                      formId: formId,
                                      from: from,
                                      box1: 'Yes',
                                      box2: 'No'),
                                  ListCard(
                                    title:
                                        'Are you looking for a new primary home after selling current home?:',
                                    val: snapshot.data[0]['newHome'],
                                    column: 'newHome',
                                    type: 'checkbox',
                                    box1: 'Yes',
                                    box2: 'No',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                    title:
                                        'Do you need assistance finding a new home?:',
                                    val: snapshot.data[0]['assiteNewHome'],
                                    type: 'checkbox',
                                    column: 'assiteNewHome',
                                    box1: 'Yes',
                                    box2: 'No',
                                    formId: formId,
                                    from: from,
                                  ),
                                  ListCard(
                                      title:
                                          'Do you need help finding a morgage lender if your selling?:',
                                      val: snapshot.data[0]['helpmorgage'],
                                      type: 'checkbox',
                                      column: 'helpmorgage',
                                      formId: formId,
                                      from: from,
                                      box1: 'Yes',
                                      box2: 'No'),
                                  ListCard(
                                      title: 'Foundation:',
                                      val: snapshot.data[0]['foundation'],
                                      type: 'checkbox',
                                      column: 'foundation',
                                      formId: formId,
                                      from: from,
                                      box1: 'pier & beam',
                                      box2: 'slab'),
                                  ListCard(
                                      title: 'Have Basement:',
                                      val: snapshot.data[0]['basement'],
                                      type: 'checkbox',
                                      column: 'basement',
                                      formId: formId,
                                      from: from,
                                      box1: 'Yes',
                                      box2: 'No'),
                                ],
                              ),
                            );
                          }
                      }
                    }),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
        ),
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
      ),
      bottomNavigationBar: from == 'admin'
          ? Container(
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              headerAnimationLoop: false,
                              animType: AnimType.topSlide,
                              title: 'Purchased Property',
                              desc: 'do you want to mark this as purchased?',
                              btnCancelOnPress: () {},
                              onDismissCallback: (type) {
                                debugPrint(
                                    'Dialog Dismiss from callback $type');
                              },
                              btnOkText: 'Yes',
                              btnOkOnPress: () async {
                                var res = await backend().update({
                                  'value': '3',
                                  'column': 'detailType',
                                  'table': 'house_details',
                                  'id': formId,
                                });

                                if (res['status'] == 'success') {
                                  debugPrint('success');
                                  FLoading.hide();
                                  Navigator.pop(context, 'success');
                                } else {
                                  FLoading.hide();
                                  debugPrint('fail');
                                  Utils().showSnackbar(
                                      res['msg'], Colors.red, context);
                                }
                              }).show();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Purchased'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              headerAnimationLoop: false,
                              animType: AnimType.topSlide,
                              title: 'Delete Property',
                              desc: 'do you want to delete this property?',
                              btnCancelOnPress: () {},
                              onDismissCallback: (type) {
                                debugPrint(
                                    'Dialog Dismiss from callback $type');
                              },
                              btnOkText: 'Yes',
                              btnOkOnPress: () async {
                                FLoading.show(
                                  context,
                                  loading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                var res = await backend().deleteProperty({
                                  'formid': formId,
                                });

                                if (res['status'] == 'success') {
                                  FLoading.hide();
                                  Navigator.pop(context, 'success');
                                }
                              }).show();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete'),
                      ),
                    ),
                  ),
                ],
              ),
              height: 60,
              width: double.infinity,
            )
          : SizedBox.shrink(),
    );
  }
}

class ListCard extends StatelessWidget {
  String title;
  String val;
  String column;
  String formId;
  String type;
  String from;
  String? box1, box2;
  ListCard({
    Key? key,
    required this.title,
    required this.val,
    required this.type,
    required this.column,
    required this.formId,
    required this.from,
    this.box1,
    this.box2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        child: Card(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      (type == 'checkbox'
                          ? (val == '--'
                              ? val
                              : val == 'true'
                                  ? box1!
                                  : box2!)
                          : val),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                from == 'admin'
                    ? SizedBox.shrink()
                    : IconButton(
                        onPressed: () async {
                          if (type == 'text') {
                            var res =
                                await Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TextEditPage(
                                  val: val,
                                  column: column,
                                  title: title,
                                  formid: formId,
                                );
                              },
                            ));
                            // ignore: unrelated_type_equality_checks
                            if (res == 'success') getData(formId);
                          } else {
                            var res =
                                await Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return checkBoxEditPage(
                                  val1: box1!,
                                  val2: box2!,
                                  val: val == '--' ? 'none' : val,
                                  column: column,
                                  title: title,
                                  formid: formId,
                                );
                              },
                            ));
                            print('my res $res');
                            // ignore: unrelated_type_equality_checks
                            if (res.toString() == 'success') getData(formId);
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.amber,
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
