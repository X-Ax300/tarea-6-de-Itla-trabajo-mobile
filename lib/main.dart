import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea 6',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarea 6 (Tools)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Image.network(
                'https://i.pinimg.com/564x/af/b9/55/afb955a4b15e57542be06618b7677d4c.jpg',  // Reemplaza con la URL de tu logo
                width: 200,  // Ajusta el tamaño si es necesario
                height: 200,
              ),
            ),
            const SizedBox(height: 20),  // Añadir espacio entre la imagen y las tarjetas
            _buildCard(
              context,
              title: 'Predecir género',
              icon: Icons.person_search,
              screen: const GenderPredictorScreen(),
            ),
            _buildCard(
              context,
              title: 'Determinar edad',
              icon: Icons.cake,
              screen: const AgePredictorScreen(),
            ),
            _buildCard(
              context,
              title: 'Listar universidades',
              icon: Icons.school,
              screen: const UniversityListScreen(),
            ),
            _buildCard(
              context,
              title: 'Clima en RD',
              icon: Icons.wb_sunny,
              screen: WeatherApp(),  // Cambia `WeatherScreen` por `WeatherApp`
            ),
            _buildCard(
              context,
              title: 'Noticias de WordPress',
              icon: Icons.article,
              screen: const WordPressNewsScreen(),
            ),
            _buildCard(
              context,
              title: 'Acerca de',
              icon: Icons.info,
              screen: const AboutScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Widget screen}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
      ),
    );
  }
}



class GenderPredictorScreen extends StatefulWidget {
  const GenderPredictorScreen({super.key});

  @override
  _GenderPredictorScreenState createState() => _GenderPredictorScreenState();
}

class _GenderPredictorScreenState extends State<GenderPredictorScreen> {
  final TextEditingController _controller = TextEditingController();
  String _gender = '';

