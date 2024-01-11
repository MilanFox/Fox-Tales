import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fox_tales/data/colors.dart';
import 'package:fox_tales/models/user.dart';
import 'package:fox_tales/providers/roles_provider.dart';

class UserCard extends ConsumerStatefulWidget {
  const UserCard(this.user, {super.key});

  final AppUser user;

  @override
  ConsumerState<UserCard> createState() {
    return _UserCardState();
  }
}

class _UserCardState extends ConsumerState<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.portrait),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.user.uid,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                ref.read(rolesProvider.notifier).toggleAdminStatus(widget.user);
              },
              child:
                  ref.watch(rolesProvider)['admins'].contains(widget.user.uid)
                      ? const Column(
                          children: [
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                            Icon(
                              Icons.vpn_key,
                              size: 15,
                              color: primary,
                            ),
                          ],
                        )
                      : const Column(
                          children: [
                            Text(
                              'Watcher',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.vpn_key_off, size: 15),
                          ],
                        ),
            )
          ],
        ),
      ),
    );
  }
}
