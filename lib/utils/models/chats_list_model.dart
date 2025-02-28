import 'package:flutter/material.dart';


class Chat {
  final String name;
  final String lastMessage;
  final String time;
  final IconData avatar;
  final int unreadCount;
  final int? id;
  final String? profilePic;
  final String? aboutYou;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatar,
    required this.unreadCount,
    this.id,
    this.profilePic,
    this.aboutYou,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'last_message': lastMessage,
      'time': time,
      'unread_count': unreadCount,
      'profile_pic': profilePic,
      'about_you': aboutYou,
    };
  }

  
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      lastMessage: map['last_message'] ?? '',
      time: map['time'] ?? '',
      avatar: getIconFromName(map['avatar'] ?? 'person'), 
      unreadCount: map['unread_count'] ?? 0,
      profilePic: map['profile_pic'] ?? 'assets/images/dummy_profile.png',
      aboutYou: map['about_you'] ?? '',
    );
  }

  static IconData getIconFromName(String iconName) {
    switch (iconName) {
      case 'chat':
        return Icons.chat;
      case 'call':
        return Icons.call;
      case 'email':
        return Icons.email;
      default:
        return Icons.person; 
    }
  }
}
