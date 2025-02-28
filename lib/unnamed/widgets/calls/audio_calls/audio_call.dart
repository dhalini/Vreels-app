import 'package:flutter/material.dart';
import 'package:prototype25/unnamed/widgets/calls/audio_calls/audio_call_action_button.dart';
import 'package:prototype25/unnamed/widgets/calls/audio_calls/wave_animation.dart';



class AudioCallPage extends StatefulWidget {
  final String userName;
  final String avatarUrl;

  const AudioCallPage({
    Key? key,
    required this.userName,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  _AudioCallPageState createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            _buildTopSection(),
            
            
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CustomWaveAnimation(),
            ),
            
            
            CallControls(
              isMuted: _isMuted,
              isSpeakerOn: _isSpeakerOn,
              onMuteToggle: _onMuteToggled,
              onSpeakerToggle: _onSpeakerToggled,
              onEndCall: _onEndCall,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildTopSection() {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Column(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(widget.avatarUrl),
          backgroundColor: Colors.grey.shade800,
        ),
        const SizedBox(height: 16),
        Text(
          widget.userName,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Calling...",
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  
  void _onMuteToggled() {
    setState(() {
      _isMuted = !_isMuted;
    });
    
  }

  
  void _onSpeakerToggled() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
    
  }

  
  void _onEndCall() {
    Navigator.pop(context);
    
  }
}
