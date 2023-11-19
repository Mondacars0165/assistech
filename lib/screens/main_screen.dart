import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'qr_scan_screen.dart';
import 'package:assistech/screens/geofencing_status.dart';
import 'package:assistech/models/shared_preferences_service.dart';

class GeoFencingScreen extends StatefulWidget {
  const GeoFencingScreen({super.key});

  @override
  _GeoFencingScreenState createState() => _GeoFencingScreenState();
}

class _GeoFencingScreenState extends State<GeoFencingScreen> {
  int _selectedIndex = 1;
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  late YoutubePlayerController _youtubeController;
  bool _isVideoVisible = false;
  bool _showButton = true;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: 'aSQUg-h8G4s',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRScanScreen()),
        );
      } else if (index == 0) {
        _pauseVideo();
        _hideVideo();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const GeoFencingMonitorScreen(geofenceStream: null),
          ),
        );
      }
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Cerrar Sesión',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          content: const Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                TextButton(
                  child: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                  onPressed: () async {
                    await _sharedPreferencesService.clearUserDetails();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildYoutubePlayer() {
    return _isVideoVisible
        ? YoutubePlayer(
            controller: _youtubeController,
            liveUIColor: Colors.amber,
          )
        : Container();
  }

  void _pauseVideo() {
    if (_youtubeController.value.isPlaying) {
      _youtubeController.pause();
    }
  }

  void _hideVideo() {
    setState(() {
      _isVideoVisible = false;
      _showButton = true;
    });
  }

  void _showVideo() {
    setState(() {
      _isVideoVisible = true;
      _showButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bienvenido a la Pantalla de Geofencing',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          if (!_isVideoVisible)
            Column(
              children: [
                const Text(
                  'Presiona el botón para ver un video sobre cómo utilizar la aplicación.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _showVideo();
                  },
                  child: const Text('Mostrar Video'),
                ),
              ],
            ),
          if (_isVideoVisible) // Mostrar el botón "Ocultar Video" si el video está visible
            ElevatedButton(
              onPressed: () {
                _hideVideo();
              },
              child: const Text('Ocultar Video'),
            ),
          const SizedBox(height: 20.0),
          _buildYoutubePlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Geofencing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Escaneo QR',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Bienvenido a Assistech',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assest/icons/Arrow - Left 2.svg',
          width: 20,
          height: 20,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: _showLogoutDialog,
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'assest/icons/dots.svg',
              width: 5,
              height: 5,
            ),
          ),
        ),
      ],
    );
  }
}
