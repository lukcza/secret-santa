import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.title,
    super.description,
    required super.authorUID,
    required super.participants,
    required super.participantsUIDs,
    required super.budgetLimit,
    required super.currency,
    required super.eventDate,
    required super.createdAt,
    required super.inviteCode,
    required super.state,
    super.excludedPairs,
    super.matches,
  });
  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      authorUID: entity.authorUID,
      participants: entity.participants,
      participantsUIDs: entity.participantsUIDs,
      budgetLimit: entity.budgetLimit,
      currency: entity.currency,
      eventDate: entity.eventDate,
      createdAt: entity.createdAt,
      inviteCode: entity.inviteCode,
      state: entity.state,
      excludedPairs: entity.excludedPairs,
      matches: entity.matches,
    );
  }
  factory GroupModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GroupModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      authorUID: data['authorUID'] ?? '',
      participantsUIDs: List<String>.from(data['participantsUIDs'] ?? []),
      participants: (data['participants'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, _stringToUserStatus(value)),
      ),
      budgetLimit: (data['budgetLimit'] ?? 0).toInt(),
      currency: data['currency'] ?? 'PLN',

      eventDate: (data['eventDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),

      inviteCode: data['inviteCode'] ?? '',

      state: _stringToState(data['state']),
      excludedPairs:
          data['excludedPairs'] == null
              ? const {}
              : Map<String, List<String>>.from(
                data['excludedPairs'] as Map<String, dynamic>,
              ),
      matches:
          data['matches'] == null
              ? const {}
              : Map<String, String>.from(
                data['matches'] as Map<String, dynamic>,
              ),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'authorUID': authorUID,
      'participantsUIDs': participantsUIDs,
      'participants': participants.map(
        (key, value) => MapEntry(key, value.name),
      ),
      'budgetLimit': budgetLimit,
      'currency': currency,
      'eventDate': Timestamp.fromDate(eventDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'inviteCode': inviteCode,
      'state': state.name,
      'excludedPairs': excludedPairs,
      'matches': matches,
    };
  }

  static UserStatus _stringToUserStatus(String? statusStr) {
    return UserStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => UserStatus.pending,
    );
  }

  static GroupStatus _stringToState(String? stateStr) {
    return GroupStatus.values.firstWhere(
      (e) => e.name == stateStr,
      orElse: () => GroupStatus.draft,
    );
  }

  static String generateGroupCode() {
    const length = 6;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = DateTime.now().millisecondsSinceEpoch;
    final code =
        List.generate(length, (index) {
          final charIndex = (rand + index) % chars.length;
          return chars[charIndex];
        }).join();
    return code;
  }

  GroupModel copyWith({
    String? id,
    String? title,
    String? description,
    String? authorUID,
    Map<String, UserStatus>? participants,
    List<String>? participantsUIDs,
    int? budgetLimit,
    String? currency,
    DateTime? eventDate,
    DateTime? createdAt,
    String? inviteCode,
    GroupStatus? state,
    Map<String, List<String>>? excludedPairs,
    Map<String, String>? matches,
  }) {
    return GroupModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorUID: authorUID ?? this.authorUID,
      participants: participants ?? this.participants,
      participantsUIDs: participantsUIDs ?? this.participantsUIDs,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      currency: currency ?? this.currency,
      eventDate: eventDate ?? this.eventDate,
      createdAt: createdAt ?? this.createdAt,
      inviteCode: inviteCode ?? this.inviteCode,
      state: state ?? this.state,
      excludedPairs: excludedPairs ?? this.excludedPairs,
      matches: matches ?? this.matches,
    );
  }
}
