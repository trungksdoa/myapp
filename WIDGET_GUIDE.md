# 🎨 Flutter Widget Guide - Hướng dẫn sử dụng Widget đúng cách

## 📋 **Giới thiệu về Widget**

Widget là đơn vị xây dựng cơ bản trong Flutter. Mọi thứ trong Flutter đều là widget - từ text, button đến layout và animation.

---

## 🏗️ **Cấu trúc Widget và Nguyên tắc Lồng nhau**

### **1. Widget Tree (Cây Widget)**
```
Scaffold
├── body: Container
│   ├── decoration: BoxDecoration (styling)
│   └── child: SafeArea
│       └── child: Column
│           ├── children[0]: Container (Header)
│           │   └── child: Row
│           │       ├── children[0]: Container (Logo)
│           │       └── children[1]: Text (Title)
│           └── children[1]: Expanded
│               └── child: Container (Main Content)
│                   └── child: Padding
│                       └── child: Column
│                           ├── children[0]: Text (Greeting)
│                           ├── children[1]: Spacer
│                           ├── children[2]: Row (Pet Cards)
│                           └── children[3]: Container (Input)
└── bottomNavigationBar: BottomNavigationBar
```

---

## 🎯 **Phân tích màn hình Chat - Ví dụ thực tế**

### **Level 1: Root Widget - Scaffold**
```dart
Scaffold(
  body: ...,                    // Nội dung chính
  bottomNavigationBar: ...,     // Thanh điều hướng
)
```
**Tại sao dùng Scaffold?**
- ✅ Cung cấp cấu trúc chuẩn Material Design
- ✅ Tự động xử lý StatusBar, Keyboard
- ✅ Hỗ trợ SnackBar, FloatingActionButton

### **Level 2: Container với Gradient Background**
```dart
Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(...)  // Tạo màu gradient
  ),
  child: SafeArea(...)            // Tránh StatusBar, Notch
)
```
**Tại sao dùng Container?**
- ✅ Styling (màu, gradient, border, shadow)
- ✅ Sizing (width, height, constraints)
- ✅ Positioning (margin, padding)

### **Level 3: SafeArea - Vùng an toàn**
```dart
SafeArea(
  child: Column(...)  // Layout chính theo chiều dọc
)
```
**Tại sao dùng SafeArea?**
- ✅ Tránh StatusBar, Home Indicator trên iPhone
- ✅ Đảm bảo nội dung hiển thị trong vùng an toàn

### **Level 4: Column - Layout dọc**
```dart
Column(
  children: [
    Container(...),    // Header
    Expanded(...),     // Main content (chiếm không gian còn lại)
  ],
)
```
**Tại sao dùng Column?**
- ✅ Sắp xếp widgets theo chiều dọc
- ✅ MainAxis = vertical, CrossAxis = horizontal

---

## 🔧 **Nguyên tắc chọn Widget**

### **1. Layout Widgets - Sắp xếp**

#### **Column vs Row**
```dart
// Sắp xếp dọc (vertical)
Column(
  children: [widget1, widget2, widget3]
)

// Sắp xếp ngang (horizontal) 
Row(
  children: [widget1, widget2, widget3]
)
```

#### **Expanded vs Flexible**
```dart
Column(
  children: [
    Container(height: 100),      // Fixed size
    Expanded(                    // Chiếm không gian còn lại
      child: Container(...),
    ),
    Container(height: 50),       // Fixed size
  ],
)
```

#### **Stack - Chồng lên nhau**
```dart
Stack(
  children: [
    Container(...),              // Background
    Positioned(                  // Vị trí tuyệt đối
      top: 10,
      right: 10,
      child: Icon(Icons.close),
    ),
  ],
)
```

### **2. Styling Widgets**

#### **Container - Đa năng nhất**
```dart
Container(
  width: 100,                    // Kích thước
  height: 100,
  margin: EdgeInsets.all(16),    // Khoảng cách ngoài
  padding: EdgeInsets.all(8),    // Khoảng cách trong
  decoration: BoxDecoration(      // Styling
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(...)],
  ),
  child: Text('Content'),
)
```

#### **Padding - Chỉ thêm padding**
```dart
Padding(
  padding: EdgeInsets.all(16),
  child: Text('Padded content'),
)
```

#### **Card - Material Design Card**
```dart
Card(
  elevation: 4,                  // Shadow
  margin: EdgeInsets.all(8),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card content'),
  ),
)
```

