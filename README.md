<p align="center">
  <img src="assets/cherry_logo.png" width="300" height ="100">
</p>

<p align="center">

</p>


# Getting started

cherry uses a postgres database so you'll need one running. Once you have that you'll need to create `.env` file like below and populate the database url

```
DATABASE_URL=...
```

The backend is written in Rust so you'll need a [Rust toolchain](https://rustup.rs). The frontend is written in Gleam so you'll need to install [Gleam](https://gleam.run/getting-started/installing/).

To run the backend
```
cd backend && cargo run
```

To run the frontend
```
cd frontend && gleam run -m lustre/dev start
```
