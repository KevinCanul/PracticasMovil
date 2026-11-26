# \# Práctica 8: GPS, Geolocalización y Mapas

# 

# \## Objetivo

# 

# Desarrollar una aplicación móvil en Flutter que permita obtener la ubicación actual del dispositivo, mostrar sus coordenadas geográficas, guardar puntos de interés y consultar su ubicación mediante Google Maps.

# 

# \## Características

# 

# \- Solicitud y manejo de permisos de ubicación.

# \- Obtención de latitud y longitud mediante GPS.

# \- Visualización de la precisión de la ubicación.

# \- Registro de puntos de interés con nombre.

# \- Cálculo de distancias mediante `Geolocator.distanceBetween`.

# \- Apertura de ubicaciones en Google Maps.

# 

# \## Tecnologías y paquetes

# 

# \- Flutter

# \- Dart

# \- geolocator

# \- url\_launcher

# \- Android

# 

# \## Requisitos

# 

# \- Flutter instalado.

# \- Dart SDK.

# \- Android SDK y ADB.

# \- Dispositivo Android con ubicación activada.

# \- Git.

# 

# \## Instalación

# 

# Clonar el repositorio:

# 

# ```bash

# git clone https://github.com/KevinCanul/PracticasMovil.git

# ```

# 

# Entrar a la carpeta del proyecto correspondiente y descargar las dependencias:

# 

# ```bash

# flutter pub get

# ```

# 

# \## Ejecución

# 

# Conectar un dispositivo Android y comprobar que Flutter lo detecte:

# 

# ```bash

# flutter devices

# ```

# 

# Ejecutar la aplicación:

# 

# ```bash

# flutter run

# ```

# 

# \## Permisos de Android

# 

# La aplicación utiliza los siguientes permisos:

# 

# \- ACCESS\_FINE\_LOCATION

# \- ACCESS\_COARSE\_LOCATION

# 

# Los permisos se solicitan durante la ejecución de la aplicación.

# 

# \## Pruebas realizadas

# 

# | Prueba | Resultado |

# |---|---|

# | Obtención de ubicación GPS | Correcta |

# | Visualización de latitud y longitud | Correcta |

# | Visualización de precisión | Correcta |

# | Apertura de Google Maps | Correcta |

# | Registro de tres puntos de interés | Correcto |

# | flutter analyze | Sin problemas |

# | flutter test | All tests passed |

# 

# \*\*Nota:\*\* Los tres puntos registrados durante las pruebas utilizaron las mismas coordenadas, por lo que sus distancias aparecen como 0.00 m. Queda pendiente comprobar distancias entre ubicaciones geográficas diferentes.

# 

# \## Estructura principal

# 

# ```text

# lib/

# ├── main.dart

# ├── models/

# │   └── lugar.dart

# ├── screens/

# │   └── ubicacion\_screen.dart

# └── services/

# &#x20;   └── ubicacion\_service.dart

# 

# docs/

# └── evidencias/

# &#x20;   └── practica-08/

# ```

# 

# \## Evidencias

# 

# Las capturas de pantalla y demás evidencias de funcionamiento se encuentran en:

# 

# `docs/evidencias/practica-08/`

# 

# \## Participantes

# 

# \- Nombre del estudiante: \[Escribir nombre]

# 

# \## Repositorio

# 

# https://github.com/KevinCanul/PracticasMovil.git

# 

# \## Rama de trabajo

# 

# `practica-08-geolocalizacion`



