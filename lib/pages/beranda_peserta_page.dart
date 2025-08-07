import 'package:flutter/material.dart';
import 'detail_produk_page.dart';
import 'user_data.dart';

class BerandaPesertaPage extends StatefulWidget {
  @override
  _BerandaPesertaPageState createState() => _BerandaPesertaPageState();
}

class _BerandaPesertaPageState extends State<BerandaPesertaPage> 

    with TickerProviderStateMixin {
  
  final List<Map<String, dynamic>> produkList = [
    {
      "nama": "Lukisan Abstrak Modern",
      "harga": "Rp 2.500.000",
      "hargaAngka": 2500000,
      "kategori": "Seni",
      "status": "Hot",
      "waktuTersisa": "2j 30m",
      "bidCount": 15,
      "gambar": "https://via.placeholder.com/400x200/4A90E2/FFFFFF?text=Lukisan+Abstrak",
      "deskripsi": "Lukisan abstrak modern dengan sentuhan kontemporer"
    },
    {
      "nama": "Vas Antik Keramik",
      "harga": "Rp 750.000",
      "hargaAngka": 750000,
      "kategori": "Antik",
      "status": "New",
      "waktuTersisa": "1j 15m",
      "bidCount": 8,
      "gambar": "https://via.placeholder.com/400x200/E74C3C/FFFFFF?text=Vas+Antik",
      "deskripsi": "Vas antik keramik dengan detail ukiran yang indah"
    },
    {
      "nama": "Kursi Kayu Jati Premium",
      "harga": "Rp 1.200.000",
      "hargaAngka": 1200000,
      "kategori": "Furniture",
      "status": "Trending",
      "waktuTersisa": "3j 45m",
      "bidCount": 22,
      "gambar": "https://via.placeholder.com/400x200/27AE60/FFFFFF?text=Kursi+Jati",
      "deskripsi": "Kursi kayu jati premium dengan finishing berkualitas tinggi"
    },
    {
      "nama": "Jam Tangan Vintage",
      "harga": "Rp 3.800.000",
      "hargaAngka": 3800000,
      "kategori": "Koleksi",
      "status": "Hot",
      "waktuTersisa": "30m",
      "bidCount": 35,
      "gambar": "https://via.placeholder.com/400x200/8E44AD/FFFFFF?text=Jam+Vintage",
      "deskripsi": "Jam tangan vintage collector edition tahun 1960an"
    },
    {
      "nama": "Laptop",
      "harga": "Rp 3.800.000",
      "hargaAngka": 3800000,
      "kategori": "Elektronik",
      "status": "Hot",
      "waktuTersisa": "30m",
      "bidCount": 35,
      "gambar": "https://via.placeholder.com/400x200/8E44AD/FFFFFF?text=Laptop+Gaming",
      "deskripsi": "Laptop gaming dengan spesifikasi tinggi, cocok untuk bermain game berat"
    },
  ];

  String searchQuery = '';
  String selectedCategory = 'Semua';
  String sortBy = 'nama';
  
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _searchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredAndSortedList {
    List<Map<String, dynamic>> filtered = produkList.where((produk) {
      final nama = produk['nama']!.toLowerCase();
      final kategori = produk['kategori']!.toLowerCase();
      final query = searchQuery.toLowerCase();
      
      bool matchesSearch = nama.contains(query);
      bool matchesCategory = selectedCategory == 'Semua' || 
                           produk['kategori'] == selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();

    // Sorting
    filtered.sort((a, b) {
      switch (sortBy) {
        case 'harga_rendah':
          return a['hargaAngka'].compareTo(b['hargaAngka']);
        case 'harga_tinggi':
          return b['hargaAngka'].compareTo(a['hargaAngka']);
        case 'populer':
          return b['bidCount'].compareTo(a['bidCount']);
        default:
          return a['nama'].compareTo(b['nama']);
      }
    });

    return filtered;
  }

  List<String> get categories {
    Set<String> cats = produkList.map((p) => p['kategori'] as String).toSet();
    return ['Semua', ...cats];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hot':
        return Colors.red;
      case 'New':
        return Colors.green;
      case 'Trending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> produk, int index) {
    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        final animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _cardAnimationController,
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            ((index * 0.1) + 0.3).clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        ));

        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailProdukPage(
                          namaProduk: produk["nama"]!,
                          hargaAwal: produk["harga"]!,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Section
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1E3C72).withOpacity(0.8),
                                    Color(0xFF2A5298).withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      produk['nama'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Status Badge
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(produk['status']),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                produk['status'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Category Badge
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                produk['kategori'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Content Section
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              produk["nama"]!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3C72),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              produk["deskripsi"]!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 12),
                            
                            // Info Row
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  produk['waktuTersisa'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.people,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "${produk['bidCount']} bid",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            
                            // Price and Button Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Harga Awal",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        produk["harga"]!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E3C72),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF1E3C72).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.gavel, size: 18),
                                    label: Text("Bid", style: TextStyle(fontSize: 14)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DetailProdukPage(
                                            namaProduk: produk["nama"]!,
                                            hargaAwal: produk["harga"]!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = filteredAndSortedList;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3C72), // Deep blue
              Color(0xFF2A5298), // Medium blue
              Color(0xFF87CEEB), // Sky blue
              Color(0xFFF0F8FF), // Alice blue (very light)
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _headerAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _headerAnimation.value,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.gavel,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Selamat Datang! 👋",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      Text(
                                        UserData.nama ?? 'User',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            
                            // Stats Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    "Total Lelang",
                                    "${produkList.length}",
                                    Icons.store,
                                    Colors.blue,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    "Aktif Bid",
                                    "7",
                                    Icons.trending_up,
                                    Colors.green,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    "Menang",
                                    "3",
                                    Icons.emoji_events,
                                    Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Search and Filter Section
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _searchAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _searchAnimation.value)),
                      child: Opacity(
                        opacity: _searchAnimation.value,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Search Bar
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Cari produk lelang...",
                                    prefixIcon: Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.search, color: Colors.white),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              
                              // Filter Row
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButton<String>(
                                        value: selectedCategory,
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCategory = value!;
                                          });
                                        },
                                        items: categories.map((category) {
                                          return DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButton<String>(
                                        value: sortBy,
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        onChanged: (value) {
                                          setState(() {
                                            sortBy = value!;
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(value: 'nama', child: Text('Nama A-Z')),
                                          DropdownMenuItem(value: 'harga_rendah', child: Text('Harga Terendah')),
                                          DropdownMenuItem(value: 'harga_tinggi', child: Text('Harga Tertinggi')),
                                          DropdownMenuItem(value: 'populer', child: Text('Paling Populer')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Product List
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: filteredList.isEmpty
                      ? Container(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Produk tidak ditemukan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Coba ubah kata kunci atau filter pencarian",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Hasil Pencarian",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${filteredList.length} item",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ...filteredList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> produk = entry.value;
                              return _buildProductCard(produk, index);
                            }).toList(),
                            SizedBox(height: 20),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}