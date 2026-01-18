# 🌍 Terral Viajes - Tourism Agency Landing Page

Modern tourism agency landing page built with Rails 8, featuring a beautiful dark mode, responsive design, and admin CMS.

![Rails](https://img.shields.io/badge/Rails-8.1.2-red)
![Ruby](https://img.shields.io/badge/Ruby-3.2.2-red)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-v4-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)

---

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación](#-instalación)
- [Iniciar el Proyecto](#-iniciar-el-proyecto)
- [Acceder al Panel de Admin](#-acceder-al-panel-de-admin)
- [Gestionar Paquetes de Viajes](#-gestionar-paquetes-de-viajes)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Tecnologías](#-tecnologías)

---

## ✨ Características

- 🎨 **Diseño Moderno**: UI Mobile-First con Tailwind CSS v4
- 🌗 **Dark Mode**: Toggle con persistencia en localStorage
- 🔐 **Autenticación Nativa**: Rails 8 Authentication Generator
- 📦 **CMS de Paquetes**: CRUD completo con imágenes (ActiveStorage)
- ⚙️ **Configuración Dinámica**: Settings model para variables globales
- 🧩 **ViewComponents**: Componentes reutilizables (Hero, PackageCard, etc.)
- 📱 **Responsive**: Optimizado para mobile (max-width: 448px)

---

## 🔧 Requisitos Previos

Asegúrate de tener instalado:

- **Ruby**: 3.2.2
- **Rails**: 8.1.2
- **Node.js**: 20.19.6
- **PostgreSQL**: 16.x
- **Redis**: 8.2.1
- **Overmind** (opcional, para gestión de procesos): `brew install overmind`

---

## 📦 Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/AlejandroBardin/terral-viajes.git
cd terral-viajes
```

### 2. Instalar dependencias

```bash
# Instalar gemas
bundle install

# Instalar dependencias de Node.js (si las hay)
npm install
```

### 3. Configurar Base de Datos

```bash
# Crear la base de datos
bin/rails db:create

# Ejecutar migraciones
bin/rails db:migrate

# Cargar datos iniciales (admin user + settings + paquetes de ejemplo)
bin/rails db:seed
```

**Nota**: El seed crea:
- ✅ Usuario admin: `admin@terral.com` / `password123`
- ✅ Settings: WhatsApp, Facebook Pixel, Textos del Hero
- ✅ 3 Paquetes de ejemplo: Mendoza, Cataratas, Merlo

---

## 🚀 Iniciar el Proyecto

### Usando Overmind (Recomendado)

```bash
bin/dev
```

Esto inicia automáticamente:
- **Web Server**: Rails (puerto 3000)
- **CSS Watcher**: Tailwind CSS

### Usando Foreman (Fallback)

Si no tenés Overmind:

```bash
# Instalar foreman si no lo tenés
gem install foreman

# Iniciar
bin/dev
```

Abrir en el navegador: [http://localhost:3000](http://localhost:3000)

---

## 🔑 Acceder al Panel de Admin

### 1. Ir a la página de login

Visitar: [http://localhost:3000/session/new](http://localhost:3000/session/new)

### 2. Ingresar credenciales

```
Email: admin@terral.com
Password: password123
```

### 3. Navegar al Dashboard

Después de loguearte, serás redirigido al dashboard:
[http://localhost:3000/admin/dashboard](http://localhost:3000/admin/dashboard)

Desde ahí podés acceder a:
- **Paquetes**: `/admin/packages`
- **Configuración**: `/admin/settings`

---

## 📦 Gestionar Paquetes de Viajes

### Ver Paquetes

1. Ir a **Admin** → **Packages**: [http://localhost:3000/admin/packages](http://localhost:3000/admin/packages)
2. Verás la lista de paquetes existentes

### Crear Nuevo Paquete

1. Click en **"New package"**
2. Completar el formulario:
   - **Title**: Nombre del destino (ej: "Mar del Plata 2024")
   - **Price**: Precio por persona (ej: 350000)
   - **Stars**: ⭐⭐⭐ (copiar/pegar emojis o texto)
   - **Duration**: Ej: "4 Noches / 5 Días"
   - **Dates**: Ej: "Salida: 15 de Febrero"
   - **Regime**: Ej: "Media Pensión" o "Desayuno Incluido"
   - **Featured**: ✅ (marcar para mostrar en home)
   - **Description**: Descripción del paquete
   - **Main Image**: Subir imagen principal (JPG, PNG, WebP)
   - **Gallery Images**: Subir múltiples imágenes (opcional)

3. Click en **"Create Package"**

### Editar Paquete

1. Ir a `/admin/packages`
2. Click en **"Edit this package"** en el paquete que querés modificar
3. Actualizar campos
4. Click en **"Update Package"**

### Eliminar Paquete

1. Ir a `/admin/packages/:id` (show)
2. Click en **"Destroy this package"**
3. Confirmar

---

## 📁 Estructura del Proyecto

```
terral-viajes/
├── app/
│   ├── components/          # ViewComponents
│   │   ├── hero_component.rb
│   │   ├── package_card_component.rb
│   │   ├── features_badge_component.rb
│   │   ├── benefits_component.rb
│   │   ├── bottom_cta_component.rb
│   │   └── header_component.rb
│   ├── controllers/
│   │   ├── admin/           # Admin namespace
│   │   │   ├── base_controller.rb
│   │   │   ├── dashboard_controller.rb
│   │   │   ├── packages_controller.rb
│   │   │   └── settings_controller.rb
│   │   ├── home_controller.rb
│   │   └── sessions_controller.rb
│   ├── models/
│   │   ├── package.rb       # Modelo de paquetes
│   │   ├── setting.rb       # Configuración global
│   │   └── user.rb          # Usuarios admin
│   ├── views/
│   │   ├── admin/
│   │   │   ├── dashboard/
│   │   │   ├── packages/
│   │   │   └── settings/
│   │   ├── home/
│   │   │   └── index.html.erb
│   │   └── layouts/
│   │       ├── application.html.erb
│   │       └── admin.html.erb
│   ├── assets/
│   │   └── tailwind/
│   │       └── application.css  # Tailwind v4 config
│   └── javascript/
│       └── controllers/
│           └── dark_mode_controller.js
├── db/
│   ├── migrate/
│   ├── seeds.rb             # Datos iniciales
│   └── fixtures/
│       └── placeholder.jpg  # Imagen placeholder
├── config/
│   ├── routes.rb
│   └── deploy.yml           # Kamal config
├── .overcommit.yml          # Git hooks config
└── README.md
```

---

## 🛠 Tecnologías

### Backend
- **Ruby on Rails** 8.1.2
- **PostgreSQL** 16
- **Redis** 8.2.1 (Solid Queue, Solid Cache, Solid Cable)
- **ActiveStorage** (imágenes)

### Frontend
- **Tailwind CSS** v4 (custom theme)
- **Stimulus** (JS framework)
- **ViewComponent** (componentes reutilizables)
- **Importmap** (sin bundling)

### Deployment
- **Kamal** (deployment tool)
- **Overmind** (process manager)

### Code Quality
- **Rubocop** (Ruby linter)
- **Overcommit** (Git hooks)
- **Brakeman** (security scanner)
- **Bundler Audit** (dependency scanner)

### Testing
- **RSpec** (test framework)
- **FactoryBot** (fixtures)
- **Faker** (fake data)
- **Capybara** (integration tests)

---

## 🎨 Configuración de Settings

Ir a `/admin/settings` para configurar:

- **whatsapp_number**: Número de WhatsApp (ej: `5493813416824`)
- **facebook_pixel**: ID del Pixel de Facebook
- **hero_title**: Título del Hero (ej: `Viajá con Terral`)
- **hero_subtitle**: Subtítulo del Hero

Estos valores se usan dinámicamente en la landing page.

---

## 🧪 Testing

```bash
# Ejecutar todos los tests
bundle exec rspec

# Ejecutar tests específicos
bundle exec rspec spec/models/package_spec.rb
```

---

## 🚢 Deployment (Kamal)

```bash
# Setup inicial (primera vez)
kamal setup

# Deploy
kamal deploy

# Ver logs
kamal app logs
```

**Nota**: Configurar variables de entorno en `.env` antes del deploy.

---

## 📝 Comandos Útiles

```bash
# Generar migraciones
bin/rails generate migration AddFieldToModel field:type

# Ejecutar migrations
bin/rails db:migrate

# Rollback última migración
bin/rails db:rollback

# Consola de Rails
bin/rails console

# Limpiar base de datos y volver a seedear
bin/rails db:reset

# Ver rutas
bin/rails routes | grep admin
```

---

## 🤝 Contribuir

1. Fork el proyecto
2. Crear una rama feature (`git checkout -b feature/amazing-feature`)
3. Commit cambios con conventional commits (`git commit -m "feat: add amazing feature"`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abrir Pull Request

---

## 📧 Contacto

**Terral Viajes**
- WhatsApp: [+54 9 381 3416824](https://wa.me/5493813416824)
- Dirección: José Colombres 372

---

## 📄 Licencia

Este proyecto es privado y propietario de Terral Viajes.

---

**¡Listo para viajar! 🌎✈️**
