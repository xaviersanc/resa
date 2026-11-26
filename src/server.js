require("dotenv").config();

const required = ["PGHOST", "PGUSER", "PGPASSWORD", "PGDATABASE"];
const missing = required.filter((name) => !process.env[name]);
if (missing.length > 0) {
  console.error(
    `Configuration manquante : ${missing.join(", ")}.\n` +
      "Copiez .env.example vers .env et renseignez ces variables.",
  );
  process.exit(1);
}

const app = require("./app");

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Résa démarré sur http://localhost:${port}`);
});
