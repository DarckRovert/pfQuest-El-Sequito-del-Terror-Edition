# pfQuest [Séquito del Terror Edition]

Una reconstrucción integral y optimizada de pfQuest v12.2 diseñada específicamente para **Turtle WoW**. Esta edición ha sido depurada de fugas de memoria, optimizada para el motor de Vanilla (Lua 5.0) e integrada con la base de datos exclusiva del servidor.

| Recurso | Enlace |
| --- | --- |
| **Desarrollador** | [DarckRovert](https://github.com/DarckRovert) |
| **Stream Oficial** | [twitch.tv/darckrovert](https://www.twitch.tv/darckrovert) |
| **Licencia** | [MIT](LICENSE) |

## Características Principales

- **Gestión de Memoria Avanzada:** Liberación automática de tablas de locales no utilizadas (~65MB ahorrados en runtime).
- **Motor de Proyección Calibrado:** Sincronización perfecta con los mapas expandidos de Turtle WoW (Hyjal, Gilneas, etc.).
- **Navegación Sin Micro-cortes:** Refactorización del OnUpdate de la flecha con caché de proyección por frame.
- **Base de Datos Integrada:** Fusión en caliente de datos vanilla + datos custom de Turtle (NPCs, Objetos, Misiones).
- **Standalone & Taint-Free:** Funciona sin dependencias externas obligatorias, manteniendo la integridad de la UI.

## Instalación

1. Descarga el repositorio.
2. Extrae la carpeta en `YourWoWDirectory\Interface\AddOns\`.
3. Asegúrate de que la carpeta se llame exactamente `pfQuest`.
4. Activa los "AddOns de versiones anteriores" en la selección de personajes.

## Wiki y Documentación

Para detalles técnicos avanzados, consulta nuestra [Wiki Corporativa](wiki/Architecture.md):
- [Arquitectura del Sistema](wiki/Architecture.md)
- [Guía de API Interna](wiki/API_Guide.md)
- [Preguntas Frecuentes](wiki/FAQ.md)
- [Manual del Usuario](wiki/User_Manual.md)

## Contribuciones

Consulta [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles sobre cómo colaborar con el proyecto.

---
© 2026 DarckRovert. Todos los derechos reservados.
