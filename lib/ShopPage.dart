import 'package:CarroTime/Core/Colors.dart';
import 'package:CarroTime/Models/plant_repository.dart';
import 'package:CarroTime/Models/globaldata.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart'; // عشان الـ Watch للكوينز

class SHOP extends StatefulWidget {
  const SHOP({super.key});

  @override
  State<SHOP> createState() => _SHOPState();
}

class _SHOPState extends State<SHOP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // بنغلف الـ Grid بـ Watch عشان لو الكوينز اتغيرت الـ شاشة تحس
        child: Watch((context) {
          return GridView.builder(
            itemCount: kAllPlants.length, // 1. ضفنا الـ itemCount
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 4 كانت ضيقة جداً على العناصر، 2 أو 3 أشيك
              childAspectRatio: 0.75,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final plant = kAllPlants[index];
              final isLocked = !plant.isUnlocked;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppBarrColor, // لون الكارت بتاعك
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // 2. تصحيح الـ Syntax
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(plant.imgPath, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plant.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: pri,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // عرض السعر أو كلمة "Unlocked"
                    if (isLocked)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/CarroCoin.png',
                            width: 20,
                            height: 20,
                          ), // اسم صورتك
                          const SizedBox(width: 5),
                          Text(
                            plant.price.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: pri,
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        "UNLOCKED 🎉",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // زرار الشراء يظهر فقط لو مقفولة
                    if (isLocked)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pri,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // الشيك على الفلوس
                          if (globalCoins.value >= plant.price) {
                            setState(() {
                              // 3. تعديل القيمة الحقيقية
                              kAllPlants[index].isUnlocked = true;

                              // خفض الكوينز وحفظها
                              globalCoins.value -= plant.price;
                              userDataBox.put('coins', globalCoins.value);

                              // 4. الحفظ في Hive باستخدام الـ id المميز للزرعة
                              userDataBox.put(
                                'plant_${plant.id}_unlocked',
                                true,
                              );
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Congrats! You unlocked ${plant.name} 🎉",
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "You don't have enough CarroCoins! 🪙",
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "BUY",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
