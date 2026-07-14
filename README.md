# Ecommerce Project

This repository contains a Django REST backend and a React/Vite frontend for a simple ecommerce app.

## Project Structure

- `backend/` - Django API, PostgreSQL configuration, and media uploads
- `frontend/` - React UI built with Vite
- `.venv/` - Python virtual environment at the repo root

## Requirements

- Python 3.14 or compatible
- Node.js 18+ recommended
- PostgreSQL running locally

## Backend Setup

1. Open a terminal in `backend/`.
2. Activate the virtual environment from the repo root:

```powershell
This depend on if you're using window or linux
```

3. Install Python dependencies:

```powershell
pip install -r requirements.txt
```

4. Make sure `backend/.env` contains your database settings:

```env
DB_NAME=ecommerce_db
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

You can copy the template from [backend/.env.example](backend/.env.example).

5. Run migrations and start the server:

```powershell
python manage.py migrate
python manage.py runserver
```

The API will be available at `http://127.0.0.1:8000`.

## Frontend Setup

1. Open a second terminal in `frontend/`.
2. Install frontend dependencies:

```powershell
cd c:\Users\OLALEYE\Desktop\Stuff\Claude\ecommerce-project\frontend
npm install
```

3. Set the backend base URL for the React app:

```powershell
$env:VITE_DJANGO_BASE_URL="http://127.0.0.1:8000"
```

You can also copy the template from [frontend/.env.example](frontend/.env.example).

4. Start the Vite dev server:

```powershell
npm run dev
```

Open the URL printed by Vite, usually `http://localhost:5173`.

## Notes

- The backend uses Django REST Framework, JWT auth, CORS, Pillow, and PostgreSQL.
- The frontend calls backend endpoints under `/api/`.
- If Pillow installation fails on Windows with Python 3.14, use the pinned version in `backend/requirements.txt`, which is compatible with the current setup.
