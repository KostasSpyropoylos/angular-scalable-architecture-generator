#!/bin/bash

# Configuration
CLI_PACKAGE="@angular/cli"
MIN_NODE_VERSION=18
PROJECT_NAME=""
# --- End Configuration ---

check_prerequisites() {
    echo "🔍 Checking prerequisites..."

    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | sed 's/v//')
        MAJOR_NODE_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1)
        if [ "$MAJOR_NODE_VERSION" -lt "$MIN_NODE_VERSION" ]; then
            echo "⚠️ Node.js version $NODE_VERSION installed. $MIN_NODE_VERSION+ recommended."
        else
            echo "✅ Node.js ($NODE_VERSION) installed."
        fi
    else
        echo "❌ Node.js is not installed. Aborting."
        exit 1
    fi

    if command -v ng &> /dev/null; then
        echo "✅ Angular CLI is installed globally."
    else
        echo "❌ Angular CLI not found. Installing now..."
        npm install -g $CLI_PACKAGE
        if [ $? -ne 0 ]; then
            echo "❌ Failed to install Angular CLI."
            exit 1
        fi
        echo "✅ Angular CLI installed."
    fi
}

generate_angular_app() {
    echo -e "\n📝 Enter the desired name for your new Angular application:"
    read -r PROJECT_NAME

    if [[ -z "$PROJECT_NAME" ]]; then
        echo "❌ Project name cannot be empty. Aborting."
        exit 1
    fi

    echo -e "\n🔥 Create new Angular application named: **$PROJECT_NAME** (y/N)"
    read -r CONFIRM

    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo "Operation cancelled by user."
        exit 0
    fi

    echo -e "\n⏳ Generating the Angular application..."
    ng new "$PROJECT_NAME" --skip-git --style=scss --standalone --skip-tests

    if [ $? -eq 0 ]; then
        echo -e "\n🎉 Success! Application **$PROJECT_NAME** created."
    else
        echo -e "\n❌ Angular application generation failed. Aborting."
        exit 1
    fi
}

generate_application_structure() {
    cd "$PROJECT_NAME" || { echo "❌ Failed to navigate to project directory."; exit 1; }

    echo -e "\n📝 Generating project structure and initial files..."

    mkdir -p src/app/features
    mkdir -p src/app/shared
    mkdir -p src/app/state
    mkdir -p src/app/core/auth/models
    mkdir -p src/app/core/auth/services

    echo "✅ Project structure created."
}

generate_sample_auth_files() {
    echo -e "\n🛠️ Adding sample Auth entities..."

    # User Model
    cat << 'EOF' > src/app/core/auth/models/user.model.ts
// src/app/core/auth/models/user.model.ts

/**
 * Represents a user entity.
 */
export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: 'admin' | 'user' | 'guest';
  createdAt: number;
}
EOF

    # Auth State Model
    cat << 'EOF' > src/app/core/auth/models/auth.state.ts
// src/app/core/auth/models/auth.state.ts

import { User } from './user.model';

/**
 * Defines the authentication state structure.
 */
export interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
  authToken: string | null;
  error: string | null;
  isLoading: boolean;
}

/**
 * Initial state for authentication.
 */
export const initialAuthState: AuthState = {
  isAuthenticated: false,
  user: null,
  authToken: null,
  error: null,
  isLoading: false,
};
EOF

    # Auth Service
    cat << 'EOF' > src/app/core/auth/services/auth.service.ts
// src/app/core/auth/services/auth.service.ts

import { Injectable, computed, signal } from '@angular/core';
import { AuthState, initialAuthState } from '../models/auth.state';
import { User } from '../models/user.model';
import { Observable, delay, of, throwError } from 'rxjs';

/**
 * Sample service for handling authentication using Angular Signals.
 * NOTE: Replace with actual API calls in a real application.
 */
@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private authState = signal<AuthState>(initialAuthState);

  public currentUser = computed(() => this.authState().user);
  public isAuthenticated = computed(() => this.authState().isAuthenticated);
  public isLoading = computed(() => this.authState().isLoading);
  public authError = computed(() => this.authState().error);

  /**
   * Mock login function.
   */
  public login(email: string): Observable<User> {
    this.authState.update(state => ({ ...state, isLoading: true, error: null }));

    // Simulate an API call
    return of(null).pipe(
      delay(1500),
      () => {
        if (email === 'test@user.com' || email === 'admin@user.com') {
          const mockUser: User = {
            id: 'u-12345',
            email: email,
            firstName: 'Demo',
            lastName: 'User',
            role: email.startsWith('admin') ? 'admin' : 'user',
            createdAt: Date.now()
          };

          this.authState.set({
            isAuthenticated: true,
            user: mockUser,
            authToken: 'mock-jwt-token-123',
            error: null,
            isLoading: false,
          });
          return of(mockUser);
        } else {
          this.authState.update(state => ({
            ...state,
            isLoading: false,
            error: 'Invalid credentials. Try test@user.com or admin@user.com'
          }));
          return throwError(() => new Error('Login failed'));
        }
      }
    );
  }

  /**
   * Logs out the current user.
   */
  public logout(): void {
    this.authState.set(initialAuthState);
    console.log('User logged out.');
  }
}
EOF

    echo "✅ Sample entities and services added."
}


prompt_for_docker_files() {
    echo -e "\n🐳 Generate Dockerfile, docker-compose.yml, and Nginx config for production deployment? (y/N)"
    read -r INCLUDE_DOCKER
    if [[ "$INCLUDE_DOCKER" == "y" || "$INCLUDE_DOCKER" == "Y" ]]; then
        generate_deployment_artifacts
    else
        echo "⏭️ Skipping deployment files."
    fi
}

generate_deployment_artifacts() {
    echo -e "\n🚢 Generating deployment artifacts..."

    # 1. Dockerfile - Uses npm ci and $PROJECT_NAME
    # Note: Using 'EOF' without quotes to allow variable substitution
    cat << EOF > Dockerfile
# Docker multi-stage build for Angular SPA
# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies deterministically
COPY package.json package-lock.json ./
RUN npm ci

# Build the application
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built app using the project name
COPY --from=builder /app/dist/${PROJECT_NAME} /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

    # 2. Nginx Configuration
    cat << 'EOF' > nginx.conf
# Nginx config for Angular Single Page Application (SPA)
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;

    # Enable Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_proxied any;
    gzip_vary on;

    # Angular SPA routing (redirects all non-file paths to index.html)
    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

    # 3. Docker Compose
    cat << 'EOF' > docker-compose.yml
version: '3.8'

services:
  angular-app:
    build:
      context: .
      dockerfile: Dockerfile
      target: builder
    ports:
      - "8080:80"
    container_name: ${PROJECT_NAME:-angular-app}-container
    restart: always
EOF

    echo "✅ Deployment artifacts generated."
    echo "------------------------------------------------------------------"
    echo "To build and run with Docker:"
    echo "  cd $PROJECT_NAME"
    echo "  docker-compose up --build -d"
    echo "App available at http://localhost:8080."
    echo "------------------------------------------------------------------"
}

# --- Main Execution ---
check_prerequisites
generate_angular_app
generate_application_structure
generate_sample_auth_files
prompt_for_docker_files

# Final instructions for local dev
echo "------------------------------------------------------------------"
echo "To start local development:"
echo "  cd $PROJECT_NAME"
echo "  ng serve --open"
echo "------------------------------------------------------------------"