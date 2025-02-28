import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class VideoCallPage extends StatefulWidget {
  final String userName;
  final String avatarUrl;

  const VideoCallPage({
    Key? key,
    required this.userName,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  late CameraDescription _frontCamera;
  late CameraDescription _backCamera;
  bool cameraOn = true;
  bool muted = false;
  bool frontCameraOn = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
      _backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);
      await _setCamera(_frontCamera);
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> switchCamera() async {
    _cameraController.dispose();
    if (frontCameraOn) {
      await _setCamera(_backCamera);
    } else {
      await _setCamera(_frontCamera);
    }
    setState(() {
      frontCameraOn = !frontCameraOn;
    });
  }

  Future<void> _setCamera(CameraDescription camera) async {
    _cameraController = CameraController(
      camera, 
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {
        cameraOn = !cameraOn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: _isCameraInitialized
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      final aspectRatio = _cameraController.value.aspectRatio;
                      final height = constraints.maxHeight;
                      final width = height * aspectRatio;
                      return Center(
                        child: ClipRect(
                          child: SizedBox(
                            height: height,
                            width: constraints.maxWidth, 
                            child: OverflowBox(
                              alignment: Alignment.center,
                              maxWidth:
                                  width, 
                              minWidth: constraints.maxWidth,
                              child: frontCameraOn
                                  ? Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..scale(-1.0, 1.0, 1.0),
                                      child: CameraPreview(_cameraController),
                                    )
                                  : CameraPreview(_cameraController),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "Video Stream",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
          ),
      
          
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.avatarUrl),
                  
                  backgroundColor: Colors.grey.shade800,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Video Call",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                  onPressed: () {
                    switchCamera();
                  },
                  icon: const Icon(color: Colors.white, Icons.cameraswitch))),
          
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: cameraOn ? Icons.videocam_off : Icons.videocam,
                  label: "Camera",
                  color: cameraOn ? Colors.grey : Colors.green,
                  onPressed: () {
                    onPausePreviewButtonPressed();
                  },
                ),
                _buildActionButton(
                  icon: Icons.call_end,
                  label: "End",
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                ),
                _buildActionButton(
                  icon: muted ? Icons.mic_off : Icons.mic,
                  label: "Mute",
                  color: muted ? Colors.green : Colors.grey,
                  onPressed: () {
                    setState(() {
                      muted = !muted;
                    });
                    
                  },
                ),
              ],
            ),
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
          onPressed: onPressed,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
