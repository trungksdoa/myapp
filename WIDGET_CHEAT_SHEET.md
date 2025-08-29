# 🚀 Flutter Widget Quick Reference - Cheat Sheet

## 📱 **Khi nào dùng Widget nào?**

### **🏗️ LAYOUT WIDGETS**

| Cần gì? | Dùng Widget | Ví dụ |
|---------|-------------|-------|
| Sắp xếp dọc | `Column` | Form, menu list |
| Sắp xếp ngang | `Row` | Button group, icon bar |
| Chồng lên nhau | `Stack` | Badge, overlay, floating button |
| Cuộn dọc | `ListView` | Chat messages, news feed |
| Cuộn ngang | `ListView` (horizontal) | Story carousel, tabs |
| Grid layout | `GridView` | Photo gallery, product grid |
| Chiếm không gian còn lại | `Expanded` | Trong Row/Column |
| Linh hoạt kích thước | `Flexible` | Responsive layout |

### **🎨 STYLING WIDGETS**

| Cần gì? | Dùng Widget | Khi nào |
|---------|-------------|---------|
| Full styling | `Container` | Cần margin, padding, color, border, shadow |
| Chỉ padding | `Padding` | Chỉ cần khoảng cách trong |
| Chỉ margin | `Container` hoặc `SizedBox` | Khoảng cách ngoài |
| Material card | `Card` | Hiển thị content trong card design |
| Tròn hình ảnh | `ClipRRect` | Avatar, thumbnail |
| Shadow đơn giản | `Card` | Nhanh và đẹp |
| Shadow custom | `Container` + BoxShadow | Control chi tiết |

### **📝 INPUT/INTERACTIVE WIDGETS**

| Cần gì? | Dùng Widget | Use case |
|---------|-------------|----------|
| Nhập text | `TextField` | Search, form input, chat |
| Button chính | `ElevatedButton` | Primary action, submit |
| Button phụ | `TextButton` | Cancel, secondary action |
| Icon action | `IconButton` | Delete, edit, favorite |
| Custom gesture | `GestureDetector` | Custom tap, swipe |
| Switch/toggle | `Switch` | Settings on/off |

### **📐 RESPONSIVE WIDGETS**

| Cần gì? | Dùng Widget | Cách dùng |
|---------|-------------|-----------|
| Responsive width | `Expanded` | Trong Row |
| Responsive height | `Expanded` | Trong Column |
| Tỷ lệ màn hình | `FractionallySizedBox` | width: 0.8 = 80% width |
| Check screen size | `MediaQuery` | MediaQuery.of(context).size |
| Safe area | `SafeArea` | Tránh notch, status bar |

---

## 🎯 **Decision Tree - 5 giây quyết định**

```
1. Cần layout?
   ├── Dọc → Column
   ├── Ngang → Row
   ├── Chồng → Stack
   └── Cuộn → ListView

2. Cần styling?
   ├── Đơn giản → Padding, SizedBox
   ├── Phức tạp → Container
   └── Material → Card

3. Cần input?
   ├── Text → TextField
   ├── Button → ElevatedButton/TextButton
   └── Custom → GestureDetector

4. Cần responsive?
   ├── Flex space → Expanded
   ├── Check size → MediaQuery
   └── Safe area → SafeArea
```

---

## 💡 **Common Patterns - Pattern thường dùng**

### **🔥 Chat Input Pattern**
```dart
Row(
  children: [
    Expanded(child: TextField(...)),  // Text field chiếm hết chỗ còn lại
    IconButton(...),                  // Send button cố định
  ],
)
```

### **🔥 Card with Image Pattern**
```dart
Card(
  child: Column(
    children: [
      Image.asset(...),               // Ảnh
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(              // Text content
          children: [Text(...), Text(...)],
        ),
      ),
    ],
  ),
)
```

### **🔥 Header with Logo Pattern**
```dart
Row(
  children: [
    Container(...),                  // Logo container
    SizedBox(width: 12),            // Spacing
    Expanded(child: Text(...)),     // Title take remaining space
    IconButton(...),                // Action button
  ],
)
```

### **🔥 List Item Pattern**
```dart
ListTile(
  leading: CircleAvatar(...),       // Avatar/Icon
  title: Text(...),                 // Main text
  subtitle: Text(...),              // Secondary text
  trailing: Icon(...),              // Action icon
  onTap: () {},                     // Tap handler
)
```

### **🔥 Bottom Navigation Pattern**
```dart
Scaffold(
  body: _currentPage,               // Main content
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: (index) => setState(() => _selectedIndex = index),
    items: [...],
  ),
)
```

---

## ⚡ **Performance Tips**

### **✅ DO:**
- `const` constructors: `const Text('hello')`
- `ListView.builder` for long lists
- Separate widgets into methods
- Use `Expanded` in Row/Column

### **❌ DON'T:**
- Nested `Container` without purpose
- Hardcode sizes: `width: 375`
- Deep widget trees (>10 levels)
- Rebuild expensive widgets

---

## 🔧 **Quick Fixes**

### **Overflow Issues:**
```dart
// ❌ Error: RenderFlex overflowed
Row(children: [Text('Very long text...')])

// ✅ Solution: 
Row(children: [Expanded(child: Text('Very long text...'))])
```

### **Layout Issues:**
```dart
// ❌ Not responsive
Container(width: 300)

// ✅ Responsive
Container(width: MediaQuery.of(context).size.width * 0.8)
```

### **Styling Issues:**
```dart
// ❌ Too many containers
Container(
  child: Container(
    child: Container(child: Text('hello'))
  )
)

// ✅ Single container
Container(
  margin: EdgeInsets.all(8),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(...),
  child: Text('hello'),
)
```

---

## 🎨 **Widget trong Chat Screen**

```
ChatScreen
├── Scaffold                    (Root structure)
│   ├── body: Container         (Background + gradient)
│   │   └── SafeArea           (Avoid notch/status bar)
│   │       └── Column         (Vertical layout)
│   │           ├── Container  (Header section)
│   │           │   └── Row    (Logo + Title horizontal)
│   │           └── Expanded   (Main content area)
│   │               └── Container (Content styling)
│   │                   └── Padding (Content spacing)
│   │                       └── Column (Content layout)
│   │                           ├── Text (Greeting)
│   │                           ├── Spacer (Push down)
│   │                           ├── Row (Pet cards)
│   │                           └── Container (Input)
│   │                               └── Row (Input layout)
│   └── bottomNavigationBar    (Navigation tabs)
```

---

## 🚀 **Nhớ 5 Rules này:**

1. **Layout first**: Column/Row/Stack
2. **Style second**: Container/Card/Padding  
3. **Responsive third**: Expanded/Flexible/MediaQuery
4. **Performance always**: const, builder, methods
5. **Debug wisely**: Widget Inspector, overflow

**Happy Coding! 🎉**