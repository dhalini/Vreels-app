







































































              






















































































































































































































                



































































































































                

























import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInputSection extends StatefulWidget {
  final Function(String) onOtpChanged;

  const OtpInputSection({Key? key, required this.onOtpChanged}) : super(key: key);

  @override
  _OtpInputSectionState createState() => _OtpInputSectionState();
}

class _OtpInputSectionState extends State<OtpInputSection> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: PinCodeTextField(
        controller: _otpController,
        appContext: context,
        length: 6,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: 50,
          fieldWidth: 46,
          activeFillColor: Colors.grey[100],
          inactiveFillColor: Colors.grey[100],
          selectedFillColor: Colors.white,
          activeColor: Colors.blue,
          inactiveColor: const Color.fromARGB(110, 68, 137, 255),
          selectedColor: Colors.blue,
        ),
        enableActiveFill: true,
        onChanged: (value) {
          
          if(value.length<6){
            widget.onOtpChanged("");
          }
          print("New Field${value}");
        },
        onCompleted: (value) {
          widget.onOtpChanged(value);
        },
        cursorColor: Colors.grey,
        showCursor: true,
      ),
    );
  }
}

