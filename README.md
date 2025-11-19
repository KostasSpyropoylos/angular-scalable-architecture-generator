# 🚀 Angular Scalable Architecture Generator

> **Rapidly bootstrap enterprise-grade Angular applications** with a battle-tested folder structure, modern state management, authentication scaffolding, and production-ready Docker deployment.

---

## 🎯 Overview

This Bash automation script generates a **scalable, well-organized Angular application** following industry best practices. Instead of starting from scratch with a flat folder structure, you get:

- ✅ **Clean architecture** with clear separation of concerns (features, shared, core, state)
- ✅ **Modern Angular stack** with standalone components and signals-based state
- ✅ **Pre-built authentication service** with mock login for rapid prototyping
- ✅ **Production-ready Docker setup** (multi-stage builds, Nginx, gzip compression)
- ✅ **SCSS styling** out of the box
- ✅ **Zero boilerplate** – start coding features immediately

Perfect for teams that want to **skip the architecture debates** and engineers who value **rapid, consistent scaffolding**.

---

## 📋 Prerequisites

Your system must have:

| Requirement | Version | Notes |
|-------------|---------|-------|
| **Node.js** | 18+ | The script validates this and warns if too old. Check with `node -v` |
| **npm** | Latest (via Node) | Comes with Node.js |
| **Bash** | 4.0+ | Standard on Linux/macOS; Windows users can use Git Bash |

### Quick Check

```bash
node --version    # Should be v18.x or higher
npm --version     # Should be 8.x or higher
ng --version      # Optional; if missing, the script installs Angular CLI
```

---

## 🎨 What Gets Generated

### Project Structure

```
my-awesome-app/
├── src/
│   ├── app/
│   │   ├── core/                          # App-wide singletons & shared logic
│   │   │   └── auth/
│   │   │       ├── models/
│   │   │       │   ├── user.model.ts      # User entity interface
│   │   │       │   └── auth.state.ts      # Auth state structure + initial state
│   │   │       └── services/
│   │   │           └── auth.service.ts    # Signal-based auth service (mock login)
│   │   │
│   │   ├── features/                      # Feature modules (add yours here)
│   │   │   └── [your-features]/
│   │   │
│   │   ├── shared/                        # Reusable components, pipes, directives
│   │   │   └── [common utilities]/
│   │   │
│   │   ├── state/                         # Global state management ready for NgRx/Akita
│   │   │   └── [your-stores]/
│   │   │
│   │   └── app.component.ts               # Root component
│   │
│   ├── main.ts                            # Bootstrap file
│   └── styles.scss                        # Global SCSS styles
│
├── Dockerfile                             # Multi-stage build (dev & prod)
├── docker-compose.yml                     # Local dev & production compose config
├── nginx.conf                             # Production Nginx configuration
├── package.json                           # Dependencies & scripts
└── angular.json                           # Angular CLI configuration
```

### Core Features Included

#### 🔐 Authentication Service
A **signal-based auth service** using Angular's latest reactive primitives:

```typescript
// Mock credentials for testing:
// ✅ test@user.com   → regular user
// ✅ admin@user.com  → admin user

const { isAuthenticated, currentUser } = inject(AuthService);
// Use these computed signals in your components
```

- Pre-configured with mock login (1.5s delay simulates API latency)
- Strongly typed User model with role-based support
- Ready to swap with real API calls
- Includes error handling and loading states

#### 🐳 Docker Ready
Production-grade deployment with:

- **Multi-stage build**: Optimized image size (only production artifacts shipped)
- **Nginx**: SPA routing, gzip compression, static asset caching
- **Docker Compose**: One-command local dev & production setup
- **Alpine images**: Minimal footprint (~50MB final image)

---

## 🚀 Usage

### Step 1: Make the Script Executable

```bash
chmod +x clean-architecture.sh
```

### Step 2: Run the Generator

```bash
./clean-architecture.sh
```

### Step 3: Follow the Interactive Prompts

The script will guide you through these questions:

```
🔍 Checking prerequisites...
✅ Node.js (v18.x.x) installed.
✅ Angular CLI is installed globally.

📝 Enter the desired name for your new Angular application:
> my-awesome-app

🔥 Create new Angular application named: **my-awesome-app** (y/N)
> y

⏳ Generating the Angular application...
✅ Success! Application **my-awesome-app** created.

📝 Generating project structure and initial files...
✅ Project structure created.

🛠️ Adding sample Auth entities...
✅ Sample entities and services added.

🐳 Generate Dockerfile, docker-compose.yml, and Nginx config for production deployment? (y/N)
> y

🚢 Generating deployment artifacts...
✅ Deployment artifacts generated.

To build and run with Docker:
  docker-compose up --build -d

To start local development:
  cd my-awesome-app
  ng serve --open
```

### Step 4: Start Development

Navigate into your new project and start coding:

```bash
cd my-awesome-app
ng serve --open
```

The app opens automatically at `http://localhost:4200` with live reload enabled.

---

## 💡 Common Workflows

### Local Development

```bash
cd my-awesome-app

# Run dev server with live reload
ng serve --open

# Run unit tests
ng test

# Run e2e tests
ng e2e

# Build for production
ng build --configuration production
```

### Docker Development

```bash
cd my-awesome-app

# Build and start container (detached mode)
docker-compose up --build -d

# View logs
docker-compose logs -f angular-app

# Stop container
docker-compose down
```

