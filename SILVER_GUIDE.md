# 🎨 Simple Silver Widgets Guide

## 📋 **Giới thiệu về Silver Widgets**

Silver widgets là các widget đặc biệt trong Flutter được thiết kế để hoạt động với `CustomScrollView`. Chúng cho phép tạo các layout phức tạp có thể cuộn mượt mà.

---

## 🏗️ **Các Silver Widgets Cơ Bản**

### 1️⃣ **SliverAppBar** - Header có thể cuộn
```dart
SliverAppBar(
  expandedHeight: 200.0,        // Chiều cao khi mở rộng
  floating: false,              // Có float khi cuộn không
  pinned: true,                 // Có pin ở top khi cuộn không
  flexibleSpace: FlexibleSpaceBar(
    title: Text('Tiêu đề'),
    background: Container(...),  // Background khi mở rộng
  ),
)
```

### 2️⃣ **SliverList** - Danh sách có thể cuộn
```dart
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) => ListTile(...),
    childCount: 20,
  ),
)
```

### 3️⃣ **SliverGrid** - Grid có thể cuộn
```dart
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,          // Số cột
    mainAxisSpacing: 10,        // Khoảng cách dọc
    crossAxisSpacing: 10,       // Khoảng cách ngang
    childAspectRatio: 1.0,      // Tỷ lệ khung hình
  ),
  delegate: SliverChildBuilderDelegate(
    (context, index) => Card(...),
    childCount: 10,
  ),
)
```

### 4️⃣ **SliverToBoxAdapter** - Widget đơn giản
```dart
SliverToBoxAdapter(
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text('Nội dung đơn giản'),
  ),
)
```

### 5️⃣ **SliverPadding** - Thêm padding
```dart
SliverPadding(
  padding: EdgeInsets.all(16),
  sliver: SliverList(...),  // Bọc sliver khác
)
```

---

## 🚀 **Cách sử dụng:**

### **Cấu trúc cơ bản:**
```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverAppBar(...),
      SliverList(...),
      SliverGrid(...),
      SliverToBoxAdapter(...),
    ],
  ),
)
```

### **Trong ứng dụng của bạn:**
```dart
// Thêm vào main_layout.dart hoặc bất kỳ screen nào
import 'package:myapp/component/simple_silver.dart';

class YourScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SimpleSilverExample(),
    );
  }
}
```

---

## 🎯 **Ví dụ thực tế:**

### **1. Header với hình nền:**
```dart
SliverAppBar(
  expandedHeight: 250.0,
  flexibleSpace: FlexibleSpaceBar(
    background: Image.network(
      'https://example.com/image.jpg',
      fit: BoxFit.cover,
    ),
  ),
)
```

### **2. Danh sách sản phẩm:**
```dart
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) => ProductCard(product: products[index]),
    childCount: products.length,
  ),
)
```

### **3. Grid ảnh:**
```dart
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
  ),
  delegate: SliverChildBuilderDelegate(
    (context, index) => Image.network(images[index]),
    childCount: images.length,
  ),
)
```

---

## ⚡ **Sliver Widgets Nâng Cao**

### 6️⃣ **SliverAnimatedList** - Danh sách có animation
```dart
class AnimatedListExample extends StatefulWidget {
  @override
  _AnimatedListExampleState createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  void _addItem() {
    final index = _items.length;
    _items.insert(index, 'Item ${index + 1}');
    _listKey.currentState?.insertItem(index);
  }

  void _removeItem(int index) {
    final removedItem = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: animation.drive(
          Tween(begin: Offset(1, 0), end: Offset.zero),
        ),
        child: ListTile(title: Text(removedItem)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: Offset(1, 0), end: Offset.zero),
          ),
          child: ListTile(
            title: Text(_items[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeItem(index),
            ),
          ),
        );
      },
    );
  }
}
```

### 7️⃣ **SliverPersistentHeader** - Header tùy chỉnh
```dart
class CustomSliverPersistentHeader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  CustomSliverPersistentHeader({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(CustomSliverPersistentHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
           minHeight != oldDelegate.minHeight ||
           child != oldDelegate.child;
  }
}

// Sử dụng:
SliverPersistentHeader(
  pinned: true,
  delegate: CustomSliverPersistentHeader(
    minHeight: 60,
    maxHeight: 120,
    child: Container(
      color: Colors.blue,
      child: Center(
        child: Text('Persistent Header', style: TextStyle(color: Colors.white)),
      ),
    ),
  ),
)
```

### 8️⃣ **SliverFillViewport** - Fill toàn màn hình
```dart
SliverFillViewport(
  delegate: SliverChildBuilderDelegate(
    (context, index) => Container(
      color: Colors.primaries[index % Colors.primaries.length],
      child: Center(
        child: Text(
          'Page ${index + 1}',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    ),
    childCount: 5,
  ),
)
```

