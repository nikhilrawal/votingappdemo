class Candidate {
  final String id;
  final String name;
  final String party;
  final int votecount; // Changed to match backend (was `voteCount`)
  final List<dynamic>? votes; // Added field to match backend

  Candidate({
    required this.id,
    required this.name,
    required this.party,
    required this.votecount,
    this.votes, // Optional since it's not always used
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['_id'],
      name: json['name'],
      party: json['party'],
      votecount: json['votecount'] ?? 0, // Match backend's lowercase
      votes: json['votes'], // Include votes field if provided
    );
  }
}
