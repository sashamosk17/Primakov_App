const { Pool } = require('pg');

const pool = new Pool({
  host: '185.221.198.242',
  port: 5432,
  database: 'primakovapp',
  user: 'primakov',
  password: 'primakov',
});

async function checkStories() {
  try {
    // First check table structure
    const structure = await pool.query(`
      SELECT column_name, data_type
      FROM information_schema.columns
      WHERE table_name = 'stories'
      ORDER BY ordinal_position
    `);
    console.log('Stories table structure:');
    console.log(structure.rows);

    // Then get data
    const result = await pool.query('SELECT * FROM stories LIMIT 10');
    console.log('\nStories in database:');
    console.log(result.rows);
    console.log(`\nTotal stories: ${result.rowCount}`);
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await pool.end();
  }
}

checkStories();
