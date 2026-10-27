// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chain_database.dart';

// ignore_for_file: type=lint
class $StoredBlocksTable extends StoredBlocks
    with TableInfo<$StoredBlocksTable, StoredBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _blockIndexMeta = const VerificationMeta(
    'blockIndex',
  );
  @override
  late final GeneratedColumn<int> blockIndex = GeneratedColumn<int>(
    'block_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [blockIndex, hash, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredBlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('block_index')) {
      context.handle(
        _blockIndexMeta,
        blockIndex.isAcceptableOrUnknown(data['block_index']!, _blockIndexMeta),
      );
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {blockIndex};
  @override
  StoredBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredBlock(
      blockIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_index'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $StoredBlocksTable createAlias(String alias) {
    return $StoredBlocksTable(attachedDatabase, alias);
  }
}

class StoredBlock extends DataClass implements Insertable<StoredBlock> {
  final int blockIndex;
  final String hash;
  final String json;
  const StoredBlock({
    required this.blockIndex,
    required this.hash,
    required this.json,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['block_index'] = Variable<int>(blockIndex);
    map['hash'] = Variable<String>(hash);
    map['json'] = Variable<String>(json);
    return map;
  }

  StoredBlocksCompanion toCompanion(bool nullToAbsent) {
    return StoredBlocksCompanion(
      blockIndex: Value(blockIndex),
      hash: Value(hash),
      json: Value(json),
    );
  }

  factory StoredBlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredBlock(
      blockIndex: serializer.fromJson<int>(json['blockIndex']),
      hash: serializer.fromJson<String>(json['hash']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'blockIndex': serializer.toJson<int>(blockIndex),
      'hash': serializer.toJson<String>(hash),
      'json': serializer.toJson<String>(json),
    };
  }

  StoredBlock copyWith({int? blockIndex, String? hash, String? json}) =>
      StoredBlock(
        blockIndex: blockIndex ?? this.blockIndex,
        hash: hash ?? this.hash,
        json: json ?? this.json,
      );
  StoredBlock copyWithCompanion(StoredBlocksCompanion data) {
    return StoredBlock(
      blockIndex: data.blockIndex.present
          ? data.blockIndex.value
          : this.blockIndex,
      hash: data.hash.present ? data.hash.value : this.hash,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredBlock(')
          ..write('blockIndex: $blockIndex, ')
          ..write('hash: $hash, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(blockIndex, hash, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredBlock &&
          other.blockIndex == this.blockIndex &&
          other.hash == this.hash &&
          other.json == this.json);
}

class StoredBlocksCompanion extends UpdateCompanion<StoredBlock> {
  final Value<int> blockIndex;
  final Value<String> hash;
  final Value<String> json;
  const StoredBlocksCompanion({
    this.blockIndex = const Value.absent(),
    this.hash = const Value.absent(),
    this.json = const Value.absent(),
  });
  StoredBlocksCompanion.insert({
    this.blockIndex = const Value.absent(),
    required String hash,
    required String json,
  }) : hash = Value(hash),
       json = Value(json);
  static Insertable<StoredBlock> custom({
    Expression<int>? blockIndex,
    Expression<String>? hash,
    Expression<String>? json,
  }) {
    return RawValuesInsertable({
      if (blockIndex != null) 'block_index': blockIndex,
      if (hash != null) 'hash': hash,
      if (json != null) 'json': json,
    });
  }

  StoredBlocksCompanion copyWith({
    Value<int>? blockIndex,
    Value<String>? hash,
    Value<String>? json,
  }) {
    return StoredBlocksCompanion(
      blockIndex: blockIndex ?? this.blockIndex,
      hash: hash ?? this.hash,
      json: json ?? this.json,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (blockIndex.present) {
      map['block_index'] = Variable<int>(blockIndex.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredBlocksCompanion(')
          ..write('blockIndex: $blockIndex, ')
          ..write('hash: $hash, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }
}

abstract class _$ChainDatabase extends GeneratedDatabase {
  _$ChainDatabase(QueryExecutor e) : super(e);
  $ChainDatabaseManager get managers => $ChainDatabaseManager(this);
  late final $StoredBlocksTable storedBlocks = $StoredBlocksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [storedBlocks];
}

typedef $$StoredBlocksTableCreateCompanionBuilder =
    StoredBlocksCompanion Function({
      Value<int> blockIndex,
      required String hash,
      required String json,
    });
typedef $$StoredBlocksTableUpdateCompanionBuilder =
    StoredBlocksCompanion Function({
      Value<int> blockIndex,
      Value<String> hash,
      Value<String> json,
    });

class $$StoredBlocksTableFilterComposer
    extends Composer<_$ChainDatabase, $StoredBlocksTable> {
  $$StoredBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoredBlocksTableOrderingComposer
    extends Composer<_$ChainDatabase, $StoredBlocksTable> {
  $$StoredBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredBlocksTableAnnotationComposer
    extends Composer<_$ChainDatabase, $StoredBlocksTable> {
  $$StoredBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$StoredBlocksTableTableManager
    extends
        RootTableManager<
          _$ChainDatabase,
          $StoredBlocksTable,
          StoredBlock,
          $$StoredBlocksTableFilterComposer,
          $$StoredBlocksTableOrderingComposer,
          $$StoredBlocksTableAnnotationComposer,
          $$StoredBlocksTableCreateCompanionBuilder,
          $$StoredBlocksTableUpdateCompanionBuilder,
          (
            StoredBlock,
            BaseReferences<_$ChainDatabase, $StoredBlocksTable, StoredBlock>,
          ),
          StoredBlock,
          PrefetchHooks Function()
        > {
  $$StoredBlocksTableTableManager(_$ChainDatabase db, $StoredBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> blockIndex = const Value.absent(),
                Value<String> hash = const Value.absent(),
                Value<String> json = const Value.absent(),
              }) => StoredBlocksCompanion(
                blockIndex: blockIndex,
                hash: hash,
                json: json,
              ),
          createCompanionCallback:
              ({
                Value<int> blockIndex = const Value.absent(),
                required String hash,
                required String json,
              }) => StoredBlocksCompanion.insert(
                blockIndex: blockIndex,
                hash: hash,
                json: json,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredBlocksTable, StoredBlock>(table),
                  BaseReferences<
                    _$ChainDatabase,
                    $StoredBlocksTable,
                    StoredBlock
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$ChainDatabase,
      $StoredBlocksTable,
      StoredBlock,
      $$StoredBlocksTableFilterComposer,
      $$StoredBlocksTableOrderingComposer,
      $$StoredBlocksTableAnnotationComposer,
      $$StoredBlocksTableCreateCompanionBuilder,
      $$StoredBlocksTableUpdateCompanionBuilder,
      (
        StoredBlock,
        BaseReferences<_$ChainDatabase, $StoredBlocksTable, StoredBlock>,
      ),
      StoredBlock,
      PrefetchHooks Function()
    >;

class $ChainDatabaseManager {
  final _$ChainDatabase _db;
  $ChainDatabaseManager(this._db);
  $$StoredBlocksTableTableManager get storedBlocks =>
      $$StoredBlocksTableTableManager(_db, _db.storedBlocks);
}
