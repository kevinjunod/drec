import 'package:flutter/material.dart';
import 'package:drec/constants.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:drec/models/searchBarModel.dart';

class SearchBar extends StatelessWidget {
  @override
  build(BuildContext context) {
    return FloatingSearchBar(
      hint: 'What do you want?',
      openAxisAlignment: 0.0,
      maxWidth: 600,
      axisAlignment: 0,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
      elevation: 4.0,
      onQueryChanged: (query) {
        //* method
      },
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 500),
      transition: CircularFloatingSearchBarTransition(),
      debounceDelay: Duration(milliseconds: 500),
      actions: [
        FloatingSearchBarAction(
          showIfClosed: false,
          child: CircularButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        )
      ],
      builder: (context, transition) {
        return Container(
          decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          height: deviceHeight / 3,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (int i = 0; i < searchList.length; i++)
                  ListTile(
                    title: Text(
                      searchList[i].title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                      left: 10,
                      top: 10,
                    ),
                    subtitle: Text(
                      searchList[i].description,
                    ),
                  ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
