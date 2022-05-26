import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  bool isLoading = false;

  @override
  void initState() {
    //start the timer on loading
    super.initState();
    startTimer();
  }

  startTimer() {
    timer = Timer(const Duration(seconds: 30), () {
      setState(() {
        isLoading = true; //set loading to false
      });

      // timer!.cancel();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                color: Colors.white,
                child: const Text(''),
              )),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: AlignmentDirectional.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? Container(
                          margin: EdgeInsets.only(top: 150),
                          child: const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              value: null,
                              strokeWidth: 2.0,
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 150),
                          child: const Text(
                            "...",
                            style: TextStyle(
                              color: Color(0xff2561AA),
                              fontSize: 13,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
