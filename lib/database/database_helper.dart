import 'dart:async';
import 'package:path/path.dart';
import 'package:prototype25/utils/models/call_model.dart';
import 'package:prototype25/utils/models/chats_list_model.dart';
import 'package:prototype25/utils/models/message_model.dart';
import 'package:sqflite/sqflite.dart';


import '../utils/dummy_del/chats_list.dart';
import '../utils/dummy_del/chat_dummy.dart';
import '../utils/dummy_del/call_logs.dart';




class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  final StreamController<void> _chatStreamController = StreamController.broadcast();

  Stream<void> get chatStream => _chatStreamController.stream;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  void dispose() {
    _chatStreamController.close();
  }

  void _notifyDatabaseChange() {
    if (!_chatStreamController.isClosed) {
      _chatStreamController.add(null);
    }
  }

  
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'msgstore.db');
    print("Database Path: $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertDummyData(db);
      },
      
    );
  }

  
  
  
  Future<void> _createTables(Database db) async {
    
    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        about_you TEXT,        -- from dummyChats aboutYou
        last_message TEXT,
        time TEXT,
        unread_count INTEGER,
        profile_pic TEXT       -- New field for profile pictures
      )
    ''');

    
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chat_id INTEGER NOT NULL,
        sender TEXT NOT NULL,    -- "me" or "friend"
        text TEXT NOT NULL,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(chat_id) REFERENCES chats(id) ON DELETE CASCADE
      )
    ''');

    
    
    await db.execute('''
      CREATE TABLE calls (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        detail TEXT,
        call_type TEXT,   -- e.g. 'missed', 'incoming', 'outgoing'
        is_video INTEGER, -- 0 or 1
        time TEXT    -- Store time as ISO 8601 string
      )
    ''');

  }

  
  
  
  Future<void> _insertDummyData(Database db) async {
    
    
    for (var chatInfo in chats) {
      

      
      final chatMap = chatInfo.toMap();
      final chatId = await db.insert('chats', chatMap);
      final chatHistory = dummyChats[chatInfo.name];

      
      if (chatHistory != null) {
        for (var msg in chatHistory.messages) {
          
          final msgMap = msg.toMap();
          msgMap['chat_id'] = chatId;
          
          await db.insert('messages', msgMap);
        }
      }
    }

    
    
    
    for (var callLog in calls) {
      
      final callMap = callLog.toMap();
      await db.insert('calls', callMap);
    }
  }

  
  
  

  
  Future<List<Map<String, dynamic>>> getAllChats() async {
    final db = await database;
    return await db.query('chats', orderBy: 'time DESC');
  }

  Future<int> insertChat(Map<String, dynamic> chatData) async {
    final db = await database;
    int id = await db.insert('chats', chatData);
    _notifyDatabaseChange();
    return id;
  }

  Future<void> deleteChat(int chatId) async {
    final db = await database;
    await db.delete('chats', where: 'id = ?', whereArgs: [chatId]);
     _notifyDatabaseChange();
  }

  
  Future<List<Map<String, dynamic>>> getMessagesForChat(int chatId) async {
    final db = await database;
    return await db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
      orderBy: 'timestamp ASC',
    );
  }

  Future<int> insertMessage({
    required int chatId,
    required String sender,
    required String text,
  }) async {
    final db = await database;
    return await db.insert('messages', {
      'chat_id': chatId,
      'sender': sender,
      'text': text,
    });
  }

  Future<void> updateChatLastMessage({
    required int chatId,
    required String lastMessage,
    required String time,
  }) async {
    final db = await database;
    await db.update(
      'chats',
      {
        'last_message': lastMessage,
        'time': time,
      },
      where: 'id = ?',
      whereArgs: [chatId],
    );
    _notifyDatabaseChange();
  }

  Future<void> deleteMessage(int messageId) async {
    final db = await database;
    await db.delete('messages', where: 'id = ?', whereArgs: [messageId]);
  }

  
  Future<List<Map<String, dynamic>>> getAllCalls() async {
    final db = await database;
    return await db.query('calls', orderBy: 'time DESC');
  }

  Future<int> insertCall(Map<String, dynamic> callData) async {
    final db = await database;
    return await db.insert('calls', callData);
  }

  Future<void> deleteCall(int callId) async {
    final db = await database;
    await db.delete('calls', where: 'id = ?', whereArgs: [callId]);
  }

  
  Future<void> logout() async {
    final db = await database;
    
    await db.delete('chats');
    await db.delete('messages');
    await db.delete('calls');
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'msgstore.db');

    
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    
    await deleteDatabase(path);
    print("Database deleted successfully: $path");
  }
}
