

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicProvider extends ChangeNotifier {
  
  final player = AudioPlayer();

  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [   
      // Specify the playlist items ...
      AudioSource.asset('assets/musics/deadopsmin.mp3'),
      AudioSource.asset('assets/musics/domin.mp3'),
      AudioSource.asset('assets/musics/elevenmin.mp3'),
      AudioSource.asset('assets/musics/mikemin.mp3'),
      AudioSource.asset('assets/musics/shamelessmin.mp3'),
      AudioSource.asset('assets/musics/wyamin.mp3'),
      AudioSource.asset('assets/musics/xtcmin.mp3'),
    ],
  );

  final List<List<String>> playlistMetaData = [
    ["mthumb4.jpg", "Dead Opps", "Mapolo"],
    ["mthumb8.jpg", "Dominion", "Secret!, Jay Rettna"],
    ["mthumb2.jpg", "7 eleven", "N!X"],
    ["mthumb3.jpg", "Mike Will", "Parris Chariz, Starringo"],
    ["mthumb6.jpg", "Shameless", "Caleb Gordon"],
    ["mthumb7.jpg", "WYA", "Tre'Gadd"],
    ["mthumb5.jpg", "XTC", "K-SEE"],
  ];


  void initializeMusics({required double initVolume}) {
    // ! init musics ......
    // Load and play the playlist
    player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);
    player.setLoopMode(LoopMode.all);        // Set playlist to loop (off|all|one)
    player.setShuffleModeEnabled(true); 
    player.setVolume(initVolume);
    player.shuffle();
    // player.play();
    
    // notifyListeners();
  }

  void pauseOrPlayMusic() {
    player.playing ? player.pause() : player.play();
    // notifyListeners();
  }

  void updateMusicVolume(double value) {
    if(value > 1) {
      player.setVolume(1);
      return;
    }

    player.setVolume(value);
    // notifyListeners();
  }
}