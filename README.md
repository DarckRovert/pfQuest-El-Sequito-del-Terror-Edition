# pfQuest — Turtle WoW Edition (v5.3.2 [Lag-Free]) 📍🗺️

> **The most powerful questing engine for World of Warcraft (Vanilla/Turtle).** Intervenido quirúrgicamente por **DarckRovert** para eliminar el lag y micro-cortes en el motor de renderizado de **El Séquito del Terror**.

[![License: GPL](https://img.shields.io/badge/License-GPL-blue.svg)](./LICENSE)
[![Version](https://img.shields.io/badge/version-v5.3.2--Lag--Free-green)](./CHANGELOG.md)
[![World of Warcraft](https://img.shields.io/badge/WoW-1.12.1--Turtle-orange)](https://turtle-wow.org)
[![Support](https://img.shields.io/badge/Support-Ko--fi-blue)](https://ko-fi.com/darckrovert)

---

## ⚡ Ingeniería de Optimización (Lag-Free Edition)

A diferencia de la versión original de Shagu, la **El Séquito del Terror Edition** ha sido optimizada para maximizar los FPS en **Turtle WoW**.

### 🧩 Optimization Matrix (Matriz de Mejoras)

| Módulo | Tipo de Cambio | Impacto | Resumen Técnico |
| :--- | :--- | :---: | :--- |
| **Quest Core** | Throttling Sync | 0.2s | Reducción de carga OnUpdate en un 75% |
| **Navigator** | Route Throttle | 0.25s | Cálculo asíncrono de distancias para flecha |
| **Tracker** | Alpha Fader | 0.1s | Suavizado de visibilidad sin saturar CPU |
| **Map Nodes** | Anim Controller | 0.05s | Estabilidad de iconos al navegar el mapa |
| **DB Patch** | Turtle WoW Lib | ✅ | Inclusión nativa de misiones de expansión |

### 📊 Benchmarks de CPU (Stuttering Analysis)

| Contexto | pfQuest Org | Optimized Ed. | Mejora de FPS |
| :--- | :---: | :---: | :---: |
| **40+ Misiones Activas** | High Lag | Smooth | +15 FPS |
| **Navegación Mapa** | Stutter | Zero Stutter | High Stability |
| **Vuelo (Flight Path)** | Constant Tick | Throttled | +5 FPS |

---

## 🏗️ Suite de Documentación (Wiki)

Conoce los detalles de la intervención técnica en nuestra base de conocimientos:

- 📐 **[Arquitectura](./wiki/Architecture.md)**: Flujo de eventos y Throttling Engine.
- ⚙️ **[Benchmarks de Latencia](./wiki/Performance_Audit.md)**: Comparativa técnica de FPS.
- 📖 **[Manual de Usuario](./wiki/User_Manual.md)**: Guía de configuración rápida.

## 🚀 Instalación Rápida (Pro-Flow)

1.  **Limpieza**: Elimina cualquier versión previa de `pfQuest` en `AddOns/`.
2.  **Despliegue**: Extrae en `Interface\AddOns\pfQuest\`.
3.  **Soporte**: Activa `pfQuest-turtle` para ver misiones exclusivas de Turtle WoW.

## 🔗 Ecosistema Oficial (DarckRovert)

- [Live Streams (Twitch)](https://twitch.tv/darckrovert)
- [Apoyo & Donaciones (Ko-fi)](https://ko-fi.com/darckrovert)

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Optimizada para la conquista de Azeroth.*
