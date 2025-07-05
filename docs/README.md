# RepCurve Documentation

Complete documentation for the RepCurve powerlifting tracker.

## Documentation Structure

```
docs/
├── README.md              # This file - documentation index
├── setup/                 # Getting started guides
│   ├── quickstart.md     # Quick setup for both systems
│   ├── backend.md        # Django API setup
│   └── frontend.md       # Flutter app setup
├── development/          # Development guides
│   ├── workflow.md       # Team workflow and Git process
│   ├── vscode-setup.md   # VS Code automation and debugging
│   ├── backend-guide.md  # Backend development guide
│   └── frontend-guide.md # Frontend development guide
├── api/                  # API documentation
│   ├── overview.md       # API overview and authentication
│   ├── endpoints.md      # All API endpoints
│   └── examples.md       # Usage examples
└── deployment/           # Production deployment
    ├── django.md         # Django deployment
    └── flutter.md        # Flutter app distribution
```

## Quick Navigation

### 🚀 Getting Started
- [**Quick Start**](setup/quickstart.md) - Get both systems running in 5 minutes
- [Backend Setup](setup/backend.md) - Django API detailed setup
- [Frontend Setup](setup/frontend.md) - Flutter app detailed setup

### 💻 Development
- [**Team Workflow**](development/workflow.md) - Git, code review, communication
- [**VS Code Setup**](development/vscode-setup.md) - Automated tasks and debugging
- [Backend Development](development/backend-guide.md) - Django API development
- [Frontend Development](development/frontend-guide.md) - Flutter app development

### 📡 API Reference
- [API Overview](api/overview.md) - Authentication, base URLs, response format
- [API Endpoints](api/endpoints.md) - Complete endpoint reference
- [API Examples](api/examples.md) - Real usage examples

### 🚀 Deployment
- [Django Deployment](deployment/django.md) - Production Django setup
- [Flutter Distribution](deployment/flutter.md) - App store deployment

## For New Developers

1. **Start here:** [Quick Start Guide](setup/quickstart.md)
2. **Pick your role:** [Backend](development/backend-guide.md) or [Frontend](development/frontend-guide.md)
3. **Learn the workflow:** [Team Workflow](development/workflow.md)
4. **Understand the API:** [API Overview](api/overview.md)

## Documentation Maintenance

- **Backend changes:** Update `api/` docs when adding endpoints
- **Frontend changes:** Update `development/frontend-guide.md` 
- **Workflow changes:** Update `development/workflow.md`
- **New features:** Add examples to relevant sections

## Auto-Generated Documentation

- **API Docs:** Available at `http://127.0.0.1:8000/api/docs/` (when running)
- **Django Admin:** Available at `http://127.0.0.1:8000/admin/`