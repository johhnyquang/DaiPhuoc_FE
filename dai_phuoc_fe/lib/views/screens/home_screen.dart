import 'package:dai_phuoc_fe/models/userModels/useresponse.dart';
import 'package:dai_phuoc_fe/repositories/userRepository.dart';
import 'package:dai_phuoc_fe/viewmodels/homeViewModel.dart';
import 'package:dai_phuoc_fe/views/widgets/common/background_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>{
  int _currentIndex = 0;
  
  // Danh sách các màn hình con tương ứng với BottomBar
  final List<Widget> _pages = [
    const _HomeTab(),
    const _NewsTab(),
    const _ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(
        userRepository: context.read<UserRepository>()
      ),
      child: BackgroundWidget(
        showAppBar: false,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5)
              )
            ]
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items:const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Trang chủ'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none),
                activeIcon: Icon(Icons.notifications),
                label: 'Thông báo'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Tài khoán'
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Tab 1: Trang chủ
class _HomeTab extends StatelessWidget {
  const _HomeTab();
  
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return CustomScrollView(
      slivers: [
        // 1. Header (Chào hỏi + avatar)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Xin chào', style: TextStyle(fontSize: 16,color: Colors.grey)),
                    const SizedBox(height: 5),
                    viewModel.isLoading ? 
                    Text(
                      'TEST',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                    )
                    :Text(
                      viewModel.fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                      ),
                    )
                  ],
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://scontent.fsgn6-1.fna.fbcdn.net/v/t39.30808-1/320397747_460761842918470_9039751594578192375_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=106&ccb=1-7&_nc_sid=1d2534&_nc_ohc=m36rBoM1LhMQ7kNvwFSjPMI&_nc_oc=AdmiHDfxyTt1NLv6pgHoitoxlmVQMMUai5GLM075dQSyOHWRatlFMjOqPNmnLbwNegk&_nc_zt=24&_nc_ht=scontent.fsgn6-1.fna&_nc_gid=kgmR0egHvDOxIeBEfJbcAw&oh=00_AfvecmE_fws6Yvhka9m14q-pkUaIoI_72tQSgB2ZDdYy5g&oe=698A3D11'),
                )
              ],
            ),
          ),
        ),

        // 2. Banner quảng cáo
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://phongkhamdaiphuoc.vn/vnt_upload/weblink/Tap_the_BS_12_08_2025.webp'),
                fit: BoxFit.cover
              ),
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
              ]
            ),
          ),
        ),

        // 3. Tiêu đề "Dịch vụ"
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("Dịch vụ của bạn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),

        // 4. GRID Chức năng
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = viewModel.menuItems[index];
                return _buildFeatureItem(context, item);
              },
              childCount: viewModel.menuItems.length
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9
            ),
          ),
        ),

        // Padding bottom để không bị che bởi BottomBar
        const SliverToBoxAdapter(child: SizedBox(height: 100))
      ],
    );
  }
  
  Widget _buildFeatureItem(BuildContext context, HomeMenuItem item) {
    return InkWell(
      onTap: () {
        // Chỉ redirect khi click
        //Navigator.pushNamed(context, item.route);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đi tới: ${item.title}")));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                shape: BoxShape.circle
              ),
              child: Icon(item.icon, color: item.color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w600, color: Colors.black87),
            )
          ],
        ),
      )
    );
  }
}

// --- TAB 2: THÔNG BÁO ---
class _NewsTab extends StatelessWidget {
  const _NewsTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Màn hình Tin tức"));
  }
}

// --- TAB 3: TÀI KHOẢN ---
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Màn hình Tài khoản"));
  }
}