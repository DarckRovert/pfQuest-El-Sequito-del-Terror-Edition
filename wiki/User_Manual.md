# 📖 Manual de Usuario — pfQuest [Séquito Edition]

Este manual proporciona una guía detallada sobre cómo interactuar con el motor de misiones de **v9.4.0 [Omni-Tier]**.

---

## 🛠️ Interfaz de Usuario (HUD)

### 1. El Rastreador Dinámico (Tracker) 📋
El **Tracker** lateral se sincroniza automáticamente con tu registro de misiones. 
- **[Click Izquierdo]:** Desplegar/Colapsar objetivos.
- **[Click Derecho]:** Mostrar misión en el registro estándar.
- **[Ctrl + Click]:** Mostrar ubicación exacta en el mapa mundial.
- **[Shift + Click]:** Marcar como completado o esconder nodos específicos.

### 2. La Flecha de Navegación 🏹
La flecha indica la dirección y distancia (en yardas) al objetivo más cercano.
- **Color Verde:** Muy cerca (<20 yardas).
- **Color Amarillo:** Distancia media (>50 yardas).
- **Color Rojo:** Objetivo lejano (>100 yardas).
- **Mover Flecha:** Mantener **Shift** y arrastrar con el botón izquierdo.

### 3. Navegación en el Mapa 🗺️
Haz clic en cualquier nodo (icono) del mapa mundial para **bloquear la flecha** a ese objetivo específico. El nodo mostrará un borde resaltado para confirmar la fijación.

---

## ⌨️ Comandos Especiales (Console)

| Comando | Acción |
|---|---|
| `/db` | Abrir panel de configuración avanzada. |
| `/db tracker` | Mostrar u ocultar el rastreador de misiones. |
| `/db arrow` | Activar o desactivar la flecha guía. |
| `/db query` | Solicitar al servidor Turtle WoW los datos de misiones actuales. |
| `/db clean` | Limpiar todos los iconos de búsqueda activa. |

---

## 🧭 Consejos para el Séquito

- **Sincronización:** Si has completado misiones fuera de este AddOn, usa `/db query` para actualizar el historial local.
- **Rendimiento:** Si notas tirones al abrir el mapa, usa `/db clean`. El motor de búsqueda puede acumular miles de nodos si haces consultas muy genéricas (ej: "Mena de Hierro" en todo el Azeroth).
- **Turtle WoW:** Este AddOn detecta automáticamente las zonas expandidas. No necesitas configurar nada adicional para Hyjal o zonas de hermandad.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de alta precisión para Turtle WoW.*
