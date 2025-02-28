
import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/calls/audio_calls/audio_call.dart';
import 'package:prototype25/unnamed/widgets/calls/video_calls/video_call.dart';
import 'package:prototype25/utils/permissions.dart';
import 'package:flutter/widgets.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const VideoCallPage(userName: "Hi", avatarUrl: "HI")
    );
  }
}