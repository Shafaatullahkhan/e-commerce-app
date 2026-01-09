import 'package:flutter/material.dart';
import 'package:pizzashop/Pages/category_details.dart';
import 'package:pizzashop/Services/Shearedprefrences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name, image;

  // 🔍 SEARCH CONTROLLER
  TextEditingController searchController = TextEditingController();
  String searchText = "";

  // 🛒 PRODUCT DATA
  final List<Map<String, String>> productList = [
    {
      "title": "Smart Watch",
      "price": "300",
      "image": "assets/images/Smart watch.jpg"
    },
    {
      "title": "Laptop",
      "price": "1000",
      "image": "assets/images/labtop.jpg"
    },
    {
      "title": "Headphones",
      "price": "150",
      "image": "assets/images/HeadPhone.jpg"
    },
    {
      "title": "Smart Phone",
      "price": "800",
      "image": "assets/images/Smartphone.jpg"
    },
    {
      "title": "Keyboard",
      "price": "120",
      "image": "assets/images/keyboard.jpg"
    },
    {
      "title": "Mouse",
      "price": "80",
      "image": "assets/images/Mouse.jpg"
    },
  ];

  getTheSharedpref() async {
    name = await SharedPreferencesHelper().getUserName();
    image = await SharedPreferencesHelper().getUserImage();
    setState(() {});
  }

  @override
  void initState() {
    getTheSharedpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 🔍 FILTER LOGIC
    final filteredProducts = productList.where((product) {
      return product["title"]!
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      // Stack to add background image
      body: Stack(
        children: [
          /// 🔹 BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/dashboard_bg.png",), // <-- Your background image
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🔹 DARK OVERLAY (optional, makes text readable)
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          /// 🔹 MAIN CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ---------------- APPBAR LOGIC ----------------
                    name == null
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello 👋, $name",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Good Morning",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    image ?? "",
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),

                    const SizedBox(height: 20),

                    // 🔍 SEARCH BAR
                    TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search Products",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ---------------- Categories ----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Categories",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("see all", style: TextStyle(color: Colors.orange)),
                      ],
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          CategoryItem(title: "All", active: true),
                          CategoryItem(title: "Headphone", icon: Icons.headphones),
                          CategoryItem(title: "Labtop", icon: Icons.laptop),
                          CategoryItem(title: "Smart Watch", icon: Icons.watch),
                          CategoryItem(title: "Smart Phone", icon: Icons.phone),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ---------------- Products ----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("All Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("see all", style: TextStyle(color: Colors.orange)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 260,
                      child: filteredProducts.isEmpty
                          ? const Center(child: Text("No product found"))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return ProductCard(
                                  title: product["title"]!,
                                  price: product["price"]!,
                                  image: product["image"]!,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- CATEGORY WIDGET ----------------
class CategoryItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool active;

  const CategoryItem(
      {super.key, required this.title, this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryDetails(category: title)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: active ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, color: active ? Colors.white : Colors.black),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(color: active ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}

// ---------------- PRODUCT CARD ----------------
class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;

  const ProductCard(
      {super.key, required this.title, required this.price, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Slight transparency for BG image
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$$price",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
