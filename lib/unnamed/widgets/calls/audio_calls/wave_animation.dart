import 'dart:async';
import 'package:flutter/material.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';


enum CallStatus { calling, ringing, answered }

class CustomWaveAnimation extends StatefulWidget {
  const CustomWaveAnimation({Key? key}) : super(key: key);

  @override
  _CustomWaveAnimationState createState() => _CustomWaveAnimationState();
}

class _CustomWaveAnimationState extends State<CustomWaveAnimation>
    with SingleTickerProviderStateMixin {
  CallStatus _currentStatus = CallStatus.calling;
  int _callDuration = 0; 
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();

    _simulateApiStatusChanges();
  }

  void _simulateApiStatusChanges() {
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _currentStatus = CallStatus.ringing;
      });
    });

    Timer(const Duration(seconds: 10), () {
      setState(() {
        _currentStatus = CallStatus.answered;
        _startCallTimer();
      });
    });
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [ WidgetCircularAnimator(
            size: 200,
            innerColor: _getInnerColor(),
            outerColor: _getOuterColor(),
            innerAnimation: Curves.easeInOut,
            outerAnimation: Curves.easeInOut,
            child: _buildStatusIcon(),
          ),
        if (_currentStatus == CallStatus.answered)
          Positioned(
            bottom: 37,
            child: Text(
              _formatDuration(_callDuration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Color _getInnerColor() {
    switch (_currentStatus) {
      case CallStatus.calling:
        return Colors.blue;
      case CallStatus.ringing:
        return Colors.orange;
      case CallStatus.answered:
        return Colors.green;
    }
  }

  Color _getOuterColor() {
    switch (_currentStatus) {
      case CallStatus.calling:
        return Colors.blueAccent;
      case CallStatus.ringing:
        return Colors.deepOrange;
      case CallStatus.answered:
        return Colors.lightGreenAccent;
    }
  }

  Widget _buildStatusIcon() {
    IconData iconData;
    switch (_currentStatus) {
      case CallStatus.calling:
        iconData = Icons.wifi_calling_3;
        break;
      case CallStatus.ringing:
        iconData = Icons.notifications_active;
        break;
      case CallStatus.answered:
        iconData = Icons.call;
        break;
    }
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getInnerColor().withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Icon(
        iconData,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
