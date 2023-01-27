import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bird_post_model.dart';

part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

  Future<void> loadPosts() async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<BirdModel> birdPosts = [];

    final List<String>? birdPostsJsonStringList =
        prefs.getStringList("birdPosts");

    if (birdPostsJsonStringList != null) {
      for (var postJsonData in birdPostsJsonStringList) {
        final Map<String, dynamic> data =
            await json.decode(postJsonData) as Map<String, dynamic>;
        final File imageFile = File(data["filePath"] as String);
        final String birdName = data["birdName"] as String;
        final String birdDescription = data["birdDescription"] as String;
        final double latitude = data["latitude"] as double;
        final double longitude = data["longitude"] as double;

        birdPosts.add(BirdModel(
            image: imageFile,
            longitude: longitude,
            latitude: latitude,
            birdDescription: birdDescription,
            birdName: birdName));
      }
    }

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));

  }

  Future<void> addBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.add(birdModel);

    _saveToSharedPrefs(birdPosts);

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  void removeBirdPost(BirdModel birdModel) {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;
    birdPosts.removeWhere((element) => element == birdModel);
    _saveToSharedPrefs(birdPosts);

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> _saveToSharedPrefs(List<BirdModel> posts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> jsonDataList = posts
        .map((post) => json.encode({
              "birdName": post.birdName,
              "birdDescription": post.birdDescription,
              "latitude": post.latitude,
              "longitude": post.longitude,
              "filePath": post.image.path,
            }))
        .toList();

    prefs.setStringList("birdPosts", jsonDataList);
  }
}
