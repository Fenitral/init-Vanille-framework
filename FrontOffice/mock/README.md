Quick mock for external reservations API (json-server)

1) Requirements: Node (or use `npx` which comes with recent Node installs).

2) From the workspace root run (PowerShell):

```powershell
npx json-server --watch mock/db.json --routes mock/routes.json --port 8081
```

This will serve the mock at `http://localhost:8081/api/reservations` which matches
the `external.api.reservations.url` in `src/main/resources/application.properties`.

3) Then run your Spring Boot app and open:

http://localhost:8080/front/reservations
