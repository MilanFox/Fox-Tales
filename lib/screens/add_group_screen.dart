import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/data/colors.dart';
import 'package:fox_tales/providers/users_provider.dart';

class AddGroupScreen extends ConsumerStatefulWidget {
  const AddGroupScreen({super.key});

  @override
  ConsumerState<AddGroupScreen> createState() {
    return _AddGroupScreenState();
  }
}

class _AddGroupScreenState extends ConsumerState<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _members = [FirebaseAuth.instance.currentUser!.uid];

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add new Group'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          GestureDetector(
              child: Container(
                  padding: const EdgeInsets.only(right: 16),
                  child: Badge(
                    label: Text(_members.length.toString()),
                    backgroundColor: primary,
                    child: const Icon(
                      Icons.check_box,
                      size: 30,
                    ),
                  )))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Group Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please add a group name";
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              users[index].name,
                              style: TextStyle(
                                fontWeight: _members.contains(users[index].uid)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _members.contains(users[index].uid)
                                    ? primary
                                    : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              _members.contains(users[index].uid)
                                  ? Icons.group_remove
                                  : Icons.group_add,
                              color: _members.contains(users[index].uid)
                                  ? primary
                                  : Colors.black,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (_members.contains(users[index].uid)) {
                            _members.remove(users[index].uid);
                          } else {
                            _members.add(users[index].uid);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
