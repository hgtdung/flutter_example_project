import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Container(
      width: MediaQuery.of(context).size.width,
      height: 500,
      child: AbsorbPointer(
        absorbing: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
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
                      "Donec nec suscipit est, at interdum augue."
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
                      "Donec nec suscipit est, at interdum augue."
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
                      "Donec nec suscipit est, at interdum augue."
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
                      "Donec nec suscipit est, at interdum augue."

              )
            ],
          ),
        ),
      ),
    )
    );
  }
}
