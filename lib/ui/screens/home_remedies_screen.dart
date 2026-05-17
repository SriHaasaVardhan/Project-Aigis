import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeRemediesScreen extends StatefulWidget {
  const HomeRemediesScreen({super.key});

  @override
  State<HomeRemediesScreen> createState() => _HomeRemediesScreenState();
}

class _HomeRemediesScreenState extends State<HomeRemediesScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, String>> _allRemedies = [
    {'condition': 'Cold & Flu', 'remedy': 'Drink warm water with honey and lemon. Rest and stay hydrated.'},
    {'condition': 'Headache', 'remedy': 'Rest in a quiet, dark room. Apply cold compress to forehead.'},
    {'condition': 'Sore Throat', 'remedy': 'Gargle with warm salt water. Drink herbal tea with honey.'},
    {'condition': 'Minor Burns', 'remedy': 'Cool the burn under running water for 10-15 minutes. Apply aloe vera.'},
    {'condition': 'Indigestion', 'remedy': 'Drink ginger tea. Avoid heavy meals. Stay hydrated.'},
    {'condition': 'Acne', 'remedy': 'Apply tea tree oil or aloe vera gel. Keep face clean.'},
    {'condition': 'Sunburn', 'remedy': 'Apply cool compress and aloe vera. Stay hydrated.'},
    {'condition': 'Dry Skin', 'remedy': 'Moisturize regularly. Avoid hot showers.'},
    {'condition': 'Dandruff', 'remedy': 'Apply coconut oil or aloe vera to scalp before washing.'},
    {'condition': 'Toothache', 'remedy': 'Rinse with warm salt water. Use clove oil.'},
  ];

  List<Map<String, String>> _filteredRemedies = [];

  @override
  void initState() {
    super.initState();
    _filteredRemedies = List.from(_allRemedies);
  }

  void _filterRemedies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRemedies = List.from(_allRemedies);
      } else {
        _filteredRemedies = _allRemedies.where((item) =>
            item['condition']!.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Remedies'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: _searchController,
                onChanged: _filterRemedies,
                decoration: InputDecoration(
                  labelText: 'Search for health or cosmetic issues',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const Text(
                'Disclaimer: These are for minor ailments only. For serious conditions, consult a doctor.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.orange),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: _filteredRemedies.length,
                itemBuilder: (context, index) {
                  final item = _filteredRemedies[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['condition']!,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            item['remedy']!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
