import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/data/colors.dart';
import 'package:fox_tales/models/screen.dart';
import 'package:fox_tales/providers/roles_provider.dart';
import 'package:fox_tales/screens/register_screen.dart';
import 'package:fox_tales/screens/upload_screen.dart';
import 'package:fox_tales/screens/users_screen.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  final List<Screen> _screens = [
    Screen(
      icon: const Icon(Icons.upload),
      label: "Upload new Image",
      screen: const UploadScreen(),
    ),
    Screen(
      icon: const Icon(Icons.app_registration),
      label: "Register New User",
      screen: const RegisterScreen(),
    ),
    Screen(
      icon: const Icon(Icons.supervised_user_circle),
      label: 'User Management',
      screen: const UsersScreen(),
    )
  ];

  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    bool isAdmin = ref.watch(rolesProvider)['admins'].contains(_uid);

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                const Text(
                  'Options',
                  style: TextStyle(fontFamily: 'Tahu', fontSize: 40),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ],
            ),
          ),
          Text(
              '${FirebaseAuth.instance.currentUser!.displayName!} (${isAdmin ? "Admin" : "Watcher"})'),
          isAdmin
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _screens.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_screens[index].label),
                        leading: _screens[index].icon,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => _screens[index].screen),
                          );
                        },
                      );
                    },
                  ),
                )
              : const Spacer(),
          ListTile(
            iconColor: primary,
            title: const Text(
              'Logout',
              style: TextStyle(color: primary, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
