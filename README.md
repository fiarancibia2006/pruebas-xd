---

##  Módulo de Reservas (`/reservas`)

Encargado del alta, consulta y cambio de estado de reservas de canchas, aplicando validaciones de negocio y disponibilidad en tiempo real.

### Endpoints

* GET /club_api/reservas
  * Descripción:** Retorna el listado paginado de reservas.
  * Query Params:** `limit` (opcional, por defecto 10), `offset` (opcional, por defecto 0).
  * Respuesta (`200 OK`):
    ```json
    {
      "total": 15,
      "limit": 10,
      "offset": 0,
      "datos": [
        {
          "id": 1,
          "id_socio": 1,
          "id_cancha": 2,
          "estado": "confirmada",
          "fecha_hora_inicio": "2026-11-10T14:00:00-03:00",
          "fecha_hora_fin": "2026-11-10T15:00:00-03:00",
          "importe": 7500.0
        }
      ]
    }
    ```

* GET /club_api/reservas/<id>`
  * Descripción: Devuelve el detalle de una reserva específica por su ID.
  * Respuesta (`200 OK`):** JSON con el detalle de la reserva.
  * Error (`404 Not Found`): `{"error": "Reserva no encontrada"}`.

* `POST /club_api/reservas`**
  * Descripción: Registra una nueva reserva calculando el importe automáticamente.
  * Body (JSON):
    ```json
    {
      "id_socio": 1,
      "id_cancha": 2,
      "fecha_hora_inicio": "2026-11-10T14:00:00-03:00",
      "fecha_hora_fin": "2026-11-10T15:00:00-03:00"
    }
    ```
  * Respuesta (`201 Created`): Objeto de la reserva creada.

* `PUT /club_api/reservas/<id>/estado`
  * Descripción: Modifica el estado de una reserva (ej. `cancelada`, `finalizada`).
  * Body (JSON): `{"estado": "cancelada"}`
  * Respuesta (`200 OK`): `{"mensaje": "Estado de reserva actualizado correctamente"}`.

---

### Reglas de Negocio y Bloqueos

Previo a la creación de una reserva (`POST`), la capa de servicio (`reservas_service.py`) evalúa:

1. **Socio Activo (`400 Bad Request`):** El socio debe existir y figurar con estado `activo`.
2. **Cancha Habilitada (`400 Bad Request`):** La cancha debe estar dada de alta y con `activa = 1`.
3. **Duración de la Reserva (`400 Bad Request`):** La duración debe ser de bloques exactos de 1, 2 o 3 horas integras.
4. **Control de Disponibilidad y Bloqueos (`409 Conflict`):** Se verifica la no existencia de reservas confirmadas previas ni bloqueos administrativos/mantenimiento sobre la cancha o el socio en el rango de horario solicitado.
