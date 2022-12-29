import 'dart:convert';
import 'package:big_cart/constants/asset_constants.dart';
import 'package:big_cart/shared/styles.dart';
import 'package:big_cart/views/shopping_cart/title_with_cost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../app/locator.dart';
import '../../services/authentication_service.dart';
import '../../shared/helpers.dart';
import '../../widgets/dumb/app_main_button.dart';
import 'package:http/http.dart' as http;
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ShoppingCartView extends StatefulWidget {
  final int? id;
  final String? floor;
  final String? state;
  final _auth = locator<AuthenticationService>();

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
                if (widget._auth.email == waitingList['data'][0]['email'].toString() ) {
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
                                          checkParkState(context);
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
                    onTap: () async{
                      // bool isFilled = await isParkFilled();
                      widget._auth.type == 'robot' ? showTimeDialog() : showDataAndTimeDialog();
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

  Future<dynamic> getData() async {
    String data;
    String url1;

    data = jsonEncode({"park_id":widget.id.toString()});
    url1 ="https://technolab4iot.com/parking_reservation/index.php/parks/list";

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

  Future<bool> updateParkState(bool state) async {
    String data;
    String url1;

    data = jsonEncode({
      "park_id":widget.id.toString(),
      "state" : state? 'on' : 'off'
    });
    url1 ="https://technolab4iot.com/parking_reservation/index.php/parks/update";

    final Uri url = Uri.parse(url1);
    var response = await http.post(url,body: data);
    var responseBody= jsonDecode(response.body);

    if (responseBody['status'] == 'success') {
      return true;
    }
    return false;

  }

  Future<void> addWaitingItem(Duration duration) async {
    String data;
    String url1;
    int currentDateInSeconds = DateTime.now().millisecondsSinceEpoch;
    int timeToSubtract = ((currentDateInSeconds - timeWhenGetDataFuncCalled)~/1000);
    int neededHours = totalTimeInHours - timeToSubtract  + duration.inSeconds.toInt();

    data = jsonEncode({
      "park_id" : widget.id.toString(),
      "user_id" : widget._auth.id.toString(),
      "needed_hours" : neededHours.toString()
    });
    url1 ="https://technolab4iot.com/parking_reservation/index.php/parks/add_list";

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

  Future<bool> isParkFilled() async {
    String url1;
    url1 ="https://technolab4iot.com/parking_reservation/is_park_filled.php?park_id=${widget.id.toString()}";
    final Uri url = Uri.parse(url1);
    var response = await http.get(url,);
    var responseBody= jsonDecode(response.body);
    if (responseBody['status'] == 'fail') {
      showErrorDialog(responseBody['data']);
      return false;
    }
    return responseBody['message'][0]['is_filled'] == 'yes' ? true : false;
  }

  Future<void> askSendNotification(Duration duration) async {
    String data;
    String url1;

    data = jsonEncode({
      "title" : "Your turn will end soon",
      "body" : "5 minutes left for your turn to end",
      "park_id" : widget.id.toString(),
      "user_id" : widget._auth.id.toString(),
      "needed_hours" : duration.inSeconds.toString()
    });
    url1 ="https://technolab4iot.com/parking_reservation/index.php/notification";

    final Uri url = Uri.parse(url1);
    http.post(url,body: data);
  }

  Future<dynamic> deleteWaitingItem(String waitingListID) async {
    String data;
    String url1;

    data = jsonEncode({
      "park_id" : widget.id.toString(),
      "user_id" : widget._auth.id.toString(),
      "waiting_list_id" : waitingListID
    });
    url1 ="https://technolab4iot.com/parking_reservation/index.php/parks/delete_list";

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

  Future<void> sendNotification(String title, body) async {
    String data;
    String url1;

    data = jsonEncode({
      "title" : title,
      "body" : body,
    });
    url1 ="https://technolab4iot.com/parking_reservation/index.php/notification";

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Navigator.of(context).pop();
                      double price = widget._auth.type == 'golden' ? selectedHoursFromTimePicker.inMinutes.toDouble() * goldMinutePrice : selectedHoursFromTimePicker.inMinutes.toDouble() * normalMinutePrice;
                      bool isConfirmed = await showMyConfirmDialog(context, price);
                      if (isConfirmed) {
                        askSendNotification(selectedHoursFromTimePicker);
                        addWaitingItem(selectedHoursFromTimePicker);
                      }
                    },
                    child: const Text('Pay')),
              ],
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          Navigator.of(context).pop();
                          selectedHoursFromTimePicker = Duration(
                            days: int.parse(daysController.text),
                            hours: int.parse(hoursController.text),
                            minutes: int.parse(minutesController.text),
                            seconds: int.parse(secondsController.text),
                          );
                          double price = widget._auth.type == 'golden' ? selectedHoursFromTimePicker.inMinutes.toDouble() * goldMinutePrice : selectedHoursFromTimePicker.inMinutes.toDouble() * normalMinutePrice;
                          bool isConfirmed = await showMyConfirmDialog(context, price);
                          if (isConfirmed) {
                            askSendNotification(selectedHoursFromTimePicker);
                            addWaitingItem(selectedHoursFromTimePicker);
                          }
                        },
                        child: const Text('Pay')),
                  ],
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Future<bool> showMyConfirmDialog(BuildContext context, double price) async {
    bool isConfirmed = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("The price is $price NIS, proceed ?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                isConfirmed = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                isConfirmed = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return isConfirmed;
  }

  Future<bool> showTimeExpandedDialog(BuildContext context) async {
    bool isConfirmed = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const ListTile(
            leading: Icon(Icons.info, color: Colors.red,),
            title: Text(
              "Your Time Ended !!, you should move your car ",
              style: TextStyle(
                color: Colors.red,
                // fontSize: 40,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Car moved'),
              onPressed: () {
                isConfirmed = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return isConfirmed;
  }

  Future<bool> showTimePayExpandedTimeDialog(BuildContext context, Duration duration) async {
    bool isConfirmed = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: ListTile(
            leading: Icon(Icons.info, color: Colors.red,),
            title: Text(
              "Your expanded time is ${printDuration(duration)} \nYou have to pay ${duration.inMinutes.toDouble()*expandedMinutePrice} NIS",
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Pay'),
              onPressed: () {
                isConfirmed = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return isConfirmed;
  }

  checkParkState(BuildContext context) async {
    int duration =0 ;
    final stopWatchTimer = StopWatchTimer(
      onChange: (value) {
        duration = value;
      },
    );

    bool isFilled = await isParkFilled();
    stopWatchTimer.onStartTimer();

    while (isFilled) {
      await showTimeExpandedDialog(context);
      isFilled = await isParkFilled();
    }

    stopWatchTimer.onStopTimer();
    Duration expandedDuration = Duration(milliseconds: duration);

    await showTimePayExpandedTimeDialog(context, expandedDuration);

  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
