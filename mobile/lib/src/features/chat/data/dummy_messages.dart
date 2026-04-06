import '../models/message.dart';

final List<Message> dummyMessages = [
  Message(
    id: 'm1',
    text: 'Hi, is the MacBook still available?',
    isMine: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Message(
    id: 'm2',
    text: 'Yes it is! Are you interested?',
    isMine: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  Message(
    id: 'm3',
    text: 'Great. Does it come with the charger?',
    isMine: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
  ),
  Message(
    id: 'm4',
    text: 'It includes the original 67W adapter.',
    isMine: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
  ),
  Message(
    id: 'm5',
    text: 'Awesome. Would you accept \$1100 for it?',
    isMine: true,
    timestamp: DateTime.now(),
  ),
];
