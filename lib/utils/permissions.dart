import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    // PermissionStatus permission = await Permission.camera.status;
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      // PermissionStatus permissionStatus = await Permission.camera.request();
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.camera]);
      // return permissionStatus ?? PermissionStatus.undetermined;
      return permissionStatus[PermissionGroup.camera] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    // PermissionStatus permission = await Permission.microphone.status;
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      // PermissionStatus permissionStatus = await Permission.microphone.request();
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.microphone]);
      // return permissionStatus ?? PermissionStatus.undetermined;
      return permissionStatus[PermissionGroup.microphone] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  static void _handleInvalidPermissions(PermissionStatus cameraPermissionStatus,
      PermissionStatus microphonePermissionStatus) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to camera and microphone denied',
        details: null,
      );
    }
  }
}
