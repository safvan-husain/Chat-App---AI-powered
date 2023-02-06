// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_schema.dart';

// ignore_for_file: type=lint
class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receiverIdMeta =
      const VerificationMeta('receiverId');
  @override
  late final GeneratedColumn<String> receiverId = GeneratedColumn<String>(
      'receiver_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, senderId, receiverId, content];
  @override
  String get aliasedName => _alias ?? 'messages';
  @override
  String get actualTableName => 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    }
    if (data.containsKey('receiver_id')) {
      context.handle(
          _receiverIdMeta,
          receiverId.isAcceptableOrUnknown(
              data['receiver_id']!, _receiverIdMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id']),
      receiverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receiver_id']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final int id;
  final String? senderId;
  final String? receiverId;
  final String content;
  const Message(
      {required this.id,
      this.senderId,
      this.receiverId,
      required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || senderId != null) {
      map['sender_id'] = Variable<String>(senderId);
    }
    if (!nullToAbsent || receiverId != null) {
      map['receiver_id'] = Variable<String>(receiverId);
    }
    map['content'] = Variable<String>(content);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      senderId: senderId == null && nullToAbsent
          ? const Value.absent()
          : Value(senderId),
      receiverId: receiverId == null && nullToAbsent
          ? const Value.absent()
          : Value(receiverId),
      content: Value(content),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<int>(json['id']),
      senderId: serializer.fromJson<String?>(json['senderId']),
      receiverId: serializer.fromJson<String?>(json['receiverId']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'senderId': serializer.toJson<String?>(senderId),
      'receiverId': serializer.toJson<String?>(receiverId),
      'content': serializer.toJson<String>(content),
    };
  }

  Message copyWith(
          {int? id,
          Value<String?> senderId = const Value.absent(),
          Value<String?> receiverId = const Value.absent(),
          String? content}) =>
      Message(
        id: id ?? this.id,
        senderId: senderId.present ? senderId.value : this.senderId,
        receiverId: receiverId.present ? receiverId.value : this.receiverId,
        content: content ?? this.content,
      );
  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, senderId, receiverId, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.senderId == this.senderId &&
          other.receiverId == this.receiverId &&
          other.content == this.content);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<int> id;
  final Value<String?> senderId;
  final Value<String?> receiverId;
  final Value<String> content;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.senderId = const Value.absent(),
    this.receiverId = const Value.absent(),
    this.content = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    this.senderId = const Value.absent(),
    this.receiverId = const Value.absent(),
    required String content,
  }) : content = Value(content);
  static Insertable<Message> custom({
    Expression<int>? id,
    Expression<String>? senderId,
    Expression<String>? receiverId,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (senderId != null) 'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      if (content != null) 'content': content,
    });
  }

  MessagesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? senderId,
      Value<String?>? receiverId,
      Value<String>? content}) {
    return MessagesCompanion(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (receiverId.present) {
      map['receiver_id'] = Variable<String>(receiverId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $MessagesTable messages = $MessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [messages];
}