### **3. Input Widgets**

#### **TextField - Nhập text**
```dart
TextField(
  controller: _controller,       // Quản lý text
  decoration: InputDecoration(
    hintText: 'Nhập tin nhắn...',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.message),
  ),
  onSubmitted: (value) => _sendMessage(),
)
```

#### **ElevatedButton - Nút bấm**
```dart
ElevatedButton(
  onPressed: () => _handlePress(),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  child: Text('Gửi'),
)
```

---

## 📱 **Phân tích chi tiết màn hình Chat**

### **Phần Header**
```dart
// Level 1: Container để styling
Container(
  padding: const EdgeInsets.all(16),  // Khoảng cách trong
  child: Row(                         // Sắp xếp ngang
    children: [
      // Logo
      Container(                      // Wrapper cho styling
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,     // Hình tròn
        ),
        child: Image.asset(...),      // Nội dung logo
      ),
      const SizedBox(width: 12),      // Khoảng cách
      // Title
      const Expanded(                 // Chiếm không gian còn lại
        child: Text(
          'CareNest',
          style: TextStyle(...),
        ),
      ),
    ],
  ),
)
```

### **Phần Main Content**
```dart
// Level 1: Expanded để chiếm không gian còn lại
Expanded(
  child: Container(                   // Styling wrapper
    decoration: const BoxDecoration(
      color: Color(0xFFE8E8D0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Padding(                   // Thêm padding
      padding: const EdgeInsets.all(20),
      child: Column(                  // Layout dọc
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting text
          const Text(...),
          const Spacer(),             // Đẩy content xuống
          // Pet cards
          Row(...),                   // Layout ngang
          // Input field
          Container(...),
        ],
      ),
    ),
  ),
)
```

### **Phần Pet Cards**
```dart
// Method riêng để tái sử dụng
Widget _buildPetCard(String petName) {
  return Column(                      // Layout dọc
    children: [
      Container(                      // Card container
        width: 70,
        height: 70,
        decoration: BoxDecoration(     // Styling
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(...)],
        ),
        child: ClipRRect(             // Bo góc cho image
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(...),
        ),
      ),
      const SizedBox(height: 8),      // Khoảng cách
      Text(petName),                  // Tên pet
    ],
  );
}
```

### **Phần Input Field**
```dart
Container(                            // Wrapper để styling
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [BoxShadow(...)],
  ),
  child: Row(                         // Layout ngang
    children: [
      // Search icon
      const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(Icons.search),
      ),
      // Text field
      Expanded(                       // Chiếm không gian còn lại
        child: TextField(
          controller: _messageController,
          decoration: const InputDecoration(
            hintText: 'Nhập câu hỏi...',
            border: InputBorder.none, // Bỏ border mặc định
          ),
        ),
      ),
      // Send button
      Container(                      // Button wrapper
        margin: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Color(0xFF4A90A4),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () => _sendMessage(),
          icon: const Icon(Icons.send, color: Colors.white),
        ),
      ),
    ],
  ),
)
```

---

## 🎯 **Decision Tree - Khi nào dùng Widget nào?**

### **📐 Layout Decision**
```
Cần sắp xếp widgets?
├── Dọc → Column
├── Ngang → Row  
├── Chồng lên nhau → Stack
├── Cuộn được → ListView/SingleChildScrollView
└── Grid → GridView
```

### **🎨 Styling Decision**
```
Cần styling?
├── Đơn giản → Padding, SizedBox, Center
├── Phức tạp → Container
├── Material Design → Card, ListTile
└── Custom → Container với decoration
```

### **📱 Responsive Decision**
```
Cần responsive?
├── Chiếm không gian còn lại → Expanded
├── Linh hoạt → Flexible
├── Responsive width → FractionallySizedBox
└── Media Query → MediaQuery.of(context)
```

### **⚡ Performance Decision**
```
Hiệu suất quan trọng?
├── Danh sách lớn → ListView.builder
├── Grid lớn → GridView.builder
├── Animation → AnimatedBuilder
└── Heavy widgets → const widgets
```

---

## 🔧 **Best Practices**

### **✅ Nên làm:**

1. **Sử dụng const khi có thể**
```dart
const Text('Hello')        // ✅ Tốt
Text('Hello')             // ❌ Không tối ưu
```

2. **Tách thành methods nhỏ**
```dart
Widget _buildHeader() {   // ✅ Dễ đọc, tái sử dụng
  return Container(...);
}
```

