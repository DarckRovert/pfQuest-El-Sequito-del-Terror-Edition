# pfQuest — v9.3.1 [Séquito Edition] 🗺️📍

> **The ultimate questing engine and database integrator for Turtle WoW.** El guía absoluto de **El Séquito del Terror**.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Version](https://img.shields.io/badge/version-9.3.1--Sequito-purple)](./CHANGELOG.md)
[![World of Warcraft](https://img.shields.io/badge/WoW-1.12.1-orange)](https://turtle-wow.org)
[![Discord](https://img.shields.io/badge/Discord-El%20S%C3%A9quito%20del%20Terror-7289DA)](https://twitch.tv/darckrovert)

---

## 🌪️ ¿Qué es pfQuest [Séquito Edition]?

**pfQuest [Séquito Edition]** no es solo un mapa de misiones; es un motor de base de datos de alta disponibilidad reconstruido desde cero para **Turtle WoW**. Esta edición ha sido purgada de código legado y optimizada para manejar el contenido exclusivo del servidor (Hyjal, Gilneas, Lapidis, etc.) con una precisión quirúrgica y un impacto mínimo en el rendimiento del cliente.

## 🚀 Características God-Tier

### 🧠 Motor de Base de Datos Híbrido
Integra dinámicamente la base de datos original de Vanilla con los parches exclusivos de Turtle WoW. Mediante el sistema `patchtable.lua`, el AddOn inyecta NPCs, objetos y misiones custom en tiempo real, garantizando que nunca te falte un objetivo.

### 🏹 Navegación Vectorial Avanzada
La flecha de dirección ha sido refactorizada para eliminar micro-stutters. Utiliza un sistema de **Caché de Proyección de 0.15s** y un algoritmo de suavizado vectorial que calcula la ruta más corta basándose en la topografía real del mapa expandido.

### ⚡ Optimización Extreme (Lua 5.0)
- **Ahorro de ~65MB de RAM:** Sistema de recolección de basura agresiva que libera tablas de locales no utilizadas tras el inicio.
- **Búsqueda O(1):** Implementación de un `nameIndex` para localizar cualquier NPC u objeto en milisegundos.
- **Taint-Free:** Arquitectura aislada que evita conflictos con la interfaz original de Blizzard, permitiendo abrir el mapa y el registro de misiones sin errores.

## ⚙️ Instalación & Comandos

1.  Descarga y extrae en `Interface\AddOns\pfQuest\`.
2.  Asegúrate de que la carpeta se llame exactamente `pfQuest`.
3.  Usa `/db` para configurar el motor principal.

| Comando | Acción |
|---|---|
| `/db` | Panel de Configuración |
| `/db tracker` | Toggle Tracker de Misiones |
| `/db arrow` | Activar/Desactivar Flecha de Guía |
| `/db query` | Forzar Sincronización con el Servidor |
| `/db clean` | Limpiar resultados de búsqueda del mapa |

## 🏗️ Suite de Documentación (Wiki)

Para una comprensión técnica profunda, consulte nuestra **[Wiki Oficial](./wiki/User_Manual.md)**:

- 📐 **[Arquitectura](./wiki/Architecture.md)**: Capas de datos y motor de proyecciones.
- 🛠️ **[Guía de API](./wiki/API_Guide.md)**: Integración para desarrolladores del Séquito.
- ❓ **[FAQ](./wiki/FAQ.md)**: Solución de problemas y optimizaciones.
- 📖 **[Manual de Usuario](./wiki/User_Manual.md)**: Guía de uso y atajos de teclado.

## 🔗 Ecosistema El Séquito del Terror

Este motor es parte del núcleo táctico. Para una experiencia definitiva, úselo junto a:
- [WCS_Brain](https://github.com/DarckRovert/WCS_Brain-v9.3.1-God-Tier)
- [pfUI (Sequito Edition)](https://github.com/DarckRovert/pfUI-El-Sequito-del-Terror-Edition)
- [TerrorMeter](https://github.com/DarckRovert/TerrorMeter-El-Sequito-del-Terror-Edition)

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de alta precisión para Turtle WoW.*
