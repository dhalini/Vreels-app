import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequest {
  
  static Future<void> requestAppPermissions(BuildContext context) async {
    try {
      
      if (await _isAndroid13OrAbove()) {
        
        if (!await _handlePermission(context, Permission.photos, 'Photos')) return;
        if (!await _handlePermission(context, Permission.videos, 'Videos')) return;
      } else {
        
        
        if (!await _handlePermission(context, Permission.manageExternalStorage, 'Storage')) return;
      }

      
      if (!await _handlePermission(context, Permission.sms, 'SMS')) return;

      
      
      
      
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  
  static Future<bool> _handlePermission(
      BuildContext context, Permission permission, String name) async {
    try {
      
      PermissionStatus status = await permission.status;
      print('Permission status for $name: $status');

      
      if (status.isGranted) return true;

      
      if (status.isDenied) {
        status = await permission.request();
      }

      
      if (status.isPermanentlyDenied) {
        final bool openSettings = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Permission Required'),
                content: Text(
                    '$name permission is required for this feature. Please enable it in settings.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Go to Settings'),
                  ),
                ],
              ),
            ) ??
            false;

        if (openSettings) {
          await openAppSettings();
        }

        return false;
      }

      
      if (status.isGranted) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name permission denied. This feature will not work without it.'),
          ),
        );
        return false;
      }
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
      return false;
    }
  }

  
  static Future<bool> _isAndroid13OrAbove() async {
    return await Permission.photos.status.then((status) => status != PermissionStatus.denied);
  }
}
