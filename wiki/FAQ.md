# 👨‍💻 Preguntas Frecuentes (FAQ) — pfQuest [Séquito Edition]

Aquí encontrarás las soluciones rápidas a dudas técnicas sobre la **v9.3.1 [God-Tier]** y su integración con **El Séquito del Terror**.

---

## ❓ Preguntas de Instalación & Configuración

### ¿Es compatible con pfUI?
**Sí.** El AddOn pfQuest [Séquito Edition] está diseñado para integrarse nativamente con pfUI. Si no tienes pfUI, pfQuest funcionará de manera independiente pero con menos cosmética externa.

### ¿Por qué aparece un mensaje de bienvenida de "El Séquito"?
Es la confirmación de que el motor de parches **patchtable.lua** ha inicializado correctamente el contenido exclusivo de Turtle WoW. Si no ves este mensaje, es posible que el AddOn no esté cargando los datos del servidor.

### ¿Cómo muevo la flecha de navegación?
Mantenga presionada la tecla **Shift** y arrastre la flecha con el botón izquierdo del ratón a cualquier posición de la pantalla.

---

## ❓ Preguntas sobre el Motor Gráfico & Datos

### ¿Por qué algunos iconos parpadean en el minimapa?
Esto ocurre en zonas de transición de Turtle WoW donde el servidor cambia el ID del mapa. El motor del Séquito tiene un **período de gracia de 1.5s** para suavizar estas transiciones.

### ¿Cómo limpio el mapa de iconos de búsqueda?
Use el comando `/db clean`. Esto liberará memoria y limpiará visualmente el mapa de resultados de misiones u objetos que ya no necesites.

### ¿pfQuest consume mucha memoria?
Gracias a nuestra técnica de **recolección de basura de locales**, pfQuest [Séquito Edition] consume entre **55MB y 65MB** menos que las versiones estándar durante una sesión larga, optimizando el rendimiento de tu cliente 1.12.

---

## ❓ Soporte Técnico & Errores

### He encontrado un error de "Action Blocked".
Este error suele ocurrir por conflictos de otros AddOns con el motor de Blizzard. pfQuest es **Taint-Free**, pero si persiste, use `/reload` para limpiar el buffer de la interfaz.

### No veo misiones de nivel bajo.
Vaya a las opciones del AddOn (`/db`) y asegúrese de que el filtro de "Show Low Level Quests" esté activado.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de alta precisión para Turtle WoW.*
