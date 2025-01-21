import 'package:flutter/material.dart';
import 'package:votingindia/api/api_service.dart';
import 'package:votingindia/models/candidate.dart';

class VoteScreen extends StatefulWidget {
  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  bool _isLoading = false;
  List<Candidate> _candidates = [];

  @override
  void initState() {
    super.initState();
    _getCandidates();
  }

  Future<void> _getCandidates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final candidates = await ApiService.getCandidates();
      setState(() {
        _candidates = candidates;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load candidates: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _voteForCandidate(String candidateId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.voteForCandidate(candidateId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vote successfully casted!")),
      );
      _getCandidates(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to cast vote: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vote for Candidates"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _candidates.isEmpty
              ? Center(
                  child: Text(
                    "No candidates available for voting.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: _candidates.length,
                  itemBuilder: (context, index) {
                    final candidate = _candidates[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text(
                          candidate.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          'Party: ${candidate.party}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _voteForCandidate(candidate.id),
                          child: Text("Vote"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
