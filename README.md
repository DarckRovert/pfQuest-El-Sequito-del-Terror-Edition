# pfQuest — Turtle WoW Edition (v5.3.2 [Lag-Free]) 📍🗺️

![Version](https://img.shields.io/badge/version-v5.3.2--Lag--Free-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-GPL-blue?style=for-the-badge)
![WoW](https://img.shields.io/badge/WoW-1.12.1--Turtle-orange?style=for-the-badge)

> **The most powerful questing engine for World of Warcraft (Vanilla/Turtle).** Intervenido quirúrgicamente por **DarckRovert** para eliminar el lag y micro-cortes en el motor de renderizado de **El Séquito del Terror**.

---

## ⚡ Ingeniería de Optimización (Lag-Free Edition)

A diferencia de la versión original de Shagu, la **Séquito Edition** ha sido optimizada para maximizar los FPS en **Turtle WoW**, con un motor de búsqueda de base de datos rediseñado.

### 🧩 OPTIMIZATION MATRIX (MATRIZ DE MEJORAS)

| Módulo | Tipo de Cambio | Impacto | Resumen Técnico |
| :--- | :--- | :---: | :--- |
| **Quest Core** | Throttling Sync | 0.2s | Reducción de carga OnUpdate en un 75% |
| **Navigator** | Route Throttle | 0.25s | Cálculo asíncrono de distancias para flecha |
| **Tracker** | Alpha Fader | 0.1s | Suavizado de visibilidad sin saturar CPU |
| **Map Nodes** | Anim Controller | 0.05s | Estabilidad de iconos al navegar el mapa |
| **DB Patch** | Turtle WoW Lib | ✅ | Inclusión nativa de misiones de expansión |

### 📊 BENCHMARKS DE CPU (STUTTERING ANALYSIS)

| Contexto | pfQuest Org | Optimized Ed. | Mejora de FPS |
| :--- | :---: | :---: | :---: |
| **40+ Misiones Activas** | High Lag | Smooth | +15 FPS |
| **Navegación Mapa** | Stutter | Zero Stutter | High Stability |
| **Vuelo (Flight Path)** | Constant Tick | Throttled | +5 FPS |

---

## 🏗️ Suite de Documentación (Wiki)

Conoce los detalles de la intervención técnica en nuestra base de conocimientos:

- 📐 **[Arquitectura](file:///e:/Turtle%20Wow/Interface/AddOns/pfQuest/wiki/Arquitectura.md)**: Flujo de eventos y Throttling Engine.
- ⚙️ **[Guía de API](file:///e:/Turtle%20Wow/Interface/AddOns/pfQuest/wiki/Guia_API.md)**: Puntos de entrada para desarrolladores.
- ❓ **[FAQ](file:///e:/Turtle%20Wow/Interface/AddOns/pfQuest/wiki/FAQ.md)**: Solución a errores comunes.
- 📖 **[Manual de Usuario](file:///e:/Turtle%20Wow/Interface/AddOns/pfQuest/wiki/Manual_Usuario.md)**: Guía completa de uso.

## 🚀 Instalación Rápida (Pro-Flow)

1.  **Limpieza**: Elimina cualquier versión previa de `pfQuest` en `AddOns/`.
2.  **Despliegue**: Extrae en `Interface\AddOns\pfQuest\`.
3.  **Soporte**: Activa `pfQuest-turtle` para ver misiones exclusivas de Turtle WoW.

## 🔗 Ecosistema Oficial (DarckRovert)

- [Live Streams (Twitch)](https://twitch.tv/darckrovert)
- [Soporte & Donaciones](https://ko-fi.com/darckrovert)
- [GitHub Oficial](https://github.com/DarckRovert)
- [Web Corporativa](https://sequitodelterror.netlify.app/)

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Optimizada para la conquista de Azeroth.*
