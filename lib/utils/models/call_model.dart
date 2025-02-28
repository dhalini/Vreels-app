import 'package:flutter/material.dart';


enum CallType { missed, incoming, outgoing }


class Call {
  final String name;
  final String detail;
  final String time; 
  final IconData avatar;
  final CallType callType;
  final bool isVideo;

  Call({
    required this.name,
    required this.detail,
    required this.time, 
    required this.avatar,
    required this.callType,
    required this.isVideo,
  });

  
  Map<String, dynamic> toMap() {
    
    
    return {
      'name': name,
      'detail': detail,
      'time': time, 
      'call_type': callType.toString().split('.').last, 
      'is_video': isVideo ? 1 : 0,
    };
  }

  
  factory Call.fromMap(Map<String, dynamic> map) {
    
    final callTypeString = map['call_type'] as String? ?? 'missed';
    final parsedCallType = CallType.values.firstWhere(
      (ct) => ct.toString().split('.').last == callTypeString,
      orElse: () => CallType.missed,
    );

    return Call(
      name: map['name'] ?? '',
      detail: map['detail'] ?? '',
      time: map['time'] ?? DateTime.now().toIso8601String(), 
      avatar: Icons.person, 
      callType: parsedCallType,
      isVideo: (map['is_video'] ?? 0) == 1,
    );
  }
}
