import 'package:chat_app/utils/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';

class UpVote extends ConsumerStatefulWidget {
  final String doubtId;
  bool isUpvoted;

  UpVote(this.doubtId, this.isUpvoted);

  @override
  _UpVoteState createState() => _UpVoteState();
}

class _UpVoteState extends ConsumerState<UpVote> {
  @override
  Widget build(BuildContext context) {
    final String uid = ref.watch(userDataProvider).uid;
    return Container(
        child: IconButton(
            icon: Icon(
              Icons.thumb_up,
              color: widget.isUpvoted
                  ? Colors.orangeAccent
                  : Constants.darkText.withOpacity(0.3),
            ),
            onPressed: () {
              if (!widget.isUpvoted) {
                FirebaseFirestore.instance
                    .collection('Colleges/PICT/Doubts')
                    .doc(widget.doubtId)
                    .update({
                  'upvotes': FieldValue.increment(1),
                  'Upvoted By': FieldValue.arrayUnion([uid])
                });
                setState(() {
                  widget.isUpvoted = true;
                });
              } else {
                FirebaseFirestore.instance
                    .collection('Colleges/PICT/Doubts')
                    .doc(widget.doubtId)
                    .update({
                  'upvotes': FieldValue.increment(-1),
                  'Upvoted By': FieldValue.arrayRemove([uid])
                });
                setState(() {
                  widget.isUpvoted = false;
                });
              }
            }));
  }
}
