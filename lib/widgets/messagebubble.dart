import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first(
      {super.key,
      required this.userimage,
      required this.username,
      required this.message,
      required this.isme})
      : isfirstinsequence = true;
  const MessageBubble.next(
      {super.key, required this.message, required this.isme})
      : isfirstinsequence = false,
        userimage = null,
        username = null;
  final bool isfirstinsequence;
  final String? username;
  final String message;
  final String? userimage;
  final bool isme;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (userimage != null)
          Positioned(
            top: 15,
            right: isme ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userimage!),
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withAlpha(180),
              radius: 23,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isme ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isfirstinsequence)
                const SizedBox(
                  height: 18,
                ),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Text(
                  username!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: isme
                        ? Colors.grey[300]
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(200),
                    borderRadius: BorderRadius.only(
                        topLeft: !isme && isfirstinsequence
                            ? Radius.zero
                            : const Radius.circular(12),
                        topRight: isme && isfirstinsequence
                            ? Radius.zero
                            : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12))),
                constraints: const BoxConstraints(maxWidth: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Text(
                  message,
                  style: TextStyle(
                    height: 1.3,
                    color: isme
                        ? Colors.black87
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
                  softWrap: true,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
