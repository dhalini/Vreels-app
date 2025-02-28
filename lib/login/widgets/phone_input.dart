import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputSection extends StatefulWidget {
  final String countryCode;
  final bool otpSending;
  final bool otpFailure;
  final Function(String) onCountryCodeChanged;
  final Function(String) onPhoneNumberChanged; 
  final Function(String) onPhoneNumberComplete; 
  final Function(String) onBackSpace;

  const PhoneInputSection({
    super.key,
    required this.countryCode,
    required this.otpSending,
    required this.otpFailure,
    required this.onCountryCodeChanged,
    required this.onPhoneNumberChanged,
    required this.onPhoneNumberComplete,
    required this.onBackSpace,
  });

  @override
  State<PhoneInputSection> createState() => _PhoneInputSectionState();
}

class _PhoneInputSectionState extends State<PhoneInputSection> {
  late TextEditingController _controller;
  String _currentPhoneNumber = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final text = _controller.text;

      
      if (text.length == 10 && _currentPhoneNumber.length != 10) {
        widget.onPhoneNumberChanged(text);
        final fullPhoneNumber = "${widget.countryCode}$text";
        widget.onPhoneNumberComplete(fullPhoneNumber);
      }

      
      if (_currentPhoneNumber.length == 10 && text.length < 10) {
        widget.onBackSpace(text);
        widget.onPhoneNumberChanged("");
      }

      
      _currentPhoneNumber = text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.countryCode,
              items: const [
                DropdownMenuItem(
                  value: '+91',
                  child: Text('+91'),
                ),
                DropdownMenuItem(
                  value: '+1',
                  child: Text('+1'),
                ),
              ],
              onChanged: (value) => widget.onCountryCodeChanged(value!),
            ),
          ),
        ),
        const SizedBox(width: 10),

        
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
              filled: true,
              fillColor: Colors.grey[100],
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            enabled: !widget.otpSending,
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
            ),
          ),
        ),
        
        const SizedBox(width: 10),

        _buildOtpStatusIndicator(),
      ],
      
    );
  }
  Widget _buildOtpStatusIndicator() {
    if(_currentPhoneNumber.length==10){
        if(widget.otpSending){
        
        return const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.blue,
          ),
        );
      } else if (!widget.otpFailure) {
        print("printing otpFailure ${widget.otpFailure}");
        return const Icon(Icons.check_circle, color: Colors.green, size: 24);
      } else{
      
        return const Icon(Icons.cancel, color: Colors.red, size: 24);
      } 
    } else {
      
      return const SizedBox(width: 24);
    }
  }
}
