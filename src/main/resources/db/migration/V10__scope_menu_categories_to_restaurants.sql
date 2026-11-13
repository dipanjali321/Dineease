ALTER TABLE menu_categories ADD COLUMN restaurant_id BIGINT;
UPDATE menu_categories SET restaurant_id = 1;
ALTER TABLE menu_categories ALTER COLUMN restaurant_id SET NOT NULL;
ALTER TABLE menu_categories DROP CONSTRAINT menu_categories_name_key;
ALTER TABLE menu_categories ADD CONSTRAINT fk_menu_categories_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE RESTRICT;
ALTER TABLE menu_categories ADD CONSTRAINT uq_menu_categories_restaurant_name UNIQUE (restaurant_id, name);
CREATE INDEX idx_menu_categories_restaurant_id ON menu_categories (restaurant_id);
