import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../utils/firebase_functions.dart';
import '../../../providers/my_provider.dart';
import '../../login/login.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _imageFile;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, MyProvider userProvider) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 60,
      );
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          _imageFile = file;
        });
        userProvider.setProfileImage(pickedFile.path);
        await _saveImage(file, userProvider);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Fluttertoast.showToast(
        msg: "Failed to pick image: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _saveImage(File imageFile, MyProvider userProvider) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isUploading = true);
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      await FirebaseFunctions.updateUserPhoto(user.uid, base64Image);
      if (userProvider.userModel != null) {
        userProvider.userModel!.photoURL = base64Image;
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showImagePickerModal(BuildContext context, MyProvider userProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('gallery'.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.gallery, userProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text('camera'.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.camera, userProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    var userprovider = Provider.of<MyProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    var isDark = provider.themeMode == ThemeMode.dark;

    final firebaseUser = userprovider.firebaseUser ?? FirebaseAuth.instance.currentUser;
    final photoBase64 = userprovider.userModel?.photoURL;
    final savedImagePath = userprovider.profileImagePath;

    ImageProvider? avatarImage;
    if (_imageFile != null) {
      avatarImage = FileImage(_imageFile!);
    } else if (savedImagePath != null && savedImagePath.isNotEmpty && File(savedImagePath).existsSync()) {
      avatarImage = FileImage(File(savedImagePath));
    } else if (photoBase64 != null && photoBase64.isNotEmpty) {
      try {
        avatarImage = MemoryImage(base64Decode(photoBase64));
      } catch (e) {
        debugPrint('Error decoding photo: $e');
      }
    } else if (firebaseUser?.photoURL != null && firebaseUser!.photoURL!.isNotEmpty) {
      avatarImage = NetworkImage(firebaseUser.photoURL!);
    }

    final userName = (userprovider.userModel?.name != null &&
        userprovider.userModel!.name.isNotEmpty)
        ? userprovider.userModel!.name
        : (firebaseUser?.displayName != null &&
        firebaseUser!.displayName!.isNotEmpty)
        ? firebaseUser.displayName!
        : "";

    final userEmail = (userprovider.userModel?.email != null &&
        userprovider.userModel!.email.isNotEmpty)
        ? userprovider.userModel!.email
        : (firebaseUser?.email != null &&
        firebaseUser!.email!.isNotEmpty)
        ? firebaseUser.email!
        : "";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () => _showImagePickerModal(context, userprovider),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF002D8F),
                    backgroundImage: avatarImage,
                    child: avatarImage == null
                        ? const Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.white,
                    )
                        : null,
                  ),
                  if (_isUploading)
                    const Positioned.fill(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black38,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          ProfileOptionCard(
            title: "dark_mode".tr(),
            trailing: Switch(
              value: isDark,
              activeThumbColor: Colors.white,
              activeTrackColor: primaryColor,
              onChanged: (value) {
                provider.changeTheme(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          const SizedBox(height: 16),
          ProfileOptionCard(
            title: "language_label".tr(),
            onTap: () {
              showLanguageSheet(context);
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: isDark ? Colors.white : primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ProfileOptionCard(
            title: "logout".tr(),
            onTap: () async {
              if (FirebaseAuth.instance.currentUser != null) {
                await FirebaseAuth.instance.signOut();
              }
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                      (r) => false,
                );
              }
            },
            trailing: const Icon(Icons.logout, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  void showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              "English".tr(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            onTap: () {
              Navigator.pop(sheetContext);
              context.setLocale(const Locale("en"));
            },
          ),
          ListTile(
            title: Text(
              "Arabic".tr(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            onTap: () {
              Navigator.pop(sheetContext);
              context.setLocale(const Locale("ar"));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ProfileOptionCard extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const ProfileOptionCard({
    super.key,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return SizedBox(
      height: 60,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff001440) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF002D8F) : primaryColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}