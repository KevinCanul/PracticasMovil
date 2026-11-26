import 'package:geolocator/geolocator.dart';

class UbicacionService {
  Future<Position> obtenerUbicacion() async {
    // Comprobar si el GPS está activado.
    final servicioActivo = await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      throw Exception('Activa el servicio de ubicación del dispositivo.');
    }

    // Comprobar permisos.
    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied) {
      throw Exception('No se concedió el permiso de ubicación.');
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'El permiso está bloqueado. Debes habilitarlo '
        'desde los ajustes del dispositivo.',
      );
    }

    // Obtener coordenadas actuales.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  double calcularDistancia(
    double latitudInicial,
    double longitudInicial,
    double latitudFinal,
    double longitudFinal,
  ) {
    return Geolocator.distanceBetween(
      latitudInicial,
      longitudInicial,
      latitudFinal,
      longitudFinal,
    );
  }
}
