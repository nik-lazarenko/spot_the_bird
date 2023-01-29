import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/bird_post_model.dart';
import '../services/sqflite.dart';

part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

  final dbHelper = DatabaseHelper.instance;

  Future<void> loadPosts() async {
    emit(state.copyWith(status: BirdPostStatus.loading));


    List<BirdModel> birdPosts = [];

    final List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();

    if (rows.length == 0) {
      print("Rows are empty");
    } else {
      print("Rows have data");
    }

    // fetch data from db

    for (var row in rows) {
      birdPosts.add(BirdModel(
          id: row["id"],
          image: File(row["url"]),
          longitude: row["longitude"],
          latitude: row["latitude"],
          birdDescription: row["birdDescription"],
          birdName: row["birdName"]));
    }

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> addBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.add(birdModel);

    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle : birdModel.birdName,
      DatabaseHelper.columnDescription : birdModel.birdDescription,
      DatabaseHelper.latitude : birdModel.latitude,
      DatabaseHelper.longitude : birdModel.longitude,
      DatabaseHelper.columnUrl : birdModel.image.path
    };

    final int? id = await dbHelper.insert(row);

    birdModel.id = id;

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> removeBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;
    birdPosts.removeWhere((element) => element == birdModel);

    await dbHelper.delete(birdModel.id!);

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }


}
