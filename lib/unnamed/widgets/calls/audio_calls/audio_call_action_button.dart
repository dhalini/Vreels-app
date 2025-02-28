import 'package:flutter/material.dart';


class CallControls extends StatelessWidget {
  final bool isMuted;
  final bool isSpeakerOn;
  final VoidCallback onMuteToggle;
  final VoidCallback onSpeakerToggle;
  final VoidCallback onEndCall;

  const CallControls({
    Key? key,
    required this.isMuted,
    required this.isSpeakerOn,
    required this.onMuteToggle,
    required this.onSpeakerToggle,
    required this.onEndCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: isMuted ? Icons.mic : Icons.mic_off,
            label: "Mute",
            color: isMuted ? Colors.green : Colors.grey,
            onPressed: onMuteToggle,
          ),
          _buildActionButton(
            icon: Icons.call_end,
            label: "End",
            color: Colors.red,
            onPressed: onEndCall,
          ),
          _buildActionButton(
            icon: isSpeakerOn ? Icons.volume_up : Icons.volume_off,
            label: "Speaker",
            color: isSpeakerOn ? Colors.green : Colors.grey,
            onPressed: onSpeakerToggle,
          ),
        ],
      ),
    );
  }

  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: color,
          onPressed: onPressed,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 49, 48, 48),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
