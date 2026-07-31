import 'package:beacon/base/data/db/db.dart';
import 'package:beacon/base/data/dto/app_dto.dart';
import 'package:beacon/base/data/models/app_model.dart';
import 'package:beacon/base/data/models/result_model.dart';
import 'package:sdk_helpers/sdk_helpers.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppDao<M extends AppModel> with LoggerMixin {
  const AppDao({required this.table, required this.mapper});

  Database get db => Db.instance.db;

  final String table;
  final M Function(Map<String, dynamic>) mapper;

  Future<Result<List<M>>> getAll() async {
    try {
      final maps = await db.query(table);
      return Result.success(maps.map(mapper).toList());
    } catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<M>> getById(String id) async {
    try {
      if (!uuid.validateV4(id)) {
        e('Invalid id: $id');
        return Result.error('Invalid id: $id');
      }

      final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.error('Not found');

      return Result.success(mapper(maps.first));
    } catch (error) {
      e('Failed to get $table with id $id: $error');
      return Result.error(error);
    }
  }

  Future<Result<M>> insert(covariant AppDto insertDto) async {
    try {
      final id = uuid.v4();

      if (!insertDto.validate()) {
        e('Invalid insert DTO: $insertDto');
        return Result.error('Invalid insert DTO: $insertDto');
      }

      final json = {
        'id': id,
        ...insertDto.toJson(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await db.insert(table, json);

      return Result.success(mapper(json));
    } catch (error) {
      e('Failed to insert into $table: $error');
      return Result.error(error);
    }
  }

  Future<Result<M>> update(covariant AppDto updateDto) async {
    try {
      if (!uuid.validateV4(updateDto.id ?? '')) {
        e('Invalid id: ${updateDto.id}');
        return Result.error('Invalid id: ${updateDto.id}');
      }

      if (!updateDto.validate()) {
        e('Invalid update DTO: $updateDto');
        return Result.error('Invalid update DTO: $updateDto');
      }

      final json = {...updateDto.toJson(), 'updated_at': DateTime.now().toIso8601String()};

      await db.update(table, json, where: 'id = ?', whereArgs: [updateDto.id]);

      return Result.success(mapper(json));
    } catch (error) {
      e('Failed to update $table with id ${updateDto.id}: $error');
      return Result.error(error);
    }
  }

  Future<Result<M>> save(covariant AppDto saveDto) async =>
      saveDto.id == null ? await insert(saveDto) : await update(saveDto);

  Future<Result<int>> delete(String id) async {
    try {
      if (!uuid.validateV4(id)) {
        e('Invalid id: $id');
        return Result.error('Invalid id: $id');
      }

      final result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
      return Result.success(result);
    } catch (error) {
      e('Failed to delete from $table with id $id: $error');
      return Result.error(error);
    }
  }
}
