import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.blueAccent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("RECOLHEDOR",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )
                ),
                centerTitle: true,
              ),
            )
          ],
        )
      ],
    );
  }
}
