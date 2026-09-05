// A simple data class that represents one product.
// This is NOT a widget, just a plain object that holds product info.
class Product {
  final String id;
  final String name;
  final String category; // e.g. Phone, Laptop, Tablet, Accessory
  final double price;
  final String imageUrl;
  final String description;
  final List<String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.specs,
  });
}

// Sample/dummy product catalog so the grid has something to show.
// In a real app this would come from a backend API instead.
final List<Product> sampleProducts = [
  const Product(
    id: 'p1',
    name: 'iPhone 15 Pro',
    category: 'Phone',
    price: 999.00,
    imageUrl:
        'https://images.unsplash.com/photo-1592286927505-1def25115558?w=800&q=80&auto=format&fit=crop',
    description:
        'Apple\'s flagship smartphone featuring a titanium design, A17 Pro chip, and a pro-grade camera system for stunning photos and video.',
    specs: ['6.1" Super Retina XDR display', 'A17 Pro chip', '128GB storage', '48MP main camera'],
  ),
  const Product(
    id: 'p2',
    name: 'Samsung Galaxy S24 Ultra',
    category: 'Phone',
    price: 1199.00,
    imageUrl:
        'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=800&q=80&auto=format&fit=crop',
    description:
        'A powerhouse Android flagship with a built-in S Pen, a 200MP camera, and a bright 6.8" Dynamic AMOLED display.',
    specs: ['6.8" QHD+ AMOLED display', 'Snapdragon 8 Gen 3', '256GB storage', '200MP main camera'],
  ),
  const Product(
    id: 'p3',
    name: 'MacBook Air M3',
    category: 'Laptop',
    price: 1099.00,
    imageUrl:
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80&auto=format&fit=crop',
    description:
        'Thin, light, and fanless. The M3 chip delivers all-day battery life and enough power for everyday work and creative tasks.',
    specs: ['13.6" Liquid Retina display', 'Apple M3 chip', '8GB unified memory', 'Up to 18 hrs battery'],
  ),
  const Product(
    id: 'p4',
    name: 'Dell XPS 13',
    category: 'Laptop',
    price: 999.00,
    imageUrl:
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80&auto=format&fit=crop',
    description:
        'A compact Windows ultrabook with an edge-to-edge InfinityEdge display, ideal for students and professionals on the go.',
    specs: ['13.4" FHD+ display', 'Intel Core i7', '16GB RAM', '512GB SSD'],
  ),
  const Product(
    id: 'p5',
    name: 'iPad Pro 12.9"',
    category: 'Tablet',
    price: 1099.00,
    imageUrl:
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800&q=80&auto=format&fit=crop',
    description:
        'The ultimate iPad experience with a stunning Liquid Retina XDR display and pro-level performance for creative work.',
    specs: ['12.9" Liquid Retina XDR', 'Apple M4 chip', '256GB storage', 'Face ID'],
  ),
  const Product(
    id: 'p6',
    name: 'Samsung Galaxy Tab S9',
    category: 'Tablet',
    price: 799.00,
    imageUrl:
        'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=800&q=80&auto=format&fit=crop',
    description:
        'A sleek Android tablet with an AMOLED display and an included S Pen, great for note-taking and entertainment.',
    specs: ['11" Dynamic AMOLED 2X', 'Snapdragon 8 Gen 2', '128GB storage', 'S Pen included'],
  ),
  const Product(
    id: 'p7',
    name: 'Sony WH-1000XM5',
    category: 'Accessory',
    price: 349.00,
    imageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80&auto=format&fit=crop',
    description:
        'Industry-leading noise-cancelling headphones with rich sound quality and up to 30 hours of battery life.',
    specs: ['Active Noise Cancelling', '30-hour battery', 'Bluetooth 5.2', 'Touch controls'],
  ),
  const Product(
    id: 'p8',
    name: 'Apple Watch Series 9',
    category: 'Accessory',
    price: 399.00,
    imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80&auto=format&fit=crop',
    description:
        'Track your health and stay connected on the go with a brighter display and a faster S9 chip.',
    specs: ['Always-On Retina display', 'S9 SiP chip', 'Blood oxygen app', 'Water resistant'],
  ),
  const Product(
    id: 'p9',
    name: 'AirPods Pro 2',
    category: 'Accessory',
    price: 249.00,
    imageUrl:
        'https://images.unsplash.com/photo-1585790050230-5dd28404ccb9?w=800&q=80&auto=format&fit=crop',
    description:
        'Adaptive noise cancellation and a personalized spatial audio experience in a compact, comfortable design.',
    specs: ['Active Noise Cancelling', 'MagSafe charging case', 'Sweat & water resistant', 'Up to 6 hrs listening'],
  ),
];
