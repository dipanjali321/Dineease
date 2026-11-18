-- V14: Add 30 new dishes to DineEase Demo Restaurant.
-- Preserve existing dishes and avoid duplicate names.
-- Image files will be added under frontend/public/images/.

WITH new_dishes(name, description, price, category_name, image_file) AS (
    VALUES
    ('Veg Hakka Noodles', 'Indo-Chinese noodles tossed with fresh vegetables', 199.00, 'Main Course', 'veg-hakka-noodles.jpg'),
    ('Veg Fried Rice', 'Wok-fried rice with mixed vegetables', 189.00, 'Main Course', 'veg-fried-rice.jpg'),
    ('Schezwan Fried Rice', 'Spicy fried rice with Schezwan sauce and vegetables', 209.00, 'Main Course', 'schezwan-fried-rice.jpg'),
    ('Veg Manchurian Gravy', 'Vegetable dumplings in Indo-Chinese gravy', 199.00, 'Main Course', 'veg-manchurian-gravy.jpg'),
    ('Hakka Paneer', 'Paneer tossed with peppers and Indo-Chinese seasoning', 249.00, 'Main Course', 'hakka-paneer.jpg'),
    ('Palak Paneer', 'Paneer cubes in creamy spinach gravy', 279.00, 'Main Course', 'palak-paneer.jpg'),
    ('Shahi Paneer', 'Paneer in a rich, creamy tomato and cashew gravy', 289.00, 'Main Course', 'shahi-paneer.jpg'),
    ('Kadai Paneer', 'Paneer cooked with peppers and kadai spices', 279.00, 'Main Course', 'kadai-paneer.jpg'),
    ('Malai Kofta', 'Vegetable and paneer dumplings in creamy gravy', 269.00, 'Main Course', 'malai-kofta.jpg'),
    ('Mix Veg Curry', 'Seasonal vegetables cooked in Indian curry', 229.00, 'Main Course', 'mix-veg-curry.jpg'),
    ('Aloo Gobi', 'Potatoes and cauliflower cooked with Indian spices', 199.00, 'Main Course', 'aloo-gobi.jpg'),
    ('Baingan Bharta', 'Roasted eggplant mashed and cooked with spices', 199.00, 'Main Course', 'baingan-bharta.jpg'),
    ('Veg Kolhapuri', 'Mixed vegetables in a spicy Kolhapuri gravy', 239.00, 'Main Course', 'veg-kolhapuri.jpg'),
    ('Mushroom Masala', 'Mushrooms cooked in spiced onion-tomato gravy', 259.00, 'Main Course', 'mushroom-masala.jpg'),
    ('Punjabi Chole Bhature', 'Punjabi chickpea curry served with bhature', 199.00, 'Main Course', 'punjabi-chole-bhature.jpg'),
    ('Tandoori Roti', 'Whole-wheat flatbread baked in a tandoor', 35.00, 'Breads and Rice', 'tandoori-roti.jpg'),
    ('Garlic Naan', 'Soft naan topped with garlic and herbs', 69.00, 'Breads and Rice', 'garlic-naan.jpg'),
    ('Laccha Paratha', 'Layered whole-wheat Indian flatbread', 59.00, 'Breads and Rice', 'laccha-paratha.jpg'),
    ('Plain Steamed Rice', 'Steamed basmati rice', 119.00, 'Breads and Rice', 'plain-steamed-rice.jpg'),
    ('Veg Pulao', 'Basmati rice cooked with vegetables and spices', 179.00, 'Breads and Rice', 'veg-pulao.jpg'),
    ('Aloo Tikki', 'Crisp potato patties served with chutneys', 129.00, 'Starters', 'aloo-tikki.jpg'),
    ('Onion Pakora', 'Onion fritters coated in seasoned gram flour', 119.00, 'Starters', 'onion-pakora.jpg'),
    ('Dahi Puri', 'Crisp puris filled with yogurt, chutneys and toppings', 139.00, 'Starters', 'dahi-puri.jpg'),
    ('Pani Puri', 'Crisp puris served with spiced tangy water', 99.00, 'Starters', 'pani-puri.jpg'),
    ('Cheese Corn Balls', 'Crispy bites filled with cheese and sweet corn', 169.00, 'Starters', 'cheese-corn-balls.jpg'),
    ('Veg Seekh Kebab', 'Minced vegetable kebabs grilled with Indian spices', 189.00, 'Starters', 'veg-seekh-kebab.jpg'),
    ('Kesar Kulfi', 'Traditional Indian frozen dessert flavored with saffron', 89.00, 'Desserts', 'kesar-kulfi.jpg'),
    ('Gajar Ka Halwa', 'Carrot pudding cooked with milk and cardamom', 119.00, 'Desserts', 'gajar-ka-halwa.jpg'),
    ('Strawberry Milkshake', 'Milkshake blended with strawberries', 129.00, 'Beverages', 'strawberry-milkshake.jpg'),
    ('Cold Coffee', 'Chilled coffee blended with milk', 119.00, 'Beverages', 'cold-coffee.jpg')
)
INSERT INTO menu_items
    (name, description, price, image_url, is_available, category_id, restaurant_id)
SELECT
    d.name,
    d.description,
    d.price,
    'https://dineease-blue.vercel.app/images/' || d.image_file,
    TRUE,
    c.id,
    r.id
FROM new_dishes d
JOIN restaurants r
    ON r.name = 'DineEase Demo Restaurant'
JOIN menu_categories c
    ON c.restaurant_id = r.id
   AND c.name = d.category_name
WHERE NOT EXISTS (
    SELECT 1
    FROM menu_items existing
    WHERE existing.restaurant_id = r.id
      AND LOWER(TRIM(existing.name)) = LOWER(TRIM(d.name))
);