App is available at `http://localhost:8080`.

### Testing the Auth Service

1. Navigate to your app
2. Use the injected `AuthService` in a component:

```typescript
import { Component, inject } from '@angular/core';
import { AuthService } from './core/auth/services/auth.service';

@Component({
  selector: 'app-root',
  template: `
    <div *ngIf="auth.isAuthenticated()">
      Welcome, {{ auth.currentUser()?.firstName }}!
    </div>
    <button (click)="login()">Login</button>
  `
})
export class AppComponent {
  protected auth = inject(AuthService);

  login() {
    this.auth.login('test@user.com').subscribe({
      next: (user) => console.log('Logged in:', user),
      error: (err) => console.error('Login failed:', err)
    });
  }
}
```

Try credentials: `test@user.com` or `admin@user.com`

---

## 🏗️ Architecture Highlights

### Clean Separation of Concerns

- **`core/`** – Singleton services, authentication, guards (initialized once)
- **`features/`** – Feature-specific modules, components, services (can be lazy-loaded)
- **`shared/`** – Reusable components, pipes, directives (no dependencies on features or core)
- **`state/`** – Centralized state management (NgRx, Akita, or custom signals)

### Modern Angular Stack

- **Standalone Components**: No NgModule boilerplate
- **Angular Signals**: Reactive, fine-grained state tracking
- **SCSS**: For maintainable, modular styling
- **Tree-shakeable**: Only used code ships to production

---

## 🔧 Customization & Next Steps

After generation, you'll typically:

1. **Replace the mock auth service** with real API calls:
   ```typescript
   // In auth.service.ts, replace the mock login with:
   return this.http.post<User>('/api/auth/login', { email })
     .pipe(
       tap(user => this.authState.set({...})),
       catchError(err => {...})
     );
   ```

2. **Add your features** under `src/app/features/`:
   ```bash
   ng generate @schematics/angular:module features/dashboard --routing
   ```

3. **Set up global state** in `src/app/state/`:
   - Option A: NgRx (enterprise scale)
   - Option B: Akita (simpler, signal-friendly)
   - Option C: Custom signals (for simple cases)

4. **Create shared components** under `src/app/shared/`:
   ```bash
   ng generate component shared/header --standalone
   ```

5. **Configure environment-specific settings**:
   - Update `src/environments/environment.ts` with API endpoints
   - Use `import { environment } from '../environments/environment'` in services

6. **Enable strict mode** for better type safety:
   - Edit `tsconfig.json` and set `"strict": true`

---

## 🚢 Production Deployment

### Build for Production

```bash
ng build --configuration production
```

Output is in `dist/my-awesome-app/`.

### Deploy with Docker

```bash
docker build -t my-awesome-app:latest .
docker run -p 8080:80 my-awesome-app:latest
```

Or use Docker Compose:

```bash
docker-compose up --build -d
```

Visit `http://localhost:8080`.

### Performance Optimizations Included

- **Gzip compression** via Nginx
- **Multi-stage build** reduces final image size
- **Tree-shaking** removes unused code
- **SPA routing** configured for client-side navigation

---

## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| `ng: command not found` | Run `npm install -g @angular/cli` or use `npx ng ...` |
| Node version too old | Update Node.js from https://nodejs.org (v18+) |
| Port 4200 already in use | Run `ng serve --port 4300` |
| Docker build fails | Ensure `package-lock.json` exists; run `npm install` first |
| Cannot reach app in Docker | Check `docker-compose logs angular-app` for errors |

---

## 📚 Resources

- [Angular Documentation](https://angular.io)
- [Angular CLI Guide](https://angular.io/cli)
- [Signals API](https://angular.io/guide/signals)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Nginx Configuration](https://nginx.org/en/docs/)

---

## 🤝 Contributing

Have ideas to improve this script? We'd love your input:

- Found a bug? Open an issue with reproduction steps
- Want a new feature? (e.g., NgRx setup, API client scaffolding, E2E tests)
- Improvements to docs or Docker config?

**Pull requests welcome!**

---

## 📄 License

This project is provided as-is for learning and commercial use. Adapt and share freely.

---

## 🎓 Learning Paths

### For Beginners
1. Run the script and explore the generated structure
2. Read through `auth.service.ts` to understand Signals
3. Modify `app.component.ts` to add your first feature component
4. Deploy locally with `ng serve`

### For Intermediate Developers
1. Replace mock auth with real API calls
2. Add feature modules under `features/`
3. Set up global state management
4. Write unit tests for services
5. Deploy to Docker locally

### For Advanced Users
1. Integrate with your CI/CD pipeline
2. Add NgRx or Akita state management
3. Implement route guards and lazy loading
4. Set up E2E tests with Playwright/Cypress
5. Deploy to cloud (AWS, GCP, Azure, Vercel)

---

## 🚀 Quick Start (TL;DR)

```bash
# 1. Make script executable
chmod +x clean-architecture.sh

# 2. Run it
./clean-architecture.sh

# 3. Answer prompts (name: "my-app", Docker: yes)

# 4. Start coding
cd my-app
ng serve --open
```

**That's it!** You now have a production-ready Angular app with authentication, Docker support, and clean architecture. 🎉

---

**Built with ❤️ for Angular developers who value clean code and rapid iteration.**
