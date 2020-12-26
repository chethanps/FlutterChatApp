import 'package:flutter/material.dart';

const kTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
);

const kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.white54, fontSize: 16.0),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
);

const kSendButtonTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.lightBlueAccent,
);

const kMessageTextFieldDecoration = InputDecoration(
  focusColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Enter your message here .... ',
  fillColor: Colors.white,
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
    border: Border(
  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
));

const kMessageEmailOrPasswordTextDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Colors.black,
  ),
//  hintText: 'Enter your email...',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kMessageSelfBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(20),
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);

const kMessagePeerBorderRadius = BorderRadius.only(
  topRight: Radius.circular(20),
  bottomRight: Radius.circular(20),
  bottomLeft: Radius.circular(20),
);
