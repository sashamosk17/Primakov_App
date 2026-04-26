const { Pool } = require('pg');
const bcrypt = require('bcrypt');

const pool = new Pool({
  host: '185.221.198.242',
  port: 5432,
  database: 'primakovapp',
  user: 'primakov',
  password: process.env.DB_PASSWORD || 'primakov'
});

async function updatePasswords() {
  try {
    // Новый bcrypt хеш для пароля "password123"
    const newPasswordHash = await bcrypt.hash('password123', 10);
    console.log('New bcrypt hash:', newPasswordHash);

    // Обновляем пароли для всех пользователей
    const result = await pool.query(
      'UPDATE users SET password_hash = $1 WHERE email LIKE $2',
      [newPasswordHash, '%@primakov.school']
    );

    console.log(`\n✓ Updated ${result.rowCount} users with new bcrypt password hash`);
    console.log('All users can now login with password: password123');

    await pool.end();
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

updatePasswords();
