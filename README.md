## Reservas de canchas

Gestión de reservas de canchas, consulta de disponibilidad, calculo de importe y actualización de estados.

### Endpoints

- Metodos : POST, GET y PUT.

- Endpoint: 
    POST y GET: /reservas
    GET y PUT: /reservas/{id}
    
- Descripción: 
    POST: Crea una nueva reserva
  
    GET: Consulta las reservas existentes o por ID
  
    PUT: Actualiza el estado de una reserva

### Códigos de respuesta

- 201: reserva creada correctamente.

- 200: consulta o actualización realizada correctamente.

- 400: datos de entrada inválidos, socio/cancha inactiva o duración incorrecta.

- 404: reserva inexistente.

- 409: superposición de horarios con otra reserva o bloqueo existente.

### Reglas

- La reserva debe corresponder a un socio activo y una cancha habilitada.
- La `fecha_hora_inicio` debe ser anterior a `fecha_hora_fin`.
- La duración de la reserva debe ser de bloques enteros de 1, 2 o 3 horas.
- No se permiten reservas superpuestas para la misma cancha o el mismo socio.
- No se permite crear una reserva si la cancha posee un bloqueo por mantenimiento en ese horario.
- El importe se calcula automáticamente según la duración y el precio por hora de la cancha.

### Ejemplo de creación

```json
POST /reservas
Content-Type: application/json

{
  "id_socio": 1,
  "id_cancha": 2,
  "fecha_hora_inicio": "2026-11-10T14:00:00-03:00",
  "fecha_hora_fin": "2026-11-10T15:00:00-03:00"
}
Respuesta exitosa:

{
  "id": 1,
  "id_socio": 1,
  "id_cancha": 2,
  "estado": "confirmada",
  "fecha_hora_inicio": "2026-11-10T14:00:00-03:00",
  "fecha_hora_fin": "2026-11-10T15:00:00-03:00",
  "importe": 7500.0
}
```
### Consulta

Se pueden consultar todas las reservas, obtener una por ID o aplicar filtros de búsqueda:

GET /reservas

Reserva por id de la tabla reservas:

GET /reservas/1

si se quiere ver todas las reservas con el id del socio o cancha correspondiente

GET /reservas?id_cancha=1

GET /reservas?id_socio=2

filtrado por fecha

GET /reservas?fecha=2026-11-10

Modificación de estado por el id tabla reservas:
PUT /reservas/1/estado
Content-Type: application/json
```json
{
  "estado": "cancelada"
}
```
Aplica lo mismo pero con finalizada:
```json
{
  "estado": "finalizada"
}
```

Si la reserva existe, se actualiza el estado correctamente. Si no existe, la API devuelve 404



### Supuestos
-Las reservas en estado cancelada liberan el horario para nuevas reservas o bloqueos.

-La tarifa final de la reserva se calcula dinámicamente multiplicando las horas por el precio por hora de la cancha.

