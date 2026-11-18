-- Add image URLs to existing dishes.
UPDATE menu_items
SET image_url = CASE name
    WHEN 'Paneer Tikka' THEN 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?auto=format&fit=crop&w=800&q=80'
    WHEN 'Veg Spring Rolls' THEN 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80'
    WHEN 'Paneer Butter Masala' THEN 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80'
    WHEN 'Veg Biryani' THEN 'https://images.unsplash.com/photo-1563379091339-03246963d96c?auto=format&fit=crop&w=800&q=80'
    WHEN 'Chocolate Brownie' THEN 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=800&q=80'
    WHEN 'Fresh Lime Soda' THEN 'https://images.unsplash.com/photo-1513558161293-cdaf765edfd7?auto=format&fit=crop&w=800&q=80'
    ELSE image_url
END
WHERE restaurant_id = 1
  AND image_url IS NULL;

-- Add more sample dishes, avoiding duplicate names for this restaurant.
INSERT INTO menu_items
    (name, description, price, image_url, is_available, category_id, restaurant_id)
SELECT
    d.name, d.description, d.price, d.image_url, TRUE, d.category_id, 1
FROM (
    VALUES
    ('Hara Bhara Kebab', 'Crispy spinach and vegetable kebabs', 189.00,
     'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80', 1::BIGINT),
    ('Crispy Corn', 'Crispy corn tossed with spices', 159.00,
     'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=800&q=80', 1::BIGINT),
    ('Gobi Manchurian', 'Cauliflower tossed in Indo-Chinese sauce', 199.00,
     'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?auto=format&fit=crop&w=800&q=80', 1::BIGINT),
    ('Dal Tadka', 'Yellow lentils tempered with Indian spices', 199.00,
     'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', 2::BIGINT),
    ('Chole Masala', 'Chickpeas cooked in a spiced gravy', 219.00,
     'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', 2::BIGINT),
    ('Butter Naan', 'Soft Indian bread brushed with butter', 59.00,
     'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80', 3::BIGINT),
    ('Jeera Rice', 'Basmati rice tempered with cumin', 149.00,
     'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80', 3::BIGINT),
    ('Gulab Jamun', 'Soft milk dumplings in sugar syrup', 99.00,
     'https://images.unsplash.com/photo-1666190092159-3c7a5f0f5f1d?auto=format&fit=crop&w=800&q=80', 4::BIGINT),
    ('Rasmalai', 'Soft cottage cheese dumplings in creamy milk', 129.00,
     'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?auto=format&fit=crop&w=800&q=80', 4::BIGINT),
    ('Mango Lassi', 'Creamy yogurt drink blended with mango', 99.00,
     'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=800&q=80', 5::BIGINT),
    ('Masala Chai', 'Indian tea brewed with aromatic spices', 49.00,
     'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?auto=format&fit=crop&w=800&q=80', 5::BIGINT)
) AS d(name, description, price, image_url, category_id)
WHERE NOT EXISTS (
    SELECT 1
    FROM menu_items existing
    WHERE existing.restaurant_id = 1
      AND LOWER(existing.name) = LOWER(d.name)
);
