"use strict";
/**
 * PostgreSQL implementation of ICanteenMenuRepository
 *
 * Handles canteen menu and menu items with nutritional information.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostgresCanteenMenuRepository = void 0;
const Result_1 = require("../../../shared/Result");
class PostgresCanteenMenuRepository {
    constructor(pool) {
        this.pool = pool;
    }
    async getByDate(date) {
        try {
            const dateString = date.toISOString().split("T")[0];
            const menuQuery = `
        SELECT id, date, meal_type, is_active, created_at, updated_at
        FROM canteen_menu
        WHERE date = $1 AND is_active = true
        ORDER BY meal_type
      `;
            const menuResult = await this.pool.query(menuQuery, [dateString]);
            const menus = [];
            for (const menuRow of menuResult.rows) {
                const items = await this.getMenuItems(menuRow.id);
                menus.push(this.mapRowToMenu(menuRow, items));
            }
            return Result_1.Result.ok(menus);
        }
        catch (error) {
            console.error("Error getting menu by date:", error);
            return Result_1.Result.fail("Failed to get menu");
        }
    }
    async getByDateAndMealType(date, mealType) {
        try {
            const dateString = date.toISOString().split("T")[0];
            const menuQuery = `
        SELECT id, date, meal_type, is_active, created_at, updated_at
        FROM canteen_menu
        WHERE date = $1 AND meal_type = $2 AND is_active = true
      `;
            const menuResult = await this.pool.query(menuQuery, [dateString, mealType]);
            if (menuResult.rows.length === 0) {
                return Result_1.Result.ok(null);
            }
            const menuRow = menuResult.rows[0];
            const items = await this.getMenuItems(menuRow.id);
            const menu = this.mapRowToMenu(menuRow, items);
            return Result_1.Result.ok(menu);
        }
        catch (error) {
            console.error("Error getting menu by date and meal type:", error);
            return Result_1.Result.fail("Failed to get menu");
        }
    }
    async getTodaysMenu() {
        const today = new Date();
        return this.getByDate(today);
    }
    async save(menu) {
        const client = await this.pool.connect();
        try {
            await client.query("BEGIN");
            const dateString = menu.date.toISOString().split("T")[0];
            // Insert menu
            const menuQuery = `
        INSERT INTO canteen_menu (id, date, meal_type, is_active, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6)
      `;
            await client.query(menuQuery, [
                menu.id,
                dateString,
                menu.mealType,
                menu.isActive,
                menu.createdAt,
                menu.updatedAt,
            ]);
            // Insert menu items
            for (const item of menu.items) {
                await this.saveMenuItem(client, item, menu.id);
            }
            await client.query("COMMIT");
            return Result_1.Result.ok();
        }
        catch (error) {
            await client.query("ROLLBACK");
            console.error("Error saving menu:", error);
            return Result_1.Result.fail("Failed to save menu");
        }
        finally {
            client.release();
        }
    }
    async update(menu) {
        const client = await this.pool.connect();
        try {
            await client.query("BEGIN");
            const dateString = menu.date.toISOString().split("T")[0];
            // Update menu
            const menuQuery = `
        UPDATE canteen_menu
        SET date = $2,
            meal_type = $3,
            is_active = $4,
            updated_at = NOW()
        WHERE id = $1
      `;
            await client.query(menuQuery, [menu.id, dateString, menu.mealType, menu.isActive]);
            // Delete existing items
            await client.query("DELETE FROM menu_items WHERE menu_id = $1", [menu.id]);
            // Insert updated items
            for (const item of menu.items) {
                await this.saveMenuItem(client, item, menu.id);
            }
            await client.query("COMMIT");
            return Result_1.Result.ok();
        }
        catch (error) {
            await client.query("ROLLBACK");
            console.error("Error updating menu:", error);
            return Result_1.Result.fail("Failed to update menu");
        }
        finally {
            client.release();
        }
    }
    async addMenuItem(item) {
        try {
            await this.saveMenuItem(this.pool, item, item.menuId);
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error adding menu item:", error);
            return Result_1.Result.fail("Failed to add menu item");
        }
    }
    async updateMenuItem(item) {
        try {
            const query = `
        UPDATE menu_items
        SET name = $2,
            description = $3,
            category = $4,
            calories = $5,
            protein = $6,
            carbs = $7,
            fat = $8,
            weight = $9,
            price = $10,
            image_url = $11,
            is_vegetarian = $12,
            is_vegan = $13,
            allergens = $14,
            display_order = $15
        WHERE id = $1
      `;
            await this.pool.query(query, [
                item.id,
                item.name,
                item.description || null,
                item.category || null,
                item.calories || null,
                item.protein || null,
                item.carbs || null,
                item.fat || null,
                item.weight || null,
                item.price || null,
                item.imageUrl || null,
                item.isVegetarian,
                item.isVegan,
                item.allergens || null,
                item.displayOrder,
            ]);
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error updating menu item:", error);
            return Result_1.Result.fail("Failed to update menu item");
        }
    }
    async removeMenuItem(itemId) {
        try {
            await this.pool.query("DELETE FROM menu_items WHERE id = $1", [itemId]);
            return Result_1.Result.ok();
        }
        catch (error) {
            console.error("Error removing menu item:", error);
            return Result_1.Result.fail("Failed to remove menu item");
        }
    }
    /**
     * Get all items for a menu
     */
    async getMenuItems(menuId) {
        const query = `
      SELECT id, menu_id, name, description, category, calories, protein, carbs, fat,
             weight, price, image_url, is_vegetarian, is_vegan, allergens, display_order, created_at
      FROM menu_items
      WHERE menu_id = $1
      ORDER BY display_order
    `;
        const result = await this.pool.query(query, [menuId]);
        return result.rows.map((row) => this.mapRowToMenuItem(row));
    }
    /**
     * Save a single menu item
     */
    async saveMenuItem(client, item, menuId) {
        const query = `
      INSERT INTO menu_items (id, menu_id, name, description, category, calories, protein, carbs, fat,
                             weight, price, image_url, is_vegetarian, is_vegan, allergens, display_order, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, NOW())
    `;
        await client.query(query, [
            item.id,
            menuId,
            item.name,
            item.description || null,
            item.category || null,
            item.calories || null,
            item.protein || null,
            item.carbs || null,
            item.fat || null,
            item.weight || null,
            item.price || null,
            item.imageUrl || null,
            item.isVegetarian,
            item.isVegan,
            item.allergens || null,
            item.displayOrder,
        ]);
    }
    /**
     * Map database row to CanteenMenu object
     */
    mapRowToMenu(row, items) {
        return {
            id: row.id,
            date: new Date(row.date),
            mealType: row.meal_type,
            isActive: row.is_active,
            items: items,
            createdAt: new Date(row.created_at),
            updatedAt: new Date(row.updated_at),
        };
    }
    /**
     * Map database row to MenuItem object
     */
    mapRowToMenuItem(row) {
        return {
            id: row.id,
            menuId: row.menu_id,
            name: row.name,
            description: row.description,
            category: row.category,
            calories: row.calories,
            protein: row.protein ? parseFloat(row.protein) : undefined,
            carbs: row.carbs ? parseFloat(row.carbs) : undefined,
            fat: row.fat ? parseFloat(row.fat) : undefined,
            weight: row.weight,
            price: row.price ? parseFloat(row.price) : undefined,
            imageUrl: row.image_url,
            isVegetarian: row.is_vegetarian,
            isVegan: row.is_vegan,
            allergens: row.allergens,
            displayOrder: row.display_order,
            createdAt: new Date(row.created_at),
        };
    }
}
exports.PostgresCanteenMenuRepository = PostgresCanteenMenuRepository;