3. **Đặt tên có ý nghĩa**
```dart
Widget _buildPetCard()    // ✅ Rõ ràng
Widget _build()          // ❌ Mơ hồ
```

4. **Sử dụng Expanded cho flexible layout**
```dart
Row(
  children: [
    Text('Fixed'),
    Expanded(child: Text('Flexible')), // ✅
  ],
)
```

### **❌ Không nên:**

1. **Lồng quá nhiều Container**
```dart
Container(
  child: Container(       // ❌ Thừa
    child: Container(...),
  ),
)
```

2. **Hardcode sizes**
```dart
Container(width: 375)    // ❌ Không responsive
MediaQuery.of(context).size.width * 0.8  // ✅
```

3. **Widget tree quá sâu**
```dart
// ❌ Quá sâu - tách thành methods
Column(
  children: [
    Container(
      child: Row(
        children: [
          Container(
            child: Column(...)
          ),
        ],
      ),
    ),
  ],
)
```

---

## 📚 **Widget Cheat Sheet**

### **Layout Widgets**
| Widget | Mục đích | Khi nào dùng |
|--------|----------|-------------|
| Column | Sắp xếp dọc | Danh sách dọc, form |
| Row | Sắp xếp ngang | Buttons, icons trong 1 hàng |
| Stack | Chồng lên nhau | Overlay, floating elements |
| Expanded | Chiếm không gian còn lại | Trong Row/Column |
| Flexible | Linh hoạt kích thước | Khi muốn flex nhưng không bắt buộc full |
| Wrap | Tự động xuống hàng | Tags, chips |

### **Styling Widgets**
| Widget | Mục đích | Khi nào dùng |
|--------|----------|-------------|
| Container | Styling tổng quát | Cần margin, padding, decoration |
| Padding | Chỉ padding | Chỉ cần thêm khoảng cách trong |
| SizedBox | Kích thước cố định | Spacer, fixed size |
| Card | Material card | Hiển thị nội dung trong card |
| DecoratedBox | Chỉ decoration | Chỉ cần background, border |

### **Input/Interactive Widgets**
| Widget | Mục đích | Khi nào dùng |
|--------|----------|-------------|
| TextField | Nhập text | Form, search, input |
| ElevatedButton | Button chính | Primary actions |
| TextButton | Button phụ | Secondary actions |
| IconButton | Button icon | Actions với icon |
| GestureDetector | Custom gestures | Custom tap, drag... |

---

## 🚀 **Ví dụ hoàn chỉnh - Rebuilding Chat Screen**

```dart
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(                    // Root structure
      body: _buildBody(),               // Main content
      bottomNavigationBar: _buildBottomNav(), // Navigation
    );
  }

  Widget _buildBody() {
    return Container(                   // Background styling
      decoration: _buildGradient(),
      child: SafeArea(                  // Safe area
        child: Column(                  // Vertical layout
          children: [
            _buildHeader(),             // Header section
            Expanded(                   // Main content area
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(                   // Header container
      padding: EdgeInsets.all(16),
      child: Row(                       // Horizontal layout
        children: [
          _buildLogo(),                 // Logo
          SizedBox(width: 12),          // Spacing
          Expanded(                     // Title takes remaining space
            child: _buildTitle(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(                   // Content container
      decoration: BoxDecoration(
        color: Color(0xFFE8E8D0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(                   // Content padding
        padding: EdgeInsets.all(20),
        child: Column(                  // Vertical content layout
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),           // Greeting text
            Spacer(),                   // Push content down
            _buildPetCards(),           // Pet selection
            SizedBox(height: 16),
            _buildSubtitle(),           // Instruction text
            SizedBox(height: 24),
            _buildInputField(),         // Message input
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper methods for each component...
  Widget _buildLogo() => Container(...);
  Widget _buildTitle() => Text(...);
  Widget _buildGreeting() => Column(...);
  Widget _buildPetCards() => Row(...);
  Widget _buildInputField() => Container(...);
  // ... other methods
}
```

---

## 🎉 **Kết luận**

Việc chọn widget đúng phụ thuộc vào:

1. **Mục đích**: Layout, Styling, Input, Display
2. **Performance**: Builder patterns cho lists
3. **Maintainability**: Tách nhỏ, đặt tên rõ ràng
4. **Responsiveness**: Flexible, Expanded, MediaQuery

**Nguyên tắc vàng**: Bắt đầu đơn giản, refactor khi cần thiết! 🚀