### 9️⃣ **SliverPrototypeExtentList** - List với fixed height
```dart
SliverPrototypeExtentList(
  prototypeItem: Container(height: 80), // Chiều cao cố định
  delegate: SliverChildBuilderDelegate(
    (context, index) => Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text('Fixed Height Item $index'),
        subtitle: Text('Subtitle $index'),
      ),
    ),
    childCount: 20,
  ),
)
```

### 🔟 **SliverFillRemaining** - Fill không gian còn lại
```dart
SliverFillRemaining(
  hasScrollBody: false,
  child: Container(
    color: Colors.grey[200],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text('Không có dữ liệu', style: TextStyle(fontSize: 18)),
      ],
    ),
  ),
)
```

---

## 🎨 **Advanced Techniques**

### 🚀 **1. Parallax Effect với SliverAppBar**
```dart
SliverAppBar(
  expandedHeight: 300.0,
  flexibleSpace: FlexibleSpaceBar(
    background: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/background.jpg',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    ),
    title: Text('Parallax Header'),
    centerTitle: true,
    titlePadding: EdgeInsets.only(bottom: 16),
  ),
)
```

### 🎯 **2. Sticky Section Headers**
```dart
class StickySectionList extends StatelessWidget {
  final List<String> sections = ['Section A', 'Section B', 'Section C'];
  final Map<String, List<String>> sectionItems = {
    'Section A': ['Item A1', 'Item A2', 'Item A3'],
    'Section B': ['Item B1', 'Item B2'],
    'Section C': ['Item C1', 'Item C2', 'Item C3', 'Item C4'],
  };

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        for (String section in sections) ...[
          SliverPersistentHeader(
            pinned: true,
            delegate: _SectionHeaderDelegate(
              title: section,
              color: Colors.blue,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final items = sectionItems[section]!;
                return ListTile(
                  title: Text(items[index]),
                  subtitle: Text('Subtitle for ${items[index]}'),
                );
              },
              childCount: sectionItems[section]!.length,
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Color color;

  _SectionHeaderDelegate({required this.title, required this.color});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
```

### 📱 **3. Nested ScrollViews**
```dart
class NestedScrollExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Nested Scroll'),
              background: Image.asset('assets/images/background.jpg', fit: BoxFit.cover),
            ),
          ),
        ];
      },
      body: TabBarView(
        children: [
          ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) => ListTile(
              title: Text('Tab 1 - Item $index'),
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: 20,
            itemBuilder: (context, index) => Card(
              child: Center(child: Text('Tab 2 - Item $index')),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 🎨 **4. Custom Sliver với Tween Animation**
```dart
class AnimatedSliverToBoxAdapter extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedSliverToBoxAdapter({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _AnimatedSliverToBoxAdapterState createState() => _AnimatedSliverToBoxAdapterState();
}

class _AnimatedSliverToBoxAdapterState extends State<AnimatedSliverToBoxAdapter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
```

### 🎪 **5. Advanced SliverGrid với Staggered Layout**
```dart
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredSliverGrid extends StatelessWidget {
  final List<int> heights = [200, 150, 180, 120, 220, 160, 190, 140];

  @override
  Widget build(BuildContext context) {
    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childCount: heights.length,
      itemBuilder: (context, index) {
        return Container(
          height: heights[index].toDouble(),
          decoration: BoxDecoration(
            color: Colors.primaries[index % Colors.primaries.length],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Item $index',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
```

---

## 🔧 **Tips & Best Practices:**

### ✅ **Do:**
- Sử dụng `CustomScrollView` để chứa các sliver
- Kết hợp nhiều sliver để tạo layout phức tạp
- Sử dụng `SliverAppBar` cho header
- Cache dữ liệu khi có thể
- Sử dụng `SliverAnimatedList` cho dynamic lists
- Implement `SliverPersistentHeader` cho sticky headers
- Sử dụng `NestedScrollView` cho complex scrolling behaviors
- Optimize với `SliverPrototypeExtentList` khi biết fixed height

### ❌ **Don't:**
- Mix sliver với regular widgets trong cùng `CustomScrollView`
- Quên `slivers` property trong `CustomScrollView`
- Sử dụng sliver khi không cần cuộn phức tạp
- Tạo heavy widgets trong `SliverChildBuilderDelegate` mà không cache
- Quên dispose AnimationController trong custom slivers
- Sử dụng `SliverFillViewport` cho content không cần fill viewport

---

## 📱 **Demo:**

Để test Silver widgets, bạn có thể:

1. **Chạy demo:**
```dart
// Trong bất kỳ screen nào
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const SilverDemoScreen()),
);
```

2. **Hoặc sử dụng NavigationHelper:**
```dart
NavigationHelper.push(const SilverDemoScreen());
```

---

## 🎉 **Kết quả:**
- **Smooth Scrolling**: Cuộn mượt mà
- **Complex Layouts**: Layout phức tạp dễ tạo
- **Performance**: Tối ưu cho danh sách lớn
- **Flexible**: Dễ tùy chỉnh

**Bắt đầu với `SimpleSilverExample` để hiểu cơ bản, sau đó tùy chỉnh theo nhu cầu!** 🚀