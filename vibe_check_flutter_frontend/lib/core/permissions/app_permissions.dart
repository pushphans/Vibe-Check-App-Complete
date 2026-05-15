import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class AppPermissions {
  static const _cameraKey = 'perm_camera';
  static const _galleryKey = 'perm_gallery';

  final SharedPreferences _prefs;

  AppPermissions(this._prefs);

  Future<bool> requestCamera() async {
    final status = await ph.Permission.camera.request();
    final granted = status.isGranted;
    await _prefs.setBool(_cameraKey, granted);
    return granted;
  }

  bool isCameraGranted() => _prefs.getBool(_cameraKey) ?? false;

  Future<bool> requestGallery() async {
    late ph.PermissionStatus status;
    if (Platform.isAndroid) {
      status = await ph.Permission.photos.request();
      if (!status.isGranted) {
        status = await ph.Permission.storage.request();
      }
    } else {
      status = await ph.Permission.photos.request();
    }
    final granted = status.isGranted;
    await _prefs.setBool(_galleryKey, granted);
    return granted;
  }

  bool isGalleryGranted() => _prefs.getBool(_galleryKey) ?? false;
}
