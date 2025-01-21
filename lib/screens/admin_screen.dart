import 'package:flutter/material.dart';
import 'package:votingindia/api/api_service.dart';
import 'package:votingindia/models/candidate.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isLoading = true;
  String? _userRole;

  List<Candidate> _candidates = [];

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    _fetchCandidates();
  }

  Future<void> _fetchUserRole() async {
    try {
      _userRole = await ApiService.getUserRole();
      if (_userRole != 'admin') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unauthorized access")),
        );
        Navigator.pop(context); // Redirect non-admin users
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch user role: $e")),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _fetchCandidates() async {
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
        SnackBar(content: Text("Failed to fetch candidates: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCandidate(String candidateId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.deleteCandidate(candidateId);
      setState(() {
        _candidates.removeWhere((candidate) => candidate.id == candidateId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Candidate deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete candidate: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddCandidateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController partyController = TextEditingController();

        return AlertDialog(
          title: Text("Add Candidate"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Candidate Name"),
              ),
              TextField(
                controller: partyController,
                decoration: InputDecoration(labelText: "Party Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    partyController.text.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    await ApiService.addCandidate({
                      'name': nameController.text,
                      'party': partyController.text,
                    });
                    Navigator.of(context).pop();
                    _fetchCandidates();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add candidate: $e")),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin - Manage Candidates"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddCandidateDialog,
          ),
        ],
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
                    return ListTile(
                      title: Text(candidate.name),
                      subtitle: Text(candidate.party),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteCandidate(candidate.id),
                      ),
                      onTap: () {
                        // Optional: Implement candidate update functionality here.
                      },
                    );
                  },
                ),
    );
  }
}
