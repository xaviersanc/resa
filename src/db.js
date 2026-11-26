const { Pool, types } = require("pg");

types.setTypeParser(1114, (value) => value);

// pg lit la configuration dans les variables PGHOST, PGPORT, PGUSER, PGPASSWORD, PGDATABASE.
const pool = new Pool();

pool.on("error", (err) => {
  console.error("PostgreSQL :", err.message);
});

module.exports = pool;
