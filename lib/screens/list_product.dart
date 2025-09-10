import 'package:flutter/material.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Products'),
            background: Image.asset(
              'assets/images/products_banner.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/product_$index.png',
                  ),
                ),
                title: Text('Product $index'),
                subtitle: Text('Description for product $index'),
                onTap: () {
                  // Handle product tap
                },
              );
            },
            childCount: 20, // Example item count
          ),
        ),
      ],
    );
  }
}
