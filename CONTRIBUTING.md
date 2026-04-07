# Guía de Contribución

¡Gracias por tu interés en contribuir a pfQuest [Séquito del Terror Edition]! Para mantener la calidad técnica y la integridad del ecosistema, sigue estas instrucciones.

## Estándares de Código

- **Compatibilidad Vanilla:** El código debe ser estrictamente compatible con **Lua 5.0**. Prohibido el uso de `#`, `math.huge` o bibliotecas de Lua 5.1+.
- **Arquitectura:** Toda modificación a la base de datos debe pasar por la `patchtable.lua`. No edites los archivos `db/*.lua` directamente si el cambio es exclusivo de Turtle WoW.
- **Rendimiento:** Evita iteraciones `pairs` u `O(n)` en frames de `OnUpdate`. Usa cachés de frame o throttles.

## Proceso de Pull Request

1. Abre un issue explicando el problema o la mejora antes de enviar el PR.
2. Sigue el formato de los [Issue Templates](.github/ISSUE_TEMPLATE).
3. Asegúrate de que el código no cause errores de taint en la UI.
4. Toda documentación debe ser actualizada en español técnico.

## Enlaces Oficiales

- Repositorio Principal: [github.com/DarckRovert/pfQuest](https://github.com/DarckRovert)
- Stream de Desarrollo: [twitch.tv/darckrovert](https://twitch.tv/darckrovert)

---
Atentamente,
**DarckRovert**