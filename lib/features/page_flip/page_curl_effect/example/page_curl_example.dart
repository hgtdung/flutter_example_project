import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/page_curl_effect.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/page_curl_controller.dart';

class PageCurlEffectExample extends StatefulWidget {
  const PageCurlEffectExample({super.key});

  @override
  State<PageCurlEffectExample> createState() => _PageCurlEffectExampleState();
}

class _PageCurlEffectExampleState extends State<PageCurlEffectExample> {
  late int pageIndex;
  late PageCurlController pageCurlController;
  late Size paperSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    paperSize = Size(
        MediaQuery.of(context).size.width -
            MediaQuery.of(context).padding.left -
            MediaQuery.of(context).padding.right,
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom - 100,
    );
    var pages = buildPages();
    pageCurlController = PageCurlController(
        Size(paperSize.width, paperSize.height),
        pageCurlIndex: 1,
        numberOfPage: pages.length);

    assert(pages.length > 2, "There should be at least two page");
    super.didChangeDependencies();
  }

  List<Widget> buildPages() {
    return [
      Container(
        width: paperSize.width,
        height: paperSize.height,
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Page 0"),
            Container(
                alignment: Alignment.topLeft,
                height: paperSize.height / 2,
                child: Image.asset(
                  "assets/images/landscape.jpg",
                ))
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        width: paperSize.width,
        height: paperSize.height,
        color: Colors.blue,
        child: const Text(
            "Age previous Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
            "Mauris ornare iaculis turpis non varius. "
            "Aenean non tortor dui. Nunc imperdiet ante vitae "
            "bibendum volutpat. Maecenas mollis bibendum dolor non "
            "blandit. Nulla pretium arcu eget urna volutpat, "
            "sit amet posuere ipsum congue. Cras facilisis "
            "augue vitae est hendrerit, at mollis diam tempor. "
            "Cras ligula magna, ultricies nec massa in, "
            "sollicitudin vulputate massa. Vestibulum ante ipsum "
            "primis in faucibus orci luctus et ultrices posuere "
            "cubilia curae; Cras tincidunt elit in dapibus lacinia. "
            "Suspendisse sed enim orci. Donec blandit pharetra efficitur. "
            "Donec nec suscipit est, at interdum augue."),
      ),
      Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        width: paperSize.width,
        height: paperSize.height,
        color: Color(0xffF5DEB3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // width: MediaQuery.of(context).size.width - 32 - 170,
                    width: paperSize.width - 32 - 170,
                    child: Text(
                      "    Your twenties are like a summer rain shower rushing by at midday, "
                      "leaving behind a touch of dampness and a raw, earthy scent rising from the soil— still bewildered, still",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 13, height: 1.8),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Spacer(),
                  Opacity(
                    opacity: 0.8,
                    child: Container(
                      width: 160,
                      // height: 140,
                      child: Image.asset("assets/images/raining.jpg"),
                    ),
                  )
                ],
              ),
              Text(
                "lost in the lingering coolness."
                " And when the rainy season comes again, it can only long for the sweltering, scorching days of the past. \n",
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 13, height: 1.8),
                textAlign: TextAlign.justify,
              ),
              Container(
                child: Text(
                  "Japan, the Season of Blossoms. \n"
                  "Cherry blossoms overflow on the rows of trees, their petals speckling the streets—"
                  "drifting away from the serenity that once cradled them."
                  "Carried by the wind, are they searching for something new, something bold?"
                  "Yet at 5 cm per second, they finally rest—"
                  "bare, solitary on the ground, trampled without a second thought.",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13, height: 1.8),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Opacity(
                  opacity: 0.5,
                  child:
                      Align(alignment: Alignment.center, child: Text("🌸🌸🌸"))),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageCurlEffect(
        pageCurlController: pageCurlController,
        // pages: buildPages(),
        pageBuilder: (context, index) {
          return Container(
            color: index == 1 ? const Color(0xff39A678) : const Color(0xffB9B9B9),
            width: paperSize.width,
            height: paperSize.height,
            child: Center(child: Text("This is page $index")),
          );
        }
      ),
    );
  }


}
