import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_santa/core/enums/group_state.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.title,
    super.description,
    required super.authorUID,
    required super.participantsUIDs,
    required super.budgetLimit,
    required super.currency,
    required super.eventDate,
    required super.createdAt,
    required super.inviteCode,
    required super.state,
  });

  // 1. TWORZENIE Z SNAPSHOTA FIREBASE (Odczyt)
  factory GroupModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GroupModel(
      id: doc.id, // ID bierzemy z dokumentu, nie z pola w środku
      title: data['title'] ?? '',
      description: data['description'],
      authorUID: data['authorUID'] ?? '',
      
      participantsUIDs: List<String>.from(data['participantsUIDs'] ?? []),
      
      budgetLimit: (data['budgetLimit'] ?? 0).toInt(),
      currency: data['currency'] ?? 'PLN',
      
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      
      inviteCode: data['inviteCode'] ?? '',
      
      state: _stringToState(data['state']),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'authorUID': authorUID,
      'participantsUIDs': participantsUIDs,
      'budgetLimit': budgetLimit,
      'currency': currency,
      'eventDate': Timestamp.fromDate(eventDate), // DateTime -> Timestamp
      'createdAt': Timestamp.fromDate(createdAt),
      'inviteCode': inviteCode,
      'state': state.name, // Enum -> String ("recruiting")
    };
  }

  static GroupState _stringToState(String? stateStr) {
    return GroupState.values.firstWhere(
      (e) => e.name == stateStr,
      orElse: () => GroupState.draft,
    );
  }

  static String generateGroupCode() {
    const length = 6;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = DateTime.now().millisecondsSinceEpoch;
    final code = List.generate(length, (index) {
      final charIndex = (rand + index) % chars.length;
      return chars[charIndex];
    }).join();
    return code;
  }
}