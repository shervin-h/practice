import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class MyDashboardPage extends StatefulWidget {
  const MyDashboardPage({super.key});

  @override
  _MyDashboardPageState createState() => _MyDashboardPageState();
}

class _MyDashboardPageState extends State<MyDashboardPage> {
  late final DashboardItemController itemController;

  @override
  void initState() {
    super.initState();
    itemController = DashboardItemController(items: [
      DashboardItem(width: 2, height: 2, identifier: '1'),
      DashboardItem(width: 3, height: 1, identifier: '2'),
      DashboardItem(width: 1, height: 3, identifier: '3'),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemController.isEditing = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    itemController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const double cellWidth = 96;
    final int slotCount = (screenWidth ~/ (cellWidth + 8)).clamp(1, 20); // 8 -> horizontalSpace

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Example")),
      body: Dashboard(
        /// رای اسکرول خود گرید. وقتی آیتم رو می‌کشی و نزدیک لبه‌ها می‌بری، با گزینه‌ی autoScroll (پایین‌تر) اسکرول خودکار انجام می‌شه.
        /// مغز مدیریت آیتم‌ها (اضافه/حذف/ویرایش/تغییر سایز/جابجایی).
        dashboardItemController: itemController,

        /// حین ریلِی‌اوت/ویرایش، آیتم‌ها رو برای جا شدن «کوچیک نکن». (اگر true باشه، پکیج تلاش می‌کنه آیتم‌ها رو برای چیدن بهتر کمی جمع‌وجور کنه.)
        /// آیتم‌ها رو فشرده نکن
        shrinkToPlace: false,

        /// ابتدای کار، آیتم‌ها رو تا حد ممکن به بالا می‌چسبونه (compact).
        /// آیتم‌ها رو به بالا نچسبون
        slideToTop: false,

        /// ایونت‌های لمس/ماوس به بچه‌ها هم بره.
        absorbPointer: false,

        /// پس‌زمینه‌ی هر اسلات (سلول گرید) رو می‌سازه. توی مثال با یه Border خاکستری نازک دور هر سلول می‌کشه؛ یعنی خطوط گرید از اینجا میان، نه از paintBackgroundLines. اگه اینو برداری و بخوای خط‌های گرید رو ببینی، باید paintBackgroundLines: true رو توی editModeSettings فعال کنی.
        slotBackgroundBuilder: SlotBackgroundBuilder.withFunction((context, item, x, y, editing) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),

        /// فاصله‌ی دور و بینِ سلول‌ها.
        padding: const EdgeInsets.all(8),
        horizontalSpace: 8,
        verticalSpace: 8,

        /// نسبت عرض به ارتفاع هر سلول؛ ۱ یعنی مربع.
        slotAspectRatio: 1,

        /// هر بار تغییر چیدمان، انیمیت کن.
        animateEverytime: true,
        // slotCount: slot!,
        /// ویجت‌های جایگزین خطا/خالی.
        errorPlaceholder: (e, s) {
          return Text("$e , $s");
        },

        /// اطراف هر آیتم یک Material می‌پیچه؛ اینجا شفاف، گردی گوشه‌ها ۱۵، سایه ۵ و Clip فعاله.
        itemStyle: ItemStyle(
          color: Colors.transparent,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),

        /// حین تغییر اندازه/چیدمان، اسکرول پوینت کمتر می‌پره و حس پایدارتری می‌ده.
        physics: const RangeMaintainingScrollPhysics(),

        /// تعداد ستون‌های گرید. توی دمو با توجه به عرض صفحه ۴/۶/۸ ستون انتخاب می‌شه. اگر slot null بمونه، خطا می‌گیری.
        // slotCount: screenWidth > 900
        //     ? 8
        //     : screenWidth > 600
        //         ? 6
        //         : 4,
        slotCount: slotCount,
        /// تنظیمات حالت ویرایش
        editModeSettings: EditModeSettings(
          /// اجازه‌ی کشیدن آیتم بیرون محدوده رو نده.
          draggableOutside: false,

          /// خط‌های گریدِ داخلیِ پکیج خاموشه (چون از slotBackgroundBuilder برای خطوط استفاده می‌کنیم).
          paintBackgroundLines: false,

          /// موقع کشیدن به لبه‌ها، خودکار اسکرول کن.
          autoScroll: true,

          longPressEnabled: true,
          // برای موبایل
          panEnabled: true,

          /// محل resize گوشه‌ها - اندازه‌ی «حاشیه‌ی فعالِ» رزایز (۱۵ پیکسل از لبه‌ها).
          resizeCursorSide: 15,

          /// انیمیشن‌های حالت ویرایش.
          curve: Curves.easeInOutCirc,
          duration: const Duration(milliseconds: 200),

          shrinkOnMove: true,

          /// رنگ/ضخامت/حالت خطوط بک‌گراند در ادیت‌مود (وقتی paintBackgroundLines رو روشن کنی).
          backgroundStyle: const EditModeBackgroundStyle(
            fillColor: Colors.black38,
            lineWidth: 1.5,
            lineColor: Colors.black,
            dualLineHorizontal: false,
            dualLineVertical: false,
          ),
        ),
        itemBuilder: (item) {
          return Card(
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                "Item ${item.identifier}",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
