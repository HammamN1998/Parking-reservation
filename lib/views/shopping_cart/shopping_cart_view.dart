import 'dart:convert';

import 'package:big_cart/constants/asset_constants.dart';
import 'package:big_cart/shared/styles.dart';
import 'package:big_cart/viewmodels/shopping_cart_viewmodel.dart';
import 'package:big_cart/views/shopping_cart/title_with_cost.dart';
import 'package:big_cart/widgets/dumb/customized_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import '../../app/locator.dart';
import '../../services/authentication_service.dart';
import '../../shared/helpers.dart';
import '../../widgets/dumb/app_main_button.dart';
import 'cart_item_list.dart';
import 'package:http/http.dart' as http;
import 'cost_with_main_button.dart';


class ShoppingCartView extends StatefulWidget {
  final int? id;
  final String? floor;
  final String? state;

  ShoppingCartView({
    Key? key,
    required this.id,
    required this.floor,
    required this.state,
  }) : super(key: key);

  @override
  _ShoppingCartViewState createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView> {

  late Future<dynamic> getDataFuture;

  late int totalTime;
  late int totalTimeInHours;
  Duration selectedHoursFromTimePicker = const Duration(hours:0, minutes: 0, seconds: 0);
  final _auth = locator<AuthenticationService>();
  dynamic waitingList;
  int timeWhenGetDataFuncCalled = 0;
  late bool isOpen = widget.state == 'on';

  @override
  void initState(){
    super.initState();
    getDataFuture = getData();
    totalTime = DateTime.now().millisecondsSinceEpoch;
    totalTimeInHours = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
      backgroundColor: appWhiteColor,
      appBar: AppBar(
        title: const Text('Waiting List'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          InkWell(
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.map_outlined, size: 40,),
            ),
            onTap: () {
              showParkImageDialog(widget.id);
            },
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Switch(
              value: isOpen,
              onChanged: (value) async {
                if (_auth.email == waitingList['data'][0]['email'].toString() ) {
                  if (await updateParkState(value)) {
                    setState(() {
                      isOpen  = value;
                    });
                  }
                } else {
                  showErrorDialog('You can\'t change park state' );
                }

              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder (
              future: getDataFuture,
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData) {
                  return ListView.builder(
                      itemCount: waitingList['data'].length,
                      itemBuilder: (context, i) {
                        int neededTime = int.parse(waitingList['data'][i]['needed_hours'].toString()) - int.parse(waitingList['current_time'].toString());
                        int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * neededTime;
                        Duration neededDuration = Duration(milliseconds: 1000 * neededTime);
                        if (i > 0) {
                            int timeToSub = int.parse(waitingList['data'][i-1]['needed_hours'].toString()) - int.parse(waitingList['current_time'].toString());

                            neededTime-= timeToSub;
                            neededDuration = Duration(milliseconds: 1000 * neededTime);
                        }
                        return Container (
                          padding: const EdgeInsets.only(left:10,right: 10,bottom: 10),
                          child: Slidable(
                            endActionPane: ActionPane(
                                extentRatio: 0.22,
                                motion: const ScrollMotion(),
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                       deleteWaitingItem(waitingList['data'][i]['waiting_list_id'].toString())
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 11),
                                      width: (screenWidth(context) * 0.22) - 17,
                                      alignment: Alignment.center,
                                      color: appRedColor,
                                      child: Image.asset(
                                        AssetConstants.deleteIcon,
                                        height: 28,
                                      ),
                                    ),
                                  )
                                ]),
                            child: Container(
                              height: 100,
                              padding: const EdgeInsets.only(right: 7),
                              margin: const EdgeInsets.only(
                                left: 17,
                                right: 17,
                                top: 11,
                              ),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                    width: 104,
                                    padding: const EdgeInsets.only(top: 15, bottom: 8),
                                    color: Colors.transparent,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 18),
                                          child: FittedBox(
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  int.parse(
                                                      '0xFF'
                                                  ),
                                                ).withOpacity(0.3),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 15, top: 2),
                                          child: const FittedBox(
                                            child: Icon(Icons.timer_sharp, color: Colors.green,),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        waitingList['data'][i]['email'].toString(),
                                        style: paragraph6.copyWith(color: appGreenColor),
                                      ),
                                      Text(
                                        waitingList['data'][i]['phone'].toString(),
                                        style: paragraph6.copyWith(color: appGreenColor),
                                      ),
                                      i == 0 ?
                                      CountdownTimer(
                                        endTime: endTime,
                                        textStyle: const TextStyle(fontSize: 20, color: Colors.red),
                                        onEnd: () {
                                          updateParkState(false);
                                          getDataFuture = getData();
                                        },
                                      ) : Text(neededDuration.toString().split('.')[0]),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          Container (
            margin: const EdgeInsets.only(top: 13),
            constraints: const BoxConstraints(minHeight: 100),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 22),
                TitleWithCost(
                  title: 'Time all to finish',
                  cost: totalTime,
                  style: paragraph6,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                  height: 1,
                  color: appGreySecondary,
                ),
                const SizedBox(height: 16),
                AppMainButton(
                    onTap: () {
                      _auth.type == 'robot' ? showTimeDialog() : showDataAndTimeDialog();
                    },
                    text: 'Reserve a turn'
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> getData()async
  {
    String data;
    String url1;

    data = jsonEncode({"park_id":widget.id.toString()});
    url1 ="http://10.0.2.2:80/ParkingServer/index.php/parks/list";

    final Uri url = Uri.parse(url1);
    var response = await http.post(url,body: data);
    var responseBody= jsonDecode(response.body);
    waitingList = responseBody;

    if (responseBody['status'] == 'success') {

      setState(() {
        totalTime = DateTime.now().millisecondsSinceEpoch;
        totalTimeInHours = 0;

        if (waitingList['data'].length > 0) {
          totalTime += 1000 *
              (int.parse(waitingList['data'][waitingList['data'].length-1]['needed_hours'].toString()) -
                  int.parse(waitingList['current_time'].toString()));


          totalTimeInHours +=
          (int.parse(waitingList['data'][waitingList['data'].length-1]['needed_hours'].toString()) -
              int.parse(waitingList['current_time'].toString()));
        }


        timeWhenGetDataFuncCalled = DateTime.now().millisecondsSinceEpoch;

        if (responseBody['data'].length > 0 ) isOpen = responseBody['data'][0]['park_state'] == 'on';
      });

    }
    return responseBody;

  }

  Future<bool> updateParkState(bool state)async
  {
    String data;
    String url1;

    data = jsonEncode({
      "park_id":widget.id.toString(),
      "state" : state? 'on' : 'off'
    });
    url1 ="http://10.0.2.2:80/ParkingServer/index.php/parks/update";

    final Uri url = Uri.parse(url1);
    var response = await http.post(url,body: data);
    var responseBody= jsonDecode(response.body);

    if (responseBody['status'] == 'success') {
      return true;
    }
    return false;

  }

  Future<void> addWaitingItem(Duration duration) async
  {
    String data;
    String url1;
    int currentDateInSeconds = DateTime.now().millisecondsSinceEpoch;
    int timeToSubtract = ((currentDateInSeconds - timeWhenGetDataFuncCalled)~/1000);
    int neededHours = totalTimeInHours - timeToSubtract  + duration.inSeconds.toInt();

    data = jsonEncode({
      "park_id" : widget.id.toString(),
      "user_id" : _auth.id.toString(),
      "needed_hours" : neededHours.toString()
    });
    url1 ="http://10.0.2.2:80/ParkingServer/index.php/parks/add_list";

    final Uri url = Uri.parse(url1);
    var response = await http.post(url,body: data);
    var responseBody= jsonDecode(response.body);

    if (responseBody['status'] == 'fail') {
      showErrorDialog(responseBody['data']);
    }
    setState(() {
      getDataFuture = getData();
    });


  }

  Future<void> askSendNotification(Duration duration) async
  {
    String data;
    String url1;

    data = jsonEncode({
      "title" : "Your turn will end soon",
      "body" : "5 minutes left for your turn to end",
      "park_id" : widget.id.toString(),
      "user_id" : _auth.id.toString(),
      "needed_hours" : duration.inSeconds.toString()
    });
    url1 ="http://10.0.2.2:80/ParkingServer/index.php/notification";

    final Uri url = Uri.parse(url1);
    http.post(url,body: data);
  }

  Future<dynamic> deleteWaitingItem(String waitingListID) async
  {
    String data;
    String url1;

    data = jsonEncode({
      "park_id" : widget.id.toString(),
      "user_id" : _auth.id.toString(),
      "waiting_list_id" : waitingListID
    });
    url1 ="http://10.0.2.2:80/ParkingServer/index.php/parks/delete_list";

    final Uri url = Uri.parse(url1);
    var response = await http.post(url,body: data);
    var responseBody= jsonDecode(response.body);
    if(responseBody['status'] == 'fail'){
      showErrorDialog(responseBody['data'].toString());
    } else {
      setState(() {
        getDataFuture = getData();
      });
    }

    return responseBody;

  }

  Future<void> sendNotification(String title, body) async
  {
    String data;
    String url1;

    data = jsonEncode({
      "title" : title,
      "body" : body,
    });
    url1 ="http://10.0.2.2:80/ParkingServer/index.php/notification";

    final Uri url = Uri.parse(url1);
    var response = await http.post(url,body: data);
    var responseBody= jsonDecode(response.body);

    if(responseBody['status'] == 'fail'){
      showErrorDialog(responseBody['data'].toString());
    }
  }

  void showTimeDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            Center(
              child: SizedBox(
                height: 200,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  backgroundColor: Colors.lightGreen,
                  onTimerDurationChanged: (value) {
                    selectedHoursFromTimePicker = value;
                  },
                ),
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () async {
                      askSendNotification(selectedHoursFromTimePicker);
                      addWaitingItem(selectedHoursFromTimePicker);
                      Navigator.of(context).pop();

                    },
                    child: const Text('Submit')),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDataAndTimeDialog() async {
    TextEditingController daysController = TextEditingController();
    TextEditingController hoursController = TextEditingController();
    TextEditingController minutesController = TextEditingController();
    TextEditingController secondsController = TextEditingController();

    daysController.text = '00';
    hoursController.text = '00';
    minutesController.text = '00';
    secondsController.text = '00';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Fill Duration'),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DAYS',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: TextField(
                        controller: daysController,

                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HRS',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: TextField(
                        controller: hoursController,

                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MIN',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: TextField(
                        controller: minutesController,

                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SEC',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: TextField(
                        controller: secondsController,

                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () async {
                          selectedHoursFromTimePicker = Duration(
                            days: int.parse(daysController.text),
                            hours: int.parse(hoursController.text),
                            minutes: int.parse(minutesController.text),
                            seconds: int.parse(secondsController.text),
                          );
                          askSendNotification(selectedHoursFromTimePicker);
                          addWaitingItem(selectedHoursFromTimePicker);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Submit')),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
            ],
          )
        );
      }
    );
  }

  void showParkImageDialog(int? parkNumber) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            Center(
              child: SizedBox(
                height: 200,
                child: Image.asset('assets/images/ParkNumber$parkNumber.png'),
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String info){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(info),
          actions: <Widget>[
            TextButton(
              child: const Text("إغلاق"),
              onPressed: () {
                Navigator.of(this.context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
