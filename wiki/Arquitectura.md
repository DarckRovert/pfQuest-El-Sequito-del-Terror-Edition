# 🏰 Arquitectura Técnica — pfQuest [LAG-FREE]

## 1. Engine de Optimización (Throttling)
pfQuest [Séquito Edition] ha sido intervenido para mitigar el impacto en el render loop de WoW Vanilla:
*   **OnUpdate Throttling**: Se ha reducido la frecuencia de actualización del motor de búsqueda de misiones de 1 tps (tick per second) a intervalos de 0.2s mediante una colas de prioridad asíncronas.
*   **Caché Estática**: La base de datos de misiones se carga en una tabla hash optimizada al inicio, evitando búsquedas lineales costosas durante la navegación.

## 2. Soporte Nativo Turtle WoW
A diferencia de otras versiones, los parches de datos para las misiones exclusivas de Turtle WoW (Emerald Dream, etc.) están inyectados directamente en el core, eliminando la necesidad de addons de parches externos que causan inestabilidad.

## 3. Navegador de Precisión
El sistema de flecha de navegación utiliza un cálculo de distancia euclidiana suavizado mediante un filtro de paso bajo, evitando que la flecha "salte" violentamente durante giros rápidos o cambios de zona.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Soberanía Técnica Lag-Free Edition.*
