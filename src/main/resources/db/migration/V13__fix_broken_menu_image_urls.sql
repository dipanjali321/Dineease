-- Fix broken image URLs for three menu items.

UPDATE menu_items
SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80'
WHERE restaurant_id = 1 AND name = 'Veg Biryani';

UPDATE menu_items
SET image_url = 'https://images.unsplash.com/photo-1546173159-315724a31696?auto=format&fit=crop&w=800&q=80'
WHERE restaurant_id = 1 AND name = 'Fresh Lime Soda';

UPDATE menu_items
SET image_url = 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=800&q=80'
WHERE restaurant_id = 1 AND name = 'Gulab Jamun';
