import 'package:flutter/material.dart';
import 'package:fox_tales/screens/register_screen.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key});

  @override
  State<MainDrawer> createState() {
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Text('Settings')),
          ListTile(
            title: Text('Register User'),
            leading: Icon(Icons.app_registration),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => RegisterScreen()));
            },
          ),
        ],
      ),
    );
  }
}
