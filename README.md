# Fullstack Application

This is a fullstack application with an Elm-based frontend and a Node.js backend. The backend uses MongoDB for data storage and runs in a Docker container, while the frontend is served locally using `vite`.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)
- [Node.js](https://nodejs.org/) (version 14 or later)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [Elm](https://elm-lang.org/) (install globally using `npm install -g elm`)

---

## Backend Setup

The backend runs in a Docker container along with a MongoDB database. Follow these steps to set it up:

### 1. Clone the Repository

Clone the project repository to your local machine:

```
git clone https://github.com/askermarcus/my-first-elm-app.git
```

Navigate to project directory:

```
cd my-first-elm-app
```

### Build and run the Docker containers

```
docker-compose up --build
```

This will:

Build the backend Docker image.
Start the backend on http://localhost:3000.
Start a MongoDB container on port 27017.
You can verify the Backend is running.
Open your browser or use a tool like Postman to test the backend API:

```
docker logs <backend-container-id>
```

## Frontend Setup

The frontend is an Elm application served locally using vite. Follow these teps to set it up:

Navigate to the frontend directory:

```
cd frontend
```

Install the dependencies

```
npm install
```

Start the development server:

```
npm run dev
```

And now you should have the todo application running on:

```
http://localhost:8000/
```

## Building for Production

Backend:
The backend is already containerized and ready for production. You can deploy the Docker container to your production environment.

Frontend:
To build the frontend for production, run:

```
npm run build
```

This will generate the production-ready files in the dist directory.

### License

This project is licensed under the ISC License.
