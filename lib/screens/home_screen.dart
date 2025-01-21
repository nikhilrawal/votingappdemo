import 'package:flutter/material.dart';
import 'package:votingindia/api/api_service.dart';
import 'package:votingindia/models/candidate.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Candidates & Vote Counts",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _candidates.isEmpty
              ? Center(
                  child: Text(
                    "No candidates available.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: _candidates.length,
                  itemBuilder: (context, index) {
                    final candidate = _candidates[index];
                    return Card(
                      elevation: 4.0,
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
                        trailing: Text(
                          'Votes: ${candidate.votecount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
