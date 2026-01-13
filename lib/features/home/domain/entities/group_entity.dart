import 'package:equatable/equatable.dart';
import 'package:secret_santa/core/enums/group_state.dart';

class GroupEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String authorUID;
  final List<String> participantsUIDs;
  final int budgetLimit;
  final String currency;
  final DateTime eventDate;
  final DateTime createdAt;
  final String inviteCode;
  final GroupState state;

  const GroupEntity({
    required this.id,
    required this.title,
    this.description,
    required this.authorUID,
    required this.participantsUIDs,
    required this.budgetLimit,
    required this.currency,
    required this.eventDate,
    required this.createdAt,
    required this.inviteCode,
    required this.state,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        authorUID,
        participantsUIDs,
        budgetLimit,
        currency,
        eventDate,
        createdAt,
        inviteCode,
        state,
      ];
}