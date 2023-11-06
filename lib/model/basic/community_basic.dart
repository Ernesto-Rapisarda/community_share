
class CommunityBasic {
  String id;
  String name;
  String docRef;

  CommunityBasic(
      {
        required this.id,
        required this.name,
        required this.docRef,
      });

  toJson() {
    return {
      'id': id,
      'name': name,
      'docRef': docRef
    };
  }

  factory CommunityBasic.fromJson(Map<String, dynamic> json) {
    return CommunityBasic(
        id: json['id'],
        name: json['name'],
        docRef: json['docRef']
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunityBasic &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          docRef == other.docRef;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ docRef.hashCode;

  @override
  String toString() {
    return 'CommunityBasic{id: $id, name: $name, docRef: $docRef}';
  }
}