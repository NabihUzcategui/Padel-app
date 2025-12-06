# Coach IA - Análisis Inteligente de Partidos

El Coach IA es una funcionalidad que analiza el estado del partido en tiempo real y proporciona consejos contextuales, tips estratégicos y mensajes de motivación.

## Características

- ✅ **Análisis en tiempo real**: Analiza el estado actual del partido (sets, juegos, puntos)
- ✅ **Consejos contextuales**: Proporciona tips específicos según la situación
- ✅ **Mensajes de motivación**: Anima cuando estás perdiendo
- ✅ **Detección de momentos críticos**: Identifica match points, set points, break points, etc.
- ✅ **Funciona sin conexión**: Usa reglas inteligentes predefinidas

## Uso Actual

El coach está integrado en la página del partido. Simplemente presiona el botón "Análisis Coach IA" durante un partido para recibir consejos personalizados.

## Servicios Disponibles

### SmartCoachService (Actual - Sin API)

Este es el servicio por defecto que funciona sin conexión a internet. Usa reglas inteligentes predefinidas para analizar el partido y dar consejos contextuales.

**Ventajas:**
- ✅ Funciona sin conexión
- ✅ Respuesta instantánea
- ✅ Sin costos de API
- ✅ Consejos específicos para padel

### OpenAICoachService (Opcional - Requiere API Key)

Para usar inteligencia artificial real con OpenAI:

1. Agrega la dependencia en `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

2. Obtén una API key de OpenAI: https://platform.openai.com/api-keys

3. Actualiza `injection_container.dart`:
```dart
import 'features/coach/data/services/openai_coach_service.dart';

// En la función init():
sl.registerLazySingleton<AICoachService>(
  () => OpenAICoachService(apiKey: 'tu-api-key-aqui'),
);
```

### GeminiCoachService (Opcional - Requiere API Key)

Para usar Google Gemini:

1. Agrega la dependencia en `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

2. Obtén una API key de Google AI Studio: https://makersuite.google.com/app/apikey

3. Actualiza `injection_container.dart`:
```dart
import 'features/coach/data/services/gemini_coach_service.dart';

// En la función init():
sl.registerLazySingleton<AICoachService>(
  () => GeminiCoachService(apiKey: 'tu-api-key-aqui'),
);
```

## Arquitectura

El feature sigue la arquitectura limpia:

```
coach/
├── domain/
│   ├── entities/
│   │   ├── coach_advice.dart      # Entidad de consejo
│   │   └── match_analysis.dart    # Análisis del partido
│   └── services/
│       ├── ai_coach_service.dart   # Interfaz del servicio
│       └── match_analyzer.dart    # Analizador de partidos
├── data/
│   └── services/
│       ├── smart_coach_service.dart    # Servicio con reglas
│       ├── openai_coach_service.dart   # Servicio OpenAI (opcional)
│       └── gemini_coach_service.dart    # Servicio Gemini (opcional)
└── presentation/
    ├── bloc/
    │   ├── coach_bloc.dart
    │   ├── coach_event.dart
    │   └── coach_state.dart
    └── widgets/
        ├── coach_dialog.dart
        └── coach_floating_button.dart
```

## Tipos de Consejos

- **Tip**: Consejos generales de técnica y táctica
- **Motivation**: Mensajes de ánimo cuando estás perdiendo
- **Strategy**: Consejos estratégicos para momentos clave
- **Warning**: Alertas para situaciones críticas

## Momentos Críticos Detectados

- Match Point
- Set Point
- Break Point
- Game Point
- Deuce
- Advantage
- Tie-Break


