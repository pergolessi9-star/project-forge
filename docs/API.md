# API

## Health

`GET /api/health`

## Projects

`GET /api/projects`
`POST /api/projects`

POST example:

```json
{
  "projectCode": "PF-0003",
  "name": "Example Project",
  "slug": "example-project",
  "description": "Discovery candidate",
  "status": "IDEA",
  "currentStage": "INTAKE"
}
```

## Evidence

`GET /api/evidence`

The evidence service is intentionally separated from project creation so the evidence boundary remains explicit.
