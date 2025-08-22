import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'detail_produk_page.dart';
import 'user_data.dart';

class BerandaPesertaPage extends StatefulWidget {
  @override
  _BerandaPesertaPageState createState() => _BerandaPesertaPageState();
}

class _BerandaPesertaPageState extends State<BerandaPesertaPage> 
    with TickerProviderStateMixin {
  
  // NIPL Status - simulasi data user
  bool hasNIPL = false;
  String? niplNumber;
  DateTime? niplExpiry;
  
  final List<Map<String, dynamic>> produkList = [
    {
      "nama": "Lukisan Abstrak Modern",
      "harga": "Rp 2.500.000",
      "hargaAngka": 2500000,
      "kategori": "Seni",
      "status": "Hot",
      "waktuTersisa": "2j 30m",
      "bidCount": 15,
      "gambar": "https://via.placeholder.com/400x200/4A90Ebb2/FFFFFF?text=Lukisan+Abstrak",
      "deskripsi": "Lukisan abstrak modern dengan sentuhan kontemporer"
    },
    {
      "nama": "Vas Antik Keramik",
      "harga": "Rp 750.000",
      "hargaAngka": 756660000,
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
    
    // Check NIPL status dari UserData atau SharedPreferences
    _checkNIPLStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _checkNIPLStatus() {
    // Simulasi pengecekan status NIPL dari database/storage
    // Di implementasi nyata, ini akan mengambil data dari backend
    setState(() {
      // Contoh: user sudah punya NIPL
      // hasNIPL = true;
      // niplNumber = "NIPL-2025-001234";
      // niplExpiry = DateTime.now().add(Duration(days: 365));
    });
  }

  void _showNIPLPurchaseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(0),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_user,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Pembelian NIPL",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Nomor Induk Peserta Lelang",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Keuntungan NIPL:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3C72),
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildBenefitItem("✅ Akses penuh ke semua lelang"),
                      _buildBenefitItem("✅ Dapat mengikuti bidding"),
                      _buildBenefitItem("✅ Riwayat lelang tersimpan"),
                      _buildBenefitItem("✅ Notifikasi lelang eksklusif"),
                      _buildBenefitItem("✅ Berlaku selama 1 tahun"),
                      SizedBox(height: 20),
                      
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Harga NIPL",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    "Rp 500.000",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey.shade400),
                              ),
                              child: Text(
                                "Batal",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () => _processPurchaseNIPL(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1E3C72),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Beli NIPL",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
        );
      },
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  void _processPurchaseNIPL() {
    Navigator.pop(context);
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Memproses pembayaran..."),
            ],
          ),
        ),
      ),
    );

    // Simulasi proses pembelian
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context); // Close loading dialog
      
      // Update NIPL status
      setState(() {
        hasNIPL = true;
        niplNumber = "NIPL-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
        niplExpiry = DateTime.now().add(Duration(days: 365));
      });
      
      // Show success dialog
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 32, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "NIPL Berhasil Dibeli!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("Nomor NIPL: $niplNumber"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

  void _showNIPLInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.verified_user, color: Colors.green),
            SizedBox(width: 8),
            Text("Informasi NIPL"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nomor NIPL: $niplNumber"),
            SizedBox(height: 8),
            Text("Berlaku hingga: ${niplExpiry?.day}/${niplExpiry?.month}/${niplExpiry?.year}"),
            SizedBox(height: 8),
            Text("Status: Aktif", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Widget _buildNIPLCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasNIPL 
            ? [Colors.green.shade400, Colors.green.shade600]
            : [Colors.orange.shade400, Colors.orange.shade600],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: (hasNIPL ? Colors.green : Colors.orange).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              hasNIPL ? Icons.verified_user : Icons.warning,
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
                  hasNIPL ? "NIPL Aktif" : "NIPL Diperlukan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  hasNIPL 
                    ? "Anda dapat mengikuti semua lelang"
                    : "Beli NIPL untuk mengikuti lelang",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: hasNIPL ? _showNIPLInfo : _showNIPLPurchaseDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: hasNIPL ? Colors.green : Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              hasNIPL ? "Info" : "Beli",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
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
                    if (!hasNIPL) {
                      _showNIPLRequiredDialog();
                      return;
                    }
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
                          // NIPL Required Overlay
                          if (!hasNIPL)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "NIPL Diperlukan",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
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
                                      colors: hasNIPL 
                                        ? [Color(0xFF1E3C72), Color(0xFF2A5298)]
                                        : [Colors.grey.shade400, Colors.grey.shade500],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: hasNIPL ? [
                                      BoxShadow(
                                        color: Color(0xFF1E3C72).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ] : [],
                                  ),
                                  child: ElevatedButton.icon(
                                    icon: Icon(
                                      hasNIPL ? Icons.gavel : Icons.lock,
                                      size: 18,
                                    ),
                                    label: Text(
                                      hasNIPL ? "Bid" : "Locked",
                                      style: TextStyle(fontSize: 14),
                                    ),
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
                                      if (!hasNIPL) {
                                        _showNIPLRequiredDialog();
                                        return;
                                      }
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

  void _showNIPLRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Text("NIPL Diperlukan"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Anda perlu memiliki NIPL (Nomor Induk Peserta Lelang) untuk dapat mengikuti lelang ini.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Beli NIPL sekarang untuk mendapatkan akses penuh ke semua lelang!",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3C72),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showNIPLPurchaseDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E3C72),
              foregroundColor: Colors.white,
            ),
            child: Text("Beli NIPL"),
          ),
        ],
      ),
    );
  }

    
      
  

  @override
Widget build(BuildContext context) {
  final filteredList = filteredAndSortedList;

  return Scaffold(
    appBar: AppBar(
      title: Text("Beranda Peserta"),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await ApiService.logout();

            // kembali ke login, hapus semua halaman sebelumnya
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
            );
          },
        ),
      ],
    ),
    extendBodyBehindAppBar: true, // biar appbar transparan nyatu ke gradient
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E3C72),
            Color(0xFF2A5298),
            Color(0xFF87CEEB),
            Color(0xFFF0F8FF),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar content
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
                          // Stats Row ...
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
                                  hasNIPL ? "7" : "0",
                                  Icons.trending_up,
                                  Colors.green,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  "Menang",
                                  hasNIPL ? "3" : "0",
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

            // sisanya tetap sama (NIPL Card, Search, Filter, Produk List)
            SliverToBoxAdapter(child: _buildNIPLCard()),

            // Search + Filter
            // ...
            // Product List
            // ...
          ],
        ),
      ),
    ),
  );
}
}