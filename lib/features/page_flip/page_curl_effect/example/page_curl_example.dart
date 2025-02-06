import 'package:flutter/material.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/page_curl_effect.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/page_curl_controller.dart';

class PageCurlEffectExample extends StatefulWidget {
  const PageCurlEffectExample({super.key});

  @override
  State<PageCurlEffectExample> createState() => _PageCurlEffectExampleState();
}

class _PageCurlEffectExampleState extends State<PageCurlEffectExample> {
  late Widget currentPage;
  late Widget? nextPage;
  late Widget? previousPage;

  late int pageIndex;
  late PageCurlController pageCurlController;

  @override
  void initState() {

    // pageCurlVM = PageCurlController(Size(widget.width, widget.height));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var pages = buildPages();
    previousPage = pages[0];
    currentPage = pages[1];
    nextPage = pages[2];
    pageCurlController = PageCurlController(
        Size(MediaQuery.of(context).size.width, 600),
        pageCurlIndex: 1,
      numberOfPage: pages.length
    );

    assert(pages.length > 2, "There should be at least two page");
    pageIndex = 1;
    super.didChangeDependencies();
  }

  void onBackWardComplete() {
    assert(previousPage != null, "previous page should not be null");
    setState(() {
      nextPage = currentPage;
      currentPage = previousPage!;
      previousPage = null;
    });
    print("onback ward completet");
  }

  void onForwardComplete() {
    assert(nextPage != null, "previous page should not be null");
    setState(() {
      previousPage = currentPage;
      currentPage = nextPage!;
      nextPage = null;

    });
  }

  List<Widget> buildPages() {
    return [
      Container(
        // key: UniqueKey(),
        width: MediaQuery.of(context).size.width,
        height: 600,
        color: Colors.orange,
        child: const Text(
            "Page 0"),
      ),
      Container(
        // key: UniqueKey(),
        width: MediaQuery.of(context).size.width,
        height: 600,
        color: Colors.blue,
        child: const Text(
            "Page 1"),
      ),
      Container(
        // key: UniqueKey(),
        width: MediaQuery.of(context).size.width,
        height: 600,
        color: Colors.grey,
        child: const Text(
            "Page 2"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageCurlEffect(
        pageCurlController: pageCurlController,
          background: Colors.blue,
          previousPage: previousPage,
          nextPage: nextPage,
          currentPage:  currentPage,
          width: MediaQuery.of(context).size.width,
          height: 600,
          onBackwardComplete: () {
            onBackWardComplete();
          },
          onForwardComplete: () {
            /// Change current paaage
            onForwardComplete();
          },
      ),
    );
  }

  Widget buildNextPage() {
    return  Container(
        width: MediaQuery.of(context).size.width,
        height: 600,
      color: Colors.grey,
      child: Text(
          "Page 2 Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Mauris ornare iaculis turpis non varius. "
              "Aenean non tortor dui. Nunc imperdiet ante vitae "
              "bibendum volutpat. xxxxMaecenas mollis bibendum dolor non "
              "blandit. Nulla pretium arcu eget urna volutpat, "
              "sit amet posuere ipsum congue. Cras facilisis "
              "augue vitae est hendrerit, at mollis diam tempor. "
              "Cras ligula magna, ultricies nec massa in, "
              "sollicitudin vulputate massa. Vestibulum ante ipsum "
              "primis in faucibus orci luctus et ultrices posuere "
              "cubilia curae; Cras tincidunt elit in dapibus lacinia. "
              "Suspendisse sed enim orci. Donec blandit pharetra efficitur. "
              "Donec nec suscipit est, at interdum augue."),
    );
  }

  Widget buildPreviousPage() {
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: 600,
      color: Colors.orange,
      child: Text(
          "Page previous Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
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
    );
  }
}


// "Page 1 Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
// "Mauris ornare iaculis turpis non varius. "
// "Aenean non tortor dui. Nunc imperdiet ante vitae "
// "bibendum volutpat. Maecenas mollis bibendum dolor non "
// "blandit. Nulla pretium arcu eget urna volutpat, "
// "sit amet posuere ipsum congue. Cras facilisis "
// "augue vitae est hendrerit, at mollis diam tempor. "
// "Cras ligula magna, ultricies nec massa in, "
// "sollicitudin vulputate massa. Vestibulum ante ipsum "
// "primis in faucibus orci luctus et ultrices posuere "
// "cubilia curae; Cras tincidunt elit in dapibus lacinia. "
// "Suspendisse sed enim orci. Donec blandit pharetra efficitur. "
// "Donec nec suscipit est, at interdum augue."