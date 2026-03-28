import pg from 'pg';
const { Pool } = pg;

class Database {
  constructor() {
    this.pool = new Pool({
      connectionString: process.env.DATABASE_URL,
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 2000,
    });

    this.pool.on('error', (err) => {
      console.error('Unexpected error on idle client', err);
      process.exit(-1);
    });
  }

  /**
   * Инициализация структуры таблиц и индексов
   */
  async init() {
    const client = await this.pool.connect();
    try {
      await client.query('BEGIN');

      // Таблица конфигурации бота
      await client.query(`
        CREATE TABLE IF NOT EXISTS bot_config (
          key TEXT PRIMARY KEY,
          value JSONB NOT NULL,
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
      `);

      // Таблица товаров с автоматическим поисковым вектором (FTS)
      await client.query(`
        CREATE TABLE IF NOT EXISTS products (
          id SERIAL PRIMARY KEY,
          external_id TEXT UNIQUE,
          name TEXT NOT NULL,
          category TEXT,
          price NUMERIC(12, 2) DEFAULT 0,
          description TEXT,
          metadata JSONB,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          search_vector tsvector GENERATED ALWAYS AS (
            setweight(to_tsvector('russian', coalesce(name, '')), 'A') ||
            setweight(to_tsvector('russian', coalesce(description, '')), 'B')
          ) STORED
        );
      `);

      // GIN индекс для быстрого поиска
      await client.query(`
        CREATE INDEX IF NOT EXISTS products_search_idx ON products USING GIN(search_vector);
      `);

      // Таблицы для AI контекста
      await client.query(`
        CREATE TABLE IF NOT EXISTS ai_chats (
          chat_id BIGINT PRIMARY KEY,
          user_id BIGINT NOT NULL,
          context_summary TEXT,
          last_activity TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS ai_messages (
          id SERIAL PRIMARY KEY,
          chat_id BIGINT REFERENCES ai_chats(chat_id),
          role TEXT NOT NULL,
          content TEXT NOT NULL,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
      `);

      await client.query('COMMIT');
      console.log('Database initialized successfully');
    } catch (e) {
      await client.query('ROLLBACK');
      console.error('Database initialization failed:', e);
      throw e;
    } finally {
      client.release();
    }
  }

  /**
   * Полнотекстовый поиск по товарам
   */
  async searchProducts(searchQuery, limit = 10) {
    const sql = `
      SELECT 
        id, name, category, price, description, metadata,
        ts_rank(search_vector, websearch_to_tsquery('russian', $1)) as rank
      FROM products
      WHERE search_vector @@ websearch_to_tsquery('russian', $1)
      ORDER BY rank DESC
      LIMIT $2;
    `;
    const res = await this.pool.query(sql, [searchQuery, limit]);
    return res.rows;
  }

  /**
   * Универсальный метод вставки
   */
  async insert(table, data) {
    const keys = Object.keys(data);
    const values = Object.values(data);
    const placeholders = keys.map((_, i) => `$${i + 1}`).join(', ');
    const sql = `INSERT INTO ${table} (${keys.join(', ')}) VALUES (${placeholders}) RETURNING *`;
    const res = await this.pool.query(sql, values);
    return res.rows[0];
  }

  /**
   * Универсальный метод обновления
   */
  async update(table, id, data) {
    const keys = Object.keys(data);
    const values = Object.values(data);
    const setClause = keys.map((key, i) => `${key} = $${i + 1}`).join(', ');
    const sql = `UPDATE ${table} SET ${setClause} WHERE id = $${keys.length + 1} RETURNING *`;
    const res = await this.pool.query(sql, [...values, id]);
    return res.rows[0];
  }

  /**
   * Универсальный метод запроса (raw SQL)
   */
  async query(sql, params = []) {
    const res = await this.pool.query(sql, params);
    return res.rows;
  }

  /**
   * Удаление записи
   */
  async delete(table, id) {
    await this.pool.query(`DELETE FROM ${table} WHERE id = $1`, [id]);
    return true;
  }

  /**
   * Закрытие пула
   */
  async close() {
    await this.pool.end();
  }
}

export default new Database();
