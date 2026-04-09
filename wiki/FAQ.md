# Preguntas Frecuentes (FAQ)

### 1. ¿Por qué no veo la flecha de navegación siendo nivel 60?
En versiones anteriores, el addon ocultaba misiones de "bajo nivel" por defecto. En la **v5.3.3**, hemos eliminado esta restricción para el nivel 60. Si aún no la ves, asegúrate de que la misión esté marcada en el rastreador o usa `/db status` para verificar si hay misiones en el log.

### 2. El mapa de Isla Lapidis / Balor aparece vacío.
Esto suele ocurrir por una discrepancia de idiomas o caché corrupta. 
- **Solución**: Borra la carpeta `WDB` de tu cliente WoW.
- **Técnico**: La versión v5.3.3 corrige la colisión de datos en el cliente español (Map ID 5564), por lo que debería funcionar tras el reinicio.

### 3. Siento lag al abrir el diario de misiones.
Hemos optimizado el motor a un diseño **Reactivo [Lag-Free]**. El lag periódico (cada 2 segundos) ha sido eliminado. Si persiste, comprueba otros addons que puedan estar escaneando el diario simultáneamente.

### 4. ¿Cómo forzar la flecha a una misión específica?
Haz Shift+Click en la misión dentro del rastreador de pfQuest o del diario oficial. Esto activará el "Sticky Target" y la flecha se bloqueará en ese objetivo.
