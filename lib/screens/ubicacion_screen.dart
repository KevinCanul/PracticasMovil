import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/lugar.dart';
import '../services/ubicacion_service.dart';

class UbicacionScreen extends StatefulWidget {
  const UbicacionScreen({super.key});

  @override
  State<UbicacionScreen> createState() => _UbicacionScreenState();
}

class _UbicacionScreenState extends State<UbicacionScreen> {
  final UbicacionService _ubicacionService = UbicacionService();

  final TextEditingController _nombreController = TextEditingController();

  Position? _posicionActual;

  bool _cargando = false;
  String _mensaje = 'Presiona el botón para obtener tu ubicación.';

  final List<Lugar> _lugares = [];

  Future<void> _obtenerUbicacion() async {
    setState(() {
      _cargando = true;
      _mensaje = 'Obteniendo ubicación...';
    });

    try {
      final posicion = await _ubicacionService.obtenerUbicacion();

      if (!mounted) return;

      setState(() {
        _posicionActual = posicion;
        _mensaje = 'Ubicación obtenida correctamente.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _mensaje = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  void _guardarLugar() {
    if (_posicionActual == null) {
      _mostrarMensaje('Primero obtén tu ubicación actual.');
      return;
    }

    final nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      _mostrarMensaje('Escribe un nombre para el lugar.');
      return;
    }

    setState(() {
      _lugares.add(
        Lugar(
          nombre: nombre,
          latitud: _posicionActual!.latitude,
          longitud: _posicionActual!.longitude,
        ),
      );

      _nombreController.clear();
    });

    _mostrarMensaje('Lugar guardado correctamente.');
  }

  Future<void> _abrirMapa(double latitud, double longitud) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud',
    );

    final resultado = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!resultado && mounted) {
      _mostrarMensaje('No se pudo abrir el mapa.');
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  String _formatearDistancia(Lugar lugar) {
    if (_posicionActual == null) {
      return 'Distancia no disponible';
    }

    final distancia = _ubicacionService.calcularDistancia(
      _posicionActual!.latitude,
      _posicionActual!.longitude,
      lugar.latitud,
      lugar.longitud,
    );

    if (distancia >= 1000) {
      return '${(distancia / 1000).toStringAsFixed(2)} km';
    }

    return '${distancia.toStringAsFixed(2)} m';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de Interés GPS'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.location_on, size: 85, color: Colors.green),
            const Text(
              'Mi ubicación actual',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(_mensaje, textAlign: TextAlign.center),
                    const SizedBox(height: 15),

                    if (_posicionActual != null) ...[
                      _dato(
                        'Latitud',
                        _posicionActual!.latitude.toStringAsFixed(6),
                      ),
                      _dato(
                        'Longitud',
                        _posicionActual!.longitude.toStringAsFixed(6),
                      ),
                      _dato(
                        'Precisión',
                        '${_posicionActual!.accuracy.toStringAsFixed(2)} m',
                      ),
                    ],

                    const SizedBox(height: 15),

                    FilledButton.icon(
                      onPressed: _cargando ? null : _obtenerUbicacion,
                      icon: const Icon(Icons.gps_fixed),
                      label: Text(
                        _cargando ? 'Obteniendo...' : 'Obtener ubicación',
                      ),
                    ),

                    if (_posicionActual != null)
                      OutlinedButton.icon(
                        onPressed: () => _abrirMapa(
                          _posicionActual!.latitude,
                          _posicionActual!.longitude,
                        ),
                        icon: const Icon(Icons.map),
                        label: const Text('Abrir en Google Maps'),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Guardar punto de interés',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del lugar',
                hintText: 'Ej. Mi casa, Escuela, Parque...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place),
              ),
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: _guardarLugar,
              icon: const Icon(Icons.save),
              label: const Text('Guardar ubicación actual'),
            ),

            const SizedBox(height: 25),

            Text(
              'Mis puntos de interés (${_lugares.length})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            if (_lugares.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Todavía no tienes lugares guardados.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            ..._lugares.map((lugar) {
              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 35,
                  ),
                  title: Text(
                    lugar.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lat: ${lugar.latitud.toStringAsFixed(6)}'),
                      Text('Long: ${lugar.longitud.toStringAsFixed(6)}'),
                      Text('Distancia: ${_formatearDistancia(lugar)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () => _abrirMapa(lugar.latitud, lugar.longitud),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _dato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(valor, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