  void _predictGender() async {
    final response = await http.get(
      Uri.parse('https://api.genderize.io/?name=${_controller.text}'),
    );
    final data = jsonDecode(response.body);
    setState(() {
      _gender = data['gender'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predecir género'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _predictGender,
              child: const Text('Predecir género'),
            ),
            const SizedBox(height: 16),
            if (_gender.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: _gender == 'male' ? Colors.blue : Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text('Género: $_gender', style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }
}

class AgePredictorScreen extends StatefulWidget {
  const AgePredictorScreen({super.key});

  @override
  _AgePredictorScreenState createState() => _AgePredictorScreenState();
}

class _AgePredictorScreenState extends State<AgePredictorScreen> {
  final TextEditingController _controller = TextEditingController();
  int _age = 0;
  String _category = '';

  void _predictAge() async {
    final response = await http.get(
      Uri.parse('https://api.agify.io/?name=${_controller.text}'),
    );
    final data = jsonDecode(response.body);
    setState(() {
      _age = data['age'];
      if (_age < 18) {
        _category = 'Joven';
      } else if (_age < 60) {
        _category = 'Adulto';
      } else {
        _category = 'Anciano';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Determinar edad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _predictAge,
              child: const Text('Determinar edad'),
            ),
            const SizedBox(height: 16),
            if (_age != 0)
              Column(
                children: [
                  Text('Edad: $_age', style: const TextStyle(fontSize: 16)),
                  Text('Categoría: $_category', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Image.network(
                    _category == 'Joven'
                        ? 'https://media.istockphoto.com/id/1273871774/es/foto/joven-joven-%C3%A1rabe-guapo-hombre-que-lleva-camiseta-blanca-casual-cara-feliz-sonriendo-con-los.jpg?s=612x612&w=0&k=20&c=26Su4ruTsO9ppelZcIrHdog54BV43qFc-UE92wlNh_A='
                        : _category == 'Adulto'
                        ? 'https://media.istockphoto.com/id/1363627613/es/foto/grupo-multirracial-de-j%C3%B3venes-amigos-que-se-unen-al-aire-libre.jpg?s=1024x1024&w=is&k=20&c=aHwTEF95KUIsoNPvhF7BXDXaKjgmuivBc3KucQoF-wc='
                        : 'https://blog.familiados.com/wp-content/uploads/2019/06/actividad-fisica-personas-mayores.jpg',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class UniversityListScreen extends StatefulWidget {
  const UniversityListScreen({super.key});

  @override
  _UniversityListScreenState createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  final TextEditingController _controller = TextEditingController();
  List _universities = [];

  void _fetchUniversities() async {
    final response = await http.get(
      Uri.parse('http://universities.hipolabs.com/search?country=${_controller.text}'),
    );
    final data = jsonDecode(response.body);
    setState(() {
      _universities = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar universidades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre del país',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUniversities,
              child: const Text('Buscar universidades'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _universities.length,
                itemBuilder: (context, index) {
                  final university = _universities[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(university['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(university['domains'].join(', ')),
                      trailing: IconButton(
                        icon: const Icon(Icons.link, color: Colors.deepPurple),
                        onPressed: () {
                          launchUrlString(university['web_pages'][0]);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _location = '';
  String _icon = '';
  String _temperature = '';
  String _condition = '';
  String _lastUpdated = '';
  String _humidity = '';
  String _wind = '';
  String _pressure = '';
  String _precipitation = '';
  String _visibility = '';
  String _videoUrl = '';
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _isVideoReady = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.weatherapi.com/v1/current.json?key=f10ff789c81f46a4bf8142925242906&q=Santo%20Domingo'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _location =
          '${data['location']['name'] ?? 'Unknown'}, ${data['location']['region'] ?? 'Unknown'}, ${data['location']['country'] ?? 'Unknown'}';
          _icon = 'https:${data['current']['condition']['icon'] ?? '//cdn.weatherapi.com/weather/64x64/day/116.png'}';
          _temperature = '${data['current']['temp_c'] ?? 'N/A'} °C';
          _condition = data['current']['condition']['text'] ?? 'Unknown';
          _lastUpdated = data['current']['last_updated'] ?? 'N/A';
          _humidity = '${data['current']['humidity'] ?? 'N/A'}%';
          _wind = '${data['current']['wind_kph'] ?? 'N/A'} kph ${data['current']['wind_dir'] ?? ''}';
          _pressure = '${data['current']['pressure_mb'] ?? 'N/A'} mb';
          _precipitation = '${data['current']['precip_mm'] ?? 'N/A'} mm';
          _visibility = '${data['current']['vis_km'] ?? 'N/A'} km';
          _videoUrl = _getVideoUrl(data['current']['condition']['code']);
        });

        _initVideoPlayer();
      } else {
        print('Failed to load weather data: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isVideoReady = true;
          _isLoading = false;
          _controller.play();
          _controller.setLooping(true);
        });
      }).catchError((error) {
        print('Error initializing video player: $error');
        setState(() {
          _isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getVideoUrl(int conditionCode) {
    if (conditionCode == 1000) {
      return 'https://www.youtube.com/watch?v=qrT3472kgF8'; // Video para clima soleado
    } else if (conditionCode == 1003) {
      return 'https://www.youtube.com/watch?v=lEVoGb9KJkM'; // Video para parcialmente nublado
    } else if (conditionCode == 1006) {
      return 'https://www.youtube.com/watch?v=G_H3j8EZCvs'; // Video para nublado
    } else if (conditionCode >= 1009 && conditionCode <= 1030) {
      return 'https://www.youtube.com/watch?v=wcPXS8cTCFk'; // Video para niebla
    } else if (conditionCode >= 1063 && conditionCode <= 1246) {
      return 'https://www.youtube.com/watch?v=c9pQYOGIWM8'; // Video para lluvia
    } else {
      return 'https://www.youtube.com/watch?v=pPC0peJkwTk'; // Video por defecto
    }
  }

  Widget _buildWeatherDetail({required IconData icon, required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en RD'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          if (_isVideoReady)
            Positioned.fill(
              child: VideoPlayer(_controller),
            ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(_icon, width: 100, height: 100),
                    const SizedBox(height: 16),
                    Text(
                      _location,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_temperature - $_condition',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildWeatherDetail(
                        icon: Icons.water_drop,
                        label: 'Humedad',
                        value: _humidity),
                    _buildWeatherDetail(
                        icon: Icons.air,
                        label: 'Viento',
                        value: _wind),
                    _buildWeatherDetail(
                        icon: Icons.compress,
                        label: 'Presión',
                        value: _pressure),
                    _buildWeatherDetail(
                        icon: Icons.opacity,
                        label: 'Precipitación',
                        value: _precipitation),
                    _buildWeatherDetail(
                        icon: Icons.visibility,
                        label: 'Visibilidad',
                        value: _visibility),
                    const SizedBox(height: 16),
                    Text(
                      'Última actualización: $_lastUpdated',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class WordPressNewsScreen extends StatefulWidget {
  const WordPressNewsScreen({super.key});

  @override
  _WordPressNewsScreenState createState() => _WordPressNewsScreenState();
}

class _WordPressNewsScreenState extends State<WordPressNewsScreen> {
  List _posts = [];

  void _fetchPosts() async {
    final response = await http.get(Uri.parse('https://www.nasa.gov/wp-json/wp/v2/posts'));
    final data = jsonDecode(response.body);
    setState(() {
      _posts = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias de WordPress'),
      ),
      body: _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(post['title']['rendered'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(post['excerpt']['rendered'].replaceAll(RegExp(r'<[^>]*>'), '')),
              trailing: IconButton(
                icon: const Icon(Icons.link, color: Colors.deepPurple),
                onPressed: () {
                  launchUrlString(post['link']);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/f1.jpeg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nombre: Edyson Alexander Mendez De La Paz',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Correo: alexandermendez3002600@gmail.com',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Teléfono: +1 (809)-962-1907',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
