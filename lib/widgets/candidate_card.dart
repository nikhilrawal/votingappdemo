import 'package:flutter/material.dart';

class CandidateCard extends StatelessWidget {
  final String name;
  final String party;
  final int voteCount;
  final VoidCallback onVote;

  const CandidateCard({
    required this.name,
    required this.party,
    required this.voteCount,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(name),
        subtitle: Text(party),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Votes: $voteCount'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onVote,
              child: Text('Vote'),
            ),
          ],
        ),
      ),
    );
  }
}